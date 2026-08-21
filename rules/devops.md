# DevOps & Infrastructure Rules

- Follow the project's existing Docker setup (Dockerfile, docker-compose)
  rather than introducing a parallel one.
- Keep CI (GitLab CI/GitHub Actions) fast and deterministic — cache
  dependencies, fail fast on lint/static analysis before running the full
  test suite.
- Do not add infrastructure (queues, containers, cloud resources)
  speculatively — only what the task requires.
- Treat AWS resources (EC2, S3, SQS) and Kubernetes config as production
  infrastructure — never assume capacity, IAM permissions, or network
  access; verify or ask.
- Keep secrets out of the repo and CI logs; use the project's existing
  secret management (env vars, CI secrets, AWS Secrets Manager/SSM).
- Prefer the simplest deployment target that meets the requirement — do
  not introduce Kubernetes for a workload that runs fine on EC2/containers
  already in use.
