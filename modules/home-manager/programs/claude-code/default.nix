{
  config,
  lib,
  pkgs,
  ...
}:
let # Fetch Claude Code skill repositories
  ccconfigs = pkgs.fetchFromGitHub {
    owner = "dhruvbaldawa";
    repo = "ccconfigs";
    rev = "451b604718d39fcc2c008d22e550bdf60c7115da";
    hash = "sha256-7V1xG2FmzqWdnWmVV6WWKBAvY6QHWo+UKzh0Uu/Xg/w=";
  };
  awesome-claude-code = pkgs.fetchFromGitHub {
    owner = "ai-digital-architect";
    repo = "awesome-claude-code";
    rev = "6b717ff581d27d13e152d65cb00acb5befc37b1f";
    hash = "sha256-ztIJq8WDHJ2baR/QUf8q7jF4UT661Z5JXElJUiJpd+M=";
  };
  anthropic-skills = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "skills";
    rev = "69c0b1a0674149f27b61b2635f935524b6add202";
    hash = "sha256-pllFZoWRdtLliz/5pLWks0V9nKFMzeWoRcmFgu2UWi8=";
  };
in
{
  programs.claude-code = {
    enable = true;

    # Global CLAUDE.md memory
    memory.source = ./CLAUDE.md;

    settings = {
      env = {
        CLAUDE_CODE_ENABLE_TELEMETRY = "false";
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "true";
        DISABLE_ERROR_REPORTING = "true";
        DISABLE_TELEMETRY = "true";
        DISABLE_AUTOUPDATER = "true";
        DISABLE_MICROCOMPACT = "true";
        ENABLE_TOOL_SEARCH = "true";
      };

      includeCoAuthoredBy = false;

      permissions.allow = [
        "Glob(**/*)"
        "Grep(**/*)"
        "LS(**/*)"
        "NotebookRead(**/*.ipynb)"
        "Read(**/*)"
        "TodoRead"
        "TodoWrite"
        "WebFetch"
        "WebSearch"
        "Bash(cal:*)"
        "Bash(cat:*)"
        "Bash(cmp:*)"
        "Bash(date:*)"
        "Bash(df:*)"
        "Bash(diff:*)"
        "Bash(du:*)"
        "Bash(echo:*)"
        "Bash(env)"
        "Bash(file:*)"
        "Bash(find:*)"
        "Bash(gh alias list)"
        "Bash(gh api:*)"
        "Bash(gh auth status)"
        "Bash(gh gist list:*)"
        "Bash(gh gist view:*)"
        "Bash(gh issue list:*)"
        "Bash(gh issue view:*)"
        "Bash(gh pr checks:*)"
        "Bash(gh pr diff:*)"
        "Bash(gh pr list:*)"
        "Bash(gh pr view:*)"
        "Bash(gh release list:*)"
        "Bash(gh release view:*)"
        "Bash(gh repo clone:*)"
        "Bash(gh repo list:*)"
        "Bash(gh repo view:*)"
        "Bash(gh run download:*)"
        "Bash(gh run list:*)"
        "Bash(gh run view:*)"
        "Bash(gh search:*)"
        "Bash(gh status)"
        "Bash(gh workflow list:*)"
        "Bash(gh workflow view:*)"
        "Bash(git add:*)"
        "Bash(git branch:*)"
        "Bash(git config --get:*)"
        "Bash(git config --list)"
        "Bash(git diff:*)"
        "Bash(git log:*)"
        "Bash(git remote:*)"
        "Bash(git show:*)"
        "Bash(git status)"
        "Bash(grep:*)"
        "Bash(groups:*)"
        "Bash(head:*)"
        "Bash(hexdump:*)"
        "Bash(history)"
        "Bash(hostname)"
        "Bash(htop)"
        "Bash(id:*)"
        "Bash(jobs)"
        "Bash(ls:*)"
        "Bash(mise --version)"
        "Bash(mise current)"
        "Bash(mise list)"
        "Bash(mise ls)"
        "Bash(mise which:*)"
        "Bash(od:*)"
        "Bash(printenv:*)"
        "Bash(printf:*)"
        "Bash(ps:*)"
        "Bash(pwd)"
        "Bash(rg:*)"
        "Bash(sort:*)"
        "Bash(stat:*)"
        "Bash(strings:*)"
        "Bash(tail:*)"
        "Bash(top)"
        "Bash(tree:*)"
        "Bash(type:*)"
        "Bash(uname:*)"
        "Bash(uniq:*)"
        "Bash(uptime)"
        "Bash(wc:*)"
        "Bash(where:*)"
        "Bash(which:*)"
        "Bash(whoami)"
        "Bash(xxd:*)"
        "Bash(gemini:*)"
        "Bash(sheldon lock:*)"
        "Bash(sheldon info:*)"
        "Bash(mise outdated:*)"
        "Bash(mise list-remote:*)"
        "Bash(mise plugins:*)"
        "Bash(mise settings:*)"
        "Bash(mise tasks:*)"
        "Bash(mise env:*)"
        "Bash(nix flake show:*)"
        "Bash(nix flake metadata:*)"
        "Bash(nix flake check:*)"
        "Bash(nix search:*)"
        "Bash(nix eval:*)"
        "Bash(nix show-config)"
        "Bash(nix doctor)"
        "Bash(nix-store --query:*)"
        "Bash(nix store info:*)"
        "Bash(nix path-info:*)"
        "Bash(nix why-depends:*)"
        "Bash(nix log:*)"
        "Bash(nix derivation show:*)"
        "Bash(nix-env --query:*)"
        "Bash(nix fmt -- --check:*)"
        "Bash(nix run nix-darwin -- build:*)"
        "mcp__github__get_code_scanning_alert"
        "mcp__github__get_commit"
        "mcp__github__get_file_contents"
        "mcp__github__get_issue"
        "mcp__github__get_issue_comments"
        "mcp__github__get_me"
        "mcp__github__get_notification_details"
        "mcp__github__get_pull_request"
        "mcp__github__get_pull_request_comments"
        "mcp__github__get_pull_request_diff"
        "mcp__github__get_pull_request_files"
        "mcp__github__get_pull_request_reviews"
        "mcp__github__get_pull_request_status"
        "mcp__github__get_secret_scanning_alert"
        "mcp__github__get_tag"
        "mcp__github__list_branches"
        "mcp__github__list_code_scanning_alerts"
        "mcp__github__list_commits"
        "mcp__github__list_issues"
        "mcp__github__list_notifications"
        "mcp__github__list_pull_requests"
        "mcp__github__list_secret_scanning_alerts"
        "mcp__github__list_tags"
        "mcp__github__list_workflow_runs"
        "mcp__github__search_code"
        "mcp__github__search_issues"
        "mcp__github__search_repositories"
        "mcp__github__search_users"
        "mcp__ide__getDiagnostics"
        "mcp__serena__get_current_config"
        "mcp__serena__list_dir"
        "mcp__serena__get_symbols_overview"
        "mcp__serena__find_file"
        "mcp__serena__find_symbol"
        "mcp__serena__search_for_pattern"
        "mcp__serena__think_about_collected_information"
        "mcp__serena__list_memories"
        "mcp__serena__read_memory"
        "mcp__serena__activate_project"
        "mcp__serena__check_onboarding_performed"
      ];

      statusLine = {
        type = "command";
        command = "mise x -- ccusage statusline";
      };
    };

    mcpServers = {
      github = {
        type = "http";
        url = "https://api.githubcopilot.com/mcp/";
        headers.Authorization = "Bearer \${GITHUB_MCP_TOKEN}";
      };

      serena = {
        type = "stdio";
        command = lib.getExe' pkgs.uv "uvx";
        args = [
          "--from"
          "git+https://github.com/oraios/serena"
          "serena"
          "start-mcp-server"
          "--context"
          "ide-assistant"
          "--enable-web-dashboard"
          "false"
        ];
        env = { };
      };
    };
  };

  home = {
    # Set environment variable for GitHub MCP token from agenix secret
    sessionVariables.GITHUB_MCP_TOKEN = "$(${lib.getExe' pkgs.coreutils "cat"} ${config.age.secrets.github-token.path})";

    # Declaratively manage Claude Code skills using home.file
    #
    # NOTE: Cannot use programs.claude-code.skills with fetchFromGitHub
    #
    # The home-manager module uses lib.isPath and lib.pathIsDirectory to determine
    # whether to create a directory (.claude/skills/{name}/) or file (.claude/skills/{name}.md).
    #
    # However, fetchFromGitHub results are NOT recognized as path types:
    # - fetchFromGitHub returns a derivation (set type)
    # - String concatenation (derivation + "/subdir") produces string type
    # - builtins.path also results in string type (even though it copies to store)
    # - lib.isPath returns false for all of the above
    # - Therefore, skills from fetchFromGitHub are ALWAYS treated as .md files
    #
    # This is a limitation of the home-manager module implementation, which only
    # supports local filesystem paths (./path or /path literals).
    #
    # Workaround: Use home.file directly with recursive = true
    file = {
      ".claude/skills/writing-documentation" = {
        source = ccconfigs + "/essentials/skills/writing-documentation";
        recursive = true;
      };
      ".claude/skills/markdown-standards" = {
        source = awesome-claude-code + "/.claude/skills/markdown-standards";
        recursive = true;
      };
      ".claude/skills/skill-creator" = {
        source = anthropic-skills + "/skills/skill-creator";
        recursive = true;
      };
      ".claude/skills/writing-japanese-documents" = {
        source = ./skills/writing-japanese-documents;
        recursive = true;
      };
      ".claude/skills/code-quality-standards" = {
        source = ./skills/code-quality-standards;
        recursive = true;
      };
      ".claude/skills/research-and-information-gathering" = {
        source = ./skills/research-and-information-gathering;
        recursive = true;
      };
      ".claude/skills/git-operations" = {
        source = ./skills/git-operations;
        recursive = true;
      };
    };
  };
}
