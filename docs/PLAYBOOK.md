# The Playbook - why every file exists

Teaching companion to the scaffold. Each section: the practice, the reasoning, the source.
Safe to delete in a real project; the scaffold works without it.

Built from primary sources: Anthropic's Claude Code best practices (Boris Cherny),
Anthropic's context-engineering and agent-design posts, the AGENTS.md open standard,
and Andrej Karpathy's "Software 3.0" / build-for-agents principles. Full links at the bottom.

---

## The one constraint everything follows from

> "Most best practices are based on one constraint: Claude's context window fills up fast,
> and performance degrades as it fills." - Anthropic, Best practices for Claude Code

Corollaries:

- **Smallest set of high-signal tokens** - always-loaded files must be tiny and dense (Anthropic, context engineering).
- **The repo is the agent's long-term memory** - agents are amnesiac between sessions; anything not written down is lost (Karpathy: LLMs have "anterograde amnesia").
- **Agents are a third consumer of the repo** - after humans and compilers. Markdown docs, runnable commands instead of click-paths, machine-checkable gates (Karpathy, Software 3.0).
- **Verification is the highest-leverage investment** - "Give Claude a check it can run… It's the difference between a session you watch and one you walk away from." Boris Cherny: a verification loop can 2–3x result quality.

The five layers of the template map onto these directly (see README diagram).

---

## Layer 1 - Always-on instructions

### AGENTS.md (canonical)

