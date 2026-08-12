# PR titles

A PR title is a single-line header with no body or footer behind it. It uses the
shared header form, with one constraint a commit subject doesn't have.

Squash-and-merge is enforced org-wide, so the title **becomes the commit message
on `main`**. A sloppy title is permanent history, not a review-time detail.
GitHub validates the title on the PR itself, so a non-conforming one blocks the
merge.

## The ticket goes inline

A title has no footer to hold it, so the ticket always sits in the description:

```text
fix(savvy): [ML:WA-110] allow savvy api host in csp connect-src
```

## Validating a title

Pipe the title through the same binary that guards commits. A single-line
message has no footer, so the ticket is forced inline — exactly the PR-title
constraint.

```bash
printf '%s' "fix(savvy): [ML:WA-110] allow savvy api host in csp connect-src" \
  | pnpm exec commitlint
```

## Reverts

One blind spot in that check: Commitlint ignores `Revert "..."` subjects by
default, so a `Revert "..."` title exits 0 here — but GitHub still validates
the title and rejects the merge. Rewrite it in the shared header form:

```text
revert: [ML:TICKET] <description>
```
