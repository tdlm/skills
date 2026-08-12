# Commit messages

A commit message is a header, an optional body, and an optional footer.
`commitlint.config.js` is the machine-enforced half of this contract, and the
`commit-msg` hook runs it on every commit.

## Ticket placement

The rule tests the raw message, so either position satisfies it. Choose by
whether the commit has a body.

**Body present → footer**, on its own line after a blank line. This keeps the
header's full 100 characters available for describing the change.

```text
refactor(learn): architect widget renderers pipeline

- Split renderers into dedicated modules under _widgetRenderers
- Add normalizeWidgetFields and enrichWidgetProps helpers
- Update BlogContentRenderer to use the new pipeline

[ML:SEO-126]
```

**No body → subject**, inline after the colon.

```text
docs: [ML:SEO-126] add notes to renderer functions
```

## Body

Most commits carry a body. Use a **bullet list**, one bullet per distinct change
area — a file group, a feature slice, or a behavior change. Each line wraps at
100 characters.

- Explain what changed and **why**; the diff already shows the mechanics
- Don't restate the subject in the first bullet
- **Avoid prose paragraphs** for multi-change commits. Long unbroken text is hard
  to scan in `git log`. Reach for bullets whenever there are two or more logical
  changes, or when one change needs more than a sentence to explain. A single
  short paragraph (2–3 sentences) is fine only when the commit has one focused
  change.
- **Skip the body entirely** when the change is small and the subject already
  says everything

## Breaking changes

Mark a breaking change with `!` before the colon, and explain it in a
`BREAKING CHANGE:` footer.

```text
feat(api)!: [ML:MP-1005] drop support for node 16

BREAKING CHANGE: node 16 is no longer supported; upgrade to node 20 or later.
```

The footer belongs there whenever the commit breaks consumers, with or without
the `!`.

## Never include

- `Co-Authored-By`, "Generated with Cursor", or "Made-with" trailers
- Agent attribution as author or contributor
- Process commentary about how the commit was produced — "split out from the
  previous commit", "dropped unrelated diffs", "per review feedback". Every
  commit should read as though written the moment the work was done.

## Validating a message

The `commit-msg` hook runs `pnpm exec commitlint --edit`. Check a draft against
the same binary before committing; the ticket must be present in the piped text
or the custom rule fails.

```bash
# No body, ticket inline
printf '%s\n' "fix: [ML:SEO-179] correct nav overflow on mobile" | pnpm exec commitlint

# Body present, ticket footer
printf '%s\n\n%s\n%s\n\n%s\n' \
  "refactor(learn): architect widget renderers pipeline" \
  "- Split renderers into dedicated modules under _widgetRenderers" \
  "- Update BlogContentRenderer to use the new pipeline" \
  "[ML:SEO-126]" | pnpm exec commitlint
```
