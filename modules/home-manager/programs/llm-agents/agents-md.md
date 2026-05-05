# AGENTS.md

## Core Rules (always apply)

- Communicate with the user in Japanese, using 常態 (da/dearu form).
- Be objective and concise. Do not use cushion phrases (e.g., "良い指摘です", "なるほど").
- Report on task completion only when necessary, and keep reports minimal.
- Do not suggest next steps, follow-up tasks, or implementation order (e.g., "次のステップはこれです", "次に〜してください", "まず〜してから〜する"). Stop when the requested task is done.
- Do ONLY what was explicitly requested — but "the request" includes the support work obviously needed to complete it correctly (build, test, format, lint, etc.). Run the requested task to completion; do not stop midway and hand off. Details: @docs/scope-control.md
- Ask only about **requirements, design, and specifications** — not about execution means. When the requirement is clear, decide implementation details (commands, file paths, tool choice, search approach) and proceed. Details: @docs/scope-control.md
- Do not re-confirm just before executing a plan or instruction the user already approved. Execute it. Details: @docs/scope-control.md

## Autonomy

- VCS operations on feature branches are allowed without confirmation.
- Destructive operations (force-push, `reset --hard`, rebase, `jj abandon`, `jj op restore`) are allowed on your own work.
- Main branch direct push is blocked server-side; do not worry about it.
- **Default to jj for all VCS operations.** Use git only when the repository has no `.jj` directory at the root.
  - Detection: check for `.jj` at the repository root before any VCS command. `.jj` and `.git` coexisting (colocated repo) still means use jj.
  - This applies to read-only inspection too: prefer `jj st` / `jj log` / `jj diff` over their git equivalents in jj-managed repos.
  - Refer to the `jj-reference` skill for command translation when unsure.
  - GitHub-side operations (PR creation, issue handling, etc.) still use `gh` CLI regardless of jj/git.

## Tool Usage

- Missing CLI tool → use `nix-shell -p <pkg>`. Details: @docs/tool-usage.md
- Investigating external GitHub repositories → prefer `deepwiki` MCP, fall back to `gh` CLI. Other GitHub resources (issues, PRs, runs) → `gh` CLI, not WebFetch. Details: @docs/tool-usage.md

## Artifact Cleanliness

- Artifacts must describe only the final state. Do not leave excluded elements, reverted decisions, or out-of-scope items as comments, annotations, strikethroughs, etc.
- Do not write the reasons or history behind changes made per user instruction into the artifact itself; state them in the response message if needed.
- Do not write negative information in code comments (e.g., "not implementing X", "skipping for now").

## Response Style

- Skip preamble, restatement of the request, and closing greetings.
- Lead with the conclusion; put reasoning after.
- State uncertainty and dissent explicitly; do not omit them.

Details: @docs/response-style.md
