# fix profile

Something was broken and now isn't. Covers `fix` and `revert`. Total budget: **~180-320 words**.

## Sections to compose

In this order, reading each section's guidance before drafting it. Each section's
own doc carries its include test; the number in parentheses is its word ceiling.

1. Description (under 70) — [../sections/description.md](../sections/description.md)
   - Its nested fields follow the paragraph: the ticket link, then preview URL
     blocks when they apply —
     [../sections/ticket-link.md](../sections/ticket-link.md) and
     [../sections/preview-url.md](../sections/preview-url.md)
2. Root Cause (under 100) — [../sections/root-cause.md](../sections/root-cause.md)
3. Changes (under 120) — [../sections/changes.md](../sections/changes.md)
4. Risk & Rollback (under 50), *conditional* — [../sections/risk-and-rollback.md](../sections/risk-and-rollback.md)
5. Testing (under 45) — [../sections/testing.md](../sections/testing.md)
6. Validation (under 70) — [../sections/validation.md](../sections/validation.md)
7. Screenshots (under 20), *conditional* — [../sections/screenshots.md](../sections/screenshots.md)

**No Motivation.** Root Cause replaces it on a fix: the reason the work happened is
that something was broken, and a separate section arguing for the work would only
restate that.

## How the include tests usually land for a fix

- **Preview URL** — included when the broken behavior can be reached in the running app, which is where a reviewer confirms the repro is gone. A fix to a build or CI failure has nothing to open.

Validation gets a wider budget than on a feature because the repro belongs in it: how to reach the broken state, and what should happen instead now.

## Reverts

A revert uses this profile, with Root Cause explaining what the reverted change broke. Title validation has a revert blind spot — see the PR title section in SKILL.md for the rewrite.

## Example to mirror

[../examples/fix.md](../examples/fix.md)
