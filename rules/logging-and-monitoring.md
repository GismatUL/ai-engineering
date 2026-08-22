# Logging & Monitoring Rules

Applies to application logging, error tracking, monitoring, and
operational diagnostics for any project, regardless of technology stack or
chosen provider (e.g. Sentry, Grafana, Laravel Nightwatch, Prometheus,
existing in-house infrastructure, or others).

## When to introduce it

- Add logging/monitoring when a failure mode is otherwise invisible,
  operationally important, or has already caused an undiagnosed incident.
- Prefer wiring into the project's existing logging/monitoring
  infrastructure over introducing a new one.
- Do not introduce new monitoring infrastructure speculatively — only when
  an existing gap actually prevents diagnosing or detecting a real problem.
- Do not add logging/monitoring purely to make a change "look" more
  production-ready.

## Logging

- Use structured logging (consistent fields, machine-parseable) where the
  project's stack and log consumers support it; do not force it where the
  project has no structured-logging convention.
- Include diagnostic context useful for reproducing or understanding the
  event (identifiers, relevant state, request/operation context) — not an
  unfiltered dump of everything available.
- Make errors and exceptions visible where they matter operationally; do
  not let a failure disappear silently.
- Avoid excessive logging — noisy logs hide the signal that matters and
  cost storage/processing; log what's actionable, not everything possible.
- Log level and destination should be environment-specific (e.g. verbose
  locally, operationally relevant only in production) — follow the
  project's existing environment configuration rather than inventing a new
  one.
- Never log secrets, credentials, tokens, API keys, or other sensitive
  data — mask, redact, or omit them, consistent with rules/security.md.
- Do not expose internal diagnostic information (stack traces, internal
  paths, query text, infrastructure details) to end users — that
  information belongs in logs/monitoring, not in user-facing output.
- Treat operationally important failures (data loss risk, payment/auth
  failures, silent job/queue failures) as requiring visibility, not just a
  log line nobody will see.

## Provider selection

- Choosing or changing a logging/monitoring provider is a project-specific
  decision based on the project's actual requirements, scale, and existing
  infrastructure — not a default this framework makes for you.
- Prefer the project's existing provider/tooling; do not introduce a
  second one for a single task without a clear reason.

## Verification

Before treating a logging/monitoring change as done, verify — do not
assume:

- Errors/events are actually received by the destination (log aggregator,
  error tracker, dashboard, etc.), not just emitted locally.
- The captured context is actually useful for diagnosis, not just present.
- No sensitive information is exposed in logs, error reports, or
  dashboards.
- Alerts, dashboards, and integrations behave as intended (e.g. an alert
  actually fires, a dashboard actually reflects the new metric).
- Environment configuration (log level, destination, credentials/DSN) is
  correct for the environment it's deployed to.

Never claim monitoring is "working" or "operational" without having
actually verified it. For any measurable claim about a monitoring change
(error rate, event volume, alerting latency, etc.), follow
rules/measurement.md rather than restating it here.
