---
name: register-project
description: Provision the canonical `type:*` Issue Labels on a target repository so solo-sprint backlog items can be filed there. Use when (1) the user explicitly asks to register a repository ("register-project", "プロジェクトを登録", "<owner>/<repo>を登録"), (2) `create-backlog-item` invokes this inline because the chosen repository lacks the labels. Always confirms the plan with the user before making any change.
compatibility: |
  Required: gh CLI (authenticated, scopes project + repo), jq.
  Requires solo-sprint to be bootstrapped (config.toml exists).
---

# Register Project

Provisions the four canonical `type:*` Issue Labels on a GitHub repository. Idempotent: only creates labels that are missing.

This skill does **not** maintain any separate registration list. The built-in `Repository` field on Project items is the canonical source of which repositories are in use.

## Conservative behavior

- This skill **always shows the planned changes and asks for explicit approval** before creating anything.
- It does not pass through silently — even when invoked inline from another skill, the user is asked to confirm.
- If there are no changes to make (all labels already exist with matching color/description), it reports that and exits without prompting.

## Workflow

### Step 1: Load config

Read `${XDG_CONFIG_HOME:-$HOME/.config}/solo-sprint/config.toml`. Required keys:

- `github.owner`
- `github.project_number`

If config is missing, abort with:

> solo-sprint がセットアップされていない。先に `bootstrap-solo-sprint` を実行してほしい。

### Step 2: Resolve target repository

If invoked with an argument, parse it as `<owner>/<repo>`. Otherwise, ask the user:

> 登録するリポジトリを `<owner>/<repo>` 形式で指定してほしい。

Validate format: must match `^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$`.

### Step 3: Verify the repository exists

```bash
gh repo view "$OWNER/$REPO" --json nameWithOwner --jq .nameWithOwner
```

If the command fails, abort:

> リポジトリ `<owner>/<repo>` が存在しない、またはアクセス権限がない。指定を見直してほしい。

### Step 4: Diff the label state

List existing labels on the repository:

```bash
gh label list --repo "$OWNER/$REPO" --json name,color,description
```

Compare against the canonical label set:

| Label | Color (hex) | Description |
|---|---|---|
| `type:bug` | `d73a4a` | Bug report or fix |
| `type:feature` | `0e8a16` | New functionality |
| `type:improvement` | `a2eeef` | Enhancement to existing functionality |
| `type:task` | `c5def5` | Internal work (refactor, deps, docs, chore) |

For each canonical label, classify as:

- **missing** — label does not exist; will be created.
- **matches** — label exists with the same color and description; nothing to do.
- **diverges** — label exists with a different color or description; **do not overwrite** (the user may have customized it). Reported informationally only.

If all four labels fall into `matches`, report:

> `<owner>/<repo>` の `type:*` ラベルは既に揃っている。何もしない。

…and exit without prompting.

### Step 5: Confirm the plan

Show the diff and ask for explicit approval:

```
<owner>/<repo> に以下の変更を加える:
  + 作成: <comma-separated missing labels, with color>
  ~ 既存(変更しない): <diverges labels, with note "color/description が canonical と異なる">

実行してよいか？(y/n)
```

Only proceed on explicit `y` / `yes`. Any other answer (including `n`, empty, or unrelated text) aborts:

> 中止した。何も変更していない。

### Step 6: Create missing labels

For each `missing` label:

```bash
gh label create "type:bug" \
  --repo "$OWNER/$REPO" \
  --color "d73a4a" \
  --description "Bug report or fix"
```

If a single creation fails, surface the error, stop the loop, and report which labels were created and which were not.

### Step 7: Report

```
Registered: <owner>/<repo>
- Created: <created labels>
- Existing (matches): <matches labels>
- Existing (diverges, left alone): <diverges labels, with the actual color seen>
```

If no changes were made (all canonical), the report is the early exit in Step 4.

## Anti-patterns

- ❌ Skip the confirmation step in Step 5 — even when invoked inline
- ❌ Overwrite existing labels with different colors/descriptions (treat as `diverges`, leave alone)
- ❌ Maintain a separate "registered repositories" list anywhere (the Project's built-in `Repository` field is canonical)
- ❌ Touch the Project's custom fields in any way (this skill is label-only)
- ❌ Create labels not in the canonical set
