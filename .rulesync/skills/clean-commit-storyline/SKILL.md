---
name: clean-commit-storyline
description: Reimplement the current branch on a new branch with a clean, narrative-quality git commit history.
targets: ["*"]
---

## Task

Reimplement the current branch on a new branch with a clean, narrative-quality git commit history suitable for reviewer comprehension.

**New branch name**: Use the branch name provided by the user if given, otherwise `{source_branch}-clean`.

### Steps

1. **Gather context**
   - `git branch --show-current` — record the source branch.
   - `git status --short` — confirm no uncommitted project changes.
   - `git fetch origin main --quiet`
   - `git log origin/main..HEAD --oneline` — commits to replay.
   - `git diff origin/main...HEAD --stat` — full diff summary.
   - `git diff origin/main...HEAD --name-status` — file-level ops (renames, additions, deletions).
   - **Load the commit contract.** Read `.rulesync/docs/git/conventions.md` and `.rulesync/docs/git/conventions-commit.md`. Where they exist they are authoritative — allowed types, subject limits, scope rules, ticket-reference format, and body style all come from there.

     If that file is not present in the current repository, fall back to discovery:
     1. Discover the commitlint config. Use the `Glob` tool — not shell globs — and check each canonical location independently:
        - Glob `commitlint.config.{js,cjs,mjs,ts}`
        - Glob `.commitlintrc` and `.commitlintrc.{js,cjs,mjs,ts,json,yml,yaml}`
        - Read `package.json` and check for a top-level `commitlint` key

        Treat the contract as "no config" only after all three have been verified missing. Resolve any `extends` (e.g. `@commitlint/config-angular`, `@commitlint/config-conventional`) to find the actual `type-enum`, `scope-enum`, and any custom rules — especially ticket-reference formats, subject length limits, and required footers.
     2. If no config exists, scan `git log origin/main -50 --pretty=format:'%s%n%b%n==='` for the project's de-facto conventions — including ticket-reference patterns in the footer.
     3. Surface the resolved contract back to the user in the plan (step 6) so it can be corrected up front.

2. **Validate the source branch**
   - No uncommitted changes or merge conflicts.
   - `git rev-list --left-right --count origin/main...HEAD` — confirm `0` commits behind. If the source is behind `origin/main`, ask the user to rebase first; do not silently rebase.

3. **Analyze the diff**
   - Read every file in `--name-status`. Identify pure renames, unrelated drift (files that don't belong to the ticket's scope), and files committed by accident.
   - These will be surfaced in the plan and excluded unless the user opts in.

4. **Create the clean branch off `origin/main`**

   ```bash
   git checkout -b <new-branch> origin/main
   ```

   Never branch from local `main` — it may be stale.

5. **Plan the commit storyline**
   - Each commit must touch only one of: a single component directory, a single hook, a single utility, a single page or feature section, a single config file, or tests colocated with one of the above. If a proposed diff spans more than one, split it.
   - Order commits as a build-up: foundational primitives → shared components → domain code → page or feature composition. A reviewer should be able to read the log top-to-bottom as a tutorial.

6. **Present the plan and STOP**
   - Output a numbered list. For each commit show:
     - Subject (`type(scope): description`)
     - Body summary (1–3 lines)
     - Exact file list
   - Include a "Resolved commit contract" section summarizing what was discovered in step 1 (allowed types, scope rules, ticket-reference format).
   - Call out anything intentionally excluded (drift, accidental commits, generated files).
   - Do **not** run `git commit`, `git checkout <files>`, `git cherry-pick`, or `git reset` until the user approves explicitly.
   - If the user requests changes, re-output the **full** updated plan and STOP again. Never partially apply feedback and continue.

7. **Commit message contract**

   The contract loaded in step 1 governs message format. Two additions specific to this workflow:

   - Each subject describes only the single concern its commit touches (step 5). If a subject needs "and" to be accurate, the commit should have been split.
   - The log is read top-to-bottom as a narrative, so each commit's body must stand on its own without assuming the reader saw the previous one.

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

   - **Fallback strategy — file-level checkout from source.** Use only when no source commit aligns with the planned step:

     ```bash
     git checkout <source-branch> -- <paths>
     git commit -m "..."
     ```

   - For message-only edits after a commit lands, `git commit --amend` (HEAD) or `git rebase -i origin/main` (earlier commits) are fine — the tree must not change.

9. **Verify correctness**
   - `git diff <source-branch> HEAD --stat` must be empty. If not, surface the diff and STOP for the user — do not push.
   - `git log origin/main..HEAD --pretty=format:'%h %s'` — share the final commit list with the user before declaring success.

### Rules

- Never add yourself as an author or contributor.
- Never include "Generated with Cursor", "Co-Authored-By", or "Made-with: Cursor" lines in commits.
- The end state of the clean branch must be byte-identical to the source branch.
- **Never run `git stash --include-untracked` or `git stash -u`.** If a stash is required, scope it to project paths only:

  ```bash
  git stash push -- <explicit project paths>
  ```

- After any branch switch or stash drop, verify the agent-tooling directories (`.cursor/`, `.claude/`, `.rulesync/`, etc.) still exist on disk before continuing. If any disappear, recover via reflog (`git fsck --lost-found`) and abort the run.
- When the Read tool's output disagrees with `git show` or `sed -n`, trust `git`/`sed` — the Read tool may be cached.
