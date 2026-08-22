# Measurement & Evidence Rules

Applies to any claim about performance, resource usage, or behavior change,
regardless of technology or domain. This is the single source of truth for
how such claims are measured, classified, and reported — agents, skills,
and other rules reference this file rather than restating it.

## Evidence classification

Label every measurable claim with exactly one of the following. Use the
lowest classification the evidence actually supports — never round up.

- **Observed** — noticed once, informally, with no stated method (e.g. "it
  felt slow"). The weakest usable evidence; not a claim of fact.
- **Measured** — a specific value captured with a stated method/tool, at a
  stated time, in a stated environment.
- **Verified** — a measured result that was reproduced or cross-checked a
  second way (a repeated run, a second tool, or independent confirmation).
- **Inferred** — reasoned from adjacent evidence without directly measuring
  the thing being claimed (e.g. a query plan shows a full table scan, so
  it's likely the bottleneck — without timing it).
- **Estimated** — an explicit, labeled prediction or order-of-magnitude
  guess, stated as a prediction — never presented as a result.
- **Assumed** — taken as given without evidence, explicitly flagged as
  needing validation.
- **Unknown** — not established. State it as a named gap, not a silent
  omission.

Never convert an Estimated or Assumed value into a Measured or Verified one
without actually performing the measurement.

## Measurement protocol

Use this structure for any claim that involves a before/after comparison:

```
Metric:         <what is being measured>
Method:         <exact command/tool used>
Environment:    <where it was run, and how it differs from production>
Baseline:       <value, when captured, how many runs>
Change:         <what was changed>
After:          <value, when captured, how many runs>
Comparison:     <delta / % change, with a caveat if only one run>
Classification: <Observed / Measured / Verified / Inferred / Estimated / Assumed / Unknown>
Conclusion:     <what can and cannot be claimed from this>
```

## Rules

1. Never invent a measurement.
2. Never convert an estimate into a measured result.
3. Never claim a percentage improvement without a real before/after pair.
4. If a measurement cannot be performed, report the limitation explicitly —
   do not substitute an estimate presented as fact.
5. Record the exact method/tool used to obtain a measurement.
6. Record the environment the measurement was taken in.
7. Distinguish a one-off observation from a reproducible measurement.
8. Do not compare measurements taken under materially different conditions
   without explicitly stating the limitation.
9. Do not optimize based solely on intuition when measurement is possible.
10. Do not require measurement when the task makes no measurable claim.

## Domain guidance

Starting points, not an exhaustive list — the same protocol applies to any
measurable engineering claim not listed here.

- **Database** — `EXPLAIN`/`EXPLAIN ANALYZE`, query timing, query count.
- **API** — repeated requests; report p50/p95/p99 where appropriate, not a
  single sample.
- **Memory** — peak RSS (or equivalent) under a comparable workload.
- **CPU** — wall-clock and CPU time under a comparable workload.
- **Queue** — jobs/sec, queue lag, or processing duration over a defined
  window.
- **Batch processing** — fixed payload size, comparable environment.
- **Frontend** — Lighthouse, Web Vitals, or bundle size.
- **Build/test duration** — same environment, comparable conditions.
- **Infrastructure** — the metric the platform itself reports (CPU/memory/
  network from its own monitoring), same caveats as above.
