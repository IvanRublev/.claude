# Claude [Code](https://claude.com/product/claude-code) Global Config

Workflow: plan → TDD → ponytail review → code review → verify → ship. GBrain with ollama:nomic-embed-text for past decision search, cocoindex-code with Snowflake/snowflake-arctic-embed-xs for code search.

[CLAUDE.md](./CLAUDE.md)


## Third-party skills

- [Egonex-AI/Understand-Anything](https://github.com/Egonex-AI/Understand-Anything) — generates an interactive knowledge graph from a codebase for architecture exploration
- [nizos/probity](https://github.com/nizos/probity) — guardrail hooks to prevent agent deviation from TDD green-red-refactor cycle, execution of unsafe commands, and implementation of prohibited code patterns
- [Roxabi/cocoindex-code](https://github.com/Roxabi/cocoindex-code) — fast AST-based semantic code search
- [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) — prevents over-engineering by enforcing the laziest senior-developer style solutions (~54% code reduction compared to Claude Haiku 4.5)
- [mattpocock/skills](https://github.com/mattpocock/skills) — strategic and tactical DDD, supports domain modelling and TDD implementation
- [garrytan/gstack](https://github.com/garrytan/gstack) — end-to-end business design for startups from strategy to code according to Y-Combinator president's standards


## Own skills

- [agent-handoff](./skills/agent-handoff) — saves context to pass between subagents to continue a TDD session


## Hooks

[settings.json](./settings.json)

- [block-dangerous-git.sh](./hooks/block-dangerous-git.sh) — prevents the agent from running dangerous git commands like `git reset --hard`
- [probity-init.sh](./hooks/probity-init.sh) — adds the default guardrails configuration to a new project
- [session-price.sh](./hooks/session-price.sh) — prints the cost per million tokens for the selected model on session start



---
Ivan Rublev (c) 2026.