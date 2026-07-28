# gh-profile

Open a GitHub profile page in the browser — yours by default.

```
gh profile [<user>] [--no-browser]
```

- no argument → your own profile (`gh api user --jq .html_url`)
- `<user>` → that user's profile, e.g. `gh profile cli` (a leading `@` is stripped)
- `--no-browser` / `-n` → print the URL instead of opening it

Tries `$BROWSER`, then `wslview`, `xdg-open`, `open`, `explorer.exe`, so it
works under WSL without a Linux browser installed.

## Install

```bash
gh extension install ~/.dotfiles/git/gh/extensions/gh-profile
```
