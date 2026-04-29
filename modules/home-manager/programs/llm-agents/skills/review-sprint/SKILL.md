---
name: review-sprint
description: Close a solo-sprint sprint. Aggregates Done / unfinished / Dropped counts, updates velocity log, and walks every unfinished item to explicitly carry over or drop. Use when (1) the user wants to close the current sprint, (2) the user says "review the sprint", "スプリントを締める", "スプリントレビュー", (3) the sprint end date has passed.
compatibility: |
  Required: gh CLI, jq.
  Requires solo-sprint bootstrap and an active sprint.
---

# Review Sprint

Closes a sprint with explicit disposition for every unfinished item, and records velocity.

## Workflow

### Step 1: Load config

Read `${XDG_CONFIG_HOME:-$HOME/.config}/solo-sprint/config.toml`. Required:

- `github.owner`, `github.project_number`
- All field IDs (status, sprint, estimate, actual, carry_count, unplanned, type)
- `storage.backend` and the corresponding storage settings (see `solo-sprint-spec/references/data-model.md`)
- `storage.paths.velocity`

Abort if missing.

### Step 2: Identify the sprint to review

Look for the most recent sprint metadata file:

```
${XDG_CACHE_HOME:-$HOME/.cache}/solo-sprint/sprint-<sprint-id>.toml
```

If multiple exist, take the one whose `end` date is closest to today (past or present).

If the user passes an argument (sprint ID), use that instead.

If no metadata file is found, list iterations from the Project and ask the user to pick.

### Step 3: Fetch sprint items

```bash
gh project item-list "$NUMBER" --owner "$OWNER" --format json --limit 500
```

Filter to items whose Sprint field matches the target iteration ID. Group by Status.

### Step 4: Aggregate

Compute:

| Bucket | Count | Sum of Estimates | Sum of Actuals |
|---|---|---|---|
| Done | ... | ... | ... (or `?` if any item lacks Actual) |
| Doing | ... | ... | (n/a) |
| Sprint (untouched) | ... | ... | (n/a) |
| Dropped (during sprint) | ... | ... | (n/a) |

Additionally, compute the **unplanned breakdown** across all sprint items (any Status):

| Origin | Count | Sum of Estimates |
|---|---|---|
| Planned (`Unplanned = no` or empty) | ... | ... |
| Unplanned (`Unplanned = yes`) | ... | ... |

Show both tables to the user. The Actual column for Done is meaningful only after Step 4.5.

### Step 4.5: Collect Actuals for Done items (SBI only)

Only SBI items in Status=Done need Actual. PBIs do not (they aggregate from children).

For each Done SBI:

1. If the item already has an Actual value (set previously via UI or earlier review run), display it and ask "そのままでよいか？"
   - If yes: keep.
   - If no: prompt for a new value (overwrite confirmation).
2. If Actual is empty, prompt:

   > #<num> "<title>" (est <X>h) は完了。実際にかかった時間（h）を入力してほしい。小数可。

3. Validate: non-negative number. Reject negative or non-numeric input.
4. Set the Actual field via `gh project item-edit ... --number <value>`.

The user may opt to defer ("skip") an Actual entry. In that case, the cell remains empty and the velocity row is recorded with a `*` warning.

After this step, refresh the aggregate table from Step 4 with concrete Actual sums.

### Step 5: Disposition unfinished items

For every item still in Status = `Sprint` or `Doing`, fetch the current Carry Count (treat empty as 0) and present:

> #<num> "<title>" (<repo>, est <X>h, carry=<N>) は未完了。次のうちどれか?
>   1) carry-over: 次スプリントに持ち越す（Status=Backlog にリセット、Sprint フィールドはクリア、Carry Count +1）
>   2) keep-in-sprint: 進行中扱いのまま次スプリントへ（Status=Doing 維持、Sprint フィールドはクリア、Carry Count +1）
>   3) drop: 打ち切り（Status=Dropped、コメントに理由を記録、Carry Count は変更なし）

If Carry Count is already ≥ 3, surface a warning before the prompt:

> ⚠ Carry Count が <N> 回。drop または re-shape を検討してほしい。

Process one item at a time, in order. For (3), ask:

> Drop の理由を記入してほしい（Issueにコメントとして残す）。

Apply changes via `gh project item-edit` and `gh issue comment`. For carry-over and keep-in-sprint, increment Carry Count via:

```bash
gh project item-edit \
  --id "$ITEM_ID" \
  --project-id "$PROJECT_ID" \
  --field-id "$CARRY_COUNT_FIELD_ID" \
  --number "$((CURRENT + 1))"
```

After all unfinished items are dispositioned, the sprint should have Status = Done or Dropped only (or items that are explicitly cleared from Sprint field for carry-over).

### Step 6: Update velocity log

Compute the new row to append:

```markdown
| <sprint-id> | <start> 〜 <end> | <target>h | <capacity>h | <ceiling>h | <estimated>h | <actual>h | <unplanned-count>/<unplanned-h> | <notes> |
```

Where:

- target = from sprint metadata (`target_hours`)
- capacity = from sprint metadata
- ceiling = from sprint metadata
- estimated = sum of Estimate for Status=Done items
- actual = sum of Actual for Status=Done items. If any Done item lacks Actual, append `*` (e.g., `34.5h*`) and add a footnote in Notes (`actual incomplete: N item(s) missing`)
- unplanned = `<count>/<hours>h` format. Count = items with `Unplanned = yes` in this sprint; hours = sum of their Estimate. Example: `3/5h`. If zero, write `0/0h`
- notes = `<done-count> done, <carry-count> carried, <drop-count> dropped[, actual incomplete: <N> item(s)]`

#### Resolve the destination

1. Read `storage.paths.velocity`.
2. Expand template variables (see `solo-sprint-spec/references/path-templates.md`). Use the sprint metadata for `{sprint_id}` and the current execution date for `{date:...}`.
3. The expanded value is the target path inside the storage backend.

#### Backend = local

```bash
TARGET="$STORAGE_PATH/$EXPANDED_RELATIVE_PATH"
```

If the file does not exist, create it with the header:

```markdown
# Solo Sprint Velocity Log

| Sprint ID | Period | Target | Capacity | Ceiling | Estimated | Actual | Unplanned | Notes |
|---|---|---|---|---|---|---|---|---|
```

Then append the new row. Use atomic write (write to temp file in same dir, then rename).

#### Backend = git, push_mode = "direct"

1. GET the file from `storage.repo` on `storage.base_branch`. Capture `sha` and existing content.
2. If 404, treat as new file. Construct content = header + new row.
3. Otherwise, content = existing + new row.
4. PUT via Contents API to `storage.base_branch` with commit message `chore(velocity): record <sprint-id>`.

See `solo-sprint-spec/references/gh-commands.md` for command details.

#### Backend = git, push_mode = "pr"

1. Expand `storage.branch_template` to determine the feature branch name.
2. Check if the branch exists:
   - **Exists**: reuse. Skip branch creation.
   - **Does not exist**: create from `storage.base_branch`'s HEAD (`POST /git/refs`).
3. GET the file on the feature branch (or 404 → create new).
4. PUT to the feature branch with commit message `chore(velocity): record <sprint-id>`.
5. Check for an existing open PR with `head = <feature_branch>` and `base = <base_branch>`:
   - **Exists**: reuse. Do not create another PR.
   - **Does not exist**: create one. Title: `Solo Sprint: <sprint-id>`. Body suggestion:
     ```
     Sprint <sprint-id> review and retrospective records.

     Generated by review-sprint and retrospect-sprint.
     ```
6. Report the PR URL.

#### Common rules

- Idempotency: re-running review-sprint for the same sprint MUST detect the existing row and replace it (not duplicate). Detect by `<sprint-id>` match in the first column.
- Always include the table header on first creation; never write a row without the header above.

### Step 7: Update sprint metadata

Append to `sprint-<sprint-id>.toml`:

```toml
[review]
reviewed_at = "<ISO timestamp>"
done_count = ...
done_estimated_hours = ...
done_actual_hours = ...
actual_incomplete_count = ...    # number of Done items still missing Actual
carried_count = ...
dropped_count = ...
unplanned_count = ...
unplanned_hours = ...
```

This is consumed by `retrospect-sprint`.

### Step 8: Report

```
Sprint <sprint-id> reviewed.
- Done: <count> items
  - Estimated: <hours>h
  - Actual:    <hours>h  [incomplete: <N> item(s)]
- Carried over: <count>
- Dropped: <count>
- Unplanned: <count> items, <hours>h  (<percentage>% of Estimated total)

Velocity log:
  <local | git>: <expanded-path>
  [git/pr]  PR: <url>

Next: run `retrospect-sprint` to capture learnings.
```

Do not auto-trigger retrospect-sprint.

## Anti-patterns

- ❌ Skip the per-item disposition (every unfinished item must be explicitly handled)
- ❌ Leave items with stale Sprint field values (always clear or move)
- ❌ Skip the Actual collection step for Done SBIs
- ❌ Overwrite a non-empty Actual without explicit user confirmation
- ❌ Treat a missing Actual as zero (must surface the gap with `*` and incomplete count)
- ❌ Forget to increment Carry Count on carry-over / keep-in-sprint
- ❌ Increment Carry Count on drop (only carry-over and keep-in-sprint count)
- ❌ Auto-decrement or reset Carry Count (manual reset is the user's prerogative)
- ❌ Append to velocity.md without the table header on first run
- ❌ Auto-run retrospect-sprint
- ❌ For PR mode: create a fresh branch when one already exists for the same sprint (must reuse)
- ❌ For PR mode: create a duplicate PR when one is already open from the same branch (must reuse)
- ❌ Duplicate the velocity row on re-run (must detect by sprint-id and replace)
- ❌ Use `gh repo clone` for git backend (Contents API is the contract)
