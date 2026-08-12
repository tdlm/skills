# Approach

**Approach commits the ticket to decisions, not mechanisms.** The implementing engineer should be free to pick their own tools, file paths, and wiring as long as their result satisfies every AC.

Apply the **decisions-vs-mechanisms litmus** (defined in the skill's Core idea) to every bullet:

> Could the engineer make a different choice here and still pass every AC?
>
> - **Yes** -> it's a mechanism. Cut it from Approach (or, if the constraint is actually load-bearing, lift it into AC).
> - **No** -> it's a decision. Keep it.

## Concrete rules

- Name a file/path only when it's a **proper noun the team needs to learn** (a new directory convention, a new public command, a new public import path).
- Don't enumerate specific script paths, config field values, library choices, or internal artifact names. Those go in the PR.
- Use nested bullets when a parent bullet covers >=3 distinct **strategic concerns**. Don't nest just to enumerate files.
- A reviewer reading Approach should still need to ask "where exactly does that go?" for most items -- that's correct.

## Before / after

Too prescriptive (lists mechanisms an engineer could swap):

```markdown
- **Pipeline scaffolding** -- Commit `rulesync.jsonc` (`cursor + claudecode`, `rules + skills + hooks`, `delete: true`), the `pnpm rulesync` script, and `scripts/rulesync/notify-drift.sh` wired into lefthook `post-checkout` / `post-merge` / `post-rewrite`.
```

Strategy only (decisions an engineer must respect):

```markdown
- **Pipeline scaffolding** -- Adopt the spike's generator config with manual-only generation (no postinstall, no auto-regen). Teammates get notified when source changes.
```

The specific script names, lefthook event names, and config field values are mechanisms -- AC covers the behavior they produce, so they don't belong here. The architectural commitment (manual generation, drift awareness) is the decision, so it stays.

**If Approach feels too thin:** the fix is to strengthen AC, not pad Approach. Approach's job is to name decisions; AC's job is to pin down "done". Keeping that separation is what makes the ticket skimmable.
