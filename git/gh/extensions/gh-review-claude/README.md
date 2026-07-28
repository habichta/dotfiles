# gh-review-claude

Review a pull request with Claude Code.

```
gh review-claude [-p|--print] [-m|--manual] [<num>] [<extra context…>]
```

- No argument → the PR for the current branch.
- A number → that PR in the current repo.
- Anything after the number is passed to the review as extra instructions.
- `-p` / `--print` → non-interactive; prints the review and exits.
- `-m` / `--manual` → prompt for permissions as usual.

```bash
gh review-claude
gh review-claude 42
gh review-claude 42 "focus on the retry logic, ignore the vendored files"
gh review-claude -p 42 > review.md
```

## Permission mode

Runs in Claude's `auto` permission mode by default (`--permission-mode auto`).
A review only reads — `gh pr view`, `git diff`, `Read`, `Grep` — and auto mode
clears read-only work without prompting, so the review runs start to finish
unattended. This matters most with `-p`, where there is nobody to answer a
prompt and an unapproved tool call just fails.

`--manual` restores normal prompting. `CLAUDE_REVIEW_PERMISSION_MODE` overrides
the default with any mode `claude --permission-mode` accepts (`acceptEdits`,
`auto`, `bypassPermissions`, `manual`, `dontAsk`, `plan`).

Run it inside the repo's checkout — the review reads the working tree for
context, not just the diff. For a PR in another repo, run `gh review-prepare`
first to land in the right checkout on the right branch, then `gh review-claude`.

## How it works

It resolves and validates the PR, then hands off to `claude` with the
`/review-pr` slash command. All the review logic — what to exclude, what to
read, how to format findings — lives in that command, at
`~/.claude/commands/review-pr.md`, so it can be edited without touching this
script and is equally usable from inside an existing Claude session.

Set `CLAUDE_CONFIG_DIR` if your Claude config is not at `~/.claude`.

## Install

```bash
cd ~/.dotfiles/git/gh/extensions/gh-review-claude && gh extension install .
```

(`gh` only accepts `.` for local extensions, so the `cd` is required.)

Requires the `/review-pr` slash command:

```bash
ln -s ~/.dotfiles/claude/commands ~/.claude/commands
```
