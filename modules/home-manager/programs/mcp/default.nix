{
  config,
  pkgs,
  ...
}:
{
  programs.mcp = {
    enable = true;

    servers = {
      github = {
        type = "http";
        url = "https://api.githubcopilot.com/mcp/";
        headers.Authorization = "Bearer {env:GITHUB_MCP_TOKEN}";
      };

      serena = {
        type = "stdio";
        command = "${pkgs.uv}/bin/uvx";
        args = [
          "--from"
          "git+https://github.com/oraios/serena"
          "serena"
          "start-mcp-server"
          "--project-from-cwd"
          "--context"
          "claude-code"
          "--enable-web-dashboard"
          "false"
        ];
      };
    };
  };

  home = {
    # Set environment variable for GitHub MCP token from agenix secret
    sessionVariables.GITHUB_MCP_TOKEN = "$(${pkgs.coreutils}/bin/cat ${config.age.secrets.github-token.path})";
  };
}
