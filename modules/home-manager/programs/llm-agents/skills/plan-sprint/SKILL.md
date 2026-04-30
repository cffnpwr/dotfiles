---
name: plan-sprint
description: Plan and start a new solo-sprint sprint. Generates a per-day calendar template for the user to edit, parses available hours, creates a variable-length Iteration in the GitHub Project, and pulls backlog items by priority within the investment ceiling. Use when (1) the user wants to start a new sprint, (2) the user says "plan a sprint", "新しいスプリントを始める", "sprint planning", (3) the previous sprint has been reviewed and a new one is due.
compatibility: |
  Required: gh CLI, jq, mktemp.
  Requires solo-sprint bootstrap, registered projects, and a backlog with items.
---

# Plan Sprint

Starts a new sprint via a calendar-driven planning flow.

## Workflow

### Step 1: Load config

Read `${XDG_CONFIG_HOME:-$HOME/.config}/solo-sprint/config.toml`. Required:

- `github.owner`, `github.project_number`
- `github.fields.{status,sprint,priority,estimate,type}.id` and option IDs
- `sprint.target_hours`, `sprint.daily_standard`, `sprint.capacity_buffer`

Abort with bootstrap instruction if missing.

### Step 2: Verify no active sprint

Check if there is an open sprint (an Iteration with start_date ≤ today < end_date and items in Status=Sprint or Doing).

If found, ask:

> 進行中のスプリント `<sprint-id>` がある。先に `review-sprint` で締めるべきだが、新規スプリントを並行して開始するか？（通常は no）

Default: no.

### Step 3: Determine sprint ID and start date

Sprint ID format: `YYYY-SN` where:

- `YYYY` = calendar year of the start date
- `N` = sequential sprint number within that calendar year, **not zero-padded** (`S1`, `S2`, ..., `S10`, `S11`, ...). The counter resets at each calendar-year boundary.

Ask the user:

> スプリント開始日を `YYYY-MM-DD` で指定してほしい。デフォルトは今日（<today>）。

If no input, use today.

Compute sprint ID:

1. Determine the year `YYYY` from the start date.
2. Find the highest existing sprint number for `YYYY` by checking, in order:
   - The Project's Sprint iteration field (both active and completed iterations) for titles matching `^YYYY-S(\d+)$`.
   - `velocity.md` (per `storage.paths.velocity`) for rows whose first column matches `^YYYY-S(\d+)$`.
3. Use the next integer (`max + 1`, or `1` if none found).

If a sprint with the same computed ID somehow already exists, append a suffix (`-2`, `-3`) to disambiguate.

### Step 4: Generate calendar file

Path:

```
${XDG_CACHE_HOME:-$HOME/.cache}/solo-sprint/sprint-plan-<sprint-id>.md
```

Generate by reading `templates/calendar.md` (relative to this skill directory) for format rules. Generate exactly **21 days** of rows starting from the start date, all initialized to `daily_standard`.

Create the directory if missing. Write the file.

### Step 5: Prompt the user to edit

Tell the user:

> カレンダーを生成した: `<path>`
>
> このファイルをエディタで編集してほしい。
> - 作業不可の日は `hours` を `0` に
> - 半日の日は `2` などに
> - その他、必要な調整を行ってから保存
>
> 編集が終わったら「done」または「edited」と返答してほしい。

Wait for the user's confirmation. Do not poll the file — wait for the message.

### Step 6: Parse calendar

After confirmation, Read the file. Apply parsing rules from `templates/calendar.md` (relative to this skill directory):

- Skip `#` comments and blank lines.
- Read `start`, `target_hours`, `daily_standard` from settings (re-validate against config; use file values if user changed them, but warn if they differ).
- Walk calendar rows, accumulating hours. Stop at the row where cumulative ≥ `target_hours`.
- The stopping row's date = sprint end date.
- Capacity = cumulative hours.
- Investment ceiling = `capacity × capacity_buffer` (rounded down to nearest 0.5h).

If target is not reached within 21 days, abort:

> 21日以内にtargetに到達しない。カレンダーを延長するか、targetを下げる必要がある。

