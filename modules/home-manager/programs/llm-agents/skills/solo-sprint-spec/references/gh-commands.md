# gh CLI / GraphQL Reference

Concrete commands used by solo-sprint skills. All commands assume `gh auth login` has been completed and the user has scopes: `repo`, `project`, `read:user`.

## Project Discovery

List user-level projects:

```bash
gh project list --owner "$OWNER" --format json
```

View a single project:

```bash
gh project view "$NUMBER" --owner "$OWNER" --format json
```

## Project Fields

List fields and their options:

```bash
gh project field-list "$NUMBER" --owner "$OWNER" --format json
```

Returns each field's `id`, `name`, and (for Single select / Iteration) the list of options/iterations with their IDs.

## Project Items

List items in a project (paginated; pass `--limit` if needed):

```bash
gh project item-list "$NUMBER" --owner "$OWNER" --format json --limit 200
```

Add an existing Issue to the project:

```bash
gh project item-add "$NUMBER" --owner "$OWNER" --url "$ISSUE_URL"
```

The command prints the new item's node ID to stdout. Capture it for subsequent field updates.

Edit a Single select field on an item:

```bash
gh project item-edit \
  --id "$ITEM_ID" \
  --project-id "$PROJECT_ID" \
  --field-id "$FIELD_ID" \
  --single-select-option-id "$OPTION_ID"
```

Edit a Number field:

```bash
gh project item-edit \
  --id "$ITEM_ID" \
  --project-id "$PROJECT_ID" \
  --field-id "$FIELD_ID" \
  --number "$VALUE"
```

Edit an Iteration field:

```bash
gh project item-edit \
  --id "$ITEM_ID" \
  --project-id "$PROJECT_ID" \
  --field-id "$FIELD_ID" \
  --iteration-id "$ITERATION_ID"
```

Clear an Iteration field (e.g., for Dropped items):

```bash
gh project item-edit \
  --id "$ITEM_ID" \
  --project-id "$PROJECT_ID" \
  --field-id "$FIELD_ID" \
  --clear
```

## Project ID

`item-edit` requires the Project's GraphQL node ID (`PVT_...`), not the project number. Get it once at bootstrap and store under `[github]` in `config.toml`, OR fetch on demand:

```bash
gh project view "$NUMBER" --owner "$OWNER" --format json | jq -r .id
```

## Issue Creation

```bash
gh issue create \
  --repo "$OWNER/$REPO" \
  --title "$TITLE" \
  --body-file /tmp/solo-sprint-body.md
```

Use `--body-file` to avoid shell escaping. Returns the Issue URL on stdout.

## Iteration Field — Creating a New Iteration

`gh` does not expose iteration creation directly. Use GraphQL:

```bash
gh api graphql -f query='
  mutation($projectId: ID!, $fieldId: ID!, $startDate: Date!, $duration: Int!) {
    updateProjectV2IterationField(input: {
      projectId: $projectId,
      fieldId: $fieldId,
      iterations: [{ startDate: $startDate, duration: $duration }]
    }) {
      projectV2IterationField { id }
    }
  }
' -f projectId="$PROJECT_ID" -f fieldId="$FIELD_ID" -f startDate="$START" -F duration="$DAYS"
```

Note: GitHub's iteration model evolves; verify the current schema with `gh api graphql -f query='{__type(name:"ProjectV2IterationField"){fields{name}}}'` if mutations fail.

## Sub-issue Linkage

Add an SBI as a sub-issue of a PBI. Sub-issues are exposed via GraphQL:

```bash
gh api graphql -f query='
  mutation($parentId: ID!, $childId: ID!) {
    addSubIssue(input: { issueId: $parentId, subIssueId: $childId }) {
      issue { number }
    }
  }
' -f parentId="$PARENT_NODE_ID" -f childId="$CHILD_NODE_ID"
```

Get an Issue's node ID:

```bash
gh issue view "$NUMBER" --repo "$OWNER/$REPO" --json id --jq .id
```

If `addSubIssue` is unavailable in the user's GitHub plan/region, fall back to a `Parent: #<num>` line in the SBI body and a checklist in the PBI body. Detect availability with the introspection query above.

