# Path Templates

Template-string syntax used in `storage.paths.velocity`, `storage.paths.retros`, and `storage.branch_template`. Loaded by every skill that resolves any of those values.

## Variables

| Variable | Meaning | Format |
|---|---|---|
| `{sprint_id}` | Sprint identifier | Fixed: `YYYY-SNN` (e.g., `2026-S18`) |
| `{date:FORMAT}` | A date, formatted by tokens | See below |

The base date for `{date:...}`:

- In `storage.paths.*` — the **operation execution date** (when the skill writes the file).
- In `storage.branch_template` — the **operation execution date** (same).

`{type}` is **not** a supported variable.

## Date Format Tokens

Following the dayjs / moment style. Tokens are matched longest first.

| Token | Meaning | Example |
|---|---|---|
| `YYYY` | 4-digit year | `2026` |
| `YY` | 2-digit year | `26` |
| `MM` | 2-digit month (zero-padded) | `04` |
| `M` | 1-2 digit month | `4` |
| `DD` | 2-digit day (zero-padded) | `29` |
| `D` | 1-2 digit day | `29` |
| `HH` | 2-digit hour (24h, zero-padded) | `14` |
| `H` | 1-2 digit hour (24h) | `14` |
| `mm` | 2-digit minute (zero-padded) | `32` |
| `m` | 1-2 digit minute | `32` |
| `ss` | 2-digit second (zero-padded) | `07` |
| `s` | 1-2 digit second | `7` |

Any character not matching a token is treated as a literal. Examples:

- `{date:YYYY-MM-DD}` → `2026-04-29`
- `{date:YYYY/MM/DD}` → `2026/04/29`
- `{date:YYYY}` → `2026`
- `{date:MM-DD HH:mm}` → `04-29 14:32`

## Resolution Rules

1. Scan the template left-to-right.
2. Each `{...}` block is replaced by its expanded value.
3. Inside `{date:FORMAT}`, the FORMAT body is parsed token-by-token (longest match first).
4. Unknown variables (e.g., `{type}`) raise an error during bootstrap or operation, with the offending token reported.
5. Outside `{...}`, characters are kept verbatim. Escaping `{` or `}` is not supported (no real-world need; reject configs containing literal braces).

## Validation

Performed at `bootstrap-solo-sprint` save time, and re-checked when each consuming skill loads `config.toml`.

| Field | Constraint | On failure |
|---|---|---|
| `storage.paths.retros` | MUST contain `{sprint_id}` | Reject the config. Per-sprint files would otherwise overwrite each other. |
| `storage.paths.velocity` | MAY contain any variable. **Warning** if it contains `{date:...}` because year/month boundary changes split the history file. | Save with a clear notice. The user is responsible for cross-file aggregation. |
| `storage.branch_template` (push_mode = "pr" only) | MUST contain at least one of `{sprint_id}` or `{date:...}` | Reject the config. Otherwise every operation reuses the same branch. |
| All templates | Unknown variables (e.g., `{type}`) | Reject with the token name. |
| All templates | Unbalanced `{` or `}` | Reject. |

## Examples

```toml
# Single-file velocity, sprint-keyed retros
[storage.paths]
velocity = "velocity.md"
retros   = "retros/{sprint_id}.md"

# Year-partitioned (warns on velocity)
[storage.paths]
velocity = "{date:YYYY}/velocity.md"
retros   = "{date:YYYY}/retros/{sprint_id}.md"

# Per-day-keyed retros (still requires {sprint_id} — combine if needed)
[storage.paths]
retros = "retros/{date:YYYY-MM-DD}-{sprint_id}.md"
```

## Reference Implementation Note

Skills implement template expansion in their own logic (typically inline; the SKILL.md describes the algorithm). They do not call out to a shared script. The single source of truth for tokens and validation is this document.
