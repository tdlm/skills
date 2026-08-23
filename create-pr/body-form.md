# PR body form

How a PR body is shaped, whatever sections it carries.

Picking the sections is a separate decision, made per type of work — each
section's own guidance covers when it applies and what belongs in it. This doc
covers only the form those sections share once picked.

## Heading levels

`## Description` is the only `h2` in a body. Every other section is an `h3`.

The rule comes from GitHub's rendering, not from the outline. GitHub draws a
full-width horizontal rule under `h1` and `h2` and gives both heavy margins, so
a body with six `h2`s reads as a stack of ruled-off boxes whose dividers carry
more weight than their content. One `h2` leaves exactly one rule on the page:
under Description, separating the summary from the detail behind it.

## Metadata labels

Ticket link, preview URL, and other CI-injected fields are bold labels, not
headings. The label and its value sit on separate lines with a blank line
between them:

```markdown
**Link to ticket**

[ABC-110](https://issues.example.com/ABC-110)
```

Bold keeps these fields out of the outline, and that is the point: a heading
would have to nest correctly under whatever precedes it, while a label can sit
under Description, drop to the bottom of the body, or be reordered without
touching anything around it. Placement stays the author's call — CI locates
injected blocks by their markers, never by position.

## Spacing

A single newline in a PR body renders as a real line break, so line breaks are
layout decisions, not invisible source formatting:

- **Prose** — one sentence per line, with a blank line between distinct ideas.
- **Bullets** — a blank line between items only when the items wrap past one
  rendered line, which bullets with bold leads usually do. Keep short one-line
  lists tight; spread out, the body stretches across screens and pushes the
  last sections below the fold.

## Style

- **Bold leads on bullets** — a bolded name for the item, an em-dash, then the
  explanation; the bold lead is what makes a body scannable.
- **Conversational tone** — written for a colleague, not a changelog parser;
  avoid clinical phrasing.
- **Adapted from the ticket when one exists, not copied** — ticket prose argues for
  work that hasn't happened yet, while the body describes the result. Ticketless PRs
  state the outcome directly.

## Omitted sections

Delete the heading along with the content. Never `n/a`, and never a heading
over "none" — an empty section is a question the reviewer has to answer before
concluding there was nothing there, while a missing one has already answered
it.

## Marker blocks

Some repos ship CI-injected preview blocks in `.github/PULL_REQUEST_TEMPLATE.md`
— development URLs, Storybook/Chromatic links, or similar. Each is a pair of
HTML comments wrapping a placeholder: CI matches the two comments byte for byte
and replaces everything between them. The comments are the fragile part — the
content between them is replaceable by definition, and a section's guidance may
even say to edit it before CI runs.

- **A mistyped marker fails silently.** CI finds nothing to match, and the
  placeholder ships to reviewers as though it were the answer.
- **Markers cannot sit inside another HTML comment.** Comments don't nest, and
  the injected content is rendered markdown that an enclosing comment would
  swallow.
- **Omitting a block is safe.** CI finds no markers, logs that there is nothing
  to do, and exits cleanly. There is no failure mode to hedge against, so a
  half-copied block is never safer than none.

When the repo's PR template ships prefilled blocks, an author starting from the
template makes one call per block — keep it or delete it, per its include test —
and never fills one in by hand. The literal blocks and each include test live
with their section guidance in [sections/preview-url.md](sections/preview-url.md).

When no template ships marker blocks, skip them entirely.
