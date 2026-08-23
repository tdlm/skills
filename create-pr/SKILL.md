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

## Resolve the contract

Before drafting, establish this repo's conventions. First tier that answers wins.

1. **The repo's agent docs** — `AGENTS.md`, `CLAUDE.md`, `.cursor/rules/**`,
   `.github/copilot-instructions.md`. If a git-conventions section exists, it is
   authoritative and the tiers below are skipped.
2. **Machine-enforced config** — check each independently with Glob, not shell
   globs: `commitlint.config.{js,cjs,mjs,ts}`, `.commitlintrc*`,
   `package.json#commitlint`, `.husky/`, `lefthook.yml`,
   `.pre-commit-config.yaml`, `.gitmessage`, `CONTRIBUTING.md`,
   `.github/PULL_REQUEST_TEMPLATE.md`. Resolve any `extends` to find the real
   `type-enum`, `scope-enum`, header limit, and ticket-reference rule. Treat the
   tier as empty only after all have been verified missing.
3. **Observed history** — `git log -50 --pretty=format:'%s%n%b%n==='` for
   de-facto types, scopes, and ticket patterns; `git branch -r
   --sort=-committerdate` for branch shape.
4. **Fallback** — Conventional Commits, no ticket reference. Say that it is a
   fallback when you surface it.

Resolve the base branch with `git symbolic-ref refs/remotes/origin/HEAD`, not a
literal `main`.

Surface the resolved contract in the confirm step so the user can correct it.
After the user confirms the PR, if resolution landed on tier 3 or 4, offer once
to record the resolved conventions in `AGENTS.md`. Never write it unprompted.

## Tickets

Many repos tie branches, commits, and PRs to an issue key (`ABC-123`, `#456`, etc.).
Whether that is required comes from the resolved contract — not from this skill.

**When the contract expects a ticket:** put the key in the PR title and include the
ticket link field in the body. Read the ticket when one is available and context
would help (via whatever issue-tracker integration the environment provides, or
from what the user pasted). Do not invent keys.

**When the work is ticketless:** omit the reference from the title and leave the
ticket link field out of the body.

**When unsure:** ask once. If the user says there is no ticket, proceed ticketless.

## Core idea

A PR describes the work that is in it. Not the plan that preceded it, and not the
things that were left out — when a ticket exists, it already argued for the work,
and a list of what wasn't done is noise a reviewer has to read past.

Which sections serve that depends on the work. A feature needs to explain what it
built and why; a fix needs to explain what broke and why this addresses the cause;
a config change needs neither, but needs the one command that proves it works. So
the section set is derived from the conventional type, the same vocabulary the
branch, the commits, and the title already use.

The test for every section: **does this help a reviewer judge the diff?** If not,
it belongs on the ticket when there is one, or nowhere.

## Pick a profile

Derive the type, then map it. The first source that answers wins:

1. **The branch prefix** — `feat/ABC-103-footer-component` is a `feat`.
2. **The commit subjects on the branch** — when types are mixed, take the one
   describing the PR's headline outcome, by precedence: `feat` > `fix`/`revert` >
   `refactor`/`perf`/`style` > `chore`/`ci`/`build`/`docs`/`test`.
3. **The diff** — infer, then confirm with the user before drafting.

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

## PR title

A PR title is a single-line header with no body or footer behind it. It uses the
shared header form from the resolved contract, with one constraint a commit subject
doesn't have.

When squash-and-merge is in use, the title **becomes the commit message on the
default branch**. A sloppy title is permanent history, not a review-time detail.
GitHub may validate the title on the PR itself, so a non-conforming one can block
the merge.

**The ticket goes inline when there is one.** A title has no footer to hold it, so
the ticket reference sits in the description when the contract requires it:

```text
fix(auth): [ABC-110] allow api host in csp connect-src   # ticketed
chore(deps): update eslint to v9                          # ticketless
```

**Validating a title.** When commitlint is configured, pipe the title through the
same binary that guards commits:

```bash
printf '%s' "<drafted title>" | <package-manager> exec commitlint
```

**Reverts.** One blind spot in that check: Commitlint ignores `Revert "..."`
subjects by default, so a `Revert "..."` title may exit 0 — but GitHub still
validates the title and rejects the merge. Rewrite it in the shared header form:

```text
revert: [ABC-123] <description>
```

## Workflow

### 1. Gather context

Read the branch's history and its diff against the base branch, then read
[body-form.md](body-form.md) — it is the source of truth for heading levels, the
bold metadata labels, spacing, style, and how marker blocks behave. Take those
from the file rather than from memory. The literal text of marker blocks is a
separate matter: each block is copied from its own section's guidance when that
section's include test passes, or from `.github/PULL_REQUEST_TEMPLATE.md` when
the repo ships prefilled blocks there.

Check the branch name for a ticket key, falling back to the ticket references in
the commit subjects. When a key exists and reading it would help, pull background
and scope via whatever issue-tracker integration is available, or from what the
user pasted — that feeds Motivation when the profile includes it. Browse key
source files when the diff alone doesn't explain the change. Ask the user when
context is still missing — don't draft around a gap.

### 2. Pick the profile

Per the section above. Read its template before drafting anything.

### 3. Derive the title

Per the PR title section above and the resolved contract.

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

Only after the user confirms. Pipe the title through commitlint when configured
and fix any violations. Skip validation when no commitlint config exists.

Then create it with `gh pr create`, passing the body from a file or a HEREDOC so
the markdown survives intact.

## Always (across all profiles)

Run this pass on every draft before presenting it.

- [ ] **No "what's not included", no future work, no scope disclaimers.** A PR
      describes what is in it.
- [ ] **Results, not plans.** When a ticket exists, it describes the plan; this
      describes the outcome.
- [ ] **Description is self-contained.** A reviewer understands the PR without
      opening the ticket when there is one.
- [ ] **No section exceeds 5 top-level bullets.** Group or nest instead.
- [ ] **Word budgets are ceilings, not targets.** Over budget means cutting a
      bullet or dropping a section — never compressing prose into fragments or
      abbreviations, which trades a readable long section for an unreadable short
      one. A PR that says everything it needs in 40 words is finished.
- [ ] **The profile's total is the budget that binds.** The per-section ceilings
      sum past it by design; they shape how the total is distributed, not permit
      exceeding it.
- [ ] **Omitted sections have no heading.** Never `n/a`.
- [ ] **The body is shaped per [body-form.md](body-form.md).** Heading levels,
      bold metadata labels, prose-versus-bullet spacing, and style are all settled
      there. Read it; don't reconstruct it.
- [ ] **Marker comments are byte-for-byte, or the block is absent.** Each block
      goes on the PRs where its own include test passes — neither is automatic.
      CI matches the marker strings exactly and treats a missing block as nothing
      to do, so a mistyped marker is never safer than leaving the block out.
      Between the markers, the section's own guidance applies.