## Single Select Option Management

Add a new option to a Single select field (used by `register-project`):

```bash
gh api graphql -f query='
  mutation($fieldId: ID!, $name: String!) {
    updateProjectV2SingleSelectField(input: {
      fieldId: $fieldId,
      options: { name: $name }
    }) {
      projectV2SingleSelectField { id }
    }
  }
' -f fieldId="$FIELD_ID" -f name="$OWNER/$REPO"
```

Note: depending on schema version, the mutation may require resending the full options list rather than a single new entry. Verify before relying on incremental adds.

## Repository File Operations (storage backend = "git")

Used by `review-sprint` and `retrospect-sprint` when `storage.backend = "git"`. All operations go through the GitHub Contents / Refs / Pulls APIs via `gh api`. No local clone is performed.

### Get a file (read existing content, before append)

```bash
gh api repos/"$OWNER"/"$REPO"/contents/"$PATH"?ref="$BRANCH" 2>/dev/null
```

Returns JSON with `content` (base64) and `sha`. The `sha` is required for subsequent updates.

If the file does not exist, the API returns 404. Treat 404 as "first write" and skip the sha.

```bash
RESPONSE=$(gh api repos/"$OWNER"/"$REPO"/contents/"$PATH"?ref="$BRANCH" 2>/dev/null || echo '{}')
SHA=$(echo "$RESPONSE" | jq -r '.sha // empty')
EXISTING=$(echo "$RESPONSE" | jq -r '.content // empty' | base64 -d 2>/dev/null || echo "")
```

### Put a file (create or update)

```bash
gh api repos/"$OWNER"/"$REPO"/contents/"$PATH" \
  -X PUT \
  -f message="$COMMIT_MESSAGE" \
  -f content="$(printf '%s' "$NEW_CONTENT" | base64)" \
  -f branch="$BRANCH" \
  ${SHA:+-f sha="$SHA"}
```

The `sha` is required for updates and forbidden for creates. Construct the command conditionally as shown.

### Resolve a branch HEAD sha

```bash
gh api repos/"$OWNER"/"$REPO"/git/refs/heads/"$BRANCH" --jq '.object.sha'
```

Returns 404 if the branch does not exist.

### Create a branch from another branch's HEAD

```bash
BASE_SHA=$(gh api repos/"$OWNER"/"$REPO"/git/refs/heads/"$BASE_BRANCH" --jq '.object.sha')

gh api repos/"$OWNER"/"$REPO"/git/refs \
  -X POST \
  -f ref="refs/heads/$NEW_BRANCH" \
  -f sha="$BASE_SHA"
```

If the new branch already exists, the API returns 422; treat as "already exists, reuse".

### List existing PRs from a head branch

```bash
gh pr list \
  --repo "$OWNER/$REPO" \
  --head "$NEW_BRANCH" \
  --base "$BASE_BRANCH" \
  --state open \
  --json number,url \
  --limit 1
```

Empty array → no existing PR; create one. Non-empty → reuse the first match.

### Create a PR

```bash
gh pr create \
  --repo "$OWNER/$REPO" \
  --base "$BASE_BRANCH" \
  --head "$NEW_BRANCH" \
  --title "$TITLE" \
  --body-file /tmp/solo-sprint-pr-body.md
```

Title and body suggestions are generated by the calling skill (`review-sprint` / `retrospect-sprint`). Use `--body-file` to avoid shell escaping.

### Append-style write (for velocity.md)

`review-sprint` appends a line to `velocity.md`. Implementation:

1. GET the file (may 404 on first run).
2. Construct new content = existing content + new row.
3. PUT with the captured sha (or no sha if creating).

The header (table prefix) is added on first creation only.

## Authentication Check

Run before any operation:

```bash
gh auth status --hostname github.com
```

If unauthenticated, instruct the user to run `gh auth login` and retry. Do not attempt to authenticate non-interactively.

For `storage.backend = "git"`, additionally verify push access:

```bash
gh api repos/"$OWNER"/"$REPO" --jq '.permissions.push'
```

Must return `true`. Otherwise abort with a clear error.
