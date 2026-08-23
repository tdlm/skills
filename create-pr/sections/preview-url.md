# Preview URL

CI-injected preview blocks that give reviewers a place to exercise the change.

Some repos ship one or more marker blocks in `.github/PULL_REQUEST_TEMPLATE.md`.
Common patterns:

- **Development URL** — a preview deploy for the running app
- **Storybook Preview** — Chromatic or Storybook links for component changes

**Include a block when the change is observable through that channel.** Leave it
out when there is nothing to look at. Every branch may get a preview deploy, but
availability isn't the test: on a tooling, CI, or lint-config PR the deploy is
identical to production and the link only costs a reviewer the click to find that
out.

When the repo's PR template ships prefilled blocks, copy the marker comments
**byte-for-byte** from the template. Do not invent marker strings — CI matches them
exactly and a mistyped marker fails silently.

## Development URL

**Include when the change is observable in the running app** — a page, route, or
component a reviewer can open and exercise.

```markdown
**Development URL**

<!-- DEVELOPMENT_URL:START -->
https://preview-XXXX.example.com
<!-- DEVELOPMENT_URL:END -->
```

CI replaces everything between the markers with the real URL as soon as the PR
opens. Leave `XXXX` alone — the PR number does not exist until the PR does.
Append a path when the change targets a specific page, inside the markers, and
the substitution keeps it.

## Storybook Preview

**Include when the diff touches something Storybook renders** — a component, or a
story for one — so Chromatic has a changed story to show. Leave it out otherwise.

```markdown
**Storybook Preview**

<!-- CHROMATIC:START -->
_Chromatic links will be automatically added here when the build completes._
<!-- CHROMATIC:END -->
```

CI replaces everything between the markers with a table of links once the build
completes.

When the repo has no PR template with these blocks, skip them entirely.
