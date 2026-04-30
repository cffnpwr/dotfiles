{
  config,
  pkgs,
  ...
}:
{
  programs.mcp = {
    enable = true;

    servers = {
      deepwiki = {
        type = "http";
        url = "https://mcp.deepwiki.com/mcp";
      };
    };
  };

  home = {
    # Set environment variable for GitHub MCP token from agenix secret
    sessionVariables.GITHUB_MCP_TOKEN = "$(${pkgs.coreutils}/bin/cat ${config.age.secrets.github-token.path})";
  };
}
