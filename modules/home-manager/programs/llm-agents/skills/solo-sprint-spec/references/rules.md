# Solo Sprint Rules

Operational rules shared by all solo-sprint skills.

## Sprint Length

- Sprint length is **variable**, not fixed at 14 days.
- A sprint ends when the cumulative available work hours reach `sprint.target_hours` (configured in `config.toml`, e.g., 40h).
- Daily standard work time is `sprint.daily_standard` (e.g., 4h).
- Actual sprint duration typically ranges 7–21 days depending on user availability.

## Capacity and Investment

- **Capacity** = sum of available hours across the planned days (set per-day during planning).
- **Investment ceiling** = `capacity × sprint.capacity_buffer` (e.g., 0.9 → 90% of capacity).
- Sum of estimates of items pulled into the sprint MUST NOT exceed the investment ceiling.

## Estimation

- Allowed values: `0.5h`, `1h`, `2h`, `4h`. No other values.
- Round intermediate values UP (e.g., 3h → 4h, 1.5h → 2h).
- Only SBIs carry estimates. PBIs do not; their effective size is the sum of child SBI estimates.

## PBI / SBI Distinction

An item MUST be created as a **PBI** when any of the following holds:

1. Estimated effort exceeds 4h (cannot be a single SBI).
2. The work cannot fit within a single sprint.
3. The work naturally decomposes into two or more independent sub-tasks.

Otherwise, create a flat **SBI** directly. Do NOT create a PBI with a single SBI child — 1-to-1 PBI/SBI structures are forbidden (they create double-bookkeeping with no benefit).

PBI/SBI parent-child relationships are expressed via GitHub's **sub-issue** feature (not via a custom field).

## Acceptance Criteria

Both PBIs and SBIs MUST have an `## Acceptance Criteria` section in their Issue body, populated with at least one checkbox item. This is enforced by `create-backlog-item`.

## Sprint Lifecycle States

| State | Meaning |
|---|---|
| Backlog | Not yet pulled into a sprint |
| Sprint | Pulled into the current sprint, not started |
| Doing | Work in progress |
| Done | Completed, acceptance criteria met |
| Dropped | Decided not to do (recorded for audit) |

## Cross-sprint Handling

At Sprint Review, every unfinished item (status: Sprint or Doing) MUST be explicitly dispositioned:

- **Carry over**: clear the Sprint field, status reset to `Backlog`. Increment Carry Count by 1.
- **Keep-in-sprint**: clear the Sprint field, status remains `Doing`. Increment Carry Count by 1.
- **Drop**: status set to `Dropped`, with reason noted in a comment on the Issue. Carry Count is NOT incremented.

Implicit carry-over (leaving the previous iteration ID) is forbidden.

## Unplanned (Interrupt) Items

The `Unplanned` Single select field marks items that did NOT come through normal sprint planning. Concretely:

- An item is `Unplanned = yes` when it was created by `create-backlog-item` while a sprint was running AND the user chose to inject it into that running sprint.
- An item is `Unplanned = no` (or empty) in all other cases — including items created during a sprint but pushed to the Backlog instead of injected.

Rules:

- The investment ceiling check from `rules.md` does NOT apply to unplanned items. Emergency work is intentional overflow.
- `review-sprint` aggregates unplanned counts and effort to surface interruption pressure.
- `Unplanned = yes` is set once at creation and never auto-flipped. The user may manually change it via the Project UI if classification was wrong.

## Carry Count

Tracks how many times an item has failed to complete within its assigned sprint. Useful for surfacing chronically delayed work that should be re-shaped or dropped.

Rules:

- Empty / unset Carry Count is interpreted as `0`. `review-sprint` reads the current value (or 0) and writes `current + 1` on carry-over / keep-in-sprint.
- The counter MUST NOT decrement automatically. The user may manually reset it via the Project UI if a re-shape justifies starting fresh.
- `Done` and `Dropped` transitions do not change Carry Count.
- Both SBIs and PBIs carry the field, though PBIs typically stay in Backlog and rarely accumulate counts.
- `show-backlog` exposes a `--carry-count <op><N>` filter so users can isolate stalled items (e.g., `--carry-count >=3`).

## Actual Time

Each SBI carries an `Actual` (Number) Project field that records the hours actually spent on the work.

Rules:

- **SBIs only.** PBIs do not carry Actual; their effective Actual is the sum of child SBI Actuals (computed on demand, not stored).
- **Set at Done transition.** `review-sprint` is the canonical place where Actual is collected: when reviewing the sprint, every item being moved to Done is asked for its Actual value if not already set.
- **Decimals allowed.** Granularity is the user's call (e.g., `1.5`, `2.25`). No rounding rule is enforced.
- **No upper bound.** Actual may exceed Estimate (and often will). The gap is signal, not error — discuss in the retrospective.
- **Optional override.** Users may pre-fill Actual in the Project UI before review-sprint runs; review-sprint MUST NOT overwrite a non-empty Actual without confirmation.

## Velocity vs Actual

`velocity.md` tracks both:

- **Estimated**: sum of Estimate for Done items (deterministic from Project state)
- **Actual**: sum of Actual for Done items (depends on user input during review-sprint)

If any Done item has an empty Actual at the time review-sprint records velocity, the Actual sum is reported with a warning (e.g., `38h*` with a footnote). It is not silently treated as zero.

`review-sprint` updates `velocity.md` at sprint close.

## When Rules Change

- Sprint cadence settings (`target_hours`, `daily_standard`, `capacity_buffer`) are stored in `config.toml`.
- To change them, re-run `bootstrap-solo-sprint`. Existing sprints are not affected retroactively.
