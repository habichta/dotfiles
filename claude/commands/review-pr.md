---
description: Review the PR for the current branch (or a given PR number)
argument-hint: "[<pr-number>] [extra context…]"
allowed-tools: Bash(gh pr view:*), Bash(gh pr diff:*), Bash(gh api:*), Bash(git fetch:*), Bash(git diff:*), Bash(git log:*), Bash(git show:*), Bash(make:*), Read, Grep, Glob, Write, Edit
---

## Context

Arguments: `$ARGUMENTS`

A leading bare number is the PR number; with no leading number the PR is the one
for the current branch. Anything else is extra reviewer instructions to fold
into the review.

## Task

Review this pull request.

1. Resolve the PR. Run `gh pr view <number> --json
   number,title,url,state,isDraft,baseRefName,headRefName,additions,deletions,changedFiles,body`,
   omitting `<number>` entirely if none was given. If that fails, stop and
   report the error — do not review anything else.

2. Make sure the base ref is current, then list what changed. With `<base>` from
   `baseRefName`:

   ```
   git fetch --quiet origin <base>
   git diff --stat "origin/<base>...HEAD"
   ```

   If the current branch is not the `headRefName` from the metadata, work from
   `gh pr diff <number>` instead and say that you did.

3. Get the diff, excluding noise:

   ```
   git diff "origin/<base>...HEAD" -- \
     ':(exclude)uv.lock' ':(exclude)package-lock.json' ':(exclude)yarn.lock' \
     ':(exclude)pnpm-lock.yaml' ':(exclude)Cargo.lock' ':(exclude)go.sum' \
     ':(exclude)*.log' ':(exclude)*.pyc' ':(exclude)*.snap'
   ```

   For a large diff, pull it per-file rather than all at once.

4. **Read the surrounding code, don't review the diff blind.** For every
   non-trivial hunk, open the file and read the function/class it lives in.
   Grep for callers of changed signatures, for other call sites of a changed
   helper, and for existing tests covering the touched code. Most real review
   findings live in the code the diff does *not* show.

5. Report findings. Judge each one against the code you actually read, not
   against a general sense that something looks risky.

6. Save the review to `pr-<number>-review.md`, merging into it if it already
   exists. See *Saving the review* below. Do this every time, without being
   asked.

## Sedimentum repos

Sedimentum repos carry a `makefile` — usually a one-line `include` of a shared
snippet in `deps/SedimentumUtils/common/makefile/` — that defines the standard
operations. Check it with `make -qp` or read the included file rather than
assuming; the targets are shared, but not every repo has all of them.

The ones that matter for a review:

| Target | Does |
|---|---|
| `make test` | Runs the test suite |
| `make lint` | Lints (and fails on stray `print(` calls) |
| `make mypy` | Type-checks |

Use them to **verify a suspicion, not as a routine step.** They run through
`docker compose`, so they are slow and need Docker up. Run one when it settles
a specific question — does this actually break type-checking, does the new test
pass — and skip them otherwise.

Never assert that something fails a check unless you ran that check and saw it
fail. "This will not type-check" without having run `make mypy` is a guess;
report it as uncertain or run the command.

**Do not run `make format` or `make all`.** `format` rewrites files with black
and isort, and `all` includes it. A review must not modify the branch it is
reviewing — the one exception is the review file itself (see *Saving the
review*). The same goes for any `build`, `release`, `rc`, or `uv-*` target —
none of them belong in a review.

## Output

### Severity

Every finding gets exactly one severity, shown by its marker:

| Marker | Severity | Means |
|---|---|---|
| 🔴 | Critical | A bug. It will misbehave, crash, corrupt, or leak. Must fix before merge. |
| 🟡 | Important | Correctness risk, missing test on a critical path, or a real design problem. Should fix. |
| 🔵 | Minor | Improvement, clarity, or style. Take it or leave it. |

IDs are `F1`, `F2`, `F3`… assigned in the order the findings are printed —
that is, **strictly most severe first**, 🔴 before 🟡 before 🔵. Severity, not
category, drives the order.

### Structure

**1.** `## Summary` — what the change does and why, in 2–4 lines. Then the
consequences of it going wrong, briefly.

**2.** `## Findings` — an overview table, most severe first:

```
| ID | Severity | Finding | Location |
|----|----------|---------|----------|
| F1 | 🔴 Critical | Beacon timeout never resets after a failed scan | `beacon_tracker.py:88` |
| F2 | 🟡 Important | No test for the fallback path | `test_ibeacon_button_fallback.py` |
| F3 | 🔵 Minor | Duplicated constant | `constants.py:15` |
```

