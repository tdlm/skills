# Development URL

A marker block that CI fills in with the preview URL for this PR.

**Include it when the change is observable in the running app** -- a page, route, or component a reviewer can open and exercise. Leave it out when there is nothing to look at. Every branch gets a preview deploy, so the link is always available, but availability isn't the test: on a tooling, CI, or lint-config PR the deploy is identical to production and the link only costs a reviewer the click to find that out.

The field is a bold label plus the two markers wrapping a placeholder URL:

```markdown
**Development URL**

<!-- DEVELOPMENT_URL:START -->
https://moneylion-next-XXXX.moneylion.dev
<!-- DEVELOPMENT_URL:END -->
```

CI replaces everything between the markers with the real URL as soon as the PR opens. Leave `XXXX` alone -- the PR number does not exist until the PR does, which is the whole reason CI does this and the template cannot. If the markers are mangled the replacement silently never happens, and `XXXX` ships to reviewers as a link that goes nowhere.

**Append a path when the change targets a specific page**, inside the markers, and the substitution keeps it:

```markdown
<!-- DEVELOPMENT_URL:START -->
https://moneylion-next-XXXX.moneylion.dev/paid-landing-pages/identity-theft
<!-- DEVELOPMENT_URL:END -->
```
