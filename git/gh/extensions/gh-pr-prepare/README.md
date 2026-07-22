# gh-pr-prepare

Prepare a local checkout of one of **your own** open PRs. Same behaviour as
`gh review-prepare`, but over PRs you authored.

```
gh pr-prepare [--accepted] [<num> | <owner/repo>#<num>]
```

Selecting the PR (numbers are only unique per-repo, so this disambiguates):

- **no argument** → pick from your open PRs via fzf.
- **`<num>`** → that PR; if the number matches several repos, pick via fzf.
- **`<owner/repo>#<num>`** → that exact PR (unambiguous; skips fzf).
- **`--accepted`** → only consider PRs approved by at least one review (as of now).

Then it:

1. Resolves the repo from your `--author=@me` open PRs.
2. `cd`s into `~/repos/helpany/<RepoName>` (override root with `GH_PR_PREPARE_ROOT`).
3. `git fetch --all --prune` so every branch is available.
4. Checks out the PR's head branch.
5. Runs `git update-all`.

## Install

```bash
gh extension install ~/.dotfiles/git/gh/extensions/gh-pr-prepare
```

## Landing your shell in the repo

A gh extension runs in a subprocess, so its `cd` can't move your interactive
shell. The extension prints the repo path as its final stdout line. Add this
shell function to also `cd` there:

```bash
pr-prepare() {
  local dir
  dir="$(gh pr-prepare "$@")" || return
  cd "$dir"
}
```

Then `pr-prepare`, `pr-prepare 5`, or `pr-prepare --accepted` prepare the
checkout **and** drop you in the repo.
