<#
.SYNOPSIS
  Install this repo's Claude Code native assets (.claude/agents, .claude/skills,
  .claude/commands) into a host project after adding it as a git submodule
  (or a plain clone — see -Local below).

.EXAMPLE
  # From the host project root:
  .\ai-engineering\install.ps1            # copy (default, works everywhere)
  .\ai-engineering\install.ps1 -Symlink   # symlink instead (needs dev mode / admin)
  .\ai-engineering\install.ps1 -Local     # keep every trace out of the host repo's git history

.NOTES
  -Local writes the rules imports to CLAUDE.local.md instead of CLAUDE.md
  (Claude Code auto-loads CLAUDE.local.md; it's meant to be gitignored) and
  appends every path this script installs to .git/info/exclude — a per-clone
  ignore file that never gets committed. This does NOT retroactively hide a
  real `git submodule add` (that command stages .gitmodules and a gitlink
  the moment it runs) — for a fully invisible setup, clone this repo as a
  plain directory instead of registering it as a submodule.
#>
param(
    [switch]$Symlink,
    [switch]$Local
)

$ErrorActionPreference = "Stop"

$SubmoduleDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$HostRoot = (Get-Location).Path

if ($SubmoduleDir.TrimEnd('\') -eq $HostRoot.TrimEnd('\')) {
    Write-Error "Refusing to install into the ai-engineering repo itself (it self-hosts .claude/ already). Run this script from the host project's root instead."
    exit 1
}

function Get-RelativePath {
    param([string]$Base, [string]$Target)
    $baseUri = New-Object System.Uri(($Base.TrimEnd('\') + '\'))
    $targetUri = New-Object System.Uri($Target)
    $relUri = $baseUri.MakeRelativeUri($targetUri)
    return [System.Uri]::UnescapeDataString($relUri.ToString())
}

$RelSubmoduleUnix = (Get-RelativePath -Base $HostRoot -Target $SubmoduleDir).TrimEnd('/')

$Mode = if ($Symlink) { "symlink" } else { "copy" }
Write-Host "Installing ai-engineering assets ($Mode) from $SubmoduleDir"
Write-Host "                                     into $HostRoot\.claude"

$InstalledRelPaths = New-Object System.Collections.Generic.List[string]

function Install-Tree {
    param([string]$SrcRoot, [string]$DestRoot)
    if (-not (Test-Path $SrcRoot)) { return }
    Get-ChildItem -Path $SrcRoot -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring($SrcRoot.Length).TrimStart('\')
        $dest = Join-Path $DestRoot $rel
        $destDir = Split-Path -Parent $dest
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Force -Path $destDir | Out-Null }
        if ($Symlink) {
            if (Test-Path $dest) { Remove-Item $dest -Force }
            New-Item -ItemType SymbolicLink -Path $dest -Target $_.FullName | Out-Null
        } else {
            Copy-Item -Path $_.FullName -Destination $dest -Force
        }
        Write-Host "  $rel"
        $InstalledRelPaths.Add($dest.Substring($HostRoot.Length).TrimStart('\').Replace('\', '/'))
    }
}

Install-Tree -SrcRoot (Join-Path $SubmoduleDir ".claude\agents") -DestRoot (Join-Path $HostRoot ".claude\agents")
Install-Tree -SrcRoot (Join-Path $SubmoduleDir ".claude\skills") -DestRoot (Join-Path $HostRoot ".claude\skills")
Install-Tree -SrcRoot (Join-Path $SubmoduleDir ".claude\commands") -DestRoot (Join-Path $HostRoot ".claude\commands")
Install-Tree -SrcRoot (Join-Path $SubmoduleDir ".claude\hooks") -DestRoot (Join-Path $HostRoot ".claude\hooks")

$ClaudeDir = Join-Path $HostRoot ".claude"
if (-not (Test-Path $ClaudeDir)) { New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null }

$ManifestRel = ".claude/.ai-engineering-installed"
$Manifest = Join-Path $HostRoot ($ManifestRel -replace '/', '\')
$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
@"
ai-engineering install manifest
source: $SubmoduleDir
mode: $Mode
local: $($Local.IsPresent)
installed: $Timestamp
"@ | Set-Content -Encoding utf8 $Manifest

if ($Local) {
    $ClaudeMd = Join-Path $HostRoot "CLAUDE.local.md"
    $Marker = "## AI Engineering (submodule, local-only)"
} else {
    $ClaudeMd = Join-Path $HostRoot "CLAUDE.md"
    $Marker = "## AI Engineering (submodule)"
}
if (-not (Test-Path $ClaudeMd)) { New-Item -ItemType File -Path $ClaudeMd | Out-Null }

$AlreadyPresent = Select-String -Path $ClaudeMd -Pattern ([regex]::Escape($Marker)) -Quiet
if ($AlreadyPresent) {
    Write-Host "$(Split-Path -Leaf $ClaudeMd) already references ai-engineering rules, skipping."
} else {
    $Block = @"

$Marker

@$RelSubmoduleUnix/rules/architecture.md
@$RelSubmoduleUnix/rules/coding-standards.md
@$RelSubmoduleUnix/rules/security.md
@$RelSubmoduleUnix/rules/task-management.md
"@
    Add-Content -Path $ClaudeMd -Value $Block -Encoding utf8
    Write-Host "Appended ai-engineering rules imports to $ClaudeMd"
}

if ($Local) {
    $GitDir = Join-Path $HostRoot ".git"
    if (Test-Path $GitDir -PathType Container) {
        $ExcludeFile = Join-Path $GitDir "info\exclude"
        $ExcludeDir = Split-Path -Parent $ExcludeFile
        if (-not (Test-Path $ExcludeDir)) { New-Item -ItemType Directory -Force -Path $ExcludeDir | Out-Null }
        if (-not (Test-Path $ExcludeFile)) { New-Item -ItemType File -Path $ExcludeFile | Out-Null }

        $BeginMark = "# BEGIN ai-engineering (local install, do not commit)"
        $EndMark = "# END ai-engineering (local install)"

        $existing = Get-Content -Path $ExcludeFile
        $kept = New-Object System.Collections.Generic.List[string]
        $skip = $false
        foreach ($line in $existing) {
            if ($line -eq $BeginMark) { $skip = $true; continue }
            if ($line -eq $EndMark) { $skip = $false; continue }
            if (-not $skip) { $kept.Add($line) }
        }

        $blockLines = New-Object System.Collections.Generic.List[string]
        $blockLines.Add($BeginMark)
        $blockLines.Add("/CLAUDE.local.md")
        $blockLines.Add("/$ManifestRel")
        foreach ($p in $InstalledRelPaths) { $blockLines.Add("/$p") }
        # Only takes effect if this is a plain clone, not a real submodule
        # (a registered submodule's gitlink is tracked, not untracked, so
        # ignore rules don't apply to it).
        $blockLines.Add("/$RelSubmoduleUnix/")
        $blockLines.Add($EndMark)

        ($kept + $blockLines) | Set-Content -Encoding utf8 $ExcludeFile
        Write-Host "Added installed paths to $ExcludeFile (never committed, local to this clone)."
    } else {
        Write-Warning "$GitDir not found - skipped writing .git\info\exclude. Add the installed paths to your ignore rules manually."
    }
    Write-Host "Note: if you added this as a real submodule (git submodule add), .gitmodules and the gitlink are already staged - -Local can't undo that. Use a plain clone for a fully invisible install."
}

Write-Host "For away mode, merge $RelSubmoduleUnix/settings/away-mode.json into .claude\settings.local.json (not done automatically)."
Write-Host "Done. Re-running this script will refresh the installed files with the submodule's current version."
