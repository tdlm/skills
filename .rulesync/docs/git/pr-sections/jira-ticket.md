# Link to Jira ticket

The ticket key as a link, sitting under the Description paragraph as a bold label.

**Include it whenever the work has a ticket** -- which is nearly always. Drop the field entirely for genuinely ticketless work rather than linking a placeholder; a link to nothing wastes a click.

The field is the bold label plus the key linked to the issue:

```markdown
**Link to Jira ticket**

[PAID-90](https://moneylion.atlassian.net/browse/PAID-90)
```

Parse the key from the branch name: `feat/PAID-103-footer-component` gives `PAID-103`, `fix/DOT-456-broken-nav` gives `DOT-456`.

When the branch name carries no key, fall back to the branch's commit subjects. Commitlint requires a bracketed Jira reference on every commit -- `JIRA_REFERENCE_RE` in `commitlint.config.js` is the enforced pattern, and the key is the part after the colon. A `TRIVIAL` reference is the ticketless marker, not a key: it means this field comes out, not that it links to TRIVIAL.
