---
name: container-runtime
description: "Use when working with Docker, Podman, containers, Dockerfiles, Containerfiles, Compose files, container images, registries, local runtime troubleshooting, or containerized development workflows. Keywords: docker, podman, container, containers, image, Dockerfile, Containerfile, compose, registry."
argument-hint: "Describe the container task, runtime preference (Docker or Podman), target files, and whether the work is local dev, CI build, or production packaging."
user-invocable: true
---
# Container Runtime Skill

Work with Docker, Podman, and containerized workflows using safe, reproducible changes that match the repository's existing runtime conventions.

## Use This Skill For

- Creating, editing, or reviewing `Dockerfile`, `Containerfile`, `.dockerignore`, or Compose files.
- Troubleshooting image builds, runtime errors, networking, volumes, permissions, ports, or health checks.
- Translating Docker commands to Podman commands or explaining compatibility differences.
- Designing local development container workflows without leaking credentials or machine-local state.
- Reviewing image size, build cache behavior, user privileges, and supply-chain risks.

## Do Not Use This Skill For

- Kubernetes manifests, Helm charts, Terraform, or cloud deployment architecture unless the task is specifically about container images.
- Adding new base images or runtime dependencies without a concrete need and user approval when dependency policy requires it.
- Running destructive cleanup commands such as pruning all images, volumes, or containers without explicit approval.
- Inventing registry URLs, credentials, image retention rules, or production deployment facts.

## Before Editing

1. Identify the repo's existing runtime: Docker, Podman, Compose, Dev Containers, CI build, or none.
2. Read existing container files, package manifests, lockfiles, startup scripts, and `.dockerignore` before editing.
3. Preserve existing base image family, package manager, port, user, and entrypoint conventions unless they are the issue.
4. Check whether local commands should use `docker` or `podman`; do not assume one when the repo documents the other.
5. Keep one concern per change: build fix, runtime fix, security hardening, or developer workflow.

## Dockerfile And Containerfile Guidance

- Prefer the smallest correct build context with a focused `.dockerignore`.
- Copy dependency manifests before source files when it improves build cache reuse.
- Use multi-stage builds when they clearly reduce runtime image size or remove build-only tools.
- Pin base image tags to a meaningful version; avoid unqualified `latest` unless the repo already uses it intentionally.
- Run as a non-root user when the application and base image support it.
- Keep environment defaults non-secret and overridable at runtime.
- Use `ENTRYPOINT` for the executable and `CMD` for default arguments when that matches the image contract.

## Compose Guidance

- Keep Compose files local-dev oriented unless the repo explicitly uses them for deployment.
- Use service names for container-to-container DNS instead of hard-coded host IPs.
- Store secrets in local env files excluded from git or external secret stores.
- Prefer named volumes for durable local data and bind mounts for editable source code.
- Add health checks only when there is a cheap, reliable readiness signal.

## Docker And Podman Differences

- Podman may run rootless by default; check file permissions and low-port binding behavior.
- Podman Compose support can vary by installation; confirm whether the repo uses `podman compose`, `podman-compose`, or Docker Compose.
- Docker socket workflows may not translate directly to Podman without a compatible socket service.
- SELinux hosts may need volume labels such as `:Z` or `:z`; do not add them unless the target environment requires them.
- Use OCI-compatible image practices when the image should work with both runtimes.

## Safety Rules

- Do not commit registry credentials, `.env` secrets, auth tokens, or copied host config.
- Do not run `docker system prune`, `podman system prune`, or volume deletion without explicit approval.
- Avoid mounting broad host paths like `/`, `$HOME`, or `/var/run/docker.sock` unless the workflow requires it and the risk is documented.
- Treat containers with privileged mode, host networking, or added capabilities as security-sensitive.

## Verification

- For build changes, run the narrowest relevant build command when feasible.
- For runtime changes, run a focused smoke test such as container start, health endpoint, logs, or CLI version check.
- For Compose changes, validate with the repo's documented Compose command before starting services when possible.
- If credentials, external registries, or unavailable runtimes block verification, state the exact blocker and perform static review.

Example commands:

```bash
docker build -t local-app:test .
podman build -t local-app:test .
docker compose config
podman compose config
```

## Output Contract

When delivering container work, include:

- Files created or updated.
- Runtime assumed or detected: Docker, Podman, or both.
- Commands run and whether they passed.
- Any secrets, registry access, or external services intentionally not used.
- Remaining risks such as unverified runtime, platform architecture, or permission differences.