If a non-numeric or negative `hours` is found, abort with the line number.

### Step 7: Create Iteration in Project

Iteration duration in days = `(end_date - start_date) + 1` (inclusive day count).

Use GraphQL `updateProjectV2IterationField` mutation. See `solo-sprint-spec/references/gh-commands.md`.

Note: the mutation requires the full iteration list. Read the existing iterations first, append the new one with `{ startDate, duration, title: "<sprint-id>" }`, and submit. If `title` is not supported in your schema, fall back to startDate-based identification.

Capture the new iteration's ID. Save under sprint metadata.

### Step 8: Pull items into the sprint

Fetch all backlog items (Status = Backlog) sorted by Priority ascending (smaller is higher priority):

```bash
gh project item-list "$NUMBER" --owner "$OWNER" --format json --limit 500 \
  | jq '[.items[] | select(.status == "Backlog")] | sort_by(.priority)'
```

Walk in priority order. For each item:

- If item is a PBI: skip (PBIs are not pulled directly; only their child SBIs are).
- If item is an SBI: add its estimate to a running total. If `total + estimate > investment_ceiling`, stop.
- Add the SBI to the candidate list.

Display the candidate list to the user with: title, repo, priority, estimate, project distribution percentages.

> 以下を引き込む候補。確定でよいか？修正があれば指摘してほしい。
>
> | # | Title | Repo | Priority | Estimate |
> ...
>
> 累積見積もり: <X>h / 投入上限 <Y>h
> プロジェクト配分: <repo>: <Z%> / ...

The user may:

- Approve as-is
- Remove specific items
- Add specific items by Issue number (overriding priority order)

Iterate until the user approves.

### Step 9: Apply Sprint and Status updates

For each approved item:

1. Set Sprint field to the new iteration ID (`gh project item-edit ... --iteration-id`).
2. Set Status to `Sprint`.

Run sequentially. If any update fails, report the failed item and continue with the rest.

#### Adjusting the lineup after Step 9

To change the sprint lineup after Step 9 (add an item that was missed, remove one pulled in by mistake, swap one item for another), do not re-run `plan-sprint` — that creates a new iteration. Instead, run these commands directly:

- **Remove from sprint**: clear the Sprint field on the item.

  ```bash
  gh project item-edit \
    --id "$ITEM_ID" \
    --project-id "$PROJECT_ID" \
    --field-id "$SPRINT_FIELD_ID" \
    --clear
  gh project item-edit \
    --id "$ITEM_ID" \
    --project-id "$PROJECT_ID" \
    --field-id "$STATUS_FIELD_ID" \
    --single-select-option-id "$BACKLOG_OPTION_ID"
  ```

- **Add to sprint**: set the Sprint field to the active iteration ID and Status to `Sprint`.

The user can also drive this through the GitHub Projects UI; both paths converge on the same Project Item state. Update is idempotent — running these commands twice does no harm.

### Step 10: Sprint Goal

Ask the user:

> このスプリントのゴールを1〜2行で言語化してほしい（任意）。

If provided, save it to a sprint metadata file alongside the calendar:

```
${XDG_CACHE_HOME:-$HOME/.cache}/solo-sprint/sprint-<sprint-id>.toml
```

```toml
sprint_id = "..."
start = "..."
end = "..."
capacity = ...
ceiling = ...
goal = "..."
iteration_id = "..."
```

This file is referenced by `review-sprint` and `retrospect-sprint`.

### Step 11: Report

```
Sprint <sprint-id> started.
Period: <start> 〜 <end> (<N> days)
Capacity: <X>h / Ceiling: <Y>h
Items pulled: <count>
Goal: <goal or "(none)">

Calendar: <calendar-path>
Metadata: <sprint-toml-path>
```

## Anti-patterns

- ❌ Pull a PBI directly into the sprint (only SBIs are pulled)
- ❌ Skip the calendar editing step and use defaults silently
- ❌ Exceed the investment ceiling
- ❌ Set Status without setting Sprint (or vice versa)
- ❌ Continue when the previous sprint is still open
- ❌ Auto-poll the calendar file instead of waiting for user confirmation
