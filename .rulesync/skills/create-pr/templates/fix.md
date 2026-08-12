# fix profile

Something was broken and now isn't. Covers `fix` and `revert`. Total budget: **~180-320 words**.

## Sections to compose

In this order, reading each section's guidance before drafting it. Each section's
own doc carries its include test; the number in parentheses is its word ceiling.

1. Description (under 70) -- `.rulesync/docs/git/pr-sections/description.md`
   - Its nested fields follow the paragraph: the Jira link, then Development URL and
     Storybook Preview when they apply --
     `.rulesync/docs/git/pr-sections/jira-ticket.md`,
     `.rulesync/docs/git/pr-sections/development-url.md`, and
     `.rulesync/docs/git/pr-sections/storybook-preview.md`
2. Root Cause (under 100) -- `.rulesync/docs/git/pr-sections/root-cause.md`
3. Changes (under 120) -- `.rulesync/docs/git/pr-sections/changes.md`
4. Risk & Rollback (under 50), *conditional* -- `.rulesync/docs/git/pr-sections/risk-and-rollback.md`
5. Testing (under 45) -- `.rulesync/docs/git/pr-sections/testing.md`
6. Validation (under 70) -- `.rulesync/docs/git/pr-sections/validation.md`
7. Screenshots (under 20), *conditional* -- `.rulesync/docs/git/pr-sections/screenshots.md`

**No Motivation.** Root Cause replaces it on a fix: the reason the work happened is
that something was broken, and a separate section arguing for the work would only
restate that.

## How the include tests usually land for a fix

- **Development URL** -- included when the broken behavior can be reached in the running app, which is where a reviewer confirms the repro is gone. A fix to a build or CI failure has nothing to open.

Validation gets a wider budget than on a feature because the repro belongs in it: how to reach the broken state, and what should happen instead now.

## Reverts

A revert uses this profile, with Root Cause explaining what the reverted change broke. Title validation has a revert blind spot -- `.rulesync/docs/git/conventions-pr-title.md` covers the rewrite.

## Example to mirror

`.rulesync/docs/git/pr-examples/fix.md`
