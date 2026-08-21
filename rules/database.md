# Database Rules (MySQL / Redis)

- Never assume schema, indexes, or row counts — check migrations,
  `DESCRIBE`/`EXPLAIN`, or ask before assuming.
- Wrap multi-step writes in DB transactions; do not leave partial writes
  possible on failure.
- Diagnose slow queries with `EXPLAIN` before proposing a fix — identify
  whether it's a missing index, N+1 (missing eager load), or an unbounded
  result set.
- Prefer eager loading (`with()`) over lazy-loading in loops; watch for
  N+1 in API responses and Nova resources.
- Add indexes deliberately — justify each with the query pattern it
  serves, and check existing indexes before adding a redundant one.
- Use Redis for caching and ephemeral state (sessions, rate limiters,
  queues), not as a system of record.
- Invalidate cache explicitly on writes that affect cached data; do not
  rely on TTL alone if staleness matters.
- Measure before and after any optimization (query time, rows examined) —
  never claim an improvement without evidence.
