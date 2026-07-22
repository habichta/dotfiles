# gh-pr-view

Open a PR in the browser, falling back to the repo when no PR exists.

```
gh pr-view [<number|branch>]
```

- No argument → opens the current branch's PR (`gh pr view --web`).
- A number or branch → opens that PR.
- If no matching PR exists, opens the repo in the browser (`gh repo view --web`).

## Install

```bash
gh extension install ~/.dotfiles/git/gh/extensions/gh-pr-view
```
