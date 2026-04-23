{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code;
    enableMcpIntegration = true;
    context = import ../llm-agents/agents-md.nix;

    settings = {
      alwaysThinkingEnabled = true;
      spinnerTipsEnabled = false;

      permissions = {
        ask = [
          # git write operations
          "Bash(git commit *)"
          "Bash(git push *)"
          "Bash(git branch *)"
          "Bash(git checkout *)"
          "Bash(git merge *)"
          "Bash(git rebase *)"
          "Bash(git reset *)"
          "Bash(git tag *)"

          # jj write operations
          "Bash(jj commit *)"
          "Bash(jj describe *)"
          "Bash(jj git push *)"
          "Bash(jj new *)"
          "Bash(jj bookmark *)"
          "Bash(jj squash *)"
          "Bash(jj rebase *)"
          "Bash(jj abandon *)"

          # gh write operations
          "Bash(gh pr create *)"
          "Bash(gh pr merge *)"
          "Bash(gh pr close *)"
          "Bash(gh pr edit *)"
          "Bash(gh pr review *)"
          "Bash(gh issue create *)"
          "Bash(gh issue close *)"
          "Bash(gh issue edit *)"
          "Bash(gh repo create *)"
          "Bash(gh release create *)"
          "Bash(gh api -X POST *)"
          "Bash(gh api -X PUT *)"
          "Bash(gh api -X PATCH *)"
          "Bash(gh api -X DELETE *)"
          "Bash(gh api --method POST *)"
          "Bash(gh api --method PUT *)"
          "Bash(gh api --method PATCH *)"
          "Bash(gh api --method DELETE *)"

          # curl write operations
          "Bash(curl -X POST *)"
          "Bash(curl -X PUT *)"
          "Bash(curl -X PATCH *)"
          "Bash(curl -X DELETE *)"
          "Bash(curl --request POST *)"
          "Bash(curl --request PUT *)"
          "Bash(curl --request PATCH *)"
          "Bash(curl --request DELETE *)"
          "Bash(curl -d *)"
          "Bash(curl --data *)"

          # cargo write operations
          "Bash(cargo publish *)"
          "Bash(cargo login *)"
          "Bash(cargo logout)"

          # Serena MCP write operations
          "mcp__plugin_claude-code-home-manager_serena__write_memory"
          "mcp__plugin_claude-code-home-manager_serena__edit_memory"
          "mcp__plugin_claude-code-home-manager_serena__delete_memory"
          "mcp__plugin_claude-code-home-manager_serena__rename_memory"
          "mcp__plugin_claude-code-home-manager_serena__replace_symbol_body"
          "mcp__plugin_claude-code-home-manager_serena__insert_after_symbol"
          "mcp__plugin_claude-code-home-manager_serena__insert_before_symbol"
          "mcp__plugin_claude-code-home-manager_serena__rename_symbol"
          "mcp__plugin_claude-code-home-manager_serena__onboarding"
        ];

        allow = [
          # jj read operations
          "Bash(jj bookmark list *)"
          "Bash(jj log *)"
          "Bash(jj status)"
          "Bash(jj diff *)"
          "Bash(jj show *)"
          "Bash(jj op log *)"

          # gh read operations
          "Bash(gh api -X GET *)"
          "Bash(gh api --method GET *)"
          "Bash(gh api *)"
          "Bash(gh repo view *)"
          "Bash(gh search *)"
          "Bash(gh release list *)"
          "Bash(gh run list *)"
          "Bash(gh run view *)"
          "Bash(gh pr list *)"
          "Bash(gh pr status *)"
          "Bash(gh pr checks *)"
          "Bash(gh pr view *)"
          "Bash(gh issue list *)"
          "Bash(gh issue view *)"
          "Bash(gh auth status)"
          "Bash(gh status)"

          # git read operations
          "Bash(git status)"
          "Bash(git log *)"
          "Bash(git diff *)"
          "Bash(git show *)"
          "Bash(git remote *)"

          # filesystem read operations
          "Bash(ls)"
          "Bash(ls *)"
          "Bash(cat *)"
          "Bash(find *)"
          "Bash(grep *)"

          # curl read operations
          "Bash(curl *)"
          "Bash(curl -I *)"
          "Bash(curl --head *)"

          # nix operations
          "Bash(nix flake show *)"
          "Bash(nix flake metadata *)"
          "Bash(nix flake check *)"
          "Bash(nix search *)"
          "Bash(nix eval *)"
          "Bash(nix show-config)"
          "Bash(nix doctor)"
          "Bash(nix-store --query *)"
          "Bash(nix store info *)"
          "Bash(nix path-info *)"
          "Bash(nix why-depends *)"
          "Bash(nix log *)"
          "Bash(nix derivation show *)"
          "Bash(nix-env --query *)"
          "Bash(nix fmt -- --check *)"
          "Bash(nix run nix-darwin -- build *)"

          # mise / sheldon operations
          "Bash(sheldon lock *)"
          "Bash(sheldon info *)"
          "Bash(mise outdated *)"
          "Bash(mise list-remote *)"
          "Bash(mise plugins *)"
          "Bash(mise settings *)"
          "Bash(mise tasks *)"
          "Bash(mise env *)"
          "Bash(mise --version)"
          "Bash(mise list)"
          "Bash(mise current)"
          "Bash(mise ls)"
          "Bash(mise doctor)"
          "Bash(mise which *)"

          # misc
          "Bash(mkdir *)"
          "Bash(cd *)"
          "Bash(cargo *)"

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

  home = {
    file = {
      ".claude/docs" = {
        source = ../llm-agents/docs;
        recursive = true;
      };

      ".claude/keybindings.json".text = builtins.toJSON {
        "$schema" = "https://www.schemastore.org/claude-code-keybindings.json";
        "$docs" = "https://code.claude.com/docs/en/keybindings";
        bindings = [
          {
            context = "Chat";
            bindings = {
              enter = "chat:newline";
              "cmd+enter" = "chat:submit";
            };
          }
        ];
      };
    };
  };
}
