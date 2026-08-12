# Branch names

A branch carries the same type, ticket, and description as the commit it leads
to, rendered for a git ref:

```text
<type>/<TICKET>-<kebab-description>
```

```text
feat/WA-60-unpublish-script
fix/WA-85-savvy-insurance-type-selection
docs/WA-74-rulesync-commit-conventions
```

## How it differs from a header

| Part        | Header               | Branch             |
| ----------- | -------------------- | ------------------ |
| Separator   | `: ` after the type  | `/` after the type |
| Scope       | `(scope)` in parens  | Omitted            |
| Ticket      | `[ML:WA-60]`         | `WA-60`, bare      |
| Description | Spaced words         | Kebab-case         |
| Breaking    | `!` before the colon | Not marked         |

## Rules

- **Type** — the same set commits use, enforced by `type-enum` and printable with
  `pnpm exec commitlint --print-config`. Lowercase, and the short form: `feat`,
  not `feature`
- **Ticket** — uppercase project key and number, no instance prefix and no
  brackets
- **Description** — kebab-case, imperative, 2–4 words, with the whole ref under
  about 40 characters
- **Ticketless work** — drop the ticket segment: `<type>/<kebab-description>`.
  There is no branch analogue to `[ML:TRIVIAL]`
- A git ref cannot contain spaces, `~`, `^`, `:`, `?`, `*`, `[`, `\`, consecutive
  dots, or a trailing dot — which is why the header punctuation cannot carry over

## Length

The ticket is the identifier. The words after it are a reminder of what the
branch is for, not a summary of it — the ticket, the PR, and the commits all
have room to say more.

`feat/PAID-147-personal-loans-cash-advance-ld-json-schema` spells out the page
so it can be told apart from the sibling ticket adding the same schema
elsewhere, but the key already does that: `feat/PAID-147-ld-json-schema` is the
same branch at half the length. Cut anything the type or the ticket already
carries, and anything that only matters once you are inside the ticket.

A branch list is scanned, not read. Long names wrap, bury their distinguishing
words at the far right, and push the ticket keys out of alignment.
