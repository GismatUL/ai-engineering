<#
  Claude Code Stop hook for away mode (rules/autonomous-mode.md).
  While .claude/tasks/.away exists and unblocked tasks remain in
  .claude/tasks/Pending/, it tells Claude to keep working instead of
  stopping. Does nothing outside away mode. Gives up after $MaxContinues
  forced continues so a stuck session can still end.
#>
$ErrorActionPreference = "Stop"

[Console]::In.ReadToEnd() | Out-Null

$Root = if ($env:CLAUDE_PROJECT_DIR) { $env:CLAUDE_PROJECT_DIR } else { (Get-Location).Path }
$Marker = Join-Path $Root ".claude\tasks\.away"
$Pending = Join-Path $Root ".claude\tasks\Pending"
$MaxContinues = 30

if (-not (Test-Path $Marker)) { exit 0 }

$OpenTasks = @()
if (Test-Path $Pending) {
    Get-ChildItem -Path $Pending -Filter *.md -File | ForEach-Object {
        $blocked = Select-String -Path $_.FullName -Pattern '^[-* ]*Status:\s*Blocked' -Quiet
        if (-not $blocked) { $OpenTasks += $_.Name }
    }
}

if ($OpenTasks.Count -eq 0) { exit 0 }

$Lines = @(Get-Content -Path $Marker)
$Count = 0
foreach ($line in $Lines) {
    if ($line -match '^continues=(\d+)') { $Count = [int]$Matches[1] }
}
if ($Count -ge $MaxContinues) { exit 0 }

$Kept = @($Lines | Where-Object { $_ -notmatch '^continues=' })
[System.IO.File]::WriteAllLines($Marker, [string[]]($Kept + "continues=$($Count + 1)"))

$Reason = "Away mode is active and unblocked tasks remain in .claude/tasks/Pending/: $($OpenTasks -join ', '). Continue with the next one per rules/autonomous-mode.md, or record it as Status: Blocked with the reason. When none remain, write the away report and delete .claude/tasks/.away."

[Console]::Out.WriteLine((@{ decision = "block"; reason = $Reason } | ConvertTo-Json -Compress))
