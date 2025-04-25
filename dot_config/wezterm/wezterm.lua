-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.automatically_reload_config = true

-- startup
config.default_prog = { "/bin/zsh", "-l", "-c", "zellij attach wezterm --create" }

-- key binds
local keybind = require("keybinds")
config.keys = keybind.keys
config.leader = keybind.leader

-- color
config.color_scheme = 'Tokyo Night'
config.window_background_opacity = 0.9

-- font
config.font = wezterm.font_with_fallback({
  { family = "0xProto Nerd Font", weight = "Regular" },
  { family = "Koruri", weight = "Regular" }
})
config.font_size = 13.0
config.line_height = 1.0
config.cell_width = 1.0

-- window size
config.initial_cols = 192
config.initial_rows = 64

-- tab bar
config.enable_tab_bar = false

-- and finally, return the configuration to wezterm
return config
