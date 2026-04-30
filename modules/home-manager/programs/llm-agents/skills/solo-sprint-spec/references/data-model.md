# Data Model

Definition of the GitHub Project (v2) fields, Issue body schema, and storage configuration used by solo-sprint skills.

## GitHub Project (v2) Fields

A user-level Project owned by `github.owner` (from `config.toml`). The Project number is `github.project_number`.

Fields (defined by `bootstrap-solo-sprint`):

| Field | Type | Values / Notes |
|---|---|---|
| Status | Single select | `Backlog`, `Sprint`, `Doing`, `Done`, `Dropped` |
| Type | Single select | `sbi`, `pbi` |
| Estimate | Single select | `0.5h`, `1h`, `2h`, `4h` (only on SBIs; leave unset on PBIs) |
| Actual | Number | Hours actually spent. SBIs only. Set by `review-sprint` when transitioning an item to Done; PBIs leave it unset. Decimals allowed (e.g., `2.5`). |
| Carry Count | Number | Non-negative integer. Counts how many times this item has been carried over (or kept-in-sprint) without being completed. Incremented by `review-sprint`. Empty is treated as `0`. |
| Unplanned | Single select | `yes` / `no`. Marks items that surfaced as interruptions during a running sprint and were injected directly into it (bypassing `plan-sprint`). Empty is treated as `no`. |
| Priority | Number | Integer in `0..100`. **Smaller is higher priority.** No default — band-based, see `create-backlog-item/references/priority-guide.md`. |
| Project | Single select | `<owner>/<repo>` form. Options added by `register-project`. |
| Sprint | Iteration | Variable-length iterations. Created by `plan-sprint`. |

Field IDs and option IDs are persisted in `config.toml` under `[github.fields]` so skills do not need to look them up on every invocation.

The default `Title` field is the Issue title. The default `Assignees`, `Labels`, `Milestone`, `Repository`, `Linked pull requests` fields are not used by solo-sprint logic.

## Repository Mapping

The Project field's value (`<owner>/<repo>`) is the canonical source of which repository an item belongs to. There is no separate `[[projects]]` mapping in `config.toml` — the Project field's Single select options enumerate all registered repositories.

`register-project` adds new options to this field. `create-backlog-item` reads the option list to let the user choose where to file the Issue.

## Issue Body Schema

All Issues created by `create-backlog-item` follow one of four category templates that live in the `create-backlog-item` skill itself. Category is selected by the user at creation and recorded as a GitHub Issue Label (`type:<category>`).

| Category | Template | Label | Typical use |
|---|---|---|---|
| `task` (default) | `create-backlog-item/templates/task.md` | `type:task` | refactor, deps update, docs, chore |
| `bug` | `create-backlog-item/templates/bug.md` | `type:bug` | bug report or fix |
| `feature` | `create-backlog-item/templates/feature.md` | `type:feature` | new functionality |
| `improvement` | `create-backlog-item/templates/improvement.md` | `type:improvement` | enhance existing functionality |

Templates are shared across SBI and PBI (粒度はテンプレ外で表現)。SBI uses each section terse (1–3 lines); PBI elaborates Background / Scope / Out of Scope.

Every template contains a mandatory `## Acceptance Criteria` section. The skill MUST refuse to create an Issue with an empty Acceptance Criteria list.

## Categorization (GitHub Labels)

Solo-sprint uses GitHub Issue Labels — not a Project field — for category. Reasons:

- Labels are GitHub-native and visible in repository Issue views, search, and CLI.
- `gh issue list --label type:bug` works out of the box.
- issue-creator skill (and other workflows) can interoperate with the same convention.

Canonical labels (created by `register-project` on each registered repository):

| Label | Color | Description |
|---|---|---|
| `type:bug` | `#d73a4a` | Bug report or fix |
| `type:feature` | `#0e8a16` | New functionality |
| `type:improvement` | `#a2eeef` | Enhancement to existing functionality |
| `type:task` | `#c5def5` | Internal work (refactor, deps, docs, chore) |

Multiple `type:*` labels on a single Issue is technically allowed but discouraged. `show-backlog` shows the first match.

## Sub-issue Relationships

