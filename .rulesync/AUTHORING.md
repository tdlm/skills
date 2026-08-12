# Authoring `.rulesync/` content

This file is the dev-facing source guide for moneylion-next's rulesync setup.

`.rulesync/` is canonical. Edit files here, then run `pnpm rulesync` to
regenerate `.cursor/` and `.claude/`. Never edit generated files directly.

## Where each kind of content lives

| Kind                            | Location                          | Emitted? |
| ------------------------------- | --------------------------------- | -------- |
| Reference docs (long-form prose)| `.rulesync/docs/*.md`             | No       |
| Skills (workflow triggers)      | `.rulesync/skills/<name>/SKILL.md`| Yes      |
| Root rule (project overview)    | `.rulesync/rules/overview.md`     | Yes      |
| Rule shims (auto-attach pointers)| `.rulesync/rules/<name>.md`      | Yes      |
| PostToolUse / hooks             | `.rulesync/hooks.json`, `.rulesync/hooks/*.sh` | Yes |
| MCP servers                     | Not managed here -- see README    | No       |

MCP servers are deliberately **outside** the rulesync pipeline, and `"mcp"` is
not in `rulesync.jsonc`'s `features`.

rulesync has no concept of a Cursor or Claude Code **plugin** -- it only
understands raw `mcpServers` entries. Most of the servers this repo's skills
depend on (Atlassian, Figma, Slack) are delivered as plugins, which bundle
their own skills and handle OAuth more durably than a hand-rolled entry. A
rulesync-generated server sitting alongside an installed plugin registers the
same MCP twice under two different keys: duplicate tool schemas burning
context, and no signal telling the agent which copy to call. Per-server
`targets` only moves the collision between tools, since the same plugins exist
for both.

Per-developer setup is documented in the README's "Recommended MCP servers and
Cursor plugins" section.

`.rulesync/docs/` is the **References-folder layer**. It holds the long-form
content. Skills and rule shims reference these docs by bare repo-relative path; the agent reads
the doc on demand. Docs are never copied into target directories, so a single
authoritative version lives in this repo.

## The bare-backtick reference contract

When a skill or rule shim needs to cite a doc, use a **bare repo-relative
path inside backticks**:

```markdown
For compound component patterns, read `.rulesync/docs/compound-primitives.md`.
```

Not `[text](path)` markdown link syntax. Not `./` or `../` relative prefixes.
The agent's CWD is the repo root in both Cursor and Claude Code, so a bare
repo-relative path resolves identically from anywhere a skill or rule body
might be quoted into the agent's context.

Trade-off: GitHub's markdown renderer interprets bare paths as file-relative,
so the link won't be clickable on github.com. Acceptable — these references
are read by agents in the IDE, not browsed on GitHub.

## When to add a rule shim

Most content should land in `.rulesync/docs/` as a plain markdown doc and be
cited from skills via the bare-backtick contract. A `.rulesync/rules/<name>.md`
**shim** is only needed when you want a specific harness loading behavior:

- **Auto-attach on file patterns.** Set top-level `globs:`. Cursor auto-attaches
  when a matching file is in context; Claude inherits `paths:` and does the same.
- **Cursor agent-requestable.** Set top-level `description:` (without `globs:`).
  Cursor's agent-requestable manifest indexes the rule by description; agent
  pulls it on demand.
- **Asymmetric scoping.** Use the `cursor:` / `claudecode:` override blocks
  for cases where Cursor and Claude need different loading semantics on the
  same rule.

## Doc filename mapping

Docs in `.rulesync/docs/` follow one of two shapes:

- **Root-level filename** (e.g. `compound-primitives.md`, `reshaped-first.md`) — standalone topics. Most docs follow this shape.
- **Category directory** (e.g. `file-structure/`, `testing/`) — for topics that span multiple module types. Inside the directory, a bare filename (`file-structure/component.md`) is the shared cross-cutting doc for that category; hyphenated suffixes (`file-structure/component-flat.md`, `file-structure/component-hybrid.md`, `file-structure/component-compound.md`) are narrower sub-scopes of the same namespace. This shape lets a category like `file-structure/` or `testing/` later add `hook-*.md`, `service-*.md`, etc., without restructuring.

