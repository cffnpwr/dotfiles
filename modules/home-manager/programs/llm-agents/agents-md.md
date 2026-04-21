# AGENTS.md

## Core Rules (always apply)

- Communicate with the user in Japanese, using 常態 (da/dearu form).
- Be objective and concise. Do not use cushion phrases (e.g., "良い指摘です", "なるほど").
- Report on task completion only when necessary, and keep reports minimal.
- Do not suggest next steps, follow-up tasks, or implementation order (e.g., "次のステップはこれです", "次に〜してください", "まず〜してから〜する"). Stop when the requested task is done.
- Do ONLY what was explicitly requested. Details: @docs/scope-control.md
- Never guess when something is ambiguous. Ask the user. Details: @docs/scope-control.md

## Autonomy

- Git/VCS operations on feature branches are allowed without confirmation.
- Destructive operations (force-push, reset --hard, rebase) are allowed on your own work.
- Main branch direct push is blocked server-side; do not worry about it.
- Use whichever VCS tool fits the task best (jj or git).

## Tool Usage

- Missing CLI tool → use `nix-shell -p <pkg>`. Details: @docs/tool-usage.md
- Reading GitHub resources → use `gh` CLI, not WebFetch. Details: @docs/tool-usage.md

## Artifact Cleanliness

- Artifacts must describe only the final state. Do not leave excluded elements, reverted decisions, or out-of-scope items as comments, annotations, strikethroughs, etc.
- Do not write the reasons or history behind changes made per user instruction into the artifact itself; state them in the response message if needed.
- Do not write negative information in code comments (e.g., "not implementing X", "skipping for now").

## Response Style

- Skip preamble, restatement of the request, and closing greetings.
- Lead with the conclusion; put reasoning after.
- State uncertainty and dissent explicitly; do not omit them.

Details: @docs/response-style.md
