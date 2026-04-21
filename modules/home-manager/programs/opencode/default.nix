{
  pkgs,
  ...
}:
{
  programs.opencode = {
    enable = true;
    package = pkgs.llm-agents.opencode;
    enableMcpIntegration = true;

    context = import ../llm-agents/agents-md.nix;

    settings = {
      permission = {
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

  xdg.configFile."opencode/docs" = {
    source = ../llm-agents/docs;
    recursive = true;
  };
}
