# Laravel / PHP Backend Rules

## Architecture

- Follow Clean Architecture / layered separation: controllers stay thin,
  business logic lives in services, data access lives behind the
  Repository pattern.
- Apply SOLID and dependency injection via the container; type-hint
  interfaces, bind implementations in a service provider.
- Prefer Laravel's built-in primitives (Form Requests, Policies, Resources,
  Jobs, Events) over custom infrastructure.
- Use Events & Listeners for side effects that don't belong in the primary
  request/response flow; avoid growing "god" service classes.
- Use Queues (Horizon where available) for anything slow, external, or
  retryable — never block a request on it.

## APIs

- Model REST endpoints around resources; use API Resources for response
  shaping and Form Requests for validation — never validate inline in
  controllers.
- Version breaking API changes; do not silently change an existing
  contract.
- Authenticate with Sanctum for first-party SPA/mobile clients, OAuth2/JWT
  for third-party/service-to-service — do not mix without a reason.
- For microservice boundaries, keep contracts explicit (OpenAPI/DTOs) and
  avoid sharing a database across services.

## Admin (Nova)

- Reuse existing Nova resources/actions/fields; do not duplicate
  authorization logic already enforced by policies.

## Frontend within a Laravel app

- Match whatever the project already uses (Blade + Alpine.js/jQuery, or a
  Vue/React island) — do not introduce a new frontend stack for a single
  feature.
- Keep AJAX calls going through the same API layer as other clients where
  one exists, rather than one-off endpoints.

## Coding

- Follow PSR-12 and the project's existing formatter/linter config (Pint,
  PHP CS Fixer) if present.
- Do not bypass the Eloquent model layer with raw queries unless there's a
  measured performance reason (see database.md).
