{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code;
    enableMcpIntegration = true;
    memory.source = import ../llm-agents/agents-md.nix;

    settings = {
      alwaysThinkingEnabled = false;
      spinnerTipsEnabled = false;

      permissions = {
        ask = [
          # git write operations
          "Bash(git commit:*)"
          "Bash(git push:*)"
          "Bash(git branch:*)"
          "Bash(git checkout:*)"
          "Bash(git merge:*)"
          "Bash(git rebase:*)"
          "Bash(git reset:*)"
          "Bash(git tag:*)"

          # jj write operations
          "Bash(jj commit:*)"
          "Bash(jj describe:*)"
          "Bash(jj git push:*)"
          "Bash(jj new:*)"
          "Bash(jj bookmark:*)"
          "Bash(jj squash:*)"
          "Bash(jj rebase:*)"
          "Bash(jj abandon:*)"

          # gh write operations
          "Bash(gh pr create:*)"
          "Bash(gh pr merge:*)"
          "Bash(gh pr close:*)"
          "Bash(gh pr edit:*)"
          "Bash(gh pr review:*)"
          "Bash(gh issue create:*)"
          "Bash(gh issue close:*)"
          "Bash(gh issue edit:*)"
          "Bash(gh repo create:*)"
          "Bash(gh release create:*)"
          "Bash(gh api -X POST:*)"
          "Bash(gh api -X PUT:*)"
          "Bash(gh api -X PATCH:*)"
          "Bash(gh api -X DELETE:*)"
          "Bash(gh api --method POST:*)"
          "Bash(gh api --method PUT:*)"
          "Bash(gh api --method PATCH:*)"
          "Bash(gh api --method DELETE:*)"
        ];

        allow = [
          "Bash(jj bookmark list:*)"

          # gh read operations
          "Bash(gh api -X GET:*)"
          "Bash(gh api --method GET:*)"
          "Bash(gh api:*)"
          "Bash(gh repo view *)"
          "Bash(gh search:*)"
          "Bash(gh release list:*)"
          "Bash(gh run list:*)"
          "Bash(gh run view:*)"
          "Bash(gh pr list:*)"
          "Bash(gh pr status:*)"
          "Bash(gh pr checks:*)"
          "Bash(gh pr view:*)"

          # Claude Code built-in tools (permission not required)
          "Agent"
          "AskUserQuestion"
          "CronCreate"
          "CronDelete"
          "CronList"
          "EnterPlanMode"
          "EnterWorktree"
          "ExitWorktree"
          "Glob"
          "Grep"
          "ListMcpResourcesTool"
          "Read"
          "ReadMcpResourceTool"
          "TaskCreate"
          "TaskGet"
          "TaskList"
          "TaskOutput"
          "TaskStop"
          "TaskUpdate"
          "TodoWrite"
          "ToolSearch"

          # Web tools
          "WebFetch"
          "WebSearch"

          # Serena MCP read-only tools
          "mcp__plugin_claude-code-home-manager_serena__check_onboarding_performed"
          "mcp__plugin_claude-code-home-manager_serena__list_memories"
          "mcp__plugin_claude-code-home-manager_serena__read_memory"
          "mcp__plugin_claude-code-home-manager_serena__find_file"
          "mcp__plugin_claude-code-home-manager_serena__find_symbol"
          "mcp__plugin_claude-code-home-manager_serena__find_referencing_symbols"
          "mcp__plugin_claude-code-home-manager_serena__get_symbols_overview"
          "mcp__plugin_claude-code-home-manager_serena__list_dir"
          "mcp__plugin_claude-code-home-manager_serena__search_for_pattern"
          "mcp__plugin_claude-code-home-manager_serena__initial_instructions"
        ];
      };
    };
  };
}
