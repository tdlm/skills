# fix example

A blocked request on a production form. No visual sections at all.

What to notice: **Root Cause does the work Motivation would do on a feature**, and it names why the fix belongs in the allowlist rather than in the directive. **Risk & Rollback is present** because the failure mode is silent -- the include test for that section is expense of being wrong, not size of the diff.

Neither Storybook Preview nor Screenshots appears, because nothing rendered changed. A fix that *did* change appearance would add Screenshots with labeled before and after images.

PR title: `fix(savvy): [ML:WA-110] allow savvy api host in csp connect-src`

```markdown
## Description

The Savvy insurance quote form failed to submit on production.
Requests to the Savvy API were blocked by our Content Security Policy, which allowlisted the widget origin but not the API origin the widget calls on submit.

**Link to Jira ticket**

[WA-110](https://moneylion.atlassian.net/browse/WA-110)

**Development URL**

<!-- DEVELOPMENT_URL:START -->
https://moneylion-next-XXXX.moneylion.dev
<!-- DEVELOPMENT_URL:END -->

### Root Cause

`connect-src` enumerates permitted origins explicitly, and the Savvy integration shipped with only the widget origin listed.
The widget loaded and rendered fine, so the gap stayed invisible until a user submitted, at which point the browser refused the request.

Because the block happened in the browser, nothing reached the API and nothing appeared in its logs — the form surfaced a generic failure with no server-side trace to follow.
Adding the origin to the allowlist fixes the cause. Loosening the directive would have hidden this class of bug instead of fixing it.

### Changes

- **`connect-src` allowlist** — Adds the Savvy API origin alongside the widget origin already present.
- **One source for the host** — The origin comes from the same environment-driven constant the widget is configured with, so the two cannot drift apart again.

### Risk & Rollback

Scope is the CSP response header. A wrong value blocks requests silently rather than breaking the page, so verify in the console rather than by eye. Headers are built per response, so a plain revert takes effect on the next deploy with nothing to purge.

### Testing

A unit test asserts the API origin is present in `connect-src`. It fails against the previous configuration, which is the regression this fix is protecting against.

### Validation

- [ ] Open the Savvy insurance page and submit a quote request
- [ ] Confirm the API call returns 200 in the network tab
- [ ] Confirm the console logs no CSP violation
- [ ] Confirm the response's `content-security-policy` header lists both Savvy origins
```
