# gh-prs-open

List all open (not-yet-merged) PRs you have authored, across repos.

```
gh prs-open [--accepted]
```

- `--accepted` → only PRs approved by at least one review (`--review=approved`).

Wraps `gh search prs --author=@me --state=open`. Extra arguments are passed
through, e.g. `gh prs-open --json number,title,url`.

## Install

```bash
gh extension install ~/.dotfiles/git/gh/extensions/gh-prs-open
```
