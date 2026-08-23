# skills

Portable agent skills for git workflows and writing style.

## Root skills

| Skill | Use when |
| ----- | -------- |
| [create-branch](create-branch/SKILL.md) | Creating, cutting, or naming a git branch for new work |
| [create-commit](create-commit/SKILL.md) | Staging changes, drafting commit messages, and committing |
| [create-pr](create-pr/SKILL.md) | Opening a pull request, drafting a PR description, or fixing a PR title |
| [clean-commit-storyline](clean-commit-storyline/SKILL.md) | Rewriting a branch with a clean, narrative commit history |
| [scottify](scottify/SKILL.md) | Writing or rewriting text in Scott's voice |

The scottify skill includes a `references/` folder (phrases, structures, examples)
adapted from [stop-slop](https://github.com/hardikpandya/stop-slop) by Hardik Pandya
(MIT). Scott's writing samples override stop-slop where they conflict; see the override
table in [scottify/SKILL.md](scottify/SKILL.md).

Each git skill resolves the repo's commit conventions at runtime — from agent docs,
machine config, git history, or Conventional Commits as a fallback — so the same
skill folder works across repos without hard-wiring ticket formats or tooling.
Ticket references are supported when the repo uses them and omitted when work is
ticketless; no particular issue tracker is assumed.

## How the git skills fit together

The three main skills run in order, each reading what the last one produced:

```text
create-branch  ->  create-commit  ->  create-pr
```

A branch, its commits, and its PR carry one vocabulary — the same type, the same
ticket, the same description rendered for each form. create-branch kebabs it into
a ref, create-commit renders it as a message header, and create-pr reads the type
back off the branch prefix to pick a body template.

[clean-commit-storyline](clean-commit-storyline/SKILL.md) is an optional step
before the PR: it replays a messy branch into a narrative history, using
create-commit's message form and create-branch's ref validation.
[scottify](scottify/SKILL.md) is opt-in inside create-pr, for a PR body in
Scott's voice.

Each skill names these relationships in a "Related skills" section and links with
relative sibling paths (`../create-commit/SKILL.md`), which resolve wherever the
folders are deployed together. Every reference is written to degrade gracefully:
a skill copied out on its own keeps working, with a dangling link as the only
cost.

Two things stay deliberately duplicated rather than extracted to a shared file,
because a self-contained folder is worth more here than a single source of truth:

- **The "Resolve the contract" tier ladder**, byte-identical in all four git
  skills. Edit one, edit all four.
- **The type-disambiguation bullets**, shared by create-branch and create-commit.
  create-commit is the one that explains them; create-branch repeats them and
  links back.

## `.rulesync/`

The `.rulesync/` directory is a source library imported from another project. It
contains project-specific skills, reference docs, hooks, and subagents. Mine it
for ideas; do not edit it as part of this repo's skill set. The root skills above
are the generic, portable versions extracted from it.
