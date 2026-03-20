#!/usr/bin/env python3
"""
Detect the current coding agent environment.

Checks environment variables to identify which coding agent is running,
and returns the corresponding headless execution command.

Usage:
    python scripts/detect_env.py

Output: JSON with agent info  (example shown for opencode)

    {
      "agent": "opencode",
      "headless_command": "opencode run",
      "env_var": "OPENCODE",
      "subagent_support": true,
      "browser_support": false
    }

Supported agents:
    Claude Code  - CLAUDECODE (any value)  -> claude -p
    opencode     - OPENCODE   (any value)  -> opencode run
    Amp          - AGENT=amp               -> amp -x
    Goose        - AGENT=goose             -> goose run --text
    Codex CLI    - AGENT=codex             -> codex exec

Exit codes:
    0 - Agent detected or unknown (always succeeds; check "agent" field)
    1 - Python version error

Requires: Python 3.11+
"""

import json
import os
import sys

if sys.version_info < (3, 11):
    print(
        json.dumps(
            {
                "error": "Python 3.11+ required",
                "current_version": f"{sys.version_info.major}.{sys.version_info.minor}",
            }
        )
    )
    sys.exit(1)

# Agent detection table (checked in order; first match wins)
# Each entry: (env_var, env_value_or_None, agent, headless_command, subagent_support, browser_support)
# env_value_or_None: None = variable exists with any value, str = must equal this value
_AGENT_TABLE = [
    # env_var        expected_value  agent          headless_cmd          subagent  browser
    ("CLAUDECODE",   None,           "claude-code",  "claude -p",          True,     True),
    ("OPENCODE",     None,           "opencode",     "opencode run",       True,     False),
    ("AGENT",        "amp",          "amp",          "amp -x",             True,     False),
    ("AGENT",        "goose",        "goose",        "goose run --text",   False,    False),
    ("AGENT",        "codex",        "codex",        "codex exec",         False,    False),
]

_UNKNOWN = {
    "agent": "unknown",
    "headless_command": None,
    "env_var": None,
    "subagent_support": False,
    "browser_support": False,
}


def detect_env() -> dict:
    """
    Detect the current coding agent by inspecting environment variables.

    Returns a dict with the following fields:
        agent            (str)  - Agent identifier, or "unknown"
        headless_command (str|None) - Command prefix for headless execution,
                                     e.g. "claude -p".  None if unknown.
        env_var          (str|None) - Environment variable that matched.
        subagent_support (bool) - Whether the agent supports parallel subagents.
        browser_support  (bool) - Whether the agent can open a browser
                                  (False means use --static / static HTML output).
    """
    for env_var, expected_value, agent, headless_cmd, subagent, browser in _AGENT_TABLE:
        actual = os.environ.get(env_var)
        if actual is None:
            continue
        if expected_value is None or actual == expected_value:
            return {
                "agent": agent,
                "headless_command": headless_cmd,
                "env_var": env_var,
                "subagent_support": subagent,
                "browser_support": browser,
            }

    return dict(_UNKNOWN)


def main() -> None:
    result = detect_env()
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