- Open standard read natively by 20+ tools (Codex, Cursor, Copilot, Windsurf, Zed…), stewarded by the Linux Foundation. Command-first H2 sections; no enforced schema.
- Size discipline: Codex caps project docs at 32 KiB; Copilot recommends ≤2 pages. This template targets **<150 lines**.
- What goes in (Anthropic's include/exclude table): commands agents can't guess, style rules that differ from defaults, testing instructions, repo etiquette, architectural decisions, environment quirks, gotchas. What stays out: anything inferable from code, standard conventions, API docs (link instead), fast-changing info, file-by-file tours, "write clean code" platitudes.
- **The pruning test** (apply to every line): "Would removing this cause the agent to make a mistake? If not, cut it." Bloated instruction files cause agents to ignore the instructions that matter.
- Maintenance loop (Boris's team): "Anytime we see Claude do something incorrectly we add it to the CLAUDE.md" - and prune weekly. The file compounds in value.
- Monorepos: nested AGENTS.md per package, nearest file wins (OpenAI's monorepo has 88 of them).

### CLAUDE.md (bridge)

- Claude Code reads CLAUDE.md, not AGENTS.md (no native support as of mid-2026). `@AGENTS.md` imports the canonical file; only Claude-specific behavior lives below (subagent usage, memory protocol, workflow preferences). See ADR-0001.
- Debug signals: agent keeps violating a rule → file too long, rule is drowning. Agent asks questions the file answers → phrasing ambiguous.
- `CLAUDE.local.md` (gitignored) for personal, machine-specific notes.

### Writing system (prose)

- Banning words one at a time ("stop saying delve") doesn't scale - every doc still ships in the same AI voice. Give the agent a writing **system** instead: Orwell's six rules ("Politics and the English Language", 1946), in AGENTS.md. One deliberate exception: the em-dash ban (U+2014), the owner's call on a tic that grated enough to outlaw by name.
- Before/after: "Comprehensive error handling has been implemented across all API endpoints to ensure robust and reliable performance." → "We added error handling to every API endpoint." Sixteen words down to eight, same facts.
- Scope: prose only - docs, PRs, commit messages, comments, reports. Never code or technical terms.
- Session reports follow the same system (CLAUDE.md "Reporting"): what changed, what failed, what comes next - no "✅ Successfully implemented" walls.
- `/rewrite-prose` applies the rules to text written before the rules existed.

## Layer 2 - On-demand knowledge

- **Skills** (`.claude/skills/*/SKILL.md`): multi-step procedures that are only sometimes relevant. Cost ~zero tokens until invoked. Rule of thumb (Anthropic): facts true every session → AGENTS.md; procedures → skills; must-happen-always → hooks.
- **Path-scoped rules** (`.claude/rules/*.md` with `paths:` frontmatter): detail that would bloat the root file, loaded only when matching files are touched.
- **Exemplar files over exhaustive docs**: `src/routes/echo.ts` is named as the canonical pattern. Anthropic: provide "diverse, canonical examples," not a laundry list of edge cases. "Follow the pattern in X" beats three paragraphs of prose.
- **Just-in-time discovery**: clean directory structure + descriptive names let an agent load only what it needs - keep lightweight identifiers (paths, links) in context, not the contents (Anthropic, context engineering).
- **Working rules** (AGENTS.md): ask-before-assuming (+ restate the deliverable), simplest-solution-first, surgical changes, confirm-destructive-actions, verify-data-freshness - the first four from the viral Karpathy-style CLAUDE.md (community adaptation, not authored by him); the freshness and restate rules earned from this user's real `/insights` failure data (stale indexer → wrong P&L; misread request → wrong deliverable). Rules earned from observed failures beat rules copied from blogs.
- **llm-caching skill**: prompt-cache design rules for API-calling code (reads at 0.1×, frozen-prefix invariant, silent-invalidator checklist) - verified against the official caching docs, dated in the skill.

## Layer 3 - Deterministic enforcement

> "Unlike CLAUDE.md instructions which are advisory, hooks are deterministic." - Claude Code docs

If something must happen 100% of the time, it must not be prose:

- **Format-on-edit hook** (`.claude/settings.json` PostToolUse → `.claude/hooks/format.sh`): Prettier runs after every agent edit. No "please format your code" rule needed - delete such rules from instruction files once a hook exists.
- **Committed permission allowlist** (`.claude/settings.json`): Boris's team explicitly prefers a shared, committed allowlist over `--dangerously-skip-permissions`. `make *`, `npm run *`, test/lint tools pre-approved; `.env` reads denied.
- **Pre-commit secret scan** (`.githooks/pre-commit`): gitleaks when installed (150+ patterns + entropy, plus `.gitleaks.toml` wallet rules for EVM keys / Solana keypairs / mnemonics), regex fallback otherwise - the gate never silently disappears. `--no-verify` documented as the false-positive escape.
- **Supply-chain cooldown**: never install a package version published <24h ago (AGENTS.md rule); Dependabot enforces 7-day / 14-day-major cooldowns mechanically, security patches exempt. npm worms spread within hours of a compromised publish - waiting out the first wave costs nothing.
- **CI = local gate** (`.github/workflows/ci.yml` runs exactly what `make check` runs) plus a gitleaks history scan and `npm audit`. If it passes locally it passes in CI.
- **SECURITY.md** is the written model (secrets, wallet keys, supply chain, agent safety); the `security-audit` skill is its executable form - same checklist, run by the agent with evidence.

## Layer 4 - Verification

- **One command, well named**: `make check`. Anthropic's tool-design guidance applied to the repo itself - consolidated, high-leverage commands beat multi-step incantations; agents (and humans) shouldn't need tribal knowledge to verify work.
- The scaffold ships with real code and passing tests so the loop **demonstrably works** - a template whose gate has never run is a template that lies.
- Escalating verification gates (from the best-practices doc): in-prompt ("run tests after") → Stop-hook (blocks turn end) → **verifier subagent** (fresh context, adversarial). This template ships the subagent.
- Evidence, not assertion: PR template and `/commit-push-pr` both require pasting actual `make check` output. "Looks done" is not a signal.

## Layer 5 - Memory across sessions

- **MEMORY.md + ERRORS.md**: agent-maintained memory, split by purpose - MEMORY.md holds context, verified facts, and lessons; ERRORS.md holds bugs with root causes and failed approaches (read it before debugging anything familiar). Updated after every significant task via `/update-memory`. The "Verified facts" table pairs with the hard rule _never guess external facts_ - the highest-value habit from the trading repos this template distills (originally the FORNADAR protocol; renamed to the generic MEMORY/ERRORS convention for portability).
- **Memory-file design** (mined from this dev's live FORNADAR.md files + Cline Memory Bank, Google SRE postmortems, Claude Code memory docs):
  - MEMORY.md is the _distilled_ layer: index not archive (~200-line cap, one line per entry), volatility split ("Current focus" is overwritten; everything else accretes), every fact = value + date + source + how verified. A fact without provenance doesn't belong.
  - ERRORS.md is the _log_ layer: append-only, dated `## YYYY-MM-DD - STATUS: headline` entries; corrections are new entries, never rewrites (wrong turns stay searchable). Five-line format: Symptom (the grep key) / Root cause (condition, not trigger) / Fix / Earlier catch / Dead ends.
  - ROADMAP.md honesty = granularity: detail only in Now (with appetite + verify step), one-liners in Later, dated Done as the evidence trail. Cull Later freely.
  - Update triggers must be structural, not vigilance-based (ngrok's bmo: "note when you learn something" fired 2× in 60 sessions; end-of-task checkpoints fire every time) - hence `/update-memory` in the commit command, not a "stay alert" rule.
  - All three ship with EXAMPLE entries from real projects - canonical examples over empty scaffolds; delete them when scaffolding.
  - **Scale path (ADR-0002)**: files first - Claude Code itself dropped RAG because agentic grep "outperformed everything" (Cherny) - but past a measured threshold (~200-line MEMORY.md cap unholdable, ~50KB ERRORS.md) structured facts graduate to a SQLite kb via the `knowledge-base` skill: queryable provenance (`kb facts --subject X --since DATE`), diffable `kb.sql` in git, prose stays in markdown. SQL is for what you query, files are for what you read.
- **ADRs** (`docs/decisions/`): decisions with the _why_, so future sessions (and teammates) don't re-litigate them. ADR-0001 dogfoods the format.
- **SPEC.md convention** (`/interview-spec`): for larger features, the agent interviews you, writes a self-contained spec, and implementation happens in a **fresh session** - separating research from implementation avoids solving the wrong problem and keeps context clean.
- **docs/architecture.md**: living doc for _measured_ facts (rate limits hit, deploy gotchas, costs) with dates. Intentions go stale; measurements compound.
- **ROADMAP.md + roadmap-check**: Now/Next/Later/Done gives sessions direction; the `roadmap-check` subagent compares recent commits against it and flags drift (work advancing nothing, stalled Now items, invisible shipped scope). Deliberately a detector, not a gate - fixes and chores legitimately map to nothing, and a blocking check would just teach everyone to ignore it.

---

## Workflow practices (not files - habits)

- **Explore → Plan → Code → Commit.** Plan mode for anything non-trivial; "if you could describe the diff in one sentence, skip the plan."
- **TDD with agents**: write the failing test first (`/fix-issue` encodes this). Optionally one session writes tests, a fresh one implements.
- **Course-correct early**: if you've corrected the agent twice on the same issue, `/clear` and restart with a better prompt - "a clean session with a better prompt almost always outperforms a long session with accumulated corrections."
- **Fresh-context review**: a reviewer that didn't write the code isn't biased toward it (`code-reviewer` subagent; or a second terminal session).
- **Parallelism**: git worktrees for independent tasks; headless `claude -p` for batch migrations (test the prompt on 2–3 files first).
- **Visual iteration**: paste a design/screenshot, have the agent implement, screenshot the result, diff, fix.
- **Prefer CLIs (`gh`, `aws`, `railway`) over MCP where both exist** - "the most context-efficient way to interact with external services." Install `gh` so agents can work issues/PRs directly.

## Sources

- Anthropic - Claude Code best practices (Boris Cherny): https://code.claude.com/docs/en/best-practices
- Anthropic - CLAUDE.md / memory: https://code.claude.com/docs/en/memory · settings: /en/settings · hooks: /en/hooks · subagents: /en/sub-agents · skills: /en/skills
- Anthropic - Effective context engineering for AI agents: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- Anthropic - Writing effective tools for agents: https://www.anthropic.com/engineering/writing-tools-for-agents
- Anthropic - Building effective agents: https://www.anthropic.com/engineering/building-effective-agents
- Anthropic - How Anthropic teams use Claude Code: https://claude.com/blog/how-anthropic-teams-use-claude-code
- AGENTS.md open standard: https://agents.md · spec repo: https://github.com/openai/agents.md
- OpenAI Codex - AGENTS.md discovery & best practices: https://learn.chatgpt.com/docs/agent-configuration/agents-md
- Andrej Karpathy - Software Is Changing (Again) / Software 3.0 (Latent Space write-up): https://www.latent.space/p/s3
- Simon Willison - Designing agentic loops: https://simonw.substack.com/p/designing-agentic-loops
- George Orwell - Politics and the English Language (1946), via Vox (@Voxyz_ai) on applying it as an agent writing system: https://x.com/Voxyz_ai
- llms.txt spec (relevant only if this repo publishes docs / is a consumed library): https://llmstxt.org
- gitleaks (secret scanning): https://github.com/gitleaks/gitleaks
- Dependabot cooldown reference: https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference
- Anthropic - prompt caching docs: https://platform.claude.com/docs/en/build-with-claude/prompt-caching
- Robert C. Martin - Clean Code ch. 2, "Meaningful Names" (intention-revealing, searchable, no abbreviations)
- Karpathy-style community CLAUDE.md (four working rules): https://github.com/multica-ai/andrej-karpathy-skills
- Cline Memory Bank: https://docs.cline.bot/prompting/cline-memory-bank
- Google SRE - Postmortem Culture: https://sre.google/sre-book/postmortem-culture/
- Now/Next/Later origin (Janna Bastow): https://www.prodpad.com/blog/invented-now-next-later-roadmap/
- ngrok - self-improving coding agent (structural vs vigilance triggers): https://ngrok.com/blog/bmo-self-improving-coding-agent
- Claude Code's no-RAG agentic search (background for ADR-0002): https://vadim.blog/claude-code-no-indexing/
- Anthropic memory tool (file or DB backend): https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool
