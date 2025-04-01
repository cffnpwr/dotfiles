local wezterm = require 'wezterm'
local act = wezterm.action
local keybind = {}

keybind.leader = { key = ",", mods = "CTRL", timeout_milliseconds = 2000 }
keybind.keys = {
  { key = 'LeftArrow',  mods = 'SUPER', action = act.SendKey { key = 'a', mods = 'CTRL' } },
  { key = 'Backspace',  mods = 'SUPER', action = act.SendKey { key = 'u', mods = 'CTRL' } },
  { key = 'RightArrow', mods = 'SUPER', action = act.SendKey { key = 'e', mods = 'CTRL' } },
  { key = 'Backspace', mods = 'ALT', action = act.SendKey { key = 'w', mods = 'CTRL' } },
  { key = 'DownArrow', mods = 'SUPER|SHIFT', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
  { key = 'UpArrow', mods = 'SUPER|SHIFT', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
  { key = 'RightArrow', mods = 'SUPER|SHIFT', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
  { key = 'LeftArrow', mods = 'SUPER|SHIFT', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
  { key = 'h', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'H', mods = 'SUPER|SHIFT', action = act.AdjustPaneSize{ 'Left', 1 } },
  { key = 'l', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'L', mods = 'SUPER|SHIFT', action = act.AdjustPaneSize{ 'Right', 1 } },
  { key = 'k', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'K', mods = 'SUPER|SHIFT', action = act.AdjustPaneSize{ 'Up', 1 } },
  { key = 'j', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection 'Down' },
  { key = 'J', mods = 'SUPER|SHIFT', action = act.AdjustPaneSize{ 'Down', 1 } },
}

return keybind
