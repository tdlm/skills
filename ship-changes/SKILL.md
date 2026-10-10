---
name: ship-changes
description: >-
  Take work in progress all the way to an open pull request: cut a branch,
  commit the changes (a single commit, or a narrative commit series for a larger
  changeset), push, and open the PR. Chains create-branch, create-commit or
  clean-commit-storyline, and create-pr behind two confirmations. Use when the
  user asks to ship, send up, or put up their changes for review, or asks for
  branch, commit, and PR in one go.
---

# Ship Changes

Run the whole branch → commit → PR sequence as one job. This skill owns the
order, the hand-offs, and the confirmation gates. The sibling skills own
everything else, and this one defers to them for every rule they define.

```text
create-branch  ->  create-commit            ->  create-pr
                   or clean-commit-storyline
```

"Ship" here means *open for review*. Nothing gets merged or deployed.

## Related skills

Unlike the siblings, this skill can't stand on its own. It sequences them. Read
each one before running its step, and follow it everywhere this file is silent.

- **[create-branch](../create-branch/SKILL.md)** names, validates, and cuts the
  branch.
- **[create-commit](../create-commit/SKILL.md)** owns message form, staging,
  validation, and pre-commit checks for every commit, including each one in a
  series.
- **[clean-commit-storyline](../clean-commit-storyline/SKILL.md)** owns
  splitting larger work into a narrative series: one concern per commit, ordered
  as a build-up.
- **[create-pr](../create-pr/SKILL.md)** owns the profile, the title, and the
  body.

If a sibling folder is missing, say which one and stop rather than improvising
its rules.

## Resolve the contract once

Run the "Resolve the contract" ladder from
[create-branch](../create-branch/SKILL.md) a single time, at the start. The
branch, the commits, and the PR all reuse that result. Don't re-resolve it for
each step.

The same goes for the ticket. Settle it once, per create-branch's Tickets
section, and carry the key forward into the branch name, the commit messages,
and the PR title.

## Pick a path

Start from the state of the repo:

```bash
git status --porcelain
git branch --show-current
git symbolic-ref refs/remotes/origin/HEAD
git log origin/<base>..HEAD --oneline
```

**Branch.** On the default branch, or detached, cut a new one per
create-branch. On a feature branch already, keep it and say so in the plan. The
user may still want a fresh branch, and that's their call.

**Commits.** Size the work by concern, not by line count. Apply
clean-commit-storyline's step 5 test: does the change touch more than one of a
single component directory, hook, utility, page or feature section, or config
file (with colocated tests counted alongside their subject)?

| What is there                                         | Commit path                        |
| ----------------------------------------------------- | ---------------------------------- |
| Uncommitted work, one concern                         | **Single** commit via create-commit |
| Uncommitted work, several concerns                    | **Series**, planned storyline-style |
| Branch already has commits, history is fine           | Commit any leftovers, then PR      |
| Branch already has commits, history is messy          | **Replay** via clean-commit-storyline |
| Nothing uncommitted and no commits ahead of the base  | Stop. There is nothing to ship.    |

- **Single.** One create-commit pass.
- **Series.** Nothing is committed yet, so there's no history to replay and no
  `-clean` branch to make. Plan the commits with clean-commit-storyline's step 5
  rules and step 7 message deltas, then make each one with create-commit's
  staging and validation, working straight from the tree. Stage by path, or by
  hunk with `git add -p <path>` when one file spans two concerns.
- **Replay.** Run clean-commit-storyline as written. It produces a new branch,
  and the PR opens from that one. Leave the source branch where it is.

When the call between single and series is close, take single and mention the
split as the alternative.

## Workflow

### 1. Gather context

