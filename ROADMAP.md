# Roadmap

<!-- Now / Next / Later / Done. The honesty mechanism is GRANULARITY:
     - Now: detailed, outcome-phrased, carries an appetite (small ~1-2wk / big ~6wk)
       and a per-item verify step. Never a date, never an estimate.
     - Next: committed, fewer specifics. Pulling Next → Now is a decision, not drift.
     - Later: one line max per item. A detailed Later item is a lie about certainty.
       Cull freely - real ideas resurface on their own.
     - Done: dated (ISO), newest first, outcome language. This section is the proof
       the roadmap is real - if nothing moves here, the file is fiction.
     The roadmap-check subagent diffs recent commits against this file.
     EXAMPLE items below are illustrative - delete when scaffolding. -->

> **Template note:** items marked below are examples showing the format - delete when scaffolding.

## Now

_1–3 items max. If an item sits here more than a few weeks, it is too big (split it) or not actually Now (move it). Appetite = the time you give it before rethinking (small ≈ 1-2 weeks, big ≈ 6)._

- [ ] _(example)_ Users can create an account and log in - appetite: small (~1-2wk).
      Verify: e2e test signup → login → `GET /api/me` returns the user; `make check` green.

## Next

- _(example)_ Password reset by email (needs a mail provider decision first - see docs/decisions/)

## Later

- _(example)_ Admin dashboard
- _(example)_ Rate limiting per API key

## Done

- _(example)_ 2026-07-20 - Template scaffolded: verification gate (`make check`), secret scanning, CI, agent config all working.
