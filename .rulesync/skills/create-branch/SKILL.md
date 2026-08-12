---
name: create-branch
description: >-
  Create a git branch for this repository. Derive the type, ticket, and a short
  kebab description from the Jira ticket or the work at hand, validate the ref,
  then branch off an up-to-date base. Use when the user asks to create, cut,
  start, or name a branch, or to start work on a ticket.
---

# Create Branch

`.rulesync/docs/git/conventions.md` and `.rulesync/docs/git/conventions-branch.md`
are the source of truth for what the name looks like. Read both before drafting.
This skill covers how to derive the name and how to cut the branch.

## Workflow

### 1. Establish the ticket

Take the key from whatever the user gave you — a bare key, a Jira URL, or a
sentence about the work. When a key exists, read the issue via Atlassian MCP for
its summary and description; both feed the description in step 3.

Ask when the work sounds like it should have a ticket and none was named. If
there genuinely is none, use the ticketless form rather than inventing one.

### 2. Pick the type

The same enum commits use. Print it if you need the current list:

```bash
pnpm exec commitlint --print-config
```

Two traps. The type describes the work the branch will carry, not the Jira issue
type — a Jira Task is very often a `fix`. And it is the short form `feat`, even
though most of this repo's history says `feature/`.

### 3. Compress the description

The ticket title is a starting point, not the answer. Cut, in this order:

- **Filler** — `the`, `a`, `for`, `to`, `from`, `on`
- **Whatever the ticket key pins down** — the product area, the page, the
  project's whole domain. `PAID-147` already identifies the page
- **Whatever the type says** — no `fix/...-fix-...`, no `feat/...-add-...` when
  the noun alone reads as an addition
- **Qualifiers that only matter inside the ticket** — the ticket, the PR, and the
  commits all have room for them

Keep the one noun that makes the branch recognizable in a list, plus an
imperative verb only when the type doesn't already imply it —
`feat/PAID-60-hero-component` needs no `add`, but `feat/PAID-170-remove-ewa-widget`
does need `remove`, since the type alone would suggest the opposite. Stop at two
to four words.

Worked examples, all branches this repo actually cut:

- `feature/PAID-170-remove-ewa-widget-from-identity-protection-review-pages`
  is the ticket title transcribed whole, 72 characters of it. Everything after
  the widget is the ticket's own subject matter →
  `feat/PAID-170-remove-ewa-widget`
- `feature/PAID-147-personal-loans-cash-advance-ld-json-schema` names the page
  to separate it from PAID-146, which adds the same schema elsewhere. The key
  separates them → `feat/PAID-147-ld-json-schema`
- `feat/PAID-209-add-phone-number-to-lifelock-offer` spends three words on
  glue. Reordering into a noun phrase drops them →
  `feat/PAID-209-lifelock-phone-number`

### 4. Validate the name

```bash
git check-ref-format --branch "<name>"
git rev-parse --verify --quiet "refs/heads/<name>"
```

The first rejects the characters a ref cannot hold. The second must print
nothing — output means the name is already taken.

### 5. Confirm with the user, then STOP

Present and wait for a reply:

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

```bash
git fetch origin main
git switch -c "<name>" --no-track origin/main
```

`--no-track` matters: branching off a remote-tracking ref otherwise sets the new
branch's upstream to `origin/main`, which makes `git status` report the work as
commits ahead of `main` and leaves a misaimed push target behind.

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
- Never branch off a local `main` without fetching first
- Never push unless the user asks

## Checklist

- [ ] Ticket resolved, or the branch is deliberately ticketless
- [ ] Type from the enum, in short form
- [ ] Description two to four words, ref under about 40 characters
- [ ] `git check-ref-format` passes and the name is unused
- [ ] Base fetched, or the user chose to branch from current `HEAD`
- [ ] Uncommitted work accounted for
- [ ] User confirmed the name before the branch was cut
