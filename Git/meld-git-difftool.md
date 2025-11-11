# Git diff with Meld (GUI)

Small cheat sheet for using **Meld** as a GUI diff tool with Git.

## Install Meld

Ubuntu / Debian:

```bash
sudo apt update
sudo apt install meld
```

## Configure Git to use Meld

```bash
git config --global diff.tool meld
git config --global difftool.prompt false
```

Now `git difftool` will open Meld by default.

## Compare a file between two branches

```bash
git difftool branch1 branch2 -- path/to/file.go
```

Git will load `path/to/file.go` from `branch1` and `branch2` into Meld.

## Compare a file in current branch vs another branch

```bash
git difftool other-branch -- path/to/file.go
```

This compares:

- left: `path/to/file.go` in `HEAD` (current branch)
- right: `path/to/file.go` in `other-branch`

## Compare working tree vs HEAD (current branch)

```bash
git difftool -- path/to/file.go
```

Shows your local changes in `path/to/file.go` against the last commit.

## Compare entire branches (all differing files)

```bash
git difftool branch1 branch2
```

Git will iterate over all changed files between `branch1` and `branch2` and open each in Meld (one by one).
