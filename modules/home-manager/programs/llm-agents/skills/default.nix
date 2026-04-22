{ pkgs, ... }:
{
  programs.agent-skills = {
    enable = true;
    sources.local = {
      path = ./.;
    };
    skills = {
      # Skills with no external dependencies
      enable = [
        "code-quality-standards"
        "problem-investigation"
        "research-and-information-gathering"
        "security-standards"
        "structured-agents-md"
        "task-reporting"
      ];
      # Skills with external dependencies
      explicit = {
        ja-writing = {
          from = "local";
          packages = with pkgs; [
            nodejs_22
            pnpm
          ];
        };
        markdown-standards = {
          from = "local";
          packages = with pkgs; [
            nodejs_22
            markdownlint-cli2
          ];
        };
        skill-creator = {
          from = "local";
          packages = with pkgs; [
            (python3.withPackages (ps: [ ps.pyyaml ]))
          ];
        };
        gh-reference = {
          from = "local";
          packages = with pkgs; [ gh ];
        };
        jj-reference = {
          from = "local";
          packages = with pkgs; [ jujutsu ];
        };
        issue-creator = {
          from = "local";
          packages = with pkgs; [
            gh
            glab
          ];
        };
      };
    };
    targets.claude.enable = true;
  };
}
