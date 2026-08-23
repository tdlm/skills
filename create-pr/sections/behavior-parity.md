# Behavior Parity

The claim that nothing observable changed, plus the evidence for it.

A restructure asks a reviewer to accept that a large diff does exactly what the old code did. This section is where that claim gets made explicitly and backed up, so state both:

- **What is unchanged** — the public surface, rendered output, or behavior that consumers depend on.
- **What proves it** — existing tests that still pass untouched, a Chromatic diff with no visual changes, or a manual comparison that was run.

Tests that had to change are the interesting part. If a test needed editing to keep passing, the behavior it asserted moved, and that is worth a sentence — either the assertion was testing a mechanism rather than an outcome, or parity is narrower than claimed. Reviewers find this out anyway by reading the diff; finding it stated is much better than finding it hidden.

When the change is deliberately not parity-preserving, name the difference and why it is acceptable. Silent behavior changes inside a restructure are the failure mode this section prevents.

**For a performance change, parity is half the claim.** The other half is the measurement: what was measured, before and after, and under what conditions. A speedup with no number is an assertion.
