# Architecture

<!-- LIVING document — the detailed counterpart to MEMORY.md's sketch.
     Record MEASURED facts (rate limits you hit, deploy quirks you debugged, costs)
     with dates. An architecture doc that only holds intentions goes stale;
     one that holds measurements compounds. -->

## System diagram

```
                ┌─────────────────────────────┐
   client ────▶ │  Fastify  (src/server.ts)   │
                │   ├── /api/health           │
                │   └── /api/echo   (Zod)     │
                └──────────┬──────────────────┘
                           │
                 [ db / external APIs — none yet ]
```

Data flow: request → route handler → Zod parse at the boundary → logic → typed response.

## Components

| Component      | Location        | Responsibility                                   |
| -------------- | --------------- | ------------------------------------------------ |
| Server factory | `src/server.ts` | Builds the app; registers routes; owns listen()  |
| Routes         | `src/routes/`   | One file per group; validation at the boundary   |
| Tests          | `test/`         | `app.inject()` based; no live server, no network |

## External services & measured limits

_Record every external dependency with its MEASURED behavior, dated:_

| Date | Service | Fact (rate limit / quota / latency / cost) | How measured |
| ---- | ------- | ------------------------------------------ | ------------ |
|      |         |                                            |              |

## Deployment

- Convention: Railway (backend) / Vercel (frontend). Railway injects `PORT`; server binds `0.0.0.0`.
- Health check endpoint: `GET /api/health`.
- _Record actual deploy gotchas here as they are discovered, with dates._

## Cost decisions

_Dated log of decisions with a cost dimension (instance sizes, API tiers, storage choices) and the reasoning._
