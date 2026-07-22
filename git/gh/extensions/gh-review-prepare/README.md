# gh-review-prepare

Prepare a local checkout for reviewing an open PR by its ID.

```
gh review-prepare [<num> | <owner/repo>#<num>]
```

Selecting the PR (numbers are only unique per-repo, so this disambiguates):

- **no argument** → pick from your review-requested PRs via fzf.
- **`<num>`** → that PR; if the number matches several repos, pick via fzf.
- **`<owner/repo>#<num>`** → that exact PR (unambiguous; skips fzf).

Then it:

1. Resolves the repo from your `--review-requested=@me` open PRs.
2. `cd`s into `~/repos/helpany/<RepoName>` (override root with `GH_REVIEW_PREPARE_ROOT`).
3. `git fetch --all --prune` so every branch is available.
4. Checks out the PR's head branch.
5. Runs `git update-all`.

## Install

```bash
gh extension install ~/.dotfiles/git/gh/extensions/gh-review-prepare
```

(`gh extension install <dir>` symlinks a local directory for development.)

## Landing your shell in the repo

A gh extension runs in a subprocess, so its `cd` can't move your interactive
shell. The extension does all the git work in the right repo and prints the
repo path as its final stdout line. To also `cd` there, add this shell function
to your `.zshrc` / `.bashrc`:

```bash
review-prepare() {
  local dir
  dir="$(gh review-prepare "$1")" || return
  cd "$dir"
}
```

Then `review-prepare 29` prepares the checkout **and** drops you in the repo.
