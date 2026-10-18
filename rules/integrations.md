# External Integrations Rules

Applies to anything that reaches outside the application: email/SMTP,
SMS, payment providers, webhooks, third-party APIs, cloud storage.

## Configuration

- Reuse an existing, authorized configuration when the owner says so —
  read it, never overwrite or "fix" another application's config.
- Never guess credentials or create new accounts/keys without permission.
- Secrets live only in the environment/secret store; never in source,
  the frontend bundle, logs, docs, or reports.
- Keep a local/sandbox target as the development default. If the real
  configuration has to sit in the same file, keep it commented and
  clearly marked so local testing cannot reach real recipients.

## Testing

- Test against a local catcher or sandbox first (e.g. Mailpit/MailHog for
  SMTP, the provider's test mode for payments).
- Test against the real service only with a safe, authorized target — a
  mailbox, account, or endpoint the team controls.
- Never send bulk messages or contact real customers without explicit
  authorization.
- Record exactly what was verified: "accepted by the SMTP server" is not
  "arrived in the inbox", which is not "passed SPF/DKIM/DMARC".

## Behaviour

- Handle failures visibly: record each attempt's outcome, surface failures
  to the user where relevant, and offer a retry.
- Rate-limit and cap outbound actions a user can trigger (recipients per
  send, sends per hour).
- Never put secrets meant for another channel into a message (e.g. a
  share password in the email that carries the link).

Never claim an integration works without having tested it successfully.
