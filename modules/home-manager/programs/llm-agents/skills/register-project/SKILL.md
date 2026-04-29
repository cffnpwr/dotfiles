---
name: register-project
description: Register a new repository as a Project field option in the solo-sprint GitHub Project, so it can be selected when creating backlog items. Use when (1) the user wants to start tracking a new repository in solo-sprint, (2) the user says "register a project", "プロジェクトを登録", "<owner>/<repo>を追加", (3) create-backlog-item reports that a repository is not yet registered.
compatibility: |
  Required: gh CLI (authenticated, scopes project + repo), jq.
  Requires solo-sprint to be bootstrapped (config.toml exists).
---

# Register Project

Adds a `<owner>/<repo>` value as a new Single select option on the Project field of the solo-sprint Project.

## Workflow

### Step 1: Load config

Read `${XDG_CONFIG_HOME:-$HOME/.config}/solo-sprint/config.toml`. Required keys:

- `github.owner`
- `github.project_number`
- `github.fields.project.id`

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

### Step 4: Check for duplicate registration

```bash
gh project field-list "$PROJECT_NUMBER" --owner "$PROJECT_OWNER" --format json
```

Find the Project field by ID (from config). Inspect its `options` array.

If `<owner>/<repo>` already exists in the options, report and exit:

> `<owner>/<repo>` は既に登録済み。何もしない。

### Step 5: Add the option

GitHub's GraphQL API for Single select fields requires sending the **full options list** including existing options when updating. Read the existing option list, append the new entry, and send the union.

Use:

```bash
gh api graphql -f query='
  mutation($fieldId: ID!, $options: [ProjectV2SingleSelectFieldOptionInput!]!) {
    updateProjectV2SingleSelectField(input: {
      fieldId: $fieldId,
      options: $options
    }) {
      projectV2SingleSelectField { id }
    }
  }
' -f fieldId="$FIELD_ID" -f options="$OPTIONS_JSON"
```

Where `OPTIONS_JSON` is a JSON array of `{ name, color, description }` objects. Reuse existing colors/descriptions; for the new entry, use `color: GRAY` and `description: ""` unless the user specifies otherwise.

If the schema variant in use does not accept this mutation (older versions), inspect the schema:

```bash
gh api graphql -f query='{__type(name:"updateProjectV2SingleSelectField"){...}}'
```

Adjust accordingly. Report any failure with the raw error.

### Step 6: Verify

Re-run `field-list` to confirm the option was added. Report:

```
Registered: <owner>/<repo>
Field: Project
```

If the new option does not appear, abort and report the failure.

### Step 7: Optional placeholder cleanup

If the Project field still contains the placeholder option `__placeholder__` (created during bootstrap when initial options were required), and at least one real option now exists, ask the user:

> `__placeholder__` オプションを削除してよいか？

If yes, send the same mutation with the placeholder excluded.

### Step 8: Ensure type labels exist on the repository

Solo-sprint uses GitHub Issue Labels to classify items by category. Ensure the four canonical labels exist on `<owner>/<repo>`:

| Label | Color (hex) | Description |
|---|---|---|
| `type:bug` | `d73a4a` | Bug report or fix |
| `type:feature` | `0e8a16` | New functionality |
| `type:improvement` | `a2eeef` | Enhancement to existing functionality |
| `type:task` | `c5def5` | Internal work (refactor, deps, docs, chore) |

For each label, check existence and create if missing:

```bash
gh label list --repo "$OWNER/$REPO" --json name --jq '.[].name'
```

If a label is missing:

```bash
gh label create "type:bug" \
  --repo "$OWNER/$REPO" \
  --color "d73a4a" \
  --description "Bug report or fix"
```

If a label already exists with a different color/description, do NOT overwrite — leave the existing one alone (the user may have customized it). Report the discrepancy as informational.

If the repository has its own label conventions (e.g., `bug` without prefix), the user can set up alias labels manually; solo-sprint always sets the `type:` prefix variants.

### Step 9: Report

```
Registered: <owner>/<repo>
- Project field option: added
- Repository labels: <created/exists> (type:bug, type:feature, type:improvement, type:task)
```

## Anti-patterns

- ❌ Add an option without verifying the repository exists
- ❌ Use a duplicate name (case-sensitive comparison)
- ❌ Drop existing options when calling the mutation (must include the full list)
- ❌ Skip the post-mutation verification
- ❌ Auto-delete placeholders without user consent
- ❌ Overwrite existing labels with different colors/descriptions
- ❌ Skip the label creation step (templates rely on these labels existing)
