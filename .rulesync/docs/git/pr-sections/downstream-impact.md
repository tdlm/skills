# Downstream Impact

What other code, or other people, have to do about this.

Include:

- **Compatibility** -- whether existing usage keeps working. When it does, say so plainly; "no breaking changes, existing imports are updated in this PR" is a complete answer and saves a reviewer the audit.
- **New patterns to adopt** -- a new import path, directory convention, or component API that future work is expected to follow.
- **Migration steps** -- what a consumer has to change, and whether this PR already did it for them.

Include this section when the PR changes a public surface or breaks consumers, and leave it out otherwise. Most PRs affect nothing downstream, and a Downstream Impact section that says "none" trains reviewers to skip the section on the PR where it matters.

A breaking change always gets this section, whatever else the PR is doing.
