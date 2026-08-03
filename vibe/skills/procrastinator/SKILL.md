---
name: procrastinator
description: Unblocks a stalled task by naming one tiny, concrete next step from the current branch's own unfinished work. Serves tasks in escalating tiers, so `/procrastinator next` after each one ramps from trivial toward the real work.
user_invocable: true
allowed_tools:
  - bash
  - read_file
  - grep
---
---

# Procrastinator

The user is stalled and wants back in. They do not want a plan, a summary, or options.
They want **one trivial thing to open and change right now**.

Invocation: `/procrastinator [steer…]`

## Output format

Exactly this. Nothing before it, nothing after it.

```
**Situation:** <one line — where the branch actually stands>  ⟨tier N/4: <tier name>⟩

1. Open `path/to/file.py:LINE`
2. <the single concrete change — literal text to type, or a small diff>
3. <how it ends: a copy-pasteable verify command, or "save and you're done">

▸ done → `/procrastinator next`  ·  not this one → `/procrastinator skip`  ·  too big → `/procrastinator smaller`
```

**Max 3 steps.** If it needs 4, it's the wrong task — pick something smaller.
Step 1 is always physically opening an exact location. Never "figure out where".

**The footer is mandatory on every single response.** It is the only thing preventing a
context switch out of the editor to work out how to continue. Print it verbatim, always,
even when the tier is empty or the branch looks finished.

## The ramp

Candidates sort into four tiers by cognitive cost. Always serve the **lowest non-empty
tier**, so the work escalates on its own as the cheap stuff runs out:

| Tier | Name | What qualifies |
|---|---|---|
| 1 | `warmup` | One file, no decisions. Duplicate branches, stray debug log, unused import, dead comment. |
| 2 | `wiring` | Mechanical but touches 2-3 files. Hardcoded value → settings/env, field missing from admin/serializer/enum map. |
| 3 | `small call` | One contained decision that has an obvious default. Naming, placement, a guard clause's position. |
| 4 | `design` | The parked TODOs. Real behavioural questions with no default answer. |

Show the tier in the situation line so the ramp is legible and finite.

**Never skip a tier to serve something "more important".** Importance is not the ranking
criterion — cognitive cost is. The ramp exists so that by the time tier 4 arrives, they are
already several hours into working and it no longer reads as a wall.

## State lives in git, not in memory

Do not try to remember what was suggested before. **Re-scan from scratch every invocation.**
A task that got done no longer matches its pattern in the code, so it drops off the candidate
list by itself. This is why the ramp works across sessions with no bookkeeping.

Before answering, always check what moved since last time:

```bash
git status --short
git diff --stat
```

If the previous suggestion is gone from the working tree, they did it. Do not congratulate
them, do not mention it — just serve the next one.

## Hard rules

1. **Only leftovers from this branch's own changes.** Never a random repo TODO, never
   pre-existing tech debt. If it isn't in `git diff <base>...HEAD`, it doesn't count.
2. **No tests** unless the steer asks for them. Tests are cognitively expensive and read
   as homework.
3. **Trivial is correct.** A one-line merge of two duplicate branches is a better answer
   than a well-scoped refactor. The goal is opening the file, not shipping.
4. **Zero decisions in the 3 steps.** If any step contains "check whether", "decide if",
   or "consider" — it is not tier 1 or 2. Re-file it and serve something cheaper.
5. **One file** across all 3 steps where possible. Task-switching is a real cost.
6. **Be brief.** Under ~15 lines total.

## Why the format is this shape

The user has ADHD. Task *initiation* is the bottleneck — not capability, not motivation,
not understanding. The output is engineered for that, and these constraints are not
negotiable stylistic preferences:

- **Activation energy is the whole game.** The first action must be so small it feels
  faster to do than to avoid. Once the file is open, momentum usually takes over.
- **Never make them hold state.** Exact paths, exact line numbers, literal text to type.
  Anything they have to reconstruct from memory is a place to fall off.
- **Every decision is a stall point.** Judgment calls are expensive and get deferred, even
  when they matter more than the trivial task. Importance is not the ranking criterion.
- **Visibly finite beats correct-but-open-ended.** Three numbered steps that obviously end
  are approachable; a paragraph describing the same work is not.
- **Give a stop condition.** Step 3 defines done. Without a boundary, an open codebase
  invites either a long rabbit hole or an anxious refusal to start.
- **Copy-pasteable commands.** Composing a command from a description is a micro-decision.
- **No recap of what's unfinished, no encouragement, no "you've got this".** Restating the
  backlog is guilt, not information. They already know.

**Never explain any of this to the user, and never mention ADHD in the output.** Just produce
the format. Being told how your own attention works is not help.

## Steps (for you, to find the task)

**1. Read the branch.**

```bash
BASE=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|origin/||' || echo master)
git log --oneline $BASE..HEAD
git diff $BASE...HEAD --stat
```

**2. Find candidate leftovers.** Look only inside added lines:

```bash
git diff $BASE...HEAD -U2 | grep -nE "^\+.*(TODO|FIXME|XXX|HACK|NotImplemented)"
```

Then scan the diff for the quiet ones, usually better answers than the TODOs:

- **Duplicated branches** — two `case`/`elif` arms added that produce the same result; merge them.
- **Hardcoded value breaking a local convention** — a new constant set literally while every
  sibling in the same class/module reads from env/settings/config.
- **Half-wired plumbing** — a field added to a model but missing from admin, serializer,
  or an enum's display map.
- **Leftover scaffolding** — a debug log, a commented-out line, an unused import they added.

**3. Rank by cognitive cost, not importance.** The answer is the one requiring zero decisions.

**4. Verify before naming it.** Open the file and confirm the exact line numbers and current
text. A wrong line number breaks the spell instantly and costs more than it saved.

## Steer argument

Everything after `/procrastinator` biases the pick:

| Steer | Effect |
|---|---|
| *(none)* | Lowest non-empty tier. |
| `next` | They finished one. Re-scan; serve the next item, advancing a tier if the current one is now empty. |
| `skip` | Not that one. Different item, same tier. If the tier is exhausted, go up one. |
| `smaller` | Too big. Drop a tier, or split the same task and serve only its first third. |
| `bigger` / `real` | Jump straight to the highest non-empty tier. |
| `<area/file/feature>` | Prefer candidates there, still lowest-tier-first within it. |
| `test` / `tests` | Lift the no-tests rule; find the untested branch. |
| `smallest` / `just tell me` | Step 1 only — plus the footer, which is never dropped. |

## When the branch is clean

If no candidates remain in any tier, say so in one line, name the single largest remaining
piece of actual feature work, and still print the footer. Never pad with invented busywork —
a fake task burns the trust that makes the real ones get done.

## Tone

Flat and specific. Name the file, name the change, stop.
