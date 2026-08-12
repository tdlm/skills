# feat profile

Work that adds something users or API consumers notice. Total budget: **~250-400 words**.

## Sections to compose

In this order, reading each section's guidance before drafting it. Each section's
own doc carries its include test; the number in parentheses is its word ceiling.

1. Description (under 90) -- `.rulesync/docs/git/pr-sections/description.md`
   - Its nested fields follow the paragraph: the Jira link, then Development URL and
     Storybook Preview when they apply --
     `.rulesync/docs/git/pr-sections/jira-ticket.md`,
     `.rulesync/docs/git/pr-sections/development-url.md`, and
     `.rulesync/docs/git/pr-sections/storybook-preview.md`
2. Motivation (under 80) -- `.rulesync/docs/git/pr-sections/motivation.md`
3. Changes (under 160) -- `.rulesync/docs/git/pr-sections/changes.md`
4. Downstream Impact (under 60), *conditional* -- `.rulesync/docs/git/pr-sections/downstream-impact.md`
5. Testing (under 40) -- `.rulesync/docs/git/pr-sections/testing.md`
6. Validation (under 50) -- `.rulesync/docs/git/pr-sections/validation.md`
7. Screenshots (under 20), *conditional* -- `.rulesync/docs/git/pr-sections/screenshots.md`

## How the include tests usually land for a feature

- **Development URL** -- almost always included; a feature is usually observable in the running app.
- **Downstream Impact** -- a feature's public surface is usually a new import path or component API, so check for one before dropping the section.

Changes carries the most weight here, and it is the section most likely to run long -- lean on its grouping rule rather than a flat list when the feature delivers many distinct things.

## Example to mirror

`.rulesync/docs/git/pr-examples/feat.md`
