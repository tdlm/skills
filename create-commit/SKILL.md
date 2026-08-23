---
name: create-commit
description: >-
  Prepare and create git commits for this repository. Stage files, draft and
  validate the message against the repo's commit rules, run pre-commit checks
  over staged files, then commit. Use when the user asks to commit, save work to
  git, write a commit message, or stage and commit changes.
---

# Create Commit

Create commits **only when the user explicitly asks** ("commit this", "make a
commit"). If the request is ambiguous, ask first.

This skill covers the mechanics of getting a commit made. Message content follows
the resolved contract below.

## Related skills

A branch, its commits, and its PR share one vocabulary — the same type, the same
ticket, the same description rendered for each form. These skills own the other
ends of it when they are available alongside this one; the guidance here stands
on its own if a sibling folder is missing.

- **[create-branch](../create-branch/SKILL.md)** cut the branch these commits
  land on, and its name is where the ticket key usually comes from. It also
  carries the branch/header comparison table.
- **[create-pr](../create-pr/SKILL.md)** derives its PR profile from the types on
  these commit subjects, so a `chore` that should have been a `fix` picks the
  wrong PR template downstream.
- **[clean-commit-storyline](../clean-commit-storyline/SKILL.md)** replays a
  finished branch into a narrative history, using this skill's message form for
  every commit it writes.

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
After the user confirms the commit, if resolution landed on tier 3 or 4, offer
once to record the resolved conventions in `AGENTS.md`. Never write it
unprompted.

## Tickets

Many repos tie branches, commits, and PRs to an issue key (`ABC-123`, `#456`, etc.).
Whether that is required comes from the resolved contract — not from this skill.

**When the contract expects a ticket:** include the reference in the commit message
per the contract (inline in the subject or in the footer). Take the key from the
branch name when the branch encodes one — [create-branch](../create-branch/SKILL.md)
describes the shape it puts there, a bare uppercase key with no brackets.
Otherwise ask the user. Do not invent keys.

**When the work is ticketless:** omit the ticket reference entirely, or use whatever
ticketless marker the contract allows (some repos define one for trivial changes).

**When unsure:** ask once. If the user says there is no ticket, proceed ticketless.

## Message form

A commit message is a header, an optional body, and an optional footer.

### Header

```text
<type>(<optional scope>)!: <ticket-reference> <short description>
```

The exact ticket-reference placement and format come from the resolved contract.

### Types

The linter enforces which types exist. These are the calls it can't make for you:

- `feat` and `fix` are for change users or API consumers notice — everything else
  is internal
- `refactor` is a restructure with no intended behavior change; `perf` is one
  where the intended change is speed; `style` is formatting with no logic change
- `chore` is the fallback. Reach for `ci`, `build`, or `docs` first when one of
  them genuinely fits

### Description

- **Imperative mood** — "add", not "adds" or "added"
- **Lowercase start.** Acronyms keep their casing; so do lowercase-initial product
  names (`iOS`)
- Say what the change does; the diff already shows the mechanics

### Scope

Optional and free-form unless the contract restricts it. Name the area of the
codebase the change touches, lowercase, using `/` for nesting. Omit it when the
change is broad.

### Ticket placement

Choose by whether the commit has a body.

**Body present → footer**, on its own line after a blank line. This keeps the
header's full character limit available for describing the change.

```text
refactor(learn): architect widget renderers pipeline

- Split renderers into dedicated modules under _widgetRenderers
- Add normalizeWidgetFields and enrichWidgetProps helpers
- Update BlogContentRenderer to use the new pipeline

[ABC-126]
```

**No body → subject**, inline after the colon.

```text
docs: [ABC-126] add notes to renderer functions
```

### Body

Most commits carry a body. Use a **bullet list**, one bullet per distinct change
area — a file group, a feature slice, or a behavior change. Each line wraps at
the header limit (typically 100 characters).

- Explain what changed and **why**; the diff already shows the mechanics
- Don't restate the subject in the first bullet
- **Avoid prose paragraphs** for multi-change commits. Long unbroken text is hard
  to scan in `git log`. Reach for bullets whenever there are two or more logical
  changes, or when one change needs more than a sentence to explain. A single
  short paragraph (2–3 sentences) is fine only when the commit has one focused
  change.
- **Skip the body entirely** when the change is small and the subject already
  says everything

### Breaking changes

Mark a breaking change with `!` before the colon, and explain it in a
`BREAKING CHANGE:` footer.

```text
feat(api)!: [ABC-1005] drop support for node 16

BREAKING CHANGE: node 16 is no longer supported; upgrade to node 20 or later.
```

The footer belongs there whenever the commit breaks consumers, with or without
the `!`.

### Never include

- `Co-Authored-By`, "Generated with Cursor", or "Made-with" trailers
- Agent attribution as author or contributor
- Process commentary about how the commit was produced — "split out from the
  previous commit", "dropped unrelated diffs", "per review feedback". Every
  commit should read as though written the moment the work was done.

## Workflow

### 1. Inspect changes

Run in parallel:

```bash
git status
git diff
git diff --staged
git log -10 --format="%s%n%n%b---"
```

Read both diffs before drafting. The recent log shows how surrounding history
phrases things.

### 2. Stage the right files

If nothing is staged, stage only what belongs in this commit:

```bash
git add <paths>
```

Never stage secrets — `.env`, credentials, keys. If the working tree holds
unrelated work, leave it unstaged or propose splitting into separate commits and
let the user decide.

### 3. Draft and validate

Write the message per the resolved contract. When commitlint is configured, pipe
the draft through the same binary the `commit-msg` hook uses; the ticket must be
present in the piped text if the contract requires it.

```bash
# No body, ticket inline
printf '%s\n' "fix: [ABC-179] correct nav overflow on mobile" | <package-manager> exec commitlint

# Body present, ticket footer
printf '%s\n\n%s\n%s\n\n%s\n' \
  "refactor(learn): architect widget renderers pipeline" \
  "- Split renderers into dedicated modules under _widgetRenderers" \
  "- Update BlogContentRenderer to use the new pipeline" \
  "[ABC-126]" | <package-manager> exec commitlint
```

Fix any errors before continuing. Skip validation when no commitlint config exists.

### 4. Run pre-commit checks over staged files

Inspect `.husky/pre-commit`, `lefthook.yml`, or `.pre-commit-config.yaml` to see
what the hook runs, then get ahead of it on staged paths. Common cases:

- **Biome** — `<package-manager> exec biome check --write --no-errors-on-unmatched <staged-paths>`
- **Prettier** — `<package-manager> exec prettier --write <staged-paths>`
- **ESLint** — `<package-manager> exec eslint --fix <staged-paths>`

Re-stage any files the formatter changed:

```bash
git add <paths-fixed-by-formatter>
```

When no pre-commit hook is configured, skip this step.

### 5. Confirm with the user, then STOP

Present the commit for review and wait for a reply:

- The **resolved contract** (types, ticket form, validator)
- The **full message** exactly as it will appear, subject and body
- The **staged files**
- Anything **deliberately left out** of this commit, and why
- Any files **reformatted** and re-staged

Ask whether to commit as-is or change something. Do **not** run `git commit` in
the same turn as this request — a commit is hard to walk back, and the user may
want a different subject, a different split, or a file added or removed. If they
ask for changes, apply them, re-validate, and present the revised commit again.

Skip this step only when the user has already approved this exact message and
file set earlier in the conversation.

### 6. Commit

Use a HEREDOC when the message has a body, so the blank lines survive:

```bash
git commit -m "$(cat <<'EOF'
<full message>
EOF
)"
```

A subject-only message can use the short form: `git commit -m "<subject>"`.

**If the commit fails on signing.** When `git config --get commit.gpgsign` is
`true`, gpg-agent caches the passphrase for a limited window. Outside that window
`git commit` fails with `gpg failed to sign the data`. Do not retry and do not
add `--no-gpg-sign` — hand the user the exact command to run in their own
terminal, where pinentry can prompt them.

### 7. Verify

```bash
git status
git log -1 --format=full
```

Report the resulting subject and confirm the tree is clean. When the branch is
ready for review, [create-pr](../create-pr/SKILL.md) reads these subjects to pick
its profile and title.

## Git safety

- Never update git config
- Never `--no-verify` or otherwise skip hooks unless the user explicitly asks
- Never run destructive commands (`push --force`, `reset --hard`) unless
  explicitly asked
- Never force-push the default branch; warn if asked
- Never push unless the user asks
- If a commit fails a hook, fix the underlying problem and make a **new** commit —
  never amend a failed one

## Checklist

- [ ] User explicitly requested a commit
- [ ] Contract resolved and surfaced for confirmation
- [ ] Ticket reference included or deliberately omitted per contract
- [ ] No secrets or local-only env files staged
- [ ] Message validated when commitlint is configured
- [ ] Staged files pass pre-commit checks when hooks exist
- [ ] Unrelated changes split out or raised with the user
- [ ] User confirmed the message and staged files before committing
- [ ] Commit verified with `git log -1`
