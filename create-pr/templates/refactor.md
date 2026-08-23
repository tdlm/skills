# refactor profile

A restructure with no intended change in behavior. Covers `refactor`, `perf`, and `style`. Total budget: **~220-380 words**.

## Sections to compose

In this order, reading each section's guidance before drafting it. Each section's
own doc carries its include test; the number in parentheses is its word ceiling.

1. Description (under 90) — [../sections/description.md](../sections/description.md)
   - Its nested fields follow the paragraph: the ticket link, then preview URL
     blocks when they apply —
     [../sections/ticket-link.md](../sections/ticket-link.md) and
     [../sections/preview-url.md](../sections/preview-url.md)
2. Motivation (under 80) — [../sections/motivation.md](../sections/motivation.md)
3. Changes (under 150) — [../sections/changes.md](../sections/changes.md)
4. Behavior Parity (under 70) — [../sections/behavior-parity.md](../sections/behavior-parity.md)
5. Downstream Impact (under 60), *conditional* — [../sections/downstream-impact.md](../sections/downstream-impact.md)
6. Testing (under 40) — [../sections/testing.md](../sections/testing.md)
7. Validation (under 50) — [../sections/validation.md](../sections/validation.md)
8. Screenshots (under 20), *conditional* — [../sections/screenshots.md](../sections/screenshots.md)

**Behavior Parity is not optional here.** It is the section that makes a large no-op diff reviewable, so it appears even when the answer is a confident two sentences.

## How the include tests usually land for a refactor

- **Preview URL** — included when the restructured code renders or runs in the app, so a reviewer can check parity against production themselves.
- **Storybook/Chromatic preview block** — on a visual restructure the Chromatic diff is the parity evidence, so this and Behavior Parity reinforce each other.

## For `perf`

Behavior Parity carries the measurement half of the claim — its guidance covers what to include — and on a perf change it can use the upper end of that section's budget.

## For `style`

Formatting-only changes with no logic change usually collapse toward the bottom of the total budget. Don't inflate Motivation to justify a formatter run.

## Example to mirror

[../examples/refactor.md](../examples/refactor.md)
