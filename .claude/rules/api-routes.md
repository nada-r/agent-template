---
paths:
  - 'src/routes/**/*.ts'
---

# API route rules

<!-- Path-scoped rule: loads only when files under src/routes/ are in play.
     Detail that would bloat AGENTS.md lives here instead. -->

- Every request body, query, and param is parsed with a Zod schema before use — no direct `request.body` access past the parse.
- Validation failures return `400` with `{ error: string, issues: ZodIssue[] }` — the shape in `src/routes/echo.ts`.
- Route files never import each other; shared logic goes in `src/lib/` (create it when first needed).
- Every new or changed route gets a happy-path test AND an invalid-input test.
