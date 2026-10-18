# Security Rules

- Never expose secrets, credentials, tokens, or private keys.
- Validate and sanitize external input.
- Use parameterized queries and safe database APIs.
- Enforce authentication and authorization where required.
- Do not weaken existing security controls.
- Avoid logging sensitive information.
- Treat external API payloads as untrusted input.
- Consider rate limiting for publicly accessible endpoints.
- Review security implications before introducing new integrations.

## Authentication and sessions

- Hash passwords with the platform's password API (`password_hash()` /
  the framework hasher) — never MD5/SHA or reversible encryption. Know
  the algorithm's limits (bcrypt ignores input past 72 bytes) and enforce
  them.
- No default accounts, hardcoded passwords, or auth bypasses. Hiding a URL
  is not a security control.
- Session cookies HttpOnly, Secure, SameSite; regenerate the session id at
  login; enforce idle timeout and account deactivation on every request.
- Login and other guessable secrets (share passwords, codes): one generic
  error message, limits per account and per IP, `Retry-After` on lockout.
- CSRF protection on every state-changing request. Check whether the
  framework relaxes it by default and whether that is acceptable.

## Authorization

- Enforce ownership and permissions on the server, on every query and
  action — scope queries by owner rather than checking afterwards.
- Prevent IDOR: ids from the client (URLs, hidden fields, component state)
  are untrusted; verify they belong to the current user or resource.
- Test it with two users: user B gets nothing (404, not 403, where
  existence itself is sensitive) from every endpoint of user A.

## Files

- Validate size, extension, and the server-detected content type; block
  executable types; never execute uploads.
- Generate storage names server-side; keep originals' names only as data.
  Sanitize paths against traversal.
- Store private files outside the web root; serve them only after an
  authorization check, never by direct path.
- Downloads: `Content-Disposition: attachment` (UTF-8 `filename*`),
  `X-Content-Type-Options: nosniff`, `Cache-Control: no-store`. Inline
  display only for an allow-list of safe types — never SVG or HTML.
- Check where the framework writes temporary uploads before using its
  upload feature; plaintext temp files defeat encryption at rest.

## Responses and output

- Encode output for its context; render user content as text.
- Do not return stack traces, internal paths, or sensitive fields; give
  JSON errors without internals.
- Set security headers: CSP (nonce-based, no `unsafe-eval` where
  achievable), HSTS over HTTPS, `Referrer-Policy`, frame restrictions;
  remove `X-Powered-By`.

## Data and secrets

- Encryption keys live outside the database, the web root, and git, with
  restrictive file permissions; document backup and rotation, and back the
  key up separately from the data.
- Minimise stored personal data (e.g. truncate IPs); define retention and
  purge it.
- Check `.gitignore` covers `.env`, keys, local credentials, and runtime
  storage before the first commit.
