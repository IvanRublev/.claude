## Workflow Orchestration

### 1a. Plan Mode Strategical — Greenfield Projects
1. Enter plan mode immediately
2. Run `/office-hours` to explore product and technical direction
3. Copy its outputs: `cp ~/.gstack/projects/{repo_slug}/*-design-*.md docs/design/`
4. Run `/grill-with-docs docs/design` — produces `CONTEXT.md` and ADR files; ADRs land in `docs/adr/`
5. Add to the project's `CLAUDE.md`: _"Infer project context from `CONTEXT.md` and the ADR files in `docs/adr/`."_
6. Run `/autoplan` — it picks up the local `CLAUDE.md` and design artifacts automatically

### 1b. Plan Mode Tactical — Brownfield Projects (existing code)
- Enter plan mode for any non-trivial task (3+ steps or architectural decisions) — **except bug fixes, which skip planning (see §5)**; present the plan via ExitPlanMode and, once approved, write the durable plan to `tasks/todo.md` before implementing (see Task Management)
- If something goes sideways, **stop** and re-plan immediately — don't keep pushing
- Plan non-trivial verification steps, not just building
- Write detailed specs upfront to reduce ambiguity — `/spec` to turn vague intent into an executable spec
- `/autoplan` to review a plan (CEO/design/eng/DX passes), or run them individually: `/plan-ceo-review`, `/plan-eng-review`, `/plan-design-review`, `/plan-devex-review`
- Implement with `/tdd`

### 2. Subagent Strategy
- Use subagents liberally to keep the main context window clean — offload research, exploration, and parallel analysis, and throw more compute at complex problems this way
- One task per subagent for focused execution
- **`/tdd` subagent lifecycle**: run `/tdd` inside a subagent; respawn it at each module boundary, completed feature, or implemented vertical slice; also respawn on context rot — detectable when the subagent re-reads files it already processed, repeats earlier analysis, loses track of prior decisions, or starts asking questions already answered; use `/agent-handoff` to transfer state before each respawn

### 3. Self-Improvement Loop
- After **any** correction from the user: persist it to memory (`feedback` type) — that's the system for behavioral corrections, and it auto-loads each session. Use `/learn` instead for project/codebase patterns ("didn't we fix this before?")
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review prior feedback memories at session start; `/retro` for a weekly engineering retrospective
- When a correction involves **blocking a specific code pattern** and it can be expressed as a regex: add a `forbidContentPattern` rule to the project's `probity.config.js` in addition to updating memory. Memory tells Claude; the probity rule enforces it mechanically. Prefer both over either alone.

### 4. Verification & Elegance
- Never mark a task complete without proving it works — `/verify` to run the app, `/qa` to test + fix (`/qa-only` to report only)
- Diff behavior between main and your changes when relevant
- On any diff: run `/ponytail-review` first (trim over-engineering), then `/code-review` for correctness/bugs (`ultra` for high-stakes diffs: auth, payments, migrations, large/risky PRs)
- `/security-review` for security-sensitive changes; `/review` as the pre-landing PR gate (runs design + eng + DX passes); `/design-review`, `/devex-review` for those dimensions alone; `/health` for a quality dashboard
- Run tests, check logs, demonstrate correctness
- Ponytail runs at full mode by default; `/ponytail-audit` for periodic whole-repo sweeps

### 5. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding — `/investigate` for systematic root-cause debugging; `/ios-fix` for iOS apps
- Point at logs, errors, failing tests — then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how
- Skip the plan-mode check-in for bug fixes

## Task Management

1. **Verify Plan**: Present the plan via ExitPlanMode and check in before starting implementation
2. **Record Plan**: Once approved, write the durable plan to `tasks/todo.md`
3. **Track Progress**: Use the harness `TaskCreate`/`TaskUpdate` tools for live in-session status (not hand-maintained checkboxes)
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to `tasks/todo.md`; `/document-release` / `/document-generate` for user-facing docs
6. **Capture Lessons**: Persist behavioral corrections to memory (`feedback` type); project/codebase patterns to `/learn` — see Self-Improvement
7. **Preserve Context**: `/context-save` before a long pause, `/context-restore` to resume

## Core Principles

- **No sloppiness**: Find root causes, not band-aids. Lazy means fewer lines, never flimsier logic

## gstack

- Use the `/browse` skill from gstack for **all** web browsing
- **Never** use `mcp__claude-in-chrome__*` or `mcp__claude_ai_Google_Drive__*` tools
- Ship flow: `/ship` then `/land-and-deploy`; `/canary` to monitor post-deploy, `/benchmark` for perf regressions
- Safety: `/careful` (destructive-command guardrails), `/freeze`/`/unfreeze` (scope edits to a dir), `/guard` (both), `/cso` (security mode)
- `/gstack-upgrade` to update gstack

## GBrain Configuration (configured by /setup-gbrain)
- Mode: local-stdio
- Engine: pglite
- Config file: ~/.gbrain/config.json (mode 0600)
- Setup date: 2026-06-21
- MCP registered: yes (user scope, /Users/ivan/.bun/bin/gbrain serve)
- Embedding: ollama:nomic-embed-text (768d) — requires `ollama serve`
- Artifacts sync: off
- Current repo policy: n/a (no git remote in setup repo)
- Code indexing: DISABLED — always pass `--no-code` to gstack-gbrain-sync (alias in ~/.zshrc). Code search is handled by ccc (cocoindex-code) instead.

## GBrain Prerequisites
- **Before any gbrain operation** (search, query, sync, MCP tools): ensure ollama is running to provide embeddings (`ollama:nomic-embed-text`) - use command `pgrep -x ollama || ollama serve &`

## GBrain Search Guidance (configured by /sync-gbrain)
<!-- gstack-gbrain-search-guidance:start -->
GBrain is set up and synced on this machine. The agent should prefer gbrain
over Grep when the question is semantic or when you don't know the exact
identifier yet. Note: code indexing is disabled (ccc handles that) — use
gbrain for conversations, decisions, and artifacts only.

Prefer gbrain when:
- "What did we decide last time?" / past plans, retros, learnings:
    `gbrain search "<terms>" --source gstack-brain-ivan`
- "What was I working on during session X?":
    `gbrain search "<terms>"`
- Semantic questions about decisions or artifacts (not code):
    `gbrain query "<question>"`

Use ccc (cocoindex-code) for all code search:
- Symbol definitions, references, callers — use ccc, not gbrain
- Exact string or regex matches — use Grep

The brain auto-syncs incrementally on every gstack skill start (--no-code).
Run `/sync-gbrain` to force-refresh.
<!-- gstack-gbrain-search-guidance:end -->
