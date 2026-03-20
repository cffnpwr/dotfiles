---
name: jj-reference
description: Jujutsu (jj) VCS command reference for Git users. Use when performing any version control operation such as committing, pushing, branching, rebasing, viewing history, or resolving conflicts. Provides git-to-jj command translation and jj-idiomatic workflows.
---

# Jujutsu (jj) Command Reference

Use `jj` for all VCS operations. Fall back to `git` only when jj has no equivalent.

## Key Concepts

- **Working copy is a commit** (`@`) — no staging area, no `git add`
- **Change ID** — stable identifier, survives amends (e.g., `wuloypwt`)
- **Commit ID** — content hash, changes on any modification (e.g., `182d3ce4`)
- **Bookmarks** — jj's equivalent of git branches
- **`jj undo`** — reverses last operation safely

## Git-to-jj Command Table

| Use case | git | jj |
|---|---|---|
| Init repo | `git init` | `jj git init --colocate` |
| Clone | `git clone URL` | `jj git clone URL` |
| Status | `git status` | `jj st` |
| Diff (working copy) | `git diff HEAD` | `jj diff` |
| Diff (specific change) | `git diff A^ A` | `jj diff -r A` |
| Log | `git log --oneline --graph` | `jj log` |
| Add files | `git add .` | (not needed) |
| Commit | `git commit -a -m "msg"` | `jj describe -m "msg"` |
| Commit and start new | `git commit -a -m "msg"` | `jj commit -m "msg"` (= describe + new) |
| Start new work | `git checkout -b feat` | `jj new -m "feat"` |
| Start from main | `git checkout -b feat main` | `jj new main -m "feat"` |
| Amend message | `git commit --amend` | `jj describe -m "new msg"` |
| Amend files | `git add .; git commit --amend` | (just edit files — `@` auto-updates) |
| Stash | `git stash` | `jj new @-` (old change stays as sibling) |
| Switch to change | `git checkout X` | `jj edit X` |
| Create bookmark | `git branch X` | `jj bookmark create X` |
| Move bookmark | `git branch -f X` | `jj bookmark move X --to REV` |
| List bookmarks | `git branch` | `jj bookmark list` |
| Delete bookmark | `git branch -d X` | `jj bookmark delete X` |
| Fetch | `git fetch` | `jj git fetch` |
| Push | `git push` | `jj git push` |
| Push new bookmark | `git push -u origin X` | `jj git push --bookmark X --allow-new` |
| Rebase onto dest | `git rebase dest` | `jj rebase -d dest` |
| Rebase branch onto main | `git rebase main` | `jj rebase -b @ -d main` |
| Squash into parent | `git reset --soft HEAD~; git commit` | `jj squash` |
| Squash specific files | N/A | `jj squash path/to/file` |
| Interactive split | `git add -p; git commit` | `jj split` |
| Merge | `git merge A` | `jj new @ A` |
| Cherry-pick | `git cherry-pick X` | `jj duplicate X -d @` |
| Revert a change | `git revert X` | `jj backout -r X` |
| Discard working changes | `git checkout -- .` | `jj restore` |
| Restore specific file | `git checkout -- FILE` | `jj restore FILE` |
| Abandon change | `git reset --hard` | `jj abandon` |
| Undo last operation | (no equivalent) | `jj undo` |
| Operation log | (no equivalent) | `jj op log` |
| Edit past change | `git rebase -i` | `jj edit CHANGE_ID` |
| Show file at rev | `git show REV:FILE` | `jj file show FILE -r REV` |
| List tracked files | `git ls-files` | `jj file list` |
| Add remote | `git remote add NAME URL` | `jj git remote add NAME URL` |

## Common Workflows

### Start new work from main
```bash
jj git fetch
jj new main@origin -m "description of work"
```

### Push a new feature
```bash
jj bookmark create my-feature -r @
jj git push --bookmark my-feature --allow-new
```

### Update existing bookmark after changes
```bash
jj bookmark set my-feature -r @
jj git push
```

### Rebase current stack onto latest main
```bash
jj git fetch
jj rebase -b @ -d main@origin
```

### Fix an earlier change
```bash
jj edit CHANGE_ID    # switch to that change
# make edits...
jj new               # return to tip to continue working
```

### Squash a chain into one change
```bash
jj squash --from FIRST::@- --into @
```

## Revsets (Common Patterns)

| Revset | Meaning |
|---|---|
| `@` | Current working copy |
| `@-` | Parent of working copy |
| `main` | Bookmark named "main" |
| `main@origin` | Remote bookmark |
| `trunk()` | Main branch trunk |
| `bookmarks()` | All local bookmarks |
| `mine()` | Changes authored by you |
| `A::B` | A through B (inclusive) |
| `A..B` | Between A and B (exclusive of A) |
| `all()` | All reachable changes |

## When to Fall Back to git

Use `git` directly only for operations jj does not support:
- `git config` for git-specific config (though prefer `jj config`)
- `git submodule` commands
- `git lfs` commands
- Reading raw git objects when jj tools are insufficient
- Third-party git hooks or integrations that require git CLI

For everything else, use `jj`.
