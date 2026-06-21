---
name: agent-handoff
description: Write a structured handoff document so a fresh subagent can continue without the current conversation history. Use at a module or domain boundary, on feature completion, or when context degradation is detected ("I'm re-reading earlier decisions to stay consistent"). Never invoke mid-cycle during TDD or /implement.
---

## Step 1 — Get timestamp

Run `date +%Y%m%d-%H%M%S` via Bash. The output path is:

```
$CLAUDE_PROJECT_DIR/.claude-handoffs/<timestamp>.md
```

Create the directory if it doesn't exist. Done when the directory exists.

## Step 2 — Write the handoff document

Write to the path above. Done when every section below is present and non-empty.

### Context
Goal, not history. One paragraph: what's being built and why.

### Entry points
Paths the next subagent should read first. Paths only — no content duplication.

### Boundary decisions
Choices made this session that the code doesn't explain: why an interface was shaped a certain way, constraints discovered, tradeoffs accepted. Skip what the code already says.

### Remaining work
What's left, specific enough to start without asking. For TDD sessions: the unchecked behaviors from the original plan.

### Suggested skills
Which skills to invoke next (e.g. `/tdd`, `/implement`).

## Step 3 — Print the path

Print the absolute path to the handoff file. Done when the path is printed to stdout — the orchestrating agent passes it directly into the next subagent prompt.

---

Reference existing artifacts by path (PRDs, ADRs, issues, recent commits) — never duplicate their content. If arguments were passed, treat them as the focus of the next subagent and tailor Remaining work accordingly.