If there are no findings, say so in one line and skip to the verdict.

**3.** `## Details` — then each finding in full, in the same order, separated by
a horizontal rule. Use exactly this shape:

```
---

### 🔴 F1 — Beacon timeout never resets after a failed scan

**`sedi_agent/bluetooth/beacon_tracker.py:88`** · Bug

Why it is wrong, and what happens concretely when it goes wrong. Be brief, but
include enough context to understand the problem without opening the file.

**Fix:** what to change.
```

The `·` field after the location is the category — one of `Bug`,
`Correctness risk`, `Improvement`, `Missing test`.

**4.** `## Verdict` — 2–4 lines. Is this safe to merge, and what must be fixed
first. Reference the blockers by ID.

## Saving the review

Always write the review to a file, in addition to printing it in the chat. Do
this on every run — it is not something to ask permission for.

**Path:** `pr-<number>-review.md` in the repo root, e.g. `pr-153-review.md`.
One file per PR, no date in the name. Tell the user the path when you are done,
and mention it is untracked so it will show up in `git status`.

**Header.** Start the file with a title and a metadata block, then the normal
`## Summary` / `## Findings` / `## Details` / `## Verdict` sections:

```
# PR #153 — Ibeacon button fallback

**Repo:** `Sedimentum/sedi-agent` · **Branch:** `ibeacon-button-fallback` → `master`
**PR:** https://github.com/Sedimentum/sedi-agent/pull/153
**Diff:** 13 files, +381 / −24 · **Head:** `b379cf5` · **Reviewed:** 2026-08-01
**Checks:** `make test` → 144 passed
```

Refresh this block on every pass. `Head` and `Reviewed` are what let a later
pass tell whether the branch moved.

### Merging into an existing file

If `pr-<number>-review.md` already exists, **read it first** and merge — never
overwrite it and never restate what is already there.

- **Do not repeat existing findings.** If you rediscover something already in
  the file, say nothing about it. It is already written down.
- **Keep IDs stable.** Never renumber an existing finding. New findings continue
  from the highest ID in the file, so `F1`–`F4` plus two new ones become `F5`
  and `F6` — even though that breaks the severity ordering of the ID sequence.
  Order the *table rows* by severity as usual; the IDs just stop being
  sequential down the table.
- **Mark new findings** with `*(new)*` after the heading summary, and in the
  Finding column of the table, so the user can see at a glance what this pass
  added.
- **Amend, don't duplicate.** If new evidence changes an existing finding —
  you ran a check that confirms it, or the severity should move — edit that
  finding in place and add a `**Update (<date>):**` line to it. Do not write a
  second finding for the same defect.
- **Mark fixed findings resolved.** If the branch has moved and a previously
  reported finding is gone from the current diff, do not delete it. Change its
  marker to ✅ in both the table and the detail heading, and add
  `**Resolved (<date>):** fixed in <sha>.` Keeping the history is the point of
  the file.
- **Rewrite the `## Summary` and `## Verdict`** to reflect the merged whole,
  not just this pass. The verdict must account for every unresolved finding in
  the file, including ones from earlier passes.
- **End with `## Revision history`** — one line per pass:

  ```
  ## Revision history

  - **2026-08-01** — initial review at `b379cf5`. F1–F4.
  - **2026-08-04** — re-review at `a91c2e0`. F1 resolved; added F5, F6.
  ```

  If a pass turns up nothing new, still refresh the header and add a line
  saying so (`no new findings`).

**Appendix.** If the user asks a follow-up during the session that is worth
keeping — how a mechanism is wired, why a finding is not what it looks like —
append it as `## Appendix — <topic>` after the verdict. Keep appendices from
earlier passes.

### Rules

- Always cite `file:line`. Never report a finding without one.
- The `---` rule and the `### <marker> <ID> — <summary>` heading are required on
  every finding. That is what makes them scannable.
- Colour comes from the 🔴/🟡/🔵 markers only. Do not emit ANSI escape codes —
  they are rendered as literal text, not colour.
- Repeat the marker in both the table and the detail heading, so severity is
  visible wherever you land.
- Be concise. No restating what the diff does — the author wrote it.
- Explicitly call out missing tests for critical paths, but only where the repo
  already has tests to extend.
- When a finding is backed by a check you ran, say so and quote the failing
  line — e.g. "confirmed: `make mypy` reports …". That is the difference
  between a 🔴 and a 🟡.
- If you are unsure whether something is a bug, say so and say what you would
  need to check. Do not present a guess as a defect. Uncertain findings are 🟡
  at most — never 🔴.
- Do not pad. Three real findings beat ten with filler.
