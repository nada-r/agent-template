---
description: Interview me about a feature, then write SPEC.md
argument-hint: <feature description>
disable-model-invocation: true
---

I want to build: $ARGUMENTS

Interview me in detail using the AskUserQuestion tool. Cover:

- Technical implementation: data model, endpoints, external services, failure modes
- UI/UX if applicable
- Edge cases and what is explicitly OUT of scope
- How we will verify it works end-to-end (the definition of done)

Keep interviewing until we've covered everything. Then write a complete, self-contained
spec to `SPEC.md`: name the files and interfaces to touch, state what's out of scope,
and end with a concrete end-to-end verification step.

Do NOT start implementing — I will start a fresh session to implement from the spec.
