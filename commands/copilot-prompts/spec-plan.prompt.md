---
description: "Capture a raw idea or requirement and refine it through a short round of clarifying questions"
name: "Spec Plan"
argument-hint: "Raw idea or requirement text"
agent: "product-ba"
---
Use the `spec-planning` skill to refine a raw idea or requirement into a clear, testable requirement.

Arguments: $ARGUMENTS

Ask at most 5 targeted clarifying questions — only ones that change scope, constraints, or acceptance criteria. Skip anything already answered in the input. Finish with a structured Refined Requirement recap (objective, scope in/out, constraints, non-functional requirements, assumptions marked TBD, acceptance criteria, open risks) and point the user to the "Spec Write Plan" prompt next. Do not write any files.
