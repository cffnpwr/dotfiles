---
name: show-backlog
description: Display the solo-sprint backlog with filters. Lists items from the GitHub Project, optionally filtered by repository, priority, sprint, or item type. PBIs are rendered as parent rows with their child SBIs nested. Use when (1) the user wants to see the backlog, (2) the user says "show the backlog", "バックログを見せて", "今のスプリントのアイテム一覧", (3) deciding what to work on next.
compatibility: |
  Required: gh CLI, jq.
  Requires solo-sprint bootstrap.
---

# Show Backlog

Renders the solo-sprint backlog as a filtered, optionally tree-structured table.

## Workflow

### Step 1: Load config

Read `${XDG_CONFIG_HOME:-$HOME/.config}/solo-sprint/config.toml`. Required:

- `github.owner`, `github.project_number`
- All field IDs

Abort if missing.

### Step 2: Parse filters

Accept any of these (passed as arguments or asked interactively):

| Filter | Form | Semantics |
|---|---|---|
| `--project <owner/repo>` | repeatable | Match Project field exactly |
| `--priority <op><N>` | e.g., `<3`, `=1`, `>=2` | Compare against Priority field |
| `--carry-count <op><N>` | e.g., `>=3`, `=0` | Compare against Carry Count field (empty treated as 0) |
| `--unplanned <yes\|no>` | one value | Match Unplanned field (empty treated as `no`) |
| `--label <name>` | repeatable | Match GitHub Issue Label (e.g., `type:bug`). Multiple flags = AND |
| `--sprint <id\|current\|backlog>` | one value | Match Sprint field; `current` = the iteration whose `start_date ≤ today < end_date` (the same rule used by `plan-sprint` and `review-sprint`); if multiple match, pick the most recent `start_date`; `backlog` = unset |
| `--status <name>` | repeatable | Match Status field |
| `--type <sbi\|pbi>` | one value | Match Type field |
| `--pbi-tree` | flag | Render as tree (PBI parents with SBI children) |
| `--limit <N>` | one value | Truncate output (default: 50) |

If no filters are provided, default to: `--status Backlog --status Sprint --status Doing --limit 50`.

### Step 3: Fetch items

```bash
gh project item-list "$NUMBER" --owner "$OWNER" --format json --limit 500
```

Apply filters in memory (jq). Sort by Priority ascending, then by created date ascending.

#### Labels enrichment

`gh project item-list` may not always return Issue labels in its output. To populate the Cat (category) column and apply `--label` filters, fetch labels via GraphQL in a single batched query:

```bash
gh api graphql -f query='
  query($owner: String!, $name: String!, $numbers: [Int!]!) {
    repository(owner: $owner, name: $name) {
      ...
    }
  }
'
```

Or, simpler when `--label` filtering is requested: fall back to per-Issue `gh issue view <num> --repo <owner>/<repo> --json labels`. Cache results within the session.

Category is derived as: take the first label matching `^type:(bug|feature|improvement|task)$`. If multiple match, keep the first; if none match, category is `-`.

### Step 4: Render

#### Flat (default)

```
| #    | T   | Cat   | U? | Title                  | Repo            | Pri | Est  | Act  | Carry | Status   | Sprint   |
|------|-----|-------|----|------------------------|-----------------|-----|------|------|-------|----------|----------|
| #42  | sbi | task  | -  | Aerospace 設定見直し    | cffnpwr/dotfiles| 1   | 2h   | 2.5h | 0     | Done     | 2026-S9  |
| #43  | pbi | feat  | -  | 認証MVP                | cffnpwr/webapp  | 2   | -    | -    | 0     | Backlog  | -        |
| #48  | sbi | bug   | Y  | プロダクション緊急修正   | cffnpwr/webapp  | 1   | 1h   | 1.5h | 0     | Done     | 2026-S9  |
| #50  | sbi | impr  | -  | 旧ライブラリ撤去        | cffnpwr/webapp  | 4   | 4h   | -    | 3 ⚠   | Backlog  | -        |
```

Use issue number for `#`. `T` = type (sbi/pbi). `Cat` = category derived from `type:*` label (`task`, `bug`, `feat`, `impr`; if multiple `type:*` labels exist, show the first; if none, `-`). `U?` = Unplanned (`Y` for yes, `-` for no/empty). `-` for empty fields. `Act` is the Actual field; shown only when set, otherwise `-`. `Carry` is the Carry Count (empty treated as 0). When Carry ≥ 3, append `⚠`. PBIs always show `-` for both Est and Act (they aggregate from children).

#### Tree (when `--pbi-tree`)

```
| #    | T   | Title                  | Repo            | Pri | Est  | Act  | Status   |
|------|-----|------------------------|-----------------|-----|------|------|----------|
| #43  | pbi | 認証MVP                | cffnpwr/webapp  | 2   | 6h   | 5h   | Backlog  |
|  ↳#44| sbi |   ログイン画面実装      | cffnpwr/webapp  | -   | 4h   | 3h   | Done     |
|  ↳#45| sbi |   セッション管理        | cffnpwr/webapp  | -   | 2h   | 2h   | Done     |
| #46  | sbi | typo fix               | cffnpwr/dotfiles| 3   | 0.5h | -    | Backlog  |
```

Indent children with `↳`. Inherit parent's priority. For PBI rows in tree mode, Est and Act show **the sum of children** (computed on the fly). Empty if no children have values.

To compute parent-child relationships, query GraphQL for sub-issues:

```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      issue(number: $number) {
        subIssues(first: 50) { nodes { id number title } }
      }
    }
  }
'
```

Cache results per session.

### Step 5: Summary line

After the table, show:

```
<N> items shown (<M> total in project, filtered to <N>).
By type: sbi=<X>, pbi=<Y>.
By status: Backlog=<A>, Sprint=<B>, Doing=<C>, Done=<D>, Dropped=<E>.
Estimate sum (sbi only): <H>h.
Actual sum (Done sbi only): <H>h  [<N> Done item(s) without Actual]
Stalled (Carry ≥ 3): <N> item(s)
Unplanned: <N> item(s), <H>h
By category: bug=<A>, feature=<B>, improvement=<C>, task=<D>, (untagged)=<E>
```

### Step 6: Hint

If the result includes the user's current sprint, also show:

```
Current sprint: <sprint-id>
Sprint progress: <done>/<total> items, <done-h>/<total-h>h
```

### Limit handling

If filtered items exceed `--limit`, append:

```
... and <N> more (use --limit to see more).
```

## Anti-patterns

- ❌ Modify any item state — this skill is read-only
- ❌ Combine unrelated filters silently (if a filter looks malformed, ask)
- ❌ Render PBI children outside their parent in tree mode
- ❌ Fetch all 500 items and render all of them (respect --limit)
