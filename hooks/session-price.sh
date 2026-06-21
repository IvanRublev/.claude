#!/usr/bin/env bash
# SessionStart hook: print the active model's per-MTok price as a welcome message.
# Reads model from stdin JSON; falls back to a full table if it can't be determined.
# ponytail: substring-match on model id; add exact-id map only if ids collide.

in=$(cat)
model=$(printf '%s' "$in" | jq -r '.model // empty' 2>/dev/null)
# Fast mode is a setting, not in stdin — best-effort read of the global setting.
fast=$(jq -r '.fastMode // false' ~/.claude/settings.json 2>/dev/null)

case "$model" in
  *fable-5*)   msg="💰 Fable 5 — \$10/MTok in · \$50/MTok out" ;;
  *opus-4-8*)  msg="💰 Opus 4.8 — \$5/MTok in · \$25/MTok out"
               [ "$fast" = "true" ] && msg="$msg  ·  fast: \$10/\$50" ;;
  *opus-4-7*)  msg="💰 Opus 4.7 — \$5/MTok in · \$25/MTok out"
               [ "$fast" = "true" ] && msg="$msg  ·  fast: \$30/\$150" ;;
  *sonnet-4-6*) msg="💰 Sonnet 4.6 — \$3/MTok in · \$15/MTok out" ;;
  *haiku-4-5*) msg="💰 Haiku 4.5 — \$1/MTok in · \$5/MTok out" ;;
  *) msg="💰 Usage pricing (per MTok, in/out): Fable 5 \$10/\$50 · Opus 4.8 \$5/\$25 (fast \$10/\$50) · Opus 4.7 \$5/\$25 (fast \$30/\$150) · Sonnet 4.6 \$3/\$15 · Haiku 4.5 \$1/\$5" ;;
esac

jq -n --arg m "$msg" '{systemMessage: $m}'
