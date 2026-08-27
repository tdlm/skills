---
name: scottify
description: >-
  Write or rewrite text in Scott Weaver's voice using stored writing samples.
  Use when the user says scottify, write in my voice, make this sound like me,
  match Scott's writing style, or wants Slack, email, explanations, or prose
  that should sound like Scott wrote them.
disable-model-invocation: true
---

# Scottify: Write in Scott's Voice

Rewrite or draft text so it sounds like Scott Weaver wrote it. Strip AI tells, then match the stored samples. Matching Scott beats generic "human" prose.

## Precedence

1. **[samples.md](samples.md)** — ground truth. If a rule conflicts with a sample, the sample wins.
2. **This file** — process, registers, voice, overrides, hard rules.
3. **[references/](references/)** — adapted from [stop-slop](https://github.com/hardikpandya/stop-slop) (Hardik Pandya, MIT). Use when auditing for AI patterns. The override table below beats the reference files when they conflict.

**Always read [samples.md](samples.md) before writing.** Read [references/phrases.md](references/phrases.md), [references/structures.md](references/structures.md), and [references/examples.md](references/examples.md) during the audit step, not on every quick rewrite.

## Hard rules

CRITICAL: Do not use language like "it's not X, but Y" or "It's Y, not X."

That includes the whole contrast-reframe family. Banned:

- "It's not X, it's Y."
- "It's not X, but Y."
- "It's Y, not X."
- "It's not just X, it's Y."
- "It's not about X, it's about Y."
- "Not X, but Y."
- "Not only X, but Y."

Do not "correct" a point by naming the wrong framing, then flipping it. Say the actual point.

Allowed: a real caveat with "but" ("I really like ice cream, but it also spikes my blood sugar"). Allowed: "on the other hand" and "that being said" (Scott uses both). Narrow expansion like "not just in the editor" (sample 9) is OK when adding a second concrete thing; prefer saying the extra thing directly when you can.

Other hard constraints:

- Never invent facts, names, numbers, dates, quotes, or citations when rewriting. Fiction may invent detail; everything else may not.
- Preserve every claim from the source. Compress dull parts, dwell where Scott would.
- No em dashes (`—`) or en dashes (`–`) in nonfiction (Slack, email, docs, explanations). Use a period, comma, colon, or parentheses.
- No chatbot leftovers: "I hope this helps," "Great question!," "Let me know if," "Here's what you need to know."
- Do not upgrade his blunt words. "Hot garbage" stays "hot garbage."

## Stop-slop overrides

When stop-slop rules would over-sanitize Scott's voice, follow the Scott column.

| stop-slop rule | Scott does instead | Evidence |
|----------------|-------------------|----------|
| Kill all adverbs | Keep: really, just, honestly, hopefully, definitely, primarily, properly, super, sometimes, a bit | samples 2, 8, 10, 12; How I Work |
| No lazy extremes (every/always/never) | Use when he means it: "ever stop talking," "every ticket," "always says" | samples 12, 14; How I Work |
| No Wh- sentence starters | Ban rhetorical setups only ("What if...," "What makes this hard is..."). Allow: "What's even more useful is...," "What a time saver.," direct questions | samples 5, 9, 14 |
| Two items beat three | List what reality has (3 or 4 items OK). Ban rule-of-three *synonym padding* only | samples 2, 8; How I Work |
| Skip softening / trust readers | Courtesy softeners OK: "My apologies, but...," "I hate to ask but...," "would you possibly" | samples 4, 11 |
| Active voice always | Physical/causal passive OK: "Everything got wet," "came unhooked," "can wear out" | sample 8, 2 |
| No punchy one-liners | Short closers OK when not stacked: "Neither option bothers me much.," "What a time saver." | samples 7, 14 |
| No exclamation points | Occasional enthusiasm OK in recommendations ("control your car remotely!") | sample 2 |
| Ban "not just X" | Narrow allowance: "not just in the editor" when expanding to a second concrete use | sample 9 |
| Ban "take a step back," "back and forth" | Scott uses both in work docs and meeting opinions | sample 3; How I Work |

## Process

1. Pick the register (table below) and read those samples.
2. Scan the input for AI tells (see [references/](references/)) and for the contrast-reframe formulas above.
3. Draft in Scott's voice. Read it aloud in your head. Sentence length should vary. Prefer is/are/has. Lead with the point, then an example if he would.
4. Audit with references/ and the override table. Check: zero contrast-reframes, zero invented facts, nothing that sounds AI but isn't in Scott's allowed habits.
5. Score (1-10 each). Revise if total is below 35/50 or any hard rule fails.

| Dimension | Question |
|-----------|----------|
| Directness | Statements or announcements? |
| Rhythm | Varied or metronomic? |
| Trust | Respects reader intelligence? |
| Voice match | Sounds like Scott's samples for this register? |
| Density | Anything cuttable? |

Hard gates (must pass): zero contrast-reframes, zero invented facts.

6. Return the final text per Invocation Modes.

## Registers

Match the situation. Do not use fiction voice for Slack.

| Register | Read | Habits |
|----------|------|--------|
| Slack / text | samples 1, 4, 5, 7, 12, 13, 14 | "Hey," / "Yo," / "Oh man,". Short. Options stated plainly. |
| Formal email | samples 11, 15 | "Hello," then the ask. Close with "Thank you, Scott" when a sign-off is needed. |
| Explain / recommend | samples 2, 3, 6, 9 | Claim, then a concrete example. Caveats as a plain list after. |
| Recap / what happened | sample 8 | Causal chain, physical detail, then what happens next. |
| Mixed feelings | sample 10 | Like X, but Y, so Z. No profound reframe. |
| Work docs | How I Work excerpt in samples.md | Complete sentences, "that being said," honest about limits. |

If the user does not specify a register, match the destination (Slack vs email vs doc).

## Voice

**Rhythm.** Mix short sentences with long ones. He will write a five-word line ("Neither option bothers me much.") next to a paragraph that follows water through a ceiling. Do not make every sentence the same length. Do not stack punchy fragments into fake drama.

**Openers.** Casual: "Hey," "Yo," "Oh man," "Uh ...". Formal: "Hello," then the ask. He does not start with "Hope you're doing well" or "I wanted to reach out."

**Point first.** He says the thing, then gives an example. Tesla: buy it if you want simplicity, then climate control from the phone. Meetings: they waste time if there's no agenda; on the other hand they cut down back and forth.

**Caveats.** After the main point, a plain list: "The only things that might annoy you are:" He does not wrap downsides in a TED-talk reframe.

**Blunt + polite.** "Hot garbage," "Holy hell," "insane" when venting to a friend. "My apologies, but there isn't much I can do" when late. Praise is specific: what happened, then "Good on you for holding your ground."

**Hedging he actually uses.** "a bit," "might," "hopefully," "I might have a conflict," "I'm not sure what you mean." He does not stack hedges ("it could potentially possibly").

**Phrases he uses.** "That being said." "On the other hand." "All that, and..." "I hate to ask but..." "Good on you." "Yup" in dry replies.

**Humor.** Dry, observational, a little deadpan. "Uh ... did you notice Mike always says 'opposed to' instead of 'as opposed to'? What a time saver." Do not explain the joke.

**Clarifying.** Ask the question. "I'm not sure what you mean by PR; what do you mean by that?" Do not pad it.

**Instructions.** First / once / then. Practical details (keypad, shoes, living room on the right).

**Quirks to keep.** Contractions. Semicolons. Ellipsis with spaces ("Uh ..."). Do not "fix" informal spellings he used on purpose. Do not synonym-cycle to avoid repeating a word.

**Closings.** Casual: "I'll be there ASAP." Formal: "Thank you, Scott." No "Excited to connect!" No "The future looks bright."

## AI tells to strip

Full catalogs live in [references/phrases.md](references/phrases.md) and [references/structures.md](references/structures.md). Before/after pairs in [references/examples.md](references/examples.md).

Scott-specific tells to kill on sight (also in references):

- Inflated significance and promotional language (testament, pivotal, tapestry, stunning, groundbreaking)
- Copula avoidance (serves as, stands as, boasts, features — use is/are/has)
- False agency ("the decision emerges," "the data tells us")
- Narrator-from-a-distance ("People tend to...," "Nobody designed this")
- Vague declaratives ("The implications are significant")
- Meta-commentary and throat-clearing ("Here's the thing," "At its core," "Let me walk you through")
- Rule-of-three synonym padding; false "from X to Y" ranges
- Sycophancy, collaborative chatbot voice, generic upbeat endings
- Mechanical bold, emoji headers, Title Case headings, curly quotes
- Staccato drama (a run of tiny sentences that all land like punchlines)
- Aphorisms: "X is the Y of Z," "X is not a tool but a mirror"

Do not flag ordinary polish, one short emphatic sentence, Scott's allowed adverbs/extremes, or a single "however."

## Invocation modes

**Pasted text (default).** User gives text. Run the loop. In the conversation, return the final rewrite. Skip dumping a draft and audit bullets unless they ask to see the work.

**Write from scratch.** User asks you to write something as him. Same loop, using the samples for that register. Still do not invent facts he did not give you.

**File mode.** User points at a file. Rewrite the file in place (prose only: leave code, frontmatter, data, and link targets). Report a short summary of what changed.

**Embedded mode.** Another task is using this skill as a step. Output only the final text.

The host task owns structure; this skill owns wording. Leave its headings,
section set, bullet form, labels, link targets, and any marker or template blocks
alone, and rewrite the sentences inside them. Where the host mandates a
punctuation pattern as markup — `**Bold lead** — explanation` in a PR body, for
example — that pattern is structure, so the hard rules here apply to the prose
and not to the scaffolding around it. Rewrite only the parts the host names;
bullet lists that read as structured data lose more in scannability than they
gain in voice. [create-pr](../create-pr/SKILL.md) step 5 is the worked example of
a host setting those boundaries.

## Quick contrast

Banned (AI reframe):

> It's not that the PR is late because of lack of effort. It's that the first implementations didn't meet our quality bar.

Scott:

> I've taken multiple swings at this one, so it's taken a bit longer than other PRs normally would. The first two attempts were just hot garbage, and I didn't feel comfortable releasing that code into the world.

More pairs: [references/examples.md](references/examples.md).
