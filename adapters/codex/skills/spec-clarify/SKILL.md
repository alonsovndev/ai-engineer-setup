---
name: spec-clarify
description: "Capture a raw idea or requirement and refine it through a short round of clarifying questions."
---

Use this skill when the user invokes `$spec-clarify` or asks for this workflow. Apply any scope, options, and details supplied with the invocation.

Capture a raw idea or requirement and refine it through a short round of clarifying questions.

Use the `spec-planning` skill.

Read the raw idea from the arguments (or ask for it if empty). Ask at most 5 targeted clarifying questions — only the ones that would change scope, constraints, or acceptance criteria. Skip anything already answered in the raw idea. Finish with a structured Refined Requirement recap (objective, scope in/out, constraints, non-functional requirements, assumptions marked TBD, acceptance criteria, open risks) and tell the user to run `$spec-write` next. Do not write any files in this command.
