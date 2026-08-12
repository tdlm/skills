# Testing

What test coverage the PR adds or changes.

Name the kinds of coverage and what they protect:

- **Unit tests** -- per component or module
- **Integration tests** -- full compositions or flows
- **Storybook stories** -- visual variations

Keep it brief. The tests are in the diff, so this section exists to tell a reviewer where to look and what was deliberately left uncovered, not to restate the test names.

When a PR fixes a bug, say which test now fails without the fix. That sentence is the difference between a fix a reviewer trusts and one they have to reason about themselves.

**When there is nothing to test, the section doesn't belong.** A PR with no runtime change has no honest Testing section.
