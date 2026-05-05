{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code;
    enableMcpIntegration = true;
    context = import ../llm-agents/agents-md.nix;

    settings = {
      alwaysThinkingEnabled = true;
      includeCoAuthoredBy = false;
      spinnerTipsEnabled = false;

      permissions = {
        defaultMode = "auto";

        ask = [
          # gh write operations (shared state on remote)
          "Bash(gh pr close *)"
          "Bash(gh issue close *)"
          "Bash(gh repo create *)"
          "Bash(gh release create *)"
          "Bash(gh api -X DELETE *)"
          "Bash(gh api --method DELETE *)"

          # curl write operations
          "Bash(curl -X DELETE *)"
          "Bash(curl --request DELETE *)"

          # cargo registry operations
          "Bash(cargo publish *)"
          "Bash(cargo login *)"
          "Bash(cargo logout)"
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

          # deepwiki MCP (external GitHub repo research)
          "mcp__deepwiki__ask_question"
          "mcp__deepwiki__read_wiki_contents"
          "mcp__deepwiki__read_wiki_structure"
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
