# Changes

What was actually built, as bullets with **bold leads** and em-dashes.

```markdown
- **Escape hatches** -- Sub-components expose overridable sub-parts via `Object.assign`, so Figma variations can be supported without forking the component.
```

The bold lead names the change; the text after the em-dash says what it does and, where it isn't obvious, why it was done that way.

## Rules

- **Results, not plans.** Describe what the diff contains, not what someone intends to do. A ticket's Approach is the plan; this is the outcome.
- **Group by concern, not by file.** One bullet per logical change area, even when it spans several files. A bullet per file produces a changelog nobody reads.
- **Name paths only when they are the point.** A new directory convention or public import path earns a mention. The rest of the file list is already in the diff.
- **Five top-level bullets maximum.** Past that, group related items or nest sub-bullets under a broader lead.

This section is usually the largest in the body, and on a straightforward change it is the one a reviewer reads first. Ordering matters: lead with the change that explains the others.
