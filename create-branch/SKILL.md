---
name: create-branch
description: >-
  Create a git branch for this repository. Derive the type, ticket, and a short
  kebab description from a ticket or the work at hand, validate the ref,
  then branch off an up-to-date base. Use when the user asks to create, cut,
  start, or name a branch, or to start work on a ticket.
---

# Create Branch

Derive the branch name from the resolved commit contract, then cut the branch.
This skill covers how to derive the name and how to cut it.

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
After the user confirms the branch, if resolution landed on tier 3 or 4, offer
once to record the resolved conventions in `AGENTS.md`. Never write it
unprompted.

## Tickets

Many repos tie branches, commits, and PRs to an issue key (`ABC-123`, `#456`, etc.).
Whether that is required comes from the resolved contract — not from this skill.

**When the contract expects a ticket:** include the key in the branch name. Read the
ticket when one is available and context would help (via whatever issue-tracker
integration the environment provides, or from what the user pasted). Do not invent
keys.

**When the work is ticketless:** use `<type>/<kebab-description>` with no key
segment. A dependency bump or typo fix may legitimately have no ticket.

**When unsure:** ask once. If the user says there is no ticket, proceed ticketless.

## Branch name form

A branch carries the same type, ticket (when used), and description as the commit
it leads to, rendered for a git ref:

```text
<type>/<TICKET>-<kebab-description>    # ticketed
<type>/<kebab-description>            # ticketless
```

```text
feat/ABC-60-unpublish-script
fix/ABC-85-insurance-type-selection
chore/update-dependencies
```

### How it differs from a header

| Part        | Header               | Branch             |
| ----------- | -------------------- | ------------------ |
| Separator   | `: ` after the type  | `/` after the type |
| Scope       | `(scope)` in parens  | Omitted            |
| Ticket      | resolved ticket form | bare key, no brackets |
| Description | Spaced words         | Kebab-case         |
| Breaking    | `!` before the colon | Not marked         |

### Rules

- **Type** — the same set commits use. Print the enum when you need the current
  list: `<package-manager> exec commitlint --print-config` (when commitlint is
  configured). Lowercase, short form (`feat`, not `feature`).
- **Ticket** — uppercase project key and number, no instance prefix and no
  brackets, per the resolved contract. Ticketless work drops the ticket segment:
  `<type>/<kebab-description>`.
- **Description** — kebab-case, imperative, 2–4 words, with the whole ref under
  about 40 characters.
