# gh-review-mistral

Review a pull request with Mistral Vibe.

```
gh review-mistral [-p|--print] [-m|--manual] [<num>] [<extra context…>]
```

- No argument → the PR for the current branch.
- A number → that PR in the current repo.
- Anything after the number is passed to the review as extra instructions.
- `-p` / `--print` → non-interactive; prints the review and exits.
- `-m` / `--manual` → prompt for tool approval as usual.

```bash
gh review-mistral
gh review-mistral 42
gh review-mistral 42 "focus on the retry logic, ignore the vendored files"
gh review-mistral -p 42 > review.md
```

This is the Vibe counterpart of `gh review-claude`. Same arguments, same
flags, same output format — so the two are directly comparable on the same PR.

## Tool approval

A review only reads, so by default the extension restricts Vibe to
`bash read_file grep` and auto-approves those calls, letting the review run
start to finish unattended. This matters most with `-p`, where there is nobody
to answer a prompt.

`--manual` restores normal prompting and lifts the tool restriction.
`VIBE_REVIEW_TOOLS` overrides the tool set:

```bash
VIBE_REVIEW_TOOLS="bash read_file grep web_search" gh review-mistral 42
```

Note that `--enabled-tools` disables everything not listed, so the list must be
complete. `write_file` and `edit` are deliberately absent — a review must not
modify the branch it is reviewing.

With `-p`, the extension also passes `--trust`, since programmatic mode has no
TTY to answer the working-directory trust prompt.

Run it inside the repo's checkout — the review reads the working tree for
context, not just the diff. For a PR in another repo, run `gh review-prepare`
first to land in the right checkout on the right branch.

## How it works

It resolves and validates the PR, then hands off to `vibe` with the
`/review-pr` skill. All the review logic — what to exclude, what to read, how
to format findings — lives in that skill, at
`~/.vibe/skills/review-pr/SKILL.md`, so it can be edited without touching this
script and is equally usable from inside an existing Vibe session.

Set `VIBE_HOME` if your Vibe home is not at `~/.vibe`.

## Install

```bash
cd ~/.dotfiles/git/gh/extensions/gh-review-mistral && gh extension install .
```

(`gh` only accepts `.` for local extensions, so the `cd` is required.)

Requires the `/review-pr` skill. Vibe discovers skills as
`<skills-dir>/<name>/SKILL.md`, and `~/.vibe/skills/` already holds other
skills, so symlink the single skill rather than the whole directory:

```bash
ln -s ~/.dotfiles/vibe/skills/review-pr ~/.vibe/skills/review-pr
```
