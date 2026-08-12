# PR sections

One doc per section of a pull request body, each covering what the section is for,
what belongs in it, and when it applies.

Which sections a given PR gets depends on the type of work. That mapping is defined
per type by the `create-pr` skill, in `.rulesync/skills/create-pr/templates/`. The
[worked examples](../pr-examples) show a finished body for each type -- start there if
you'd rather see the shape than read the rules.

## The sections

Roughly the order they appear in a body:

- **[Description](description.md)** -- one paragraph stating what the PR delivers and
  why. The only section on every PR.
- **[Motivation](motivation.md)** -- why the change was needed.
- **[Root Cause](root-cause.md)** -- what broke, why, and why the fix addresses the
  cause rather than the symptom. Replaces Motivation on a fix.
- **[Changes](changes.md)** -- what was actually built, as bullets with bold leads.
  Usually the largest section.
- **[Behavior Parity](behavior-parity.md)** -- the claim that nothing observable
  changed, plus the evidence for it.
- **[Downstream Impact](downstream-impact.md)** -- what other code, or other people,
  have to do about this.
- **[Risk & Rollback](risk-and-rollback.md)** -- what this could break, and how to
  undo it.
- **[Testing](testing.md)** -- what test coverage the PR adds or changes.
- **[Validation](validation.md)** -- how a reviewer confirms the change does what it
  claims.
- **[Screenshots](screenshots.md)** -- visual evidence for rendered changes Storybook
  doesn't already show.

Three more sit under Description as bold labels rather than headings. CI fills the
last two in from marker blocks that have to be copied exactly:

- **[Link to Jira ticket](jira-ticket.md)** -- the ticket key as a link.
- **[Development URL](development-url.md)** -- the preview deploy for this PR.
- **[Storybook Preview](storybook-preview.md)** -- Chromatic and Storybook links.

Each doc carries its own test for whether that section applies. Where a section is
optional, the test lives with the section rather than here.

## Writing the body

[conventions-pr-body.md](../conventions-pr-body.md) covers heading levels, the bold
metadata labels, spacing, and what to do with a section that doesn't apply.