- A git ref cannot contain spaces, `~`, `^`, `:`, `?`, `*`, `[`, `\`, consecutive
  dots, or a trailing dot — which is why the header punctuation cannot carry over.

### Length

The ticket is the identifier. The words after it are a reminder of what the
branch is for, not a summary of it — the ticket, the PR, and the commits all
have room to say more.

`feat/ABC-147-personal-loans-cash-advance-ld-json-schema` spells out the page
so it can be told apart from a sibling ticket adding the same schema elsewhere,
but the key already does that: `feat/ABC-147-ld-json-schema` is the same branch
at half the length. Cut anything the type or the ticket already carries, and
anything that only matters once you are inside the ticket.

A branch list is scanned, not read. Long names wrap, bury their distinguishing
words at the far right, and push the ticket keys out of alignment.

## Workflow

### 1. Establish the ticket

Take the key from whatever the user gave you — a bare key, an issue URL, or a
sentence about the work. When a key exists and reading it would help, pull title
and description via whatever issue-tracker integration is available, or ask the
user to paste the relevant parts.

Ask when the work sounds like it should have a ticket and none was named. If
there genuinely is none, use the ticketless form rather than inventing one.

### 2. Pick the type

The same enum commits use. Two traps. The type describes the work the branch will
carry, not the issue type in the tracker — a "Task" is very often a `fix`. And it is the
short form `feat`, even when history uses `feature/`.

When the linter cannot decide for you:

- `feat` and `fix` are for change users or API consumers notice — everything else
  is internal
- `refactor` is a restructure with no intended behavior change; `perf` is one
  where the intended change is speed; `style` is formatting with no logic change
- `chore` is the fallback. Reach for `ci`, `build`, or `docs` first when one of
  them genuinely fits

### 3. Compress the description

The ticket title is a starting point, not the answer. Cut, in this order:

- **Filler** — `the`, `a`, `for`, `to`, `from`, `on`
- **Whatever the ticket key pins down** — the product area, the page, the
  project's whole domain. `ABC-147` already identifies the page
- **Whatever the type says** — no `fix/...-fix-...`, no `feat/...-add-...` when
  the noun alone reads as an addition
- **Qualifiers that only matter inside the ticket** — the ticket, the PR, and the
  commits all have room for them

Keep the one noun that makes the branch recognizable in a list, plus an
imperative verb only when the type doesn't already imply it —
`feat/ABC-60-hero-component` needs no `add`, but `feat/ABC-170-remove-ewa-widget`
does need `remove`, since the type alone would suggest the opposite. Stop at two
to four words.

Worked examples:

- `feature/ABC-170-remove-ewa-widget-from-identity-protection-review-pages`
  is the ticket title transcribed whole, 72 characters of it. Everything after
  the widget is the ticket's own subject matter →
  `feat/ABC-170-remove-ewa-widget`
- `feature/ABC-147-personal-loans-cash-advance-ld-json-schema` names the page
  to separate it from ABC-146, which adds the same schema elsewhere. The key
  separates them → `feat/ABC-147-ld-json-schema`
- `feat/ABC-209-add-phone-number-to-lifelock-offer` spends three words on
  glue. Reordering into a noun phrase drops them →
  `feat/ABC-209-lifelock-phone-number`

### 4. Validate the name

```bash
git check-ref-format --branch "<name>"
git rev-parse --verify --quiet "refs/heads/<name>"
```

The first rejects the characters a ref cannot hold. The second must print
nothing — output means the name is already taken.

### 5. Confirm with the user, then STOP

Present and wait for a reply:

- The **resolved contract** (types, ticket form, base branch)
- The **branch name**
- The **base** it will branch from, and whether that base was just fetched
- Any **uncommitted work** in the tree and what will happen to it
- One **alternative name** when the compression was lossy — either a shorter cut
  or a more specific one

Do not create the branch in the same turn as this request. Renaming a branch
after commits land on it is a nuisance, and the user may want different words, a
different type, or a different base.

### 6. Create it

Check the tree first:

```bash
git status --porcelain
```

A dirty tree carries over to the new branch with `git switch -c`, which is
usually what the user wants. Ask before stashing.

Resolve the base branch name from `git symbolic-ref refs/remotes/origin/HEAD`
(e.g. `refs/remotes/origin/main` → `main`).

```bash
git fetch origin <base>
git switch -c "<name>" --no-track origin/<base>
```

`--no-track` matters: branching off a remote-tracking ref otherwise sets the new
branch's upstream to `origin/<base>`, which makes `git status` report the work as
commits ahead of `<base>` and leaves a misaimed push target behind.

Branch from the current `HEAD` instead when the user is stacking on work already
in progress. Don't push — the branch stays local until the user asks or a PR is
opened.

### 7. Verify

```bash
git branch --show-current
git log -1 --oneline
```

Report the branch and the commit it starts from.

## Git safety

- Never update git config
- Never rename or delete an existing branch
- Never reset, discard, or force-clean the working tree to get a clean base
- Never branch off a local base without fetching first
- Never push unless the user asks

## Checklist

- [ ] Contract resolved and surfaced for confirmation
- [ ] Ticket resolved, or the branch is deliberately ticketless
- [ ] Type from the enum, in short form
- [ ] Description two to four words, ref under about 40 characters
- [ ] `git check-ref-format` passes and the name is unused
- [ ] Base fetched, or the user chose to branch from current `HEAD`
- [ ] Uncommitted work accounted for
- [ ] User confirmed the name before the branch was cut
