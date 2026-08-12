# Minimal tier example

Bug fix, small follow-up, or work where context is one ticket-link away. Summary + AC only -- skip Background/Approach/etc. unless the linked ticket truly doesn't cover them.

**Description** (goes into the Description field):

```markdown
## Summary

Follow-up to PAID-204: the asset-path codemod missed Lottie imports inside `src/app/(marketing)/`, so a handful of files still import from `@/public/lotties/`. Update the remaining imports to `@/assets/lotties/` to finish the migration.
```

**Acceptance Criteria** (goes into the dedicated JIRA field as a task list):

- No remaining imports from `@/public/lotties/` anywhere in the repo
- Affected pages render the same Lottie animations as before

Note how Background and Approach are omitted -- the linked ticket (PAID-204) already carries the rationale and strategy, so repeating it here would be noise.
