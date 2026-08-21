---
name: terraform
description: "Use when working with Terraform, OpenTofu, HCL, .tf files, modules, providers, backends, state, plan output, imports, moved blocks, IAM/security, or CI/CD workflow guidance. Keywords: terraform, opentofu, hcl, tf, module, provider, backend, state, plan, apply, import, drift, infrastructure-as-code."
argument-hint: "Describe the infrastructure task: module design, plan review, state operation, provider/backend config, import, or security review."
user-invocable: true
---
# Terraform / OpenTofu Skill

Use this skill when working with Terraform or OpenTofu infrastructure-as-code.

For security-specific concerns (secrets, IAM least privilege, public exposure), also apply the `secure-code-generation` skill. For diagramming infrastructure architecture, also apply the `diagram-author` or `drawio-author` skill.

## Safety Rules

- Never request, expose, store, or commit cloud credentials, tokens, secrets, real `.tfvars`, or state files.
- Never run `apply`, `destroy`, `import`, `state rm`, `state mv`, workspace changes, backend migration, or provider upgrades without explicit user approval and target environment confirmation.
- Treat production applies, state operations, imports, destroys, and provider upgrades as high-risk.
- Separate observed facts from assumptions; mark unknowns as `TBD`.

## Required Checks

- Identify whether the project uses Terraform, OpenTofu, Terragrunt, or a wrapper.
- Read relevant `.tf` files, `.tfvars.example`, `.terraform.lock.hcl`, backend configuration, provider versions, and module files.
- Confirm target environment: local, dev, test, stage, prod, or Terraform Cloud workspace.
- Do not read or edit real `.tfvars`, state files, or credential files unless the user confirms they are sanitized.

## Module Design

- Clear input/output contracts over hidden coupling between modules.
- Validate variable types, descriptions, and defaults; use `validation` blocks for constraints.
- Flag excessive module abstraction, duplicated resources, and environment-specific logic inside reusable modules.
- Prefer explicit resource dependencies over implicit ordering.

## Providers And Backends

- Check provider version constraints and `.terraform.lock.hcl` consistency.
- Review backend and workspace strategy for state isolation and blast-radius control.
- Flag backend migrations and workspace changes as requiring explicit rollout steps.
- Use `required_providers` with explicit version pins.

## Plan And Lifecycle Safety

- Review `plan` output for creates, updates, deletes, replacements, unknown values, drift, and dependency ordering.
- Flag risky lifecycle behavior: missing `lifecycle.prevent_destroy`, unsafe `ignore_changes`, unnecessary `create_before_destroy`, and broad resource replacement.
- Require justification for deletes, replacements, and changes to externally managed resources.

## State, Imports, And Refactors

- Prefer `moved` blocks for Terraform-native refactors when supported.
- Plan imports, `state mv`, and `state rm` as explicit, reviewable runbooks.
- Never suggest state changes without target addresses, backup guidance, validation steps, and rollback or recovery notes.

## Security And Access

- Review IAM least privilege, public exposure, encryption, network boundaries, logging, and secret handling.
- Never put secrets in `.tf`, `.tfvars`, outputs, examples, docs, logs, or plan snippets.
- Use `sensitive = true` on outputs that contain credentials or private data.
- Mark sensitive outputs and avoid exposing generated credentials in state where possible.

## CI/CD And Policy

- Prefer gates for `terraform fmt`, `terraform validate`, static checks, plan review, policy checks, and manual approval before apply.
- Keep apply permissions separate from plan permissions.
- Require environment and workspace clarity before approving any apply workflow.

## Verification

- Run `terraform fmt -check` for formatting consistency.
- Run `terraform validate` for syntax and internal consistency.
- Review `terraform plan` output for unexpected changes before any apply.
