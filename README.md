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

## `.rulesync/`

The `.rulesync/` directory is a source library imported from another project. It
contains project-specific skills, reference docs, hooks, and subagents. Mine it
for ideas; do not edit it as part of this repo's skill set. The root skills above
are the generic, portable versions extracted from it.
