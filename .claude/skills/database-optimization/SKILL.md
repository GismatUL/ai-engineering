---
name: database-optimization
description: Use when a query, endpoint, or Nova resource is slow, or when asked to add an index, fix an N+1, or optimize a database interaction. Requires measuring before and after (EXPLAIN/timing) and finding the actual root cause — never guesses at a fix or claims an improvement without evidence.
---

# Database Optimization

Rules: @../../../rules/database.md, @../../../rules/measurement.md

## Steps

1. Reproduce and measure the current behavior using the protocol in
   @../../../rules/measurement.md — query time, `EXPLAIN` output, number of
   queries executed (watch for N+1 in loops/relations).
2. Identify the actual root cause: missing index, N+1 from lazy-loading,
   unbounded result set, inefficient query shape, or missing cache.
3. Propose the smallest fix that addresses the measured cause — an index,
   `with()`/eager load, query restructure, or Redis cache with explicit
   invalidation. Do not add an index or cache "just in case."
4. Verify the fix using the same method as step 1, and record the
   before/after comparison per @../../../rules/measurement.md.
5. If the fix touches a migration or cache invalidation path, check it
   against @../../../rules/database.md's transaction and cache-invalidation
   rules.
