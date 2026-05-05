---
name: create-backlog-item
description: Create a new backlog item (SBI or PBI) in the solo-sprint GitHub Project. Files an Issue in the chosen repository using the appropriate template, adds it to the Project, and sets all required fields. Promotes a PBI when effort exceeds 4h or the work decomposes naturally. Use when (1) the user wants to add a backlog item, (2) the user says "add a backlog item", "バックログに追加", "Issueを作って積んでおいて", (3) the user describes new work to track in solo-sprint.
compatibility: |
  Required: gh CLI (authenticated, scopes project + repo), jq.
  Requires solo-sprint bootstrap.
---

# Create Backlog Item

Creates an Issue and registers it in the solo-sprint Project with all required fields populated.

## Workflow

### Step 1: Load config

Read `${XDG_CONFIG_HOME:-$HOME/.config}/solo-sprint/config.toml`. Required keys:

- `github.owner`, `github.project_number`
- `github.fields.{status,type,estimate,priority,sprint,unplanned}.id`
- All option IDs for status / type / estimate / unplanned

If config is missing, abort and instruct user to run `bootstrap-solo-sprint`.

### Step 1.5: Detect running sprint

Look up the current iteration from the Project's Sprint field. An iteration is "running" if `start_date ≤ today < end_date`. Cache the result.

If multiple match, take the most recent `start_date`. If none match, there is no running sprint and the unplanned flow is skipped.

### Step 2: Gather inputs (single round)

Ask the user, in **one consolidated message**:

> 以下を回答してほしい。
>
> 1. タイトル（72文字以内推奨）
> 2. 分類: bug / feature / improvement / task（迷ったら task）
> 3. 粒度: sbi / pbi（迷ったら sbi。4h超や複数サブタスクに分解できそうなら pbi）
> 4. 対象リポジトリ: `<owner>/<repo>` 形式で指定（過去使用したリポジトリの一覧は後述。`type:*` ラベルが未整備の場合は確認のうえ整備する）
> 5. Priority: 0--100の整数（小さいほど高優先度。デフォルト値は設けない — 必ず帯を判断する。帯の目安は `references/priority-guide.md`）
> 6. Estimate: 0.5h / 1h / 2h / 4h（pbi の場合は不要）
> 7. テンプレートに沿った本文情報（後述、分類により異なる）
> 8. (進行中スプリントがある場合のみ) これは現スプリント `<sprint-id>` への割り込みタスクか？(y/n)
>    - yes: 即スプリントに投入、`Unplanned = yes` をマーク（投入上限チェックは行わない）
>    - no: 通常通り Backlog に積む

For (4), derive the hint list from previously-used repositories by inspecting the Project's existing items:

```bash
gh project item-list "$PROJECT_NUMBER" --owner "$OWNER" --format json --limit 500 \
  | jq -r '.items[].content.repository' \
  | sort -u
```

Display the list (or note that it is empty) so the user can pick one, but accept any `<owner>/<repo>` value as input. The list is purely informational — there is no "registered" gating; any reachable repository may be used.

For (7), the body fields depend on the chosen category. Read the corresponding template (see Step 5) and prompt for each section it defines. Acceptance Criteria is mandatory for all four templates.

### Step 2.5: Ensure type:* labels exist on the chosen repository

Before creating the Issue, verify the four canonical `type:*` labels exist on `<owner>/<repo>`:

```bash
gh label list --repo "$OWNER/$REPO" --json name --jq '[.[].name] | map(select(startswith("type:"))) | sort'
```

If all of `type:bug`, `type:feature`, `type:improvement`, `type:task` are present, continue to Step 3.

Otherwise, do **not** auto-create the labels here. Inform the user and invoke `register-project` inline:

> `<owner>/<repo>` に `type:*` ラベルが揃っていない。`register-project` を実行してラベルを整備する。

Then run `register-project` with `<owner>/<repo>` as its argument. `register-project` itself will display the diff and prompt for explicit approval — do not pre-approve on the user's behalf.

If the user declines `register-project`'s confirmation prompt, abort this skill as well:

> ラベルが整備されていないため、Issue を作成できない。中止した。

If `register-project` succeeds, continue to Step 3. If it errors (repository missing, network error, etc.), surface the error and stop.

### Step 3: Validate inputs

- Title: non-empty, ≤ 200 characters.
- Category: exactly one of `bug`, `feature`, `improvement`, `task`.
- Type (粒度): exactly `sbi` or `pbi`.
- Repository: matches `^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$`. Label provisioning is handled in Step 2.5 (with explicit user confirmation).
- Priority: integer in `0..100`. See `references/priority-guide.md` for band guidance.
- Estimate (sbi only): exactly one of `0.5h`, `1h`, `2h`, `4h`.
- Acceptance Criteria: at least one non-empty line.
- Category-specific mandatory sections (see template files): all required sections must be filled.

If any fails, report which field and stop.

### Step 4: Sub-SBI flow for PBI

For PBIs, ask:

> このPBIに紐づく子SBIを今、追加で作成するか？（PBIだけ作って後で子を追加することも可能）

If yes, after the PBI is created, loop back to Step 2 for each child SBI, automatically setting type=sbi and offering to link via sub-issue.

### Step 5: Read the appropriate template

Read the template corresponding to the chosen category (relative to this skill directory):