Run the path checks above alongside create-commit's step 1 inspection (`git
status`, `git diff`, `git diff --staged`, recent log). Read the diff in full
before planning. Read the ticket when there is one and it would help.

### 2. Present the plan, then STOP

This is the first of two gates. It folds create-branch's and create-commit's
confirmations into one message:

- The **resolved contract** (types, ticket form, base branch, validator) and
  which tier it came from
- The **branch**: the new name and its base, or the existing branch being kept
- The **commit path** (single, series, or replay) and why
- Every **commit**, numbered: the full message as it will appear, and its exact
  files
- Anything **left out**, and why: drift, local config, generated files,
  secrets
- One **alternative** wherever the call was close: a different branch name, or
  a different split

Don't create a branch, stage, or commit until the user replies. When they ask
for changes, re-present the **whole** plan and stop again.

### 3. Cut the branch

Per create-branch steps 6 and 7. Fetch the base first, use `--no-track`, and let
uncommitted work carry over with `git switch -c`. Skip this step when the plan
kept the current branch, and skip it on the replay path, where
clean-commit-storyline cuts its own.

### 4. Make the commits

Per the path:

- **Single or series.** For each planned commit, in order: stage its files,
  validate the message, run the pre-commit checks over the staged paths, then
  commit (create-commit steps 2 through 4, 6, and 7). The plan approved in
  step 2 stands in for create-commit's own confirmation, so don't stop again
  between commits unless something drifts from the plan.
- **Replay.** clean-commit-storyline steps 1 through 9. Its plan *is* the
  step 2 plan here, so don't present it twice.

Stop and report when a hook fails, a formatter rewrites a file outside the
commit's planned paths, or the tree no longer matches the plan. Fix the cause
and make a **new** commit; never amend a failed one. When signing fails, follow
create-commit's signing note: hand the user the command and don't retry.

When done, `git status` must show nothing left over that the plan meant to
commit.

### 5. Draft the PR, then STOP

This is the second gate. Run create-pr steps 1 through 6 against the branch
just made: profile, title, body, and the voice pass if the user asked for one.
Present the title and the body in a single code block. Name the profile and the
sections left out, as create-pr requires.

Say plainly that confirming this pushes the branch and opens the PR. That is
the outward-facing step, so it gets its own gate even when the user approved
everything else quickly.

### 6. Push and open the PR

Only after the user confirms. Validate the title per create-pr step 8, then:

```bash
git push -u origin <branch>
gh pr create --base <base> --head <branch> --title "<title>" --body-file <file>
```

Write the body to a file in the scratchpad (or use a HEREDOC) so the markdown
survives intact. Asking for this skill is the request to push that the siblings
wait for. It covers this one branch, this one time, and never a force push.

### 7. Report

- The branch, and the commits on it (`git log origin/<base>..HEAD --oneline`)
- The PR URL from `gh pr create`
- When the contract landed on tier 3 or 4, the one-time offer to record it in
  `AGENTS.md` that the siblings make. Make it once here, not once per step.

## Collapsing the gates

When the user says up front to skip confirmations ("just ship it", "don't ask"),
merge both gates: present the plan and the PR draft together, then stop once.
Don't skip that last stop entirely. It's the only point where the user sees the
branch name, the messages, and the PR text before they leave the machine.

## Git safety

Everything in the siblings' Git safety sections applies. On top of that:

- Never push the default branch, and never push with `--force` or
  `--force-with-lease`
- Never push a branch other than the one this run made or kept
- Never open the PR before the commits are verified and the tree is accounted
  for
- Never stash, reset, or discard to tidy the tree. Unrelated work stays
  uncommitted and gets named in the plan
- On the replay path, never delete or rewrite the source branch

## Checklist

- [ ] Every sibling skill read before its step ran
- [ ] Contract and ticket resolved once and reused
- [ ] Path chosen (single, series, or replay) and justified in the plan
- [ ] Gate 1: user approved branch, commit messages, and file lists
- [ ] Branch cut off a freshly fetched base, or the kept branch named
- [ ] Each commit validated, hook-clean, and matching the plan
- [ ] Nothing the plan meant to commit left in the tree
- [ ] Gate 2: user approved PR title and body, knowing it pushes
- [ ] Branch pushed with an upstream, without force
- [ ] PR URL reported
