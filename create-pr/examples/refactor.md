# refactor example

A restructure with no intended behavior change.

What to notice: **Behavior Parity states the claim and then backs it**, including the one test that had to change and why that is not a parity violation. That admission is the section earning its place — a reviewer would have found it in the diff anyway, and finding it stated is what makes the rest of the claim credible.

**Downstream Impact is present** because the restructure moved a public import path. Testing and Validation stay short, since neither carries the argument here.

PR title: `refactor(blog): [ABC-126] architect widget renderers pipeline`

```markdown
## Description

Splits the blog widget renderers out of one growing switch statement into dedicated modules under `_widgetRenderers`, behind a shared pipeline that normalizes fields and enriches props before dispatch.
No rendered output changes.

**Link to ticket**

[ABC-126](https://issues.example.com/ABC-126)

**Development URL**

<!-- DEVELOPMENT_URL:START -->
https://preview-XXXX.example.com
<!-- DEVELOPMENT_URL:END -->

### Motivation

Every new widget type meant another branch in the same function, and each branch repeated the same field-normalization and prop-shaping work with small variations.
The variations were the problem: two widgets that should have handled a missing field identically often didn't, and the switch made that hard to see.

### Changes

- **Renderer modules** — Each widget type becomes its own module under `_widgetRenderers`, registered in one place. Adding a type no longer means editing shared control flow.

- **Shared pipeline** — `normalizeWidgetFields` and `enrichWidgetProps` run before dispatch, so field defaulting happens once instead of per branch.

- **Consumer update** — `BlogContentRenderer` calls the pipeline rather than the switch. Its public props are unchanged.

### Behavior Parity

Rendered output for every existing widget type is unchanged, and the existing renderer tests pass untouched against the new modules.

One test changed: it asserted the switch's fallthrough order rather than a rendered result, so it had nothing to assert once dispatch moved to the registry. It is replaced by a test that the unknown-widget case renders nothing, which is the behavior it was indirectly checking.

### Downstream Impact

- **No breaking changes** — `BlogContentRenderer` keeps its props, so pages consuming it need no edits.
- **New convention** — New widget types go in `_widgetRenderers` as modules and register themselves. Adding a branch to the old switch is no longer possible.

### Testing

Unit tests per renderer module, plus tests for `normalizeWidgetFields` and `enrichWidgetProps` covering the defaulting the branches used to do individually.

### Validation

Open a blog post containing a pro-tip, script, and embedded-entry widget, and confirm each renders as it does on production.
```