| Category | Template |
|---|---|
| `bug` | `templates/bug.md` |
| `feature` | `templates/feature.md` |
| `improvement` | `templates/improvement.md` |
| `task` | `templates/task.md` |

Render the body following the template **exactly**: same headings, same order. Sections marked optional in the template's "Section Rules" may be omitted when empty (do not write "なし" or "N/A"). All other sections must be populated.

Templates are written for both SBI and PBI use. The 粒度 (sbi/pbi) is recorded as a Project custom field, not in the Issue body. Section content depth may differ between SBI and PBI:

- **SBI**: keep each section terse (1〜3行)
- **PBI**: more elaborate, especially Background / Scope / Out of Scope

### Step 6: Confirm draft

Show the draft to the user once:

> 以下の内容で Issue を作成する。問題なければ「OK」と返答してほしい。修正があれば指摘してほしい。
>
> - リポジトリ: <owner>/<repo>
> - 分類: <category> (label: type:<category>)
> - 粒度: <sbi|pbi>
> - Priority: <N>
> - Estimate: <value or "(none)">
> - タイトル: <title>
>
> ---
> <full body>

After explicit approval, proceed without further confirmations.

### Step 7: Create Issue

Write body to a temp file:

```bash
BODY_FILE=$(mktemp -t solo-sprint-body.XXXXXX.md)
# write body to "$BODY_FILE"
```

Create the Issue with the appropriate `type:<category>` label:

```bash
gh issue create \
  --repo "$OWNER/$REPO" \
  --title "$TITLE" \
  --body-file "$BODY_FILE" \
  --label "type:$CATEGORY"
```

If the label creation fails because the label does not exist (this should not happen — Step 2.5 should have caught it — but could occur if the label was deleted between Step 2.5 and now), invoke `register-project` inline for `<owner>/<repo>` and retry. Do NOT inline the label creation here directly (label provisioning is `register-project`'s contract).

Capture the Issue URL from stdout.

Get the Issue's GraphQL node ID for sub-issue linkage if needed:

```bash
ISSUE_NODE_ID=$(gh issue view "$ISSUE_NUMBER" --repo "$OWNER/$REPO" --json id --jq .id)
```

Clean up the temp file.

### Step 8: Add to Project and set fields

```bash
ITEM_ID=$(gh project item-add "$PROJECT_NUMBER" --owner "$OWNER" --url "$ISSUE_URL" --format json | jq -r .id)
```

The built-in `Repository` field is populated automatically by `gh project item-add`; it requires no explicit set step.

Set the custom fields (run in this order — Type before Estimate, since Estimate may be skipped for PBI):

1. Status → `Backlog` if not unplanned; `Sprint` if unplanned
2. Type → `sbi` or `pbi`
3. Priority → number
4. Estimate → option (SBI only)
5. Unplanned → `yes` if injecting into running sprint, otherwise `no`
6. Sprint → current iteration ID (only when unplanned = yes)

Use `gh project item-edit` for each. See `solo-sprint-spec/references/gh-commands.md` for exact command form.

If any field set fails, report which one and continue with the rest. The Issue exists regardless; field misalignment can be repaired manually.

### Step 9: Sub-issue linkage (when applicable)

If the new SBI was created as a child of a previously-created PBI in this same session, link it:

```bash
gh api graphql -f query='
  mutation($parentId: ID!, $childId: ID!) {
    addSubIssue(input: { issueId: $parentId, subIssueId: $childId }) {
      issue { number }
    }
  }
' -f parentId="$PARENT_NODE_ID" -f childId="$CHILD_NODE_ID"
```

If `addSubIssue` is unavailable, fall back: append `Parent: #<parent-number>` to the SBI body via `gh issue edit`. Detect availability by introspection on first use, cache result for the session.

### Step 10: Report

```
Created: <type> #<number> "<title>"
Repo: <owner>/<repo>
Label: type:<category>
URL: <issue-url>
Project item: configured (Status=Backlog, Type=<type>, Priority=<N>, Estimate=<value or "(n/a)">)
[Sub-issue linked under #<parent-number>]
```

## Anti-patterns

- ❌ Skip Acceptance Criteria entry or accept empty AC
- ❌ Pre-approve `register-project`'s confirmation prompt on the user's behalf (Step 2.5 must let the user see and approve the diff)
- ❌ Auto-create `type:*` labels inline (delegated to `register-project`)
- ❌ Set Estimate on a PBI
- ❌ Set Actual at creation time (Actual is collected by review-sprint at Done transition)
- ❌ Apply the investment ceiling check to unplanned items (interrupts are intentional overflow)
- ❌ Mark `Unplanned = yes` when no sprint is running (the flag is only meaningful inside a running sprint)
- ❌ Inject into a sprint without setting both `Sprint` and `Status=Sprint` (or both must be cleared)
- ❌ Render the Issue body without reading the template file
- ❌ Add or remove sections that the template defines (except optional sections that are empty)
- ❌ Create 1-to-1 PBI/SBI structures (a PBI must have ≥ 2 children, or be planned to)
- ❌ Pause for additional confirmations after the user approves the draft
- ❌ Skip the `type:<category>` label on the Issue (categorization is the contract)
- ❌ Use a category not in {bug, feature, improvement, task}