Cite any doc via its bare repo-relative path in backticks, e.g. ``.rulesync/docs/compound-primitives.md`` or ``.rulesync/docs/file-structure/component-compound.md``.

## Skill→skill relative paths

Within a skill directory (e.g.
`.rulesync/skills/create-react-component/`), relative paths to sibling files
(like `./workflows/compound-primitive.md`) **are preserved end-to-end**.
Cursor and Claude both keep the relative position intact when emitting to
their respective skill directories. Use ordinary `./subfolder/file.md`
markdown links for these — no need for the bare-backtick contract inside a
skill's own folder.

## Docs carry content, not navigation

Every markdown file under `.rulesync/docs/` is written for exactly one of two
readers, and which reader decides what the file may contain:

- **A doc** — any file that isn't a `README.md` — is read by an agent that the
  loading layer (a skill, a rule shim, a workflow's "Rules to follow" /
  "Tests" / "Storybook" section) has already routed to it. Its job is content,
  nothing else.
- **A directory `README.md`** is read by a human browsing on GitHub, which
  renders it atop the directory's tree view. Its job is navigation: an index
  of its siblings (e.g. `docs/git/pr-sections/README.md`, which
  `.github/pull_request_template.md` points humans at).

Each file navigates only for its own reader. Skills navigate for agents,
READMEs navigate for humans, and a doc navigates for no one:

**A doc never references another doc file.** To an agent, a file path is an
eager-loading instruction, so prose like "for shared X, see parent.md" or "see
also: peer.md" is loading semantics leaking into content. If a doc legitimately
needs another doc in context, the workflow that loads it bundles both — a
breadcrumb inside the doc either duplicates bundling the workflow already does
or papers over a workflow gap (fix the workflow). Likewise a reader who loaded
the wrong doc is redirected by the skill's decision tree (e.g. "Pick a layer"
in `create-react-component`), never by prose inside the doc.

When a doc touches a neighboring concern — a decision-tree exit, a diagnostic
redirect, a hand-off to an orthogonal concern — **name the concept, not the
file**: "that's an opinionated wrapper", "extracting an island moves the
parent from the flat to the hybrid file layout". Doc filenames match concept
names, so an agent that genuinely needs the other doc can locate it. A named
concept is a recoverable breadcrumb; a file path is an instruction.

The violations to catch in review, whatever shape they take:

- **Header breadcrumbs** — "for shared X, see parent.md".
- **Parent docs enumerating their children**, and end-of-doc bibliography
  sections that mirror the workflow's reference list.
- **Code-path advertisements** — bulleted lists of "canonical examples"
  pointing at full component directories:

  ```markdown
  Canonical examples in this codebase:

  - `src/app/.../ProductCard/`
  - `src/components/Hero/`
  ```

  The same eager-loading problem aimed at source code: navigating into those
  directories can mean tens of thousands of tokens of incidental code. Inline
  mentions in the doc's own snippets and worked examples (`ProductCard.Badge`,
  `OfferCard` vs `OfferCardCompact`) are breadcrumb enough. If one file
  genuinely is the canonical worked example for the pattern being taught, cite
  that **one file** in the relevant section — not a directory at the top of
  the doc.

A README's linking freedom comes with the inverse restriction: **a README is
never cited by a skill or rule shim**, so it never enters agent context. A
README that a skill needs to cite is a doc wearing the wrong filename — move
the content into a doc and let the README go back to being an index.

## When skills should NOT reference rules by name

Don't write prose like "follow the `compound-primitives` rule." Whether that
resolves depends on the rule's loading mode and which files are open. Instead,
cite the doc directly:

```markdown
For compound primitives, read `.rulesync/docs/compound-primitives.md`.
```

## Regenerating

```bash
pnpm rulesync
```

That's the only mutating entry point. There is no `postinstall` hook, no
automatic regen anywhere. The drift notifier (`scripts/rulesync/notify-drift.sh`)
alerts you when an incoming `git checkout` / `merge` / `rebase` pulled in a
`.rulesync/**` change, but it never runs the generator itself.
