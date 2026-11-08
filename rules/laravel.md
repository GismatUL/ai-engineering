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

## Security-sensitive defaults

- Livewire's file upload stores temporary uploads on disk in plaintext;
  if files must be encrypted at rest, upload to your own endpoint that
  encrypts on arrival and leave Livewire uploads disabled.
- Alpine under a strict CSP needs Livewire's CSP-safe build, with Alpine
  logic in registered components instead of inline expressions.
- Check whether the installed Laravel version relaxes CSRF verification
  (e.g. a same-origin shortcut) and whether that is acceptable.
- Scope owner data in a query scope (e.g. `Model::ownedBy($user)`) and
  mark Livewire properties holding ids `#[Locked]`.

## PHP and Composer versions

- Before running `php`, `composer`, `artisan` or tests, check which PHP
  version and which Composer version will actually run them (`php -v`,
  `composer --version`). Compare them with what the project requires:
  `require.php` and `config.platform.php` in `composer.json`, the
  Dockerfile or CI PHP version, and the framework's minimum (Laravel 11
  and 12 need PHP 8.2, Laravel 13 needs PHP 8.3). The default `php` on
  PATH is often an old install (for example Laragon's PHP 7.4) and is
  not proof of anything.
- Always run on the recommended version: the one the project's
  Docker/CI/production uses, or, for a new project or package, the latest
  stable PHP the framework supports.
- If the active PHP is older than required, upgrade to the required
  version. Switch to or install it (Laragon: select or add the version;
  otherwise call that version's binary by its full path, or run inside the
  project's container). Do not work around it with
  `--ignore-platform-reqs`, by lowering `require.php`, or by downgrading
  packages.
- Changing the project's own declared version (`composer.json`
  `require.php`, Dockerfile, CI, production) is a separate change: propose
  it, state the impact, and wait for approval.
- Keep Composer current (`composer self-update`); CI always uses the
  latest. Composer 2.9+ refuses to install versions with security
  advisories, which includes end-of-life Laravel releases. Do not turn the
  check off globally. If a project is on an end-of-life version, report it
  and recommend the upgrade. Bypass the check (`COMPOSER_NO_SECURITY_BLOCKING=1`)
  only for explicitly marked end-of-life CI jobs that must keep testing
  that version.
- When reporting verification, state the PHP and Composer versions the
  tests ran on.

## Coding

- Follow PSR-12 and the project's existing formatter/linter config (Pint,
  PHP CS Fixer) if present.
- Do not bypass the Eloquent model layer with raw queries unless there's a
  measured performance reason (see database.md).
