---
name: create-commit
description: >-
  Prepare and create git commits for this repository. Stage files, draft and
  validate the message against Commitlint, run Biome over staged files, then
  commit. Use when the user asks to commit, save work to git, write a commit
  message, or stage and commit changes.
---

# Create Commit

Create commits **only when the user explicitly asks** ("commit this", "make a
commit"). If the request is ambiguous, ask first.

`.rulesync/docs/git/conventions.md` and `.rulesync/docs/git/conventions-commit.md`
are the source of truth for message content and validation. Read both before
drafting. This skill covers only the mechanics of getting a commit made.

Every commit needs a Jira reference. Take it from the branch name when the branch
encodes one. Otherwise ask the user — and if there genuinely is no ticket, as with
a dependency bump or a typo fix, `[ML:TRIVIAL]` is a valid reference.

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

Write the message per `.rulesync/docs/git/conventions-commit.md` and validate it
using the recipe in that doc. Fix any errors before continuing.

### 4. Run Biome over staged files

The `pre-commit` hook runs Biome and fails the commit on violations. Get ahead of
it:

```bash
pnpm exec biome check --write --no-errors-on-unmatched <staged-paths>
git add <paths-fixed-by-biome>
```

### 5. Confirm with the user, then STOP

Present the commit for review and wait for a reply:

- The **full message** exactly as it will appear, subject and body
- The **staged files**
- Anything **deliberately left out** of this commit, and why
- Any files **Biome reformatted** and re-staged

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

**If the commit fails on signing.** This repo sets `commit.gpgsign = true`, and
gpg-agent caches the passphrase for ten minutes. Outside that window `git commit`
fails with `gpg failed to sign the data`. Do not retry and do not add
`--no-gpg-sign` — hand the user the exact command to run in their own terminal,
where pinentry can prompt them.

### 7. Verify

```bash
git status
git log -1 --format=full
```

Report the resulting subject and confirm the tree is clean.

## Git safety

- Never update git config
- Never `--no-verify` or otherwise skip hooks unless the user explicitly asks
- Never run destructive commands (`push --force`, `reset --hard`) unless
  explicitly asked
- Never force-push `main`/`master`; warn if asked
- Never push unless the user asks
- If a commit fails a hook, fix the underlying problem and make a **new** commit —
  never amend a failed one

## Checklist

- [ ] User explicitly requested a commit
- [ ] No secrets or local-only env files staged
- [ ] Message validated against Commitlint
- [ ] Staged files pass Biome
- [ ] Unrelated changes split out or raised with the user
- [ ] User confirmed the message and staged files before committing
- [ ] Commit verified with `git log -1`