PBI–SBI parent-child relationships use GitHub's **sub-issue** feature (added 2024). This is not exposed via top-level `gh` subcommands; use GraphQL via `gh api graphql`. See `gh-commands.md` for concrete mutations.

A sub-issue link is unidirectional in storage (parent points to children) but visible bidirectionally in GitHub's UI.

## Storage

The `[storage]` section determines where `velocity` (sprint history log, written by `review-sprint`) and `retros` (per-sprint KPT files, written by `retrospect-sprint`) are placed. Both share the same backend.

### Backend: local

Files are written directly to a directory on the user's filesystem.

```toml
[storage]
backend = "local"
path = "/absolute/path/to/dir"

[storage.paths]
velocity = "velocity.md"
retros   = "retros/{sprint_id}.md"
```

- `storage.path` MUST be absolute. `~` and environment variables are expanded by `bootstrap-solo-sprint` before writing.
- `storage.paths.*` are **relative** to `storage.path`. They use the template syntax in `path-templates.md`.
- The directory is created if missing (with user confirmation in bootstrap).

### Backend: git

Files are written into a GitHub repository, accessed via the GitHub Contents API (`gh api repos/{owner}/{repo}/contents/{path}`). No local clone is performed.

```toml
[storage]
backend = "git"
repo = "<owner>/<repo>"
base_branch = "main"
push_mode = "direct"   # or "pr"
# branch_template is required only when push_mode = "pr"
branch_template = "solo-sprint/{sprint_id}"

[storage.paths]
velocity = "velocity.md"
retros   = "retros/{sprint_id}.md"
```

- `storage.repo`: target GitHub repository in `<owner>/<repo>` form.
- `storage.base_branch`: the branch that direct pushes target, or the base branch for PRs.
- `storage.push_mode`:
  - `"direct"`: write directly to `base_branch` via the Contents API. Each file write becomes one commit on `base_branch`.
  - `"pr"`: create or reuse a feature branch named per `branch_template`, write commits there, and create or reuse a Pull Request from that branch into `base_branch`.
- `storage.branch_template`: required when `push_mode = "pr"`. See `path-templates.md`.
- `storage.paths.*` are paths inside the repository (no leading `/`).

### Path templates

`storage.paths.velocity`, `storage.paths.retros`, and `storage.branch_template` all use the template syntax described in `path-templates.md`. Constraints:

- `paths.retros` MUST contain `{sprint_id}`.
- `paths.velocity` MAY contain templates. A warning is shown on save if it contains `{date:...}`, since year/month boundaries split the history into multiple files.
- `branch_template` MUST contain at least one of `{sprint_id}` or `{date:...}`.

## config.toml Schema

Generated by `bootstrap-solo-sprint`. Read by all other skills.

```toml
[github]
owner = "<user-or-org>"
project_number = 0

[github.fields]
# Project field IDs (e.g., "PVTSSF_xxx") and the field's option IDs.
# Stored as a nested table per field.
status = { id = "PVTSSF_...", options = { backlog = "...", sprint = "...", doing = "...", done = "...", dropped = "..." } }
type = { id = "PVTSSF_...", options = { sbi = "...", pbi = "..." } }
estimate = { id = "PVTSSF_...", options = { "0.5h" = "...", "1h" = "...", "2h" = "...", "4h" = "..." } }
actual = { id = "PVTF_..." }
carry_count = { id = "PVTF_..." }
unplanned = { id = "PVTSSF_...", options = { yes = "...", no = "..." } }
priority = { id = "PVTF_..." }
project = { id = "PVTSSF_..." }    # options enumerated dynamically via gh project field-list
sprint = { id = "PVTIF_..." }

[sprint]
target_hours = 40
daily_standard = 4
capacity_buffer = 0.9

[storage]
# One of:
#   backend = "local"; path = "..."
#   backend = "git";   repo = "..."; base_branch = "..."; push_mode = "direct"
#   backend = "git";   repo = "..."; base_branch = "..."; push_mode = "pr"; branch_template = "..."

[storage.paths]
velocity = "..."   # template — see path-templates.md
retros   = "..."   # template — must contain {sprint_id}
```
