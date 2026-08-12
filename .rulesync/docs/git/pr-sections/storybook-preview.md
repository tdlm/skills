# Storybook Preview

A marker block that CI fills in with Chromatic and Storybook links.

**Include it when the diff touches something Storybook renders** -- a component, or a story for one -- so Chromatic has a changed story to show. Leave it out otherwise. Chromatic runs on every PR and always produces links, so including this block on a PR that changes no stories yields a link to stories nobody touched, which is noise a reviewer has to rule out.

The field is a bold label plus the two markers and their placeholder line:

```markdown
**Storybook Preview**

<!-- CHROMATIC:START -->
_Chromatic links will be automatically added here when the build completes._
<!-- CHROMATIC:END -->
```

CI replaces everything between the markers with a table of links once the build completes. If the markers are mangled the replacement silently never happens, and the placeholder sentence ships to reviewers as if it were the answer.
