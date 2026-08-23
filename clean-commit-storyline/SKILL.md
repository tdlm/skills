---
name: clean-commit-storyline
description: >-
  Reimplement the current branch on a new branch with a clean, narrative-quality
  git commit history suitable for reviewer comprehension. Use when the user asks
  to clean up commit history, rewrite commits, or create a narrative commit log.
---

# Clean Commit Storyline

Reimplement the current branch on a new branch with a clean, narrative-quality
git commit history suitable for reviewer comprehension.

**New branch name**: Use the branch name provided by the user if given, otherwise
`{source_branch}-clean`.

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

Surface the resolved contract in the plan (step 6) so the user can correct it.
After the user confirms success, if resolution landed on tier 3 or 4, offer once
to record the resolved conventions in `AGENTS.md`. Never write it unprompted.

## Tickets

When replaying commits, preserve whatever ticket-reference format the resolved
contract uses — or omit references when the source branch was ticketless. Do not
add ticket keys that were not on the original branch unless the user asks.

## Steps

1. **Gather context**
   - `git branch --show-current` — record the source branch.
   - `git status --short` — confirm no uncommitted project changes.
   - Resolve the base branch: `git symbolic-ref refs/remotes/origin/HEAD` →
     e.g. `refs/remotes/origin/main` → `main`.
   - `git fetch origin <base> --quiet`
   - `git log origin/<base>..HEAD --oneline` — commits to replay.
   - `git diff origin/<base>...HEAD --stat` — full diff summary.
   - `git diff origin/<base>...HEAD --name-status` — file-level ops (renames,
     additions, deletions).
   - **Load the commit contract** per the resolution ladder above.

2. **Validate the source branch**
   - No uncommitted changes or merge conflicts.
   - `git rev-list --left-right --count origin/<base>...HEAD` — confirm `0`
     commits behind. If the source is behind `origin/<base>`, ask the user to
     rebase first; do not silently rebase.

3. **Analyze the diff**
   - Read every file in `--name-status`. Identify pure renames, unrelated drift
     (files that don't belong to the ticket's scope), and files committed by
     accident.
   - These will be surfaced in the plan and excluded unless the user opts in.

4. **Create the clean branch off `origin/<base>`**

   ```bash
   git checkout -b <new-branch> origin/<base>
   ```

   Never branch from a local base without fetching first — it may be stale.

5. **Plan the commit storyline**
   - Each commit must touch only one of: a single component directory, a single
     hook, a single utility, a single page or feature section, a single config
     file, or tests colocated with one of the above. If a proposed diff spans
     more than one, split it.
   - Order commits as a build-up: foundational primitives → shared components →
     domain code → page or feature composition. A reviewer should be able to read
     the log top-to-bottom as a tutorial.

6. **Present the plan and STOP**
   - Output a numbered list. For each commit show:
     - Subject (`type(scope): description`)
     - Body summary (1–3 lines)
     - Exact file list
   - Include a "Resolved commit contract" section summarizing what was discovered
     in step 1 (allowed types, scope rules, ticket-reference format).
   - Call out anything intentionally excluded (drift, accidental commits,
     generated files).
   - Do **not** run `git commit`, `git checkout <files>`, `git cherry-pick`, or
     `git reset` until the user approves explicitly.
   - If the user requests changes, re-output the **full** updated plan and STOP
     again. Never partially apply feedback and continue.

7. **Commit message contract**

   The contract loaded in step 1 governs message format. Two additions specific to
   this workflow:

   - Each subject describes only the single concern its commit touches (step 5).
     If a subject needs "and" to be accurate, the commit should have been split.
   - The log is read top-to-bottom as a narrative, so each commit's body must
     stand on its own without assuming the reader saw the previous one.

8. **Reimplement the work**
   - **Default strategy — cherry-pick from the source branch:**

     ```bash
     git cherry-pick -n <sha>          # stage source-commit changes, no commit yet
     git reset HEAD <paths-to-defer>   # peel off a subset for a later commit
     git commit -m "$(cat <<'EOF'
     type(scope): subject

     body

     <ticket-reference>
     EOF
     )"
     ```

   - **Fallback strategy — file-level checkout from source.** Use only when no
     source commit aligns with the planned step:

     ```bash
     git checkout <source-branch> -- <paths>
     git commit -m "..."
     ```

   - For message-only edits after a commit lands, `git commit --amend` (HEAD) or
     `git rebase -i origin/<base>` (earlier commits) are fine — the tree must not
     change.

9. **Verify correctness**
   - `git diff <source-branch> HEAD --stat` must be empty. If not, surface the
     diff and STOP for the user — do not push.
   - `git log origin/<base>..HEAD --pretty=format:'%h %s'` — share the final
     commit list with the user before declaring success.

## Rules

- Never add yourself as an author or contributor.
- Never include "Generated with Cursor", "Co-Authored-By", or "Made-with: Cursor"
  lines in commits.
- The end state of the clean branch must be byte-identical to the source branch.
- **Never run `git stash --include-untracked` or `git stash -u`.** If a stash is
  required, scope it to project paths only:

  ```bash
  git stash push -- <explicit project paths>
  ```

- After any branch switch or stash drop, verify the agent-tooling directories
  (`.cursor/`, `.claude/`, etc.) still exist on disk before continuing. If any
  disappear, recover via reflog (`git fsck --lost-found`) and abort the run.
- When the Read tool's output disagrees with `git show` or `sed -n`, trust
  `git`/`sed` — the Read tool may be cached.
