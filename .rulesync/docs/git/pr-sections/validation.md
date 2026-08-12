# Validation

How a reviewer confirms the change does what it claims.

The bar is that someone who has not read the diff closely can follow this section and end up convinced. Use checkboxes when validation takes more than one step.

- **Visual work** -- link the Storybook or Chromatic story and say what to compare it against, e.g. the Figma mock it implements.
- **Behavioral work** -- give the steps: where to go, what to do, what should happen.
- **Config, tooling, and CI work** -- give the exact command, and say what its output proves.

That last case is the one that carries the most weight, because the diff itself is unreadable as evidence. A Commitlint preset migration is a small diff whose real effect is invisible until the resolved config is printed and a deliberately bad message is piped through:

```bash
pnpm exec commitlint --print-config
printf '%s' "Feat: no ticket here" | pnpm exec commitlint
```

The first shows which rules are now in force; the second proves the rules still reject what they should. On that kind of PR this section is often the longest one in the body, and it is the only section a reviewer can act on.
