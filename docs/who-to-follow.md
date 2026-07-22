# Who to follow: agentic coding

Directory of the people whose practices shaped this template, with their canonical
resources. Built by adversarial deep research on 2026-07-23: 24 sources fetched,
113 claims extracted, top 25 verified by 3-vote panels (23 confirmed, 2 refuted).
Entries marked "not re-verified" come from an earlier repo benchmark, not this run.
Affiliations move fast: re-check before quoting anyone.

## Tier 1: template-shaping

**Boris Cherny** (Anthropic, creator and head of Claude Code) - @bcherny. Says Claude
Code has been 100% written by Claude Code for over six months (self-reported).

- Best practices: https://code.claude.com/docs/en/best-practices
- Platformer interview (May 2026): https://www.platformer.news/boris-cherny-interview-ai-jobs/
- X: https://x.com/bcherny

**Jesse Vincent** (Prime Radiant; GitHub obra). Superpowers: a composable-skills
methodology (brainstorm, plan, subagent implementation, two fresh-context reviews).
Says he has not hand-written code since October 2025 (self-reported). Track record:
Request Tracker, K-9 Mail, Keyboardio.

- https://github.com/obra/superpowers
- https://blog.fsck.com
- MLOps talk: "Why real agentic engineering beats vibe coding"

**Dex Horthy** (HumanLayer) - @dexhorthy. 12-factor-agents: rejects the naive
"prompt plus a bag of tools, loop until done" pattern; owned prompts, owned control
flow, small stateless agents.

- https://github.com/humanlayer/12-factor-agents

**Erik Schluntz and Barry Zhang** (Anthropic). "Building Effective Agents"
(Dec 2024): the workflows-vs-agents distinction and simplicity-first. Still the
standard architecture citation.

- https://www.anthropic.com/engineering/building-effective-agents

## Tier 2: steady signal

**Simon Willison** - datasette creator. Active "agentic-engineering" tag, ~58 posts
through July 2026. The field's most reliable chronicler.

- https://simonwillison.net/tags/agentic-engineering/

**OpenAI Codex team**. Alexander Embiricos (@embirico) is product lead and public
voice; Thibault Sottiaux is Head of Codex (leads the merged org after the July 2026
reorg); Hanson Wang trained codex-1. The written guidance (AGENTS.md as "an
open-format README for agents", short beats long) is institutional, no byline.
Podcast guidance: typed languages, small well-tested modules, names agents can search.

- https://developers.openai.com/codex/learn/best-practices
- Sequoia Training Data episode: https://sequoiacap.com/podcast/training-data-openai-codex/
- https://agents.md

**Mitchell Hashimoto** (ghostty; not re-verified this run). CLAUDE.md as a literal
symlink to AGENTS.md, AI_POLICY.md with mandatory disclosure, tripwire guardrails.

- https://github.com/ghostty-org/ghostty
- "Vibing a Non-Trivial Ghostty Feature" (his blog)

**Andrej Karpathy** (not re-verified this run). Coined vibe coding (Feb 2025),
renamed the serious practice "agentic engineering" (Feb 2026): orchestrate and
supervise agents rather than write code.

- Software 3.0 talk write-up: https://www.latent.space/p/s3

## Tier 3: opinionated, calibrate before adopting

**Peter Steinberger** (not re-verified this run). agent-rules is deprecated by its
author; successor is agent-scripts. Contrarian on subagents ("mostly charade") and
on markdown sprawl; runs one large AGENTS.md. Reported affiliation "OpenClaw"
(single source, unconfirmed).

- https://github.com/steipete/agent-scripts
- https://steipete.me

**DHH** (Basecamp/Rails). A moving target, not a static skeptic: the verified quote
is felt skill atrophy from AI-assisted Bash on Omakub ("I can literally feel
competence draining out of my fingers", Lex Fridman #474). Two stronger
skeptic claims were refuted 3-0 in verification, and by January 2026 he had
reportedly reversed toward agent-first work. Read him time-stamped.

- Lex transcript: https://lexfridman.com/dhh-david-heinemeier-hansson-transcript/
- Pragmatic Engineer, "DHH's new way of writing code"
- https://world.hey.com/dhh

**Armin Ronacher, Thorsten Ball, Geoffrey Huntley** (none re-verified this run).
Ronacher: "Agentic Coding" essays, agent-diagnosable runtimes. Ball: "How to Build
an Agent". Huntley: Ralph-loop experiments.

## Solana: thin under verification

**"SpacemanDEV" is Dev Bharel** (GitHub spacemandev-git; ex-Jump Crypto devrel).
X bio says "builder relations - ai @solanafndn"; self-reported only, no Foundation
page confirms it. No published agentic-coding setups found to cite.
Armani Ferrante (Backpack, Anchor): zero public agentic-coding footprint as of
July 2026. The solana-ai-kit repo belongs to Superteam Brazil, not to either.
Verdict: low-signal category for a template maintainer today.

## Refuted during verification

- "DHH tried Cursor/Windsurf and rejects agent-driven editing, keeping AI as a
  side-window consultant": refuted 0-3.
- "DHH types all production code himself": refuted 0-3.

Star counts were internally inconsistent across sources; none are quoted here.
