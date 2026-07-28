# gh-repo-sync

Give an existing local git repo a GitHub remote, in one command. Private by
default.

```
gh repo-sync [<name>|<owner>/<name>] [--public] [--remote <name>] [--no-push]
```

- no argument → repo named after the local repo's directory
- `<owner>/<name>` → create it under an org
- `--public` / `--internal` → visibility other than private
- `--remote <name>` → remote to add (default: `origin`)
- `--no-push` → create and wire up the remote, but don't push

Wraps `gh repo create --source=<repo root> --private --remote=origin --push`.
Extra flags are passed through, e.g. `gh repo-sync -d "some description"`.

Refuses to run outside a git repo, if the remote name is already taken, or if
there are no commits yet (unless `--no-push`).

Not to be confused with the built-in `gh repo sync`, which syncs a fork with
its upstream.

## Install

```bash
gh extension install ~/.dotfiles/git/gh/extensions/gh-repo-sync
```
