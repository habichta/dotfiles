---
name: procrastinator
description: Unblocks a stalled task by naming one tiny, concrete next step from the current branch's own unfinished work. Reads the branch diff, finds the lowest-effort leftover, and answers with a one-line situation plus at most 3 zero-decision steps.
user_invocable: true
allowed_tools:
  - bash
  - read_file
  - grep
---

# Procrastinator

The user is stalled and wants back in. They do not want a plan, a summary, or options.
They want **one trivial thing to open and change right now**.

Invocation: `/procrastinator [steer…]`

## Output format

Exactly this. Nothing before it, nothing after it except the optional deferred line.

```
**Situation:** <one line — where the branch actually stands>

1. Open `path/to/file.py:LINE`
2. <the single concrete change — literal text to type, or a small diff>
3. <how it ends: a copy-pasteable verify command, or "save and you're done">

*Later (not now): <one judgment call left on this branch, with file:line>*
```

**Max 3 steps.** If it needs 4, it's the wrong task — pick something smaller.
Step 1 is always physically opening an exact location. Never "figure out where".
The deferred line is optional; drop it if the steer asked for only the start.

## Hard rules

1. **Only leftovers from this branch's own changes.** Never a random repo TODO, never
   pre-existing tech debt. If it isn't in `git diff <base>...HEAD`, it doesn't count.
2. **No tests** unless the steer asks for them. Tests are cognitively expensive and read
   as homework.
3. **Trivial is correct.** A one-line merge of two duplicate branches is a better answer
   than a well-scoped refactor. The goal is opening the file, not shipping.
4. **Zero decisions in the 3 steps.** If any step contains "check whether", "decide if",
   or "consider" — it belongs in the deferred line instead.
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

- names an area/file/feature → prefer leftovers there
- `test` / `tests` → lift the no-tests rule; find the untested branch
- `bigger` / `real` / `meaty` → promote the deferred judgment call into the 3 steps
- `just tell me` / `smallest` → output step 1 only, drop the rest

## Tone

Flat and specific. Name the file, name the change, stop.
