---
name: new-endpoint
description: Add a new API endpoint following this repo's route pattern. Use when asked to add a route, endpoint, or API handler.
---

# Adding a new endpoint

Follow the canonical pattern in `src/routes/echo.ts` - read it first.

1. Create `src/routes/<name>.ts`:
   - Define the Zod schema(s) at the top; infer types with `z.infer`. Never hand-write a type the schema defines.
   - Export `async function <name>Routes(app: FastifyInstance): Promise<void>`.
   - Validate with `schema.safeParse`; return `400` with `{ error, issues }` on failure.
2. Register the route in `src/server.ts` (`void app.register(<name>Routes)`).
3. Create `test/<name>.test.ts` mirroring `test/echo.test.ts`:
   - One happy-path test, one invalid-input test minimum. Use `app.inject()` - never a live server.
4. Run the single test file while iterating: `npx vitest run test/<name>.test.ts`
5. Finish with `make check` and show the output.

Conventions: route paths start with `/api/`; one route group per file; handlers stay under
~50 lines - extract logic into plain functions when they grow.
