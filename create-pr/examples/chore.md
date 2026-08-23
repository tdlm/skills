# chore example

A tooling change with nothing to test.

What to notice: **three sections, and Validation is the longest of them.** The diff is a handful of deleted lines whose actual effect — which rules are now in force — is invisible until the resolved config is printed, so the commands are the review.

**There is no Testing section**, because there is nothing to test. **There is no Motivation section** either: the change explains itself, and a paragraph arguing that presets beat hand-rolled config would be padding. Had this needed a new test to prove behavior, it would not have been a chore.

**There is no Development URL** either: the deploy exists, but nothing in it changed.

PR title: `build(commitlint): [ABC-74] migrate to the config-conventional preset`

````markdown
## Description

Replaces the hand-maintained Commitlint rule set with the `@commitlint/config-conventional` preset, keeping only the rules the preset doesn't supply.

**Link to ticket**

[ABC-74](https://issues.example.com/ABC-74)

### Changes

- **Preset adopted** — Extends `@commitlint/config-conventional`, dropping the locally enumerated type list and header-length rules it already provides.
- **Repo-specific rules kept** — Custom ticket-reference and subject-case rules remain local plugin rules, as does `scope-case`, which the preset leaves unset.

### Validation

The rules in force are now split between the preset and this file, so read them resolved rather than from the diff:

```bash
<package-manager> exec commitlint --print-config
```

Then confirm the custom rules still bite, since they are the ones the migration could have dropped silently:

```bash
printf '%s' "Feat: no ticket here" | <package-manager> exec commitlint
```

That message should fail — once for the missing ticket reference, once for the capitalized description.
````
