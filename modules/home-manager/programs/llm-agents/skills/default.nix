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
        "socratic-sparring"
        "structured-agents-md"
        "task-reporting"
      ];
      # Skills with external dependencies
      explicit = {
        bootstrap-solo-sprint = {
          from = "local";
          packages = with pkgs; [
            gh
            jq
          ];
        };
        create-backlog-item = {
          from = "local";
          packages = with pkgs; [
            gh
            jq
          ];
        };
        gh-reference = {
          from = "local";
          packages = with pkgs; [ gh ];
        };
        issue-creator = {
          from = "local";
          packages = with pkgs; [
            gh
            glab
          ];
        };
        ja-writing = {
          from = "local";
          packages = with pkgs; [
            nodejs_22
            pnpm
          ];
        };
        jj-reference = {
          from = "local";
          packages = with pkgs; [ jujutsu ];
        };
        markdown-standards = {
          from = "local";
          packages = with pkgs; [
            nodejs_22
            markdownlint-cli2
          ];
        };
        plan-sprint = {
          from = "local";
          packages = with pkgs; [
            gh
            jq
          ];
        };
        register-project = {
          from = "local";
          packages = with pkgs; [
            gh
            jq
          ];
        };
        retrospect-sprint = {
          from = "local";
          packages = with pkgs; [
            gh
            jq
          ];
        };
        review-sprint = {
          from = "local";
          packages = with pkgs; [
            gh
            jq
          ];
        };
        show-backlog = {
          from = "local";
          packages = with pkgs; [
            gh
            jq
          ];
        };
        skill-creator = {
          from = "local";
          packages = with pkgs; [
            (python3.withPackages (ps: [ ps.pyyaml ]))
          ];
        };
        solo-sprint-spec = {
          from = "local";
        };
      };
    };
    targets.claude.enable = true;
  };
}
