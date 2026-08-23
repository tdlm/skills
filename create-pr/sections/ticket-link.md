# Link to ticket

The ticket key as a link, sitting under the Description paragraph as a bold label.

**Include when the work has a ticket and the repo tracks work that way.** Drop the
field entirely for ticketless work rather than linking a placeholder — a link to
nothing wastes a click.

The field is the bold label plus the key linked to the issue:

```markdown
**Link to ticket**

[ABC-90](https://issues.example.com/ABC-90)
```

Use whatever issue URL format the repo uses — the skill does not assume a particular
tracker product. Parse the key from the branch name: `feat/ABC-103-footer-component`
gives `ABC-103`, `fix/DOT-456-broken-nav` gives `DOT-456`. That segment is a bare
uppercase key with no brackets, per
[create-branch](../../create-branch/SKILL.md) — the bracketed form belongs to
commit messages, so strip nothing and add nothing when lifting it. Some repos use
`#123` or other shapes; follow the resolved contract.

When the branch name carries no key, fall back to the branch's commit subjects.
When commitlint is configured, the ticket-reference rule in the resolved contract
defines the pattern; extract the key per that rule. A ticketless marker means this
field comes out, not that it links to the marker.
