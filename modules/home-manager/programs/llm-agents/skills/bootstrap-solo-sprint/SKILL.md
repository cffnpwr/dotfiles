---
name: bootstrap-solo-sprint
description: Initialize the solo-sprint workflow. Creates (or registers an existing) GitHub user-level Project (v2), defines the required custom fields (Status / Type / Estimate / Priority / Project / Sprint), configures the storage backend (local filesystem or git repository, optionally with PR-based push), and writes the configuration file. Use when (1) the user wants to set up solo-sprint for the first time, (2) the user wants to reset or reconfigure the existing solo-sprint setup, (3) the user says "bootstrap solo-sprint", "solo-sprintを初期化", "solo-sprintをセットアップ".
compatibility: |
  Required: gh CLI (authenticated with scopes: project, repo, read:user), jq.
  No language runtime required.
---

# Bootstrap Solo Sprint

Initial setup for the solo-sprint family of skills. Run once per environment, or whenever the user wants to reconfigure.

## Prerequisites

Before running, verify:

```bash
gh auth status --hostname github.com
```

Ensure scopes include `project`, `repo`, `read:user`. If missing, instruct the user:

> 必要なスコープが不足している。以下を実行してから再度起動してほしい。
>
> ```
> gh auth refresh -s project,repo,read:user
> ```

Required tools: `gh`, `jq`. If absent, instruct user to install via Nix.

## Workflow

### Step 1: Check existing config

Check whether `${XDG_CONFIG_HOME:-$HOME/.config}/solo-sprint/config.toml` exists.

- **Exists**: Show current values and ask: "既存の設定がある。上書きしてよいか？"
  - If no, exit without changes.
  - If yes, proceed and overwrite at the end.
- **Does not exist**: Proceed to fresh setup.

### Step 2: Gather GitHub Project inputs (single round)

Ask the user, in **one consolidated message**:

> 以下を回答してほしい。デフォルト値はない、すべて指定が必要。
>
> 1. GitHub の owner（user名 or organization名）
> 2. Project: 既存の Project を使う / 新規作成
>    - 既存の場合: Project number
>    - 新規の場合: Project の名前
> 3. スプリントの目標時間（時間単位の数値、例: 40）
> 4. 1日あたり標準作業時間（例: 4）
> 5. キャパシティバッファ係数（0 < x ≤ 1.0、例: 0.9）

Wait for all answers. Validate:

- `target_hours` / `daily_standard`: positive numbers.
- `capacity_buffer`: number in `(0, 1.0]`.

### Step 3: Gather storage configuration (single round)

Ask the user:

> 以下を回答してほしい。velocity.md と retro ファイルの保管先を決める。
>
> A. backend: `local` または `git` のどちらか
>
> B. local の場合:
>    - 保管ディレクトリの絶対パス（例: `/Users/foo/Documents/solo-sprint`）
>
> C. git の場合:
>    - リポジトリ（`<owner>/<repo>` 形式）
>    - base_branch（例: `main`）
>    - push_mode: `direct` / `pr`
>    - push_mode = pr の場合: branch_template（例: `solo-sprint/{sprint_id}`）
>
> D. すべての backend 共通:
>    - velocity のパステンプレート（例: `velocity.md`）
>    - retros のパステンプレート（必ず `{sprint_id}` を含む。例: `retros/{sprint_id}.md`）

For path templates, the syntax is documented in `solo-sprint-spec/references/path-templates.md`. Read that file to ensure validation matches the spec.

### Step 4: Validate storage inputs

Apply the rules from `solo-sprint-spec/references/path-templates.md`:

- `storage.paths.retros` MUST contain `{sprint_id}`.
- `storage.paths.velocity` MAY contain templates. If it contains `{date:...}`, surface a warning and re-confirm before saving.
- `storage.branch_template` (when push_mode = "pr") MUST contain at least one of `{sprint_id}` or `{date:...}`.
- All templates: unknown variables (e.g., `{type}`) → reject with the offending token.
- All templates: unbalanced `{` or `}` → reject.

For backend = "local":

- `storage.path` MUST be absolute. Expand `~` and environment variables.
- The directory MUST exist OR be creatable. If missing, ask "<path> が存在しない。作成してよいか？".

For backend = "git":

- Verify the repository exists and the user has push permission:
  ```bash
  gh api repos/"$OWNER"/"$REPO" --jq '.permissions.push'
  ```
  Must return `true`. Otherwise abort.
