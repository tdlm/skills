# Root Cause

What broke, why it broke, and why this fix addresses the cause rather than the symptom.

Three things a reviewer needs, in order:

- **The observable failure** -- what users or consumers actually hit, stated concretely enough to recognize.
- **The mechanism** -- the reason the code behaved that way. Not the line number; the misplaced assumption, missing guard, or wrong ordering that made the failure possible.
- **Why this fix is the right layer** -- what makes this the cause and not a symptom further downstream.

That third point is what the section exists for. A reviewer's main question on a fix is whether it patches the visible failure or removes the condition that produced it, and only the author can answer that. When the honest answer is that the fix *is* a stopgap, say so and say what the real fix would require -- a known, stated stopgap is reviewable, a disguised one is not.
