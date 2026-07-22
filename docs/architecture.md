# Architecture

<!-- LIVING document — the detailed counterpart to MEMORY.md's sketch.
     Order follows C4: context (level 1) → containers (level 2) → components (level 3).
     Record MEASURED facts (rate limits hit, deploy quirks, costs) with dates —
     intentions go stale; measurements compound.
     EXAMPLE content below describes a typical fullstack shape — replace with the
     real system when scaffolding. -->

## System context — who uses it, what it talks to

_The whole system, including parts that live in OTHER repos or that don't exist yet.
An agent reading only this section should understand what the project is for._

- **Users:** _who, and through what (browser, bot, cron, another service)_
- **This repo:** _which box(es) below it implements_
- **Sibling repos:** _frontend / execution / data repos that belong to the same system_

```
                        ┌─────────────── the system ────────────────────┐
   user ──▶ frontend ──▶│  API (THIS REPO)  ──▶  PostgreSQL             │
   (browser) (Vercel,   │  Fastify, Railway      (Railway)              │
    sibling repo)       │        │                                      │
                        │        ├──▶ external APIs (rate-limited!)     │
                        │        └──▶ workers / cron jobs               │
                        └───────────────────────────────────────────────┘
```

Data flow: request → route handler → Zod parse at the boundary → logic → typed response.

## Containers — deployable units

_One row per thing that runs somewhere. Mark what THIS repo owns._

| Unit         | Runs on | Repo         | Responsibility                            |
| ------------ | ------- | ------------ | ----------------------------------------- |
| API          | Railway | **this one** | HTTP boundary, validation, business logic |
| Frontend     | Vercel  | _sibling_    | UI; calls the API only                    |
| PostgreSQL   | Railway | —            | State (when Prisma is added)              |
| Cron/workers | Railway | **this one** | Scheduled jobs — never in-process loops   |

## Components — inside this repo

| Component      | Location        | Responsibility                                   |
| -------------- | --------------- | ------------------------------------------------ |
| Server factory | `src/server.ts` | Builds the app; registers routes; owns listen()  |
| Routes         | `src/routes/`   | One file per group; validation at the boundary   |
| Tests          | `test/`         | `app.inject()` based; no live server, no network |

## External services & measured limits

_Every external dependency with its MEASURED behavior, dated. Also mirror durable
facts into MEMORY.md "Verified facts"._

| Date | Service | Fact (rate limit / quota / latency / cost) | How measured |
| ---- | ------- | ------------------------------------------ | ------------ |
|      |         |                                            |              |

## Deployment

- Convention: Railway (backend, injects `PORT`, server binds `0.0.0.0`) / Vercel (frontend).
- Health check: `GET /api/health`. Frontend → API URL is explicit env config, never hardcoded.
- _Record actual deploy gotchas here as discovered, with dates._

## Cost decisions

_Dated log of decisions with a cost dimension (instance sizes, API tiers, storage) and the reasoning._
