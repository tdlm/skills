# chore profile

Internal work with no behavior for a user to notice. Covers `chore`, `ci`, `build`, `docs`, and `test`. Total budget: **~70-160 words**.

## Sections to compose

Three sections, reading each section's guidance before drafting it. Each section's
own doc carries its include test; the number in parentheses is its word ceiling --
this profile in particular is meant to come in short.

1. Description (under 50) -- `.rulesync/docs/git/pr-sections/description.md`
   - The Jira link follows the paragraph --
     `.rulesync/docs/git/pr-sections/jira-ticket.md`. Add the Development URL only
     when its include test passes --
     `.rulesync/docs/git/pr-sections/development-url.md` -- which for tooling, CI,
     and config work it usually doesn't.
2. Changes (under 80) -- `.rulesync/docs/git/pr-sections/changes.md`
3. Validation (under 60) -- `.rulesync/docs/git/pr-sections/validation.md`

Add Motivation only when the reason isn't obvious from the change itself. A dependency bump doesn't need one; dropping a tool the team still uses does.

## What this profile deliberately omits

- **Testing** -- there is nothing to test on a chore; the skill's overrides cover re-deriving the profile when that isn't true. On a `test:` PR, the tests *are* the Changes section.
- **Storybook Preview and Screenshots** -- a change to rendered output isn't a chore.

## Validation is the section that matters here

Expect it to be the longest part of the body despite the small total. The section's own guidance covers why config and tooling work leans on it; the example below shows it carrying a whole review.

## Example to mirror

`.rulesync/docs/git/pr-examples/chore.md`
