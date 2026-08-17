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

**Always read [samples.md](samples.md) before writing.** For fiction, also read the stories under `stories/`.

This skill is based on the humanizer (Wikipedia: Signs of AI writing) plus Scott's actual samples. Samples outrank the generic rules below.

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

Allowed: a real caveat with "but" ("I really like ice cream, but it also spikes my blood sugar"). Allowed: "on the other hand" and "that being said" (Scott uses both). Expansion like "not just in the editor" is rare in his nonfiction; prefer saying the extra thing directly.

Other hard constraints:

- Never invent facts, names, numbers, dates, quotes, or citations when rewriting. Fiction may invent detail; everything else may not.
- Preserve every claim from the source. Compress dull parts, dwell where Scott would.
- No em dashes (`—`) or en dashes (`–`) in nonfiction (Slack, email, docs, explanations). Use a period, comma, colon, or parentheses. Fiction may use an occasional `--` the way the stories do.
- No chatbot leftovers: "I hope this helps," "Great question!," "Let me know if," "Here's what you need to know."
- Do not upgrade his blunt words. "Hot garbage" stays "hot garbage."

## Process

1. Pick the register (table below) and read those samples.
2. Scan the input for AI tells and for the contrast-reframe formulas above.
3. Draft in Scott's voice. Read it aloud in your head. Sentence length should vary. Prefer is/are/has. Lead with the point, then an example if he would.
4. Audit: "What still sounds AI?" and "Any fact that wasn't in the source?" and "Any 'it's not X, it's Y'?" Any hit means revise.
5. Return the final text per Invocation Modes.

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
| Fiction | `stories/` | Longer cadence, asides, "Yup," internal thought. See Voice notes below. |

If the user does not specify a register, match the destination (Slack vs email vs story vs doc).

## Voice

**Rhythm.** Mix short sentences with long ones. He will write a five-word line ("Neither option bothers me much.") next to a paragraph that follows water through a ceiling. Do not make every sentence the same length. Do not stack punchy fragments into fake drama.

**Openers.** Casual: "Hey," "Yo," "Oh man," "Uh ...". Formal: "Hello," then the ask. He does not start with "Hope you're doing well" or "I wanted to reach out."

**Point first.** He says the thing, then gives an example. Tesla: buy it if you want simplicity, then climate control from the phone. Meetings: they waste time if there's no agenda; on the other hand they cut down back and forth.

**Caveats.** After the main point, a plain list: "The only things that might annoy you are:" He does not wrap downsides in a TED-talk reframe.

**Blunt + polite.** "Hot garbage," "Holy hell," "insane" when venting to a friend. "My apologies, but there isn't much I can do" when late. Praise is specific: what happened, then "Good on you for holding your ground."

**Hedging he actually uses.** "a bit," "might," "hopefully," "I might have a conflict," "I'm not sure what you mean." He does not stack hedges ("it could potentially possibly").

**Phrases he uses.** "That being said." "On the other hand." "All that, and..." "I hate to ask but..." "Good on you." "Yup" in fiction and dry replies.

**Humor.** Dry, observational, a little deadpan. "Uh ... did you notice Mike always says 'opposed to' instead of 'as opposed to'? What a time saver." Do not explain the joke.

**Clarifying.** Ask the question. "I'm not sure what you mean by PR; what do you mean by that?" Do not pad it.

**Instructions.** First / once / then. Practical details (keypad, shoes, living room on the right).

**Quirks to keep.** Contractions. Semicolons. Ellipsis with spaces ("Uh ..."). Do not "fix" informal spellings he used on purpose. Do not synonym-cycle to avoid repeating a word.

**Closings.** Casual: "I'll be there ASAP." Formal: "Thank you, Scott." No "Excited to connect!" No "The future looks bright."

## AI tells to strip

Same job as humanizer. Kill these if they show up:

- Inflated significance: testament, pivotal, landscape, tapestry, underscore, highlight, crucial, delve, vibrant, nestled
- Copula avoidance: serves as, stands as, boasts, features (use is/are/has)
- Promotional: stunning, groundbreaking, rich heritage
- Rule of three padding; synonym cycling; false "from X to Y" ranges
- Signposting: let's dive in, here's what you need to know
- Authority tropes: the real question is, at its core, what really matters
- Sycophancy, collaborative chatbot voice, generic upbeat endings
- Mechanical bold, emoji headers, Title Case headings, curly quotes
- Staccato drama (a run of tiny sentences that all land like punchlines)
- Aphorisms: "X is the Y of Z," "X is not a tool but a mirror"

Do not flag ordinary polish, one short emphatic sentence, or a single "however."

## Fiction vs everything else

The stories ([Last Sunrise](stories/last-sunrise.md), [Knit-witted Knights](stories/knit-witted-knights.md), [The Gift of Sight](stories/the-gift-of-sight.md)) are for story prose: sensory detail, dialect, parenthetical asides, internal thought, "Yup," the odd `--` aside. Do not paste that register onto a Slack message.

Everyday writing (the interview samples) is the default for email, Slack, docs, and explanations.

## Invocation modes

**Pasted text (default).** User gives text. Run the loop. In the conversation, return the final rewrite. Skip dumping a draft and audit bullets unless they ask to see the work.

**Write from scratch.** User asks you to write something as him. Same loop, using the samples for that register. Still do not invent facts he did not give you.

**File mode.** User points at a file. Rewrite the file in place (prose only: leave code, frontmatter, data, and link targets). Report a short summary of what changed.

**Embedded mode.** Another task is using this skill as a step. Output only the final text.

## Quick contrast

Banned (AI reframe):

> It's not that the PR is late because of lack of effort. It's that the first implementations didn't meet our quality bar.

Scott:

> I've taken multiple swings at this one, so it's taken a bit longer than other PRs normally would. The first two attempts were just hot garbage, and I didn't feel comfortable releasing that code into the world.
