---
name: retrospect-sprint
description: Run a KPT (Keep / Problem / Try) retrospective for a closed solo-sprint. Records the retro to a file in the configured storage backend (local, git direct push, or git PR). Use when (1) the user wants to retrospect on the sprint, (2) the user says "retro", "振り返り", "レトロスペクティブ", "KPT", (3) review-sprint has just been completed.
compatibility: |
  Required: gh CLI (when storage.backend = "git"), jq, filesystem write access (when storage.backend = "local").
  Requires a reviewed sprint with metadata file.
---

# Retrospect Sprint

Captures a KPT retrospective for a closed sprint into a Markdown file. Does NOT promote anything to auto memory or any other store. Activation of learnings is the user's responsibility — typically by adjusting the relevant skill's behavior or creating a new skill, not by relying on a memory layer.

## Workflow

### Step 1: Load config

Read `${XDG_CONFIG_HOME:-$HOME/.config}/solo-sprint/config.toml`. Required:

- `storage.backend` and the corresponding storage settings (see `solo-sprint-spec/references/data-model.md`)
- `storage.paths.retros` (must contain `{sprint_id}`)

Abort if missing.

### Step 2: Identify the sprint

Default: the most recently reviewed sprint (look for `sprint-<id>.toml` files in `${XDG_CACHE_HOME:-$HOME/.cache}/solo-sprint/` containing a `[review]` section, sort by `reviewed_at`).

If the user passes a sprint ID as argument, use it.

If no reviewed sprint is found, look for an **unreviewed** sprint (a `sprint-<id>.toml` without a `[review]` section, or an iteration in the Project that has items in Sprint/Doing/Done):

- **Unreviewed sprint exists**: invoke the `review-sprint` workflow inline for that sprint, then return here and use it as the target. Briefly notify the user (one line, e.g. `スプリント <sprint-id> は未レビューのため review-sprint を先に実行する`). `review-sprint` is interactive (per-item disposition, Actual collection); run it to completion before resuming. If the user aborts review-sprint, stop retrospect-sprint as well.
- **No sprint at all**: abort with `振り返り対象のスプリントもアクティブなスプリントもない。先に plan-sprint でスプリントを開始する必要がある。` (this is genuinely a setup-state issue, not a self-driving handoff).

### Step 3: Resolve the destination

1. Read `storage.paths.retros`.
2. Expand template variables (see `solo-sprint-spec/references/path-templates.md`). Use the sprint metadata for `{sprint_id}` and the current execution date for `{date:...}`.
3. The expanded value is the target path inside the storage backend.

### Step 4: Check for existing retro

Check whether the target file already exists:

- **Backend = local**: stat the resolved absolute path.
- **Backend = git**: GET via Contents API on the relevant branch (base_branch for direct, feature branch for pr — create the feature branch first if it does not exist; see Step 7).

If the file exists, ask:

> このスプリントの振り返りは既に存在する。上書きするか中断するか、どちらがよいか？

Default to abort. Re-running the retro should be a deliberate user choice.

### Step 5: Generate retro body from template

Read `templates/retro.md` (relative to this skill directory). Substitute:

| Placeholder | Source |
|---|---|
| `<sprint-id>` | sprint metadata |
| `<start-date>`, `<end-date>` | sprint metadata |
| `<capacity>` | sprint metadata |
| `<ceiling>` | sprint metadata |
| `<completed>` | sprint metadata `[review]` section |
| `<percentage>` | `<completed>` / `<capacity>` × 100, rounded |
| `<velocity>` | same as `<completed>` for now |

Hold the body in memory; do not write yet.

### Step 6: Walk Keep / Problem / Try

For each section, ask the user in order:

> **Keep**: 今回うまくいったこと、続けたいことを箇条書きで挙げてほしい。最低1項目。

Wait for response. Append answers as `- <item>` lines under the Keep section. Repeat for Problem and Try.

For Try especially, push for specificity:

> Try のうち、抽象的な項目（「気をつける」「頑張る」など）があれば、次スプリントで観測可能な変更に書き直してほしい。

### Step 7: Write the retro

#### Backend = local

```
TARGET="$STORAGE_PATH/$EXPANDED_RELATIVE_PATH"
mkdir -p "$(dirname "$TARGET")"
# atomic write: write to temp in same dir, then rename
```

#### Backend = git, push_mode = "direct"

PUT to `storage.base_branch` via Contents API. Commit message: `chore(retro): record <sprint-id>`.

If overwriting (Step 4 user chose overwrite), include the existing file's `sha`.

#### Backend = git, push_mode = "pr"

1. Expand `storage.branch_template` to determine the feature branch name.
2. If the branch does not exist, create it from `storage.base_branch`'s HEAD.
3. PUT to the feature branch via Contents API.
4. Check for an existing open PR with `head = <feature_branch>` and `base = <base_branch>`:
   - **Exists**: reuse. Do not create another PR.
   - **Does not exist**: create one (likely the same PR `review-sprint` would create — coordinate by branch name).
5. Capture the PR URL.

Coordination with `review-sprint`: when both skills target the same `<sprint-id>` and `branch_template` produces the same branch name, they share a single feature branch and a single PR (review-sprint commits velocity, retrospect-sprint commits retro).

See `solo-sprint-spec/references/gh-commands.md` for command details.

### Step 8: Optional notes

Ask:

> 追加のメモがあれば書いてほしい。なければ skip。

If non-empty, perform a second write with the Notes section appended. If empty, remove the Notes section from the body and skip the additional write.

### Step 9: Report

```
Retro saved.
  <local | git>: <expanded-path>
  [git/pr]  PR: <url>

Sprint <sprint-id> closed.

If any Try item points to a recurring pattern, consider:
  - Adjusting an existing solo-sprint skill's behavior
  - Adding a structural constraint (Project field options, validation in a skill)
  - Creating a new skill that encapsulates the new pattern

These are user actions, not actions this skill performs.
```

## Anti-patterns

- ❌ Allow empty Keep/Problem/Try sections
- ❌ Overwrite an existing retro without explicit user consent
- ❌ Skip the Try specificity check
- ❌ Auto-run plan-sprint after the retro
- ❌ Write retro entries to any store other than the configured destination (no auto memory, no comments on Issues, no log files)
- ❌ For PR mode: create a fresh branch when one already exists for the same sprint (must reuse, sharing with review-sprint)
- ❌ For PR mode: create a duplicate PR when one is already open from the same branch (must reuse)
- ❌ Use `gh repo clone` for git backend (Contents API is the contract)
