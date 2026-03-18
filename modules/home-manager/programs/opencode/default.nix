{
  pkgs,
  ...
}:
let # Fetch skill repositories
  ccconfigs = pkgs.fetchFromGitHub {
    owner = "dhruvbaldawa";
    repo = "ccconfigs";
    rev = "451b604718d39fcc2c008d22e550bdf60c7115da";
    hash = "sha256-7V1xG2FmzqWdnWmVV6WWKBAvY6QHWo+UKzh0Uu/Xg/w=";
  };
in
{
  programs.opencode = {
    enable = true;
    package = pkgs.llm-agents.opencode;
    enableMcpIntegration = true;

    # Global AGENTS.md memory
    rules = ./agents.md;

    settings = {
      permission = {
        # GitHub MCP tools: read-only operations are allowed, write operations require approval
        mcp_github_create_branch = "ask";
        mcp_github_create_or_update_file = "ask";
        mcp_github_create_pull_request = "ask";
        mcp_github_create_pull_request_with_copilot = "ask";
        mcp_github_create_repository = "ask";
        mcp_github_delete_file = "ask";
        mcp_github_fork_repository = "ask";
        mcp_github_issue_write = "ask";
        mcp_github_merge_pull_request = "ask";
        mcp_github_push_files = "ask";
        mcp_github_update_pull_request = "ask";
        mcp_github_update_pull_request_branch = "ask";
        mcp_github_assign_copilot_to_issue = "ask";
        mcp_github_add_comment_to_pending_review = "ask";
        mcp_github_add_issue_comment = "ask";
        mcp_github_add_reply_to_pull_request_comment = "ask";
        mcp_github_pull_request_review_write = "ask";
        mcp_github_sub_issue_write = "ask";

        # bash: VCS state-changing operations and gh write operations require approval
        bash = {
          # git write operations
          "git commit *" = "ask";
          "git push *" = "ask";
          "git branch *" = "ask";
          "git checkout *" = "ask";
          "git merge *" = "ask";
          "git rebase *" = "ask";
          "git reset *" = "ask";
          "git tag *" = "ask";

          # jj write operations
          "jj commit *" = "ask";
          "jj describe *" = "ask";
          "jj git push *" = "ask";
          "jj new *" = "ask";
          "jj bookmark *" = "ask";
          "jj bookmark list *" = "allow";
          "jj squash *" = "ask";
          "jj rebase *" = "ask";
          "jj abandon *" = "ask";

          # gh write operations
          "gh pr create *" = "ask";
          "gh pr merge *" = "ask";
          "gh pr close *" = "ask";
          "gh pr edit *" = "ask";
          "gh pr review *" = "ask";
          "gh issue create *" = "ask";
          "gh issue close *" = "ask";
          "gh issue edit *" = "ask";
          "gh repo create *" = "ask";
          "gh release create *" = "ask";
          "gh api -X POST *" = "ask";
          "gh api -X PUT *" = "ask";
          "gh api -X PATCH *" = "ask";
          "gh api -X DELETE *" = "ask";
          "gh api --method POST *" = "ask";
          "gh api --method PUT *" = "ask";
          "gh api --method PATCH *" = "ask";
          "gh api --method DELETE *" = "ask";
        };

        # External direcoties
        external_directory = {
          # allow tmp directories
          "/var/folders/**/tmp.*/**" = "allow";
          "/tmp/**" = "allow";
        };
      };
    };
  };

  home = {
    # Set environment variable to enable WebSearch tool in opencode
    sessionVariables.OPENCODE_ENABLE_EXA = "1";
  };

  # Declaratively manage OpenCode skills using xdg.configFile
  #
  # NOTE: Cannot use programs.opencode.skills with fetchFromGitHub
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
  xdg.configFile = {
    "opencode/skills/writing-documentation" = {
      source = ccconfigs + "/essentials/skills/writing-documentation";
      recursive = true;
    };
    "opencode/skills/markdown-standards" = {
      source = ./skills/markdown-standards;
      recursive = true;
    };
    "opencode/skills/skill-creator" = {
      source = ./skills/skill-creator;
      recursive = true;
    };
    "opencode/skills/ja-writing" = {
      source = ./skills/ja-writing;
      recursive = true;
    };
    "opencode/skills/code-quality-standards" = {
      source = ./skills/code-quality-standards;
      recursive = true;
    };
    "opencode/skills/research-and-information-gathering" = {
      source = ./skills/research-and-information-gathering;
      recursive = true;
    };
    "opencode/skills/structured-agents-md" = {
      source = ./skills/structured-agents-md;
      recursive = true;
    };
    "opencode/skills/jj-reference" = {
      source = ./skills/jj-reference;
      recursive = true;
    };
    "opencode/skills/problem-investigation" = {
      source = ./skills/problem-investigation;
      recursive = true;
    };
    "opencode/skills/gh-reference" = {
      source = ./skills/gh-reference;
      recursive = true;
    };
  };
}
