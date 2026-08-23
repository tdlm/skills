# feat profile

Work that adds something users or API consumers notice. Total budget: **~250-400 words**.

## Sections to compose

In this order, reading each section's guidance before drafting it. Each section's
own doc carries its include test; the number in parentheses is its word ceiling.

1. Description (under 90) — [../sections/description.md](../sections/description.md)
   - Its nested fields follow the paragraph: the ticket link, then preview URL
     blocks when they apply —
     [../sections/ticket-link.md](../sections/ticket-link.md) and
     [../sections/preview-url.md](../sections/preview-url.md)
2. Motivation (under 80) — [../sections/motivation.md](../sections/motivation.md)
3. Changes (under 160) — [../sections/changes.md](../sections/changes.md)
4. Downstream Impact (under 60), *conditional* — [../sections/downstream-impact.md](../sections/downstream-impact.md)
5. Testing (under 40) — [../sections/testing.md](../sections/testing.md)
6. Validation (under 50) — [../sections/validation.md](../sections/validation.md)
7. Screenshots (under 20), *conditional* — [../sections/screenshots.md](../sections/screenshots.md)

## How the include tests usually land for a feature

- **Preview URL** — almost always included; a feature is usually observable in the running app.
- **Downstream Impact** — a feature's public surface is usually a new import path or component API, so check for one before dropping the section.

Changes carries the most weight here, and it is the section most likely to run long — lean on its grouping rule rather than a flat list when the feature delivers many distinct things.

## Example to mirror

[../examples/feat.md](../examples/feat.md)
