# Risk & Rollback

What this could break, and how to undo it.

Two questions, answered in a few bullets:

- **Blast radius** -- what breaks if the fix is wrong. Which pages, flows, or consumers are exposed, and whether the failure would be loud or silent.
- **Rollback** -- how to back it out. A plain revert is the usual answer and is worth stating; anything else (a flag to flip, a cache to purge, an order the revert has to follow) has to be spelled out, because the person reaching for it will be in a hurry.

Include this section when the change ships under time pressure or touches something user-facing enough that being wrong is expensive. A routine fix with a contained failure mode doesn't need it.

Silent failure is what makes this section worth writing. A fix that breaks loudly gets caught; one that quietly serves the wrong content does not, and a reviewer who knows which they are looking at reviews differently.
