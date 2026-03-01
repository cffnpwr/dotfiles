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

    settings = { };
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
