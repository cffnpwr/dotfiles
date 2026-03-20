{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code;
    enableMcpIntegration = true;
    memory.source = import ../llm-agents/agents-md.nix;

    settings.permissions = {
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
      ];
    };
  };
}
