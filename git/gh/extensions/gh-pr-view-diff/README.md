# gh-pr-view-diff

Open a PR's diff (Files changed tab) in the browser.

```
gh pr-view-diff [<number|branch>]
```

- No argument → the current branch's PR.
- A number or branch → that PR.
- If no matching PR exists, it fails (no fallback).

## Install

```bash
gh extension install ~/.dotfiles/git/gh/extensions/gh-pr-view-diff
```
