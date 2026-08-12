# Git conventions

The shared vocabulary behind commit messages, PR titles, and branch names. Each
artifact renders these parts differently, but the types, ticket forms, and
description rules are the same across all three.

The three are linked: a branch feeds GitHub's prefilled PR title, and
squash-and-merge turns the PR title into the commit message on `main`. One
vocabulary keeps that chain readable end to end.

`commitlint.config.js` is what actually enforces this — on commits through the
`commit-msg` hook, and on PR titles through the same binary. It declares the
repo's custom rules and inherits the rest from the
`@commitlint/config-conventional` preset it extends, so the file alone is not the
whole picture. Print everything resolved:

```bash
pnpm exec commitlint --print-config
```

This doc covers what the linter can't check: which type to reach for, which
ticket form fits, and how to phrase a description.

## Types

The linter enforces which types exist. These are the calls it can't make for you:

- `feat` and `fix` are for change users or API consumers notice — everything else
  is internal
- `refactor` is a restructure with no intended behavior change; `perf` is one
  where the intended change is speed; `style` is formatting with no logic change
- `chore` is the fallback. Reach for `ci`, `build`, or `docs` first when one of
  them genuinely fits

## Ticket forms

`jira-reference-format` in `commitlint.config.js` is the enforced pattern. Which
form to use:

| Form                  | Use for                                                                 |
| --------------------- | ----------------------------------------------------------------------- |
| `[ML:PAID-123]`       | Normal MoneyLion Jira work. `J:` is Gen Jira, `CT:` ConsumerTrack        |
| `[ML:LINWEALTH-1143]` | Linear-tracked contractor work — the project key just starts with `LIN`  |
| `[ML:RITM000213]`     | ServiceNow request items                                                 |
| `[ML:TRIVIAL]`        | Genuinely ticketless work                                                |

`[ML:TRIVIAL]` exists for dependency bumps, typo fixes, and the urgent fix that
has no ticket yet. It is not a way to skip filing one — if the work is worth a
review, it is usually worth a ticket.

## Description

- **Imperative mood** — "add", not "adds" or "added"
- **Lowercase start.** `allow savvy api host`, not `Allow Savvy API Host`.
  Acronyms keep their casing (`update CSP connect-src`), as do lowercase-initial
  product names (`iOS`)
- Say what the change does; the diff already shows the mechanics

## Scope

Optional and free-form — no `scope-enum` is configured. Name the area of the
codebase the change touches, lowercase, using `/` for nesting
(`refactor(skills/create-jira-ticket): …`). Omit it when the change is broad.

## Header form

Commit subjects and PR titles share one header:

```text
<type>(<optional scope>)!: [ML:<ticket>] <short description>
```

| Part          | Required | Notes                                                 |
| ------------- | -------- | ------------------------------------------------------ |
| `type`        | Yes      | Lowercase                                             |
| `(scope)`     | No       | In parens, before the colon                           |
| `!`           | No       | Immediately before the colon; marks a breaking change |
| `[ML:ticket]` | Yes      | One of the forms above                                |
| description   | Yes      | No trailing period                                    |

The whole header stays under 100 characters (`header-max-length`), type and
ticket included. The scope is optional but the `!` always sits immediately before
the colon, so `feat!:` and `feat(api)!:` are both valid.

Branch names carry the same type, ticket, and description, rendered with slashes
and dashes instead of this punctuation.
