# gh-pr-create

Open a PR for a branch into `master` (or `main` if `master` doesn't exist).

```
gh pr-create [--ready] [--branch <branch>] [--base <base>] [--reviewer <user>]... [--pick-reviewers]
```

- **Draft by default.** Pass `--ready` (alias `--finished`, `-r`) for a non-draft PR.
- **Head branch** defaults to the current branch; override with `--branch`/`-b`.
- **Base** defaults to origin's `master`, falling back to `main`; override with `--base`/`-B`.
- **Reviewers** (`--reviewer`/`-a`, repeatable and/or comma-separated) request review.
  Only users who actually have access are accepted — each name is validated against
  the repo's collaborator list, and an invalid one aborts with the eligible names.
- **`--pick-reviewers`/`-A`** opens an fzf picker over the users with access.
- Title/body are auto-filled from the branch's commits (`gh pr create --fill`).
- The head branch is pushed (`--set-upstream`) before the PR is opened.

## Examples

```bash
gh pr-create                              # draft PR: current branch -> master/main
gh pr-create --ready                      # finished (non-draft) PR
gh pr-create -b feature/foo               # PR for another branch
gh pr-create --ready --base dev           # finished PR into a custom base
gh pr-create --ready -a habichta          # request review from habichta
gh pr-create -a habichta,furgerf          # multiple reviewers
gh pr-create --ready --pick-reviewers     # choose reviewers via fzf
```

## Install

```bash
gh extension install ~/.dotfiles/git/gh/extensions/gh-pr-create
```
