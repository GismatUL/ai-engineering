---
name: laravel-api
description: Use when building or modifying a REST API endpoint in a Laravel project — a new route/controller/resource, a changed response shape, or added authentication on an endpoint. Enforces thin controllers, Form Request validation, API Resource responses, and correct auth (Sanctum vs OAuth2/JWT) instead of ad-hoc inline logic. Skip for non-API Laravel work (Blade views, Artisan commands, jobs).
---

# Laravel API Design

Rules: @../../../rules/laravel.md, @../../../rules/security.md

## Checklist

- Route registered in the correct group (`api.php`, versioned prefix,
  correct middleware) matching existing route conventions.
- Controller method stays thin — delegates to a service/action, does not
  contain business logic or raw Eloquent queries beyond a simple lookup.
- Input validated via a Form Request, not inline `$request->validate()`
  scattered across the method, unless the project's own convention is
  otherwise.
- Response shaped via an API Resource (or the project's existing response
  pattern) — do not return raw models or ad-hoc arrays inconsistent with
  other endpoints.
- Auth matches what the endpoint needs: Sanctum for first-party
  SPA/mobile, OAuth2/JWT for third-party/service-to-service — check what
  the rest of the API already uses before introducing a second scheme.
- Errors return the project's existing error response shape and correct
  HTTP status codes, not a default framework exception page.
- If this changes an existing response contract, treat it as a breaking
  change: version it or confirm this is acceptable.
