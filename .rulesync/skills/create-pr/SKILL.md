---
name: create-pr
description: >-
  Open a pull request for the current branch -- derive a conventional PR title,
  compose the description from the sections that fit the type of work, then
  create the PR. Use when the user asks to open, create, raise, or submit a pull
  request; to write, draft, or update a PR description, body, or summary; or to
  fix, rename, or correct a PR title.
---

# Create PR

Commit to a **profile** before drafting. It decides which sections the body gets.

## Core idea

A PR describes the work that is in it. Not the plan that preceded it, and not the
things that were left out -- the ticket already argued for the work, and a list
of what wasn't done is noise a reviewer has to read past.

Which sections serve that depends on the work. A feature needs to explain what it
built and why; a fix needs to explain what broke and why this addresses the cause;
a config change needs neither, but needs the one command that proves it works. So
the section set is derived from the conventional type, the same vocabulary the
branch, the commits, and the title already use.

The test for every section: **does this help a reviewer judge the diff?** If not,
it belongs on the ticket, or nowhere.

## Pick a profile

Derive the type, then map it. The first source that answers wins:

1. **The branch prefix** -- `feat/PAID-103-footer-component` is a `feat`.
2. **The commit subjects on the branch** -- when types are mixed, take the one
   describing the PR's headline outcome, by precedence: `feat` > `fix`/`revert` >
   `refactor`/`perf`/`style` > `chore`/`ci`/`build`/`docs`/`test`.
3. **The diff** -- infer, then confirm with the user before drafting.

| Type                                   | Profile                   |
| -------------------------------------- | ------------------------- |
| `feat`                                 | `./templates/feat.md`     |
| `fix`, `revert`                        | `./templates/fix.md`      |
| `refactor`, `perf`, `style`            | `./templates/refactor.md` |
| `chore`, `ci`, `build`, `docs`, `test` | `./templates/chore.md`    |

Read the matched template. It owns the section list, the include test for each
conditional section, and the word budget per section.

**Two overrides:**

- **A breaking change forces Downstream Impact.** A `!` anywhere on the branch, or
  a change that breaks consumers, gets that section whatever the profile says.
- **Needing a new test means `chore` is wrong.** If the PR adds or changes a test
  to cover behavior, re-derive as `feat`, `fix`, or `refactor`. The exception is a
  `test:` PR whose whole subject is coverage.

## Workflow

### 1. Gather context

Read the branch's history and its diff against the base branch, then read
`.rulesync/docs/git/conventions-pr-body.md` -- it is the source of truth for
heading levels, the bold metadata labels, spacing, style, and how the marker
blocks behave. Take those from the file rather than from memory. The literal text
of the two marker blocks is a separate matter: each block is copied from its own
section's guidance when that section's include test passes.

Check the branch name for a ticket key, falling back to the bracketed Jira
references in the commit subjects. When a key exists, read the issue via
Atlassian MCP: its Background feeds Motivation, and its own description tells you
what the work was meant to achieve. Browse key source files when the diff alone
doesn't explain the change. Ask the user when context is still missing -- don't
draft around a gap.

### 2. Pick the profile

Per the section above. Read its template before drafting anything.

### 3. Derive the title

`.rulesync/docs/git/conventions.md` and `.rulesync/docs/git/conventions-pr-title.md`
are the source of truth for the format. Read both.

Squash-and-merge means the title becomes the commit message on `main`, and GitHub
blocks the merge on a non-conforming one.

### 4. Draft the sections

In the order the template lists, reading each section's guidance first. Apply the
include test for every conditional section, and drop the heading for any section
that doesn't apply.

### 5. Present the draft

The title, then the full description in a single markdown code block. Name the
profile you picked and any conditional sections you left out, so the user can
disagree with the composition and not just the wording.

### 6. Ask, then STOP

Wait for a reply before creating anything.

### 7. Validate the title, then create the PR

Only after the user confirms. Pipe the title through Commitlint first and fix any
violations:

```bash
printf '%s' "<drafted title>" | pnpm exec commitlint
```

Watch the revert blind spot: a `Revert "..."` title exits 0 here but GitHub still
rejects it -- `.rulesync/docs/git/conventions-pr-title.md` covers the rewrite.

Then create it with `gh pr create`, passing the body from a file or a HEREDOC so
the markdown survives intact.

## Always (across all profiles)

Run this pass on every draft before presenting it.

- [ ] **No "what's not included", no future work, no scope disclaimers.** A PR
      describes what is in it.
- [ ] **Results, not plans.** The ticket describes the plan; this describes the
      outcome.
- [ ] **Description is self-contained.** A reviewer understands the PR without
      opening the ticket.
- [ ] **No section exceeds 5 top-level bullets.** Group or nest instead.
- [ ] **Word budgets are ceilings, not targets.** Over budget means cutting a
      bullet or dropping a section -- never compressing prose into fragments or
      abbreviations, which trades a readable long section for an unreadable short
      one. A PR that says everything it needs in 40 words is finished.
- [ ] **The profile's total is the budget that binds.** The per-section ceilings
      sum past it by design; they shape how the total is distributed, not permit
      exceeding it.
- [ ] **Omitted sections have no heading.** Never `n/a`.
- [ ] **The body is shaped per `.rulesync/docs/git/conventions-pr-body.md`.**
      Heading levels, bold metadata labels, prose-versus-bullet spacing, and style
      are all settled there. Read it; don't reconstruct it.
- [ ] **Marker comments are byte-for-byte, or the block is absent.** Each block goes
      on the PRs where its own include test passes -- neither is automatic. CI matches
      the marker strings exactly and treats a missing block as nothing to do, so a
      mistyped marker is never safer than leaving the block out. Between the markers,
      the section's own guidance applies.