- Verify `base_branch` exists:
  ```bash
  gh api repos/"$OWNER"/"$REPO"/git/refs/heads/"$BASE_BRANCH" >/dev/null
  ```

If any value fails, report which field is invalid and stop. Do not proceed with partial valid values.

### Step 5: Project setup

#### Option A: Use existing project

```bash
gh project view "$NUMBER" --owner "$OWNER" --format json
```

Capture: `id` (PVT_...), `number`, `title`.

If the project does not exist or the user lacks access, abort with the error.

#### Option B: Create new project

```bash
gh project create --owner "$OWNER" --title "$TITLE" --format json
```

Capture: `id`, `number`, `url`. Report the URL to the user.

### Step 6: Define fields

For each required field, check whether it already exists (via `gh project field-list ... --format json`). If present with the expected type, skip. If present with a wrong type, abort and ask the user to delete it manually.

Required fields:

| Name | Type | Options |
|---|---|---|
| Status | SINGLE_SELECT | Backlog, Sprint, Doing, Done, Dropped |
| Type | SINGLE_SELECT | sbi, pbi |
| Estimate | SINGLE_SELECT | 0.5h, 1h, 2h, 4h |
| Actual | NUMBER | (none) |
| Carry Count | NUMBER | (none) |
| Unplanned | SINGLE_SELECT | yes, no |
| Priority | NUMBER | (none) |
| Project | SINGLE_SELECT | (no initial options — added by `register-project`) |
| Sprint | ITERATION | (managed by `plan-sprint`) |

Create with `gh project field-create`:

```bash
gh project field-create "$NUMBER" \
  --owner "$OWNER" \
  --name "$NAME" \
  --data-type "$TYPE" \
  [--single-select-options "$OPT1,$OPT2,..."]
```

For SINGLE_SELECT fields with no initial options (Project), `gh project field-create` may require at least one option. If it does, create with a placeholder like `__placeholder__` and instruct the user that `register-project` will add real options.

For ITERATION fields, fall back to GraphQL `createProjectV2Field` mutation if `gh` does not support creation. See `solo-sprint-spec/references/gh-commands.md`.

After creation, capture each field's `id` and (for SINGLE_SELECT) the option IDs by re-running `field-list`.

### Step 7: Write config.toml

Compose the TOML content using the gathered field IDs, option IDs, and storage settings. Use the schema in `solo-sprint-spec/references/data-model.md`.

Create directory if missing:

```bash
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/solo-sprint"
```

Write the file. Use 0600 permissions:

```bash
chmod 600 "${XDG_CONFIG_HOME:-$HOME/.config}/solo-sprint/config.toml"
```

### Step 8: Initialize storage

#### Backend = local

- Ensure `storage.path` exists (create if approved in Step 4).
- Do NOT create `velocity.md` or `retros/` directories upfront. They are created by `review-sprint` and `retrospect-sprint` on first use.

#### Backend = git

- Do NOT create files upfront. The first `review-sprint` / `retrospect-sprint` invocation will:
  - For `direct` mode: write to `base_branch` directly.
  - For `pr` mode: create the feature branch from `base_branch` (or reuse if it exists).
- Bootstrap simply confirms the repository is reachable and writable.

### Step 9: Report

```
Solo Sprint setup complete.
- Project: <owner>/<project-number> (<url>)
- Config: ${XDG_CONFIG_HOME:-$HOME/.config}/solo-sprint/config.toml
- Fields registered: Status, Type, Estimate, Priority, Project, Sprint
- Storage: <backend>
  [local]  Path: <storage.path>
  [git]    Repo: <storage.repo>, base: <base_branch>, mode: <push_mode>
           Branch template: <branch_template>   (only if pr)
  Velocity: <storage.paths.velocity>
  Retros:   <storage.paths.retros>

Next steps:
- Run `register-project` to add a repository to the Project field.
- Run `create-backlog-item` to add your first backlog item.
```

Do not proceed to those next steps automatically.

## Anti-patterns

- ❌ Use defaults for any user input
- ❌ Continue when authentication scopes are insufficient
- ❌ Silently overwrite an existing config without asking
- ❌ Accept a `storage.paths.retros` that does not contain `{sprint_id}`
- ❌ Accept a `storage.branch_template` (pr mode) that contains neither `{sprint_id}` nor `{date:...}`
- ❌ Proceed to write `config.toml` when storage validation failed
- ❌ Create files in the storage location preemptively (let downstream skills do it on first use)
