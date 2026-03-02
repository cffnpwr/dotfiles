{ ... }:
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false; # Managed by Sheldon

    settings = {
      default_layout = "compact";
      theme = "tokyo-night";
      pane_frames = false;

      keybinds._children = [
        {
          locked = {
            _children = [
              {
                bind = {
                  _args = [ "Ctrl g" ];
                  SwitchToMode = "Normal";
                };
              }
            ];
          };
        }

        {
          normal = {
            _children = [
              {
                bind = {
                  _args = [ "Ctrl f" ];
                  ToggleFloatingPanes = { };
                  SwitchToMode = "Normal";
                };
              }
            ];
          };
        }

        {
          resize = {
            _children = [
              {
                bind = {
                  _args = [ "Ctrl r" ];
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [
                    "h"
                    "Left"
                  ];
                  Resize = "Increase Left";
                };
              }
              {
                bind = {
                  _args = [
                    "j"
                    "Down"
                  ];
                  Resize = "Increase Down";
                };
              }
              {
                bind = {
                  _args = [
                    "k"
                    "Up"
                  ];
                  Resize = "Increase Up";
                };
              }
              {
                bind = {
                  _args = [
                    "l"
                    "Right"
                  ];
                  Resize = "Increase Right";
                };
              }
              {
                bind = {
                  _args = [ "H" ];
                  Resize = "Decrease Left";
                };
              }
              {
                bind = {
                  _args = [ "J" ];
                  Resize = "Decrease Down";
                };
              }
              {
                bind = {
                  _args = [ "K" ];
                  Resize = "Decrease Up";
                };
              }
              {
                bind = {
                  _args = [ "L" ];
                  Resize = "Decrease Right";
                };
              }
              {
                bind = {
                  _args = [
                    "="
                    "+"
                  ];
                  Resize = "Increase";
                };
              }
              {
                bind = {
                  _args = [ "-" ];
                  Resize = "Decrease";
                };
              }
            ];
          };
        }

        {
          pane = {
            _children = [
              {
                bind = {
                  _args = [ "Ctrl p" ];
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [
                    "h"
                    "Left"
                  ];
                  MoveFocus = "Left";
                };
              }
              {
                bind = {
                  _args = [
                    "l"
                    "Right"
                  ];
                  MoveFocus = "Right";
                };
              }
              {
                bind = {
                  _args = [
                    "j"
                    "Down"
                  ];
                  MoveFocus = "Down";
                };
              }
              {
                bind = {
                  _args = [
                    "k"
                    "Up"
                  ];
                  MoveFocus = "Up";
                };
              }
              {
                bind = {
                  _args = [
                    "Ctrl h"
                    "Ctrl Left"
                  ];
                  NewPane = "Left";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [
                    "Ctrl l"
                    "Ctrl Right"
                  ];
                  NewPane = "Right";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [
                    "Ctrl j"
                    "Ctrl Down"
                  ];
                  NewPane = "Down";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [
                    "Ctrl k"
                    "Ctrl Up"
                  ];
                  NewPane = "Up";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "p" ];
                  SwitchFocus = { };
                };
              }
              {
                bind = {
                  _args = [ "x" ];
                  CloseFocus = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "f" ];
                  ToggleFocusFullscreen = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "z" ];
                  TogglePaneFrames = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "w" ];
                  ToggleFloatingPanes = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "e" ];
                  TogglePaneEmbedOrFloating = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "c" ];
                  SwitchToMode = "RenamePane";
                  PaneNameInput = 0;
                };
              }
              {
                bind = {
                  _args = [ "i" ];
                  TogglePanePinned = { };
                  SwitchToMode = "Normal";
                };
              }
            ];
          };
        }

        {
          move = {
            _children = [
              {
                bind = {
                  _args = [ "Ctrl h" ];
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [
                    "n"
                    "Tab"
                  ];
                  MovePane = { };
                };
              }
              {
                bind = {
                  _args = [ "p" ];
                  MovePaneBackwards = { };
                };
              }
              {
                bind = {
                  _args = [
                    "h"
                    "Left"
                  ];
                  MovePane = "Left";
                };
              }
              {
                bind = {
                  _args = [
                    "j"
                    "Down"
                  ];
                  MovePane = "Down";
                };
              }
              {
                bind = {
                  _args = [
                    "k"
                    "Up"
                  ];
                  MovePane = "Up";
                };
              }
              {
                bind = {
                  _args = [
                    "l"
                    "Right"
                  ];
                  MovePane = "Right";
                };
              }
            ];
          };
        }

        {
          tab = {
            _children = [
              {
                bind = {
                  _args = [ "Ctrl t" ];
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "r" ];
                  SwitchToMode = "RenameTab";
                  TabNameInput = 0;
                };
              }
              {
                bind = {
                  _args = [
                    "h"
                    "Left"
                    "Up"
                    "k"
                  ];
                  GoToPreviousTab = { };
                };
              }
              {
                bind = {
                  _args = [
                    "l"
                    "Right"
                    "Down"
                    "j"
                  ];
                  GoToNextTab = { };
                };
              }
              {
                bind = {
                  _args = [ "n" ];
                  NewTab = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "x" ];
                  CloseTab = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "s" ];
                  ToggleActiveSyncTab = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "b" ];
                  BreakPane = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "]" ];
                  BreakPaneRight = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "[" ];
                  BreakPaneLeft = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "1" ];
                  GoToTab = 1;
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "2" ];
                  GoToTab = 2;
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "3" ];
                  GoToTab = 3;
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "4" ];
                  GoToTab = 4;
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "5" ];
                  GoToTab = 5;
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "6" ];
                  GoToTab = 6;
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "7" ];
                  GoToTab = 7;
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "8" ];
                  GoToTab = 8;
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "9" ];
                  GoToTab = 9;
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "Tab" ];
                  ToggleTab = { };
                };
              }
            ];
          };
        }

        {
          scroll = {
            _children = [
              {
                bind = {
                  _args = [ "Ctrl s" ];
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "e" ];
                  EditScrollback = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "s" ];
                  SwitchToMode = "EnterSearch";
                  SearchInput = 0;
                };
              }
              {
                bind = {
                  _args = [ "Ctrl c" ];
                  ScrollToBottom = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [
                    "j"
                    "Down"
                  ];
                  ScrollDown = { };
                };
              }
              {
                bind = {
                  _args = [
                    "k"
                    "Up"
                  ];
                  ScrollUp = { };
                };
              }
              {
                bind = {
                  _args = [
                    "Ctrl f"
                    "PageDown"
                    "Right"
                    "l"
                  ];
                  PageScrollDown = { };
                };
              }
              {
                bind = {
                  _args = [
                    "Ctrl b"
                    "PageUp"
                    "Left"
                    "h"
                  ];
                  PageScrollUp = { };
                };
              }
              {
                bind = {
                  _args = [ "d" ];
                  HalfPageScrollDown = { };
                };
              }
              {
                bind = {
                  _args = [ "u" ];
                  HalfPageScrollUp = { };
                };
              }
            ];
          };
        }

        {
          search = {
            _children = [
              {
                bind = {
                  _args = [ "Ctrl s" ];
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "Ctrl c" ];
                  ScrollToBottom = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [
                    "j"
                    "Down"
                  ];
                  ScrollDown = { };
                };
              }
              {
                bind = {
                  _args = [
                    "k"
                    "Up"
                  ];
                  ScrollUp = { };
                };
              }
              {
                bind = {
                  _args = [
                    "Ctrl f"
                    "PageDown"
                    "Right"
                    "l"
                  ];
                  PageScrollDown = { };
                };
              }
              {
                bind = {
                  _args = [
                    "Ctrl b"
                    "PageUp"
                    "Left"
                    "h"
                  ];
                  PageScrollUp = { };
                };
              }
              {
                bind = {
                  _args = [ "d" ];
                  HalfPageScrollDown = { };
                };
              }
              {
                bind = {
                  _args = [ "u" ];
                  HalfPageScrollUp = { };
                };
              }
              {
                bind = {
                  _args = [ "n" ];
                  Search = "down";
                };
              }
              {
                bind = {
                  _args = [ "p" ];
                  Search = "up";
                };
              }
              {
                bind = {
                  _args = [ "c" ];
                  SearchToggleOption = "CaseSensitivity";
                };
              }
              {
                bind = {
                  _args = [ "w" ];
                  SearchToggleOption = "Wrap";
                };
              }
              {
                bind = {
                  _args = [ "o" ];
                  SearchToggleOption = "WholeWord";
                };
              }
            ];
          };
        }

        {
          entersearch = {
            _children = [
              {
                bind = {
                  _args = [
                    "Ctrl c"
                    "Esc"
                  ];
                  SwitchToMode = "Scroll";
                };
              }
              {
                bind = {
                  _args = [ "Enter" ];
                  SwitchToMode = "Search";
                };
              }
            ];
          };
        }

        {
          renametab = {
            _children = [
              {
                bind = {
                  _args = [ "Ctrl c" ];
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "Esc" ];
                  UndoRenameTab = { };
                  SwitchToMode = "Tab";
                };
              }
            ];
          };
        }

        {
          renamepane = {
            _children = [
              {
                bind = {
                  _args = [ "Ctrl c" ];
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "Esc" ];
                  UndoRenamePane = { };
                  SwitchToMode = "Pane";
                };
              }
            ];
          };
        }

        {
          session = {
            _children = [
              {
                bind = {
                  _args = [ "Ctrl o" ];
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "Ctrl s" ];
                  SwitchToMode = "Scroll";
                };
              }
              {
                bind = {
                  _args = [ "d" ];
                  Detach = { };
                };
              }
              {
                bind = {
                  _args = [ "w" ];
                  LaunchOrFocusPlugin = {
                    _args = [ "session-manager" ];
                    floating = true;
                    move_to_focused_tab = true;
                  };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "c" ];
                  LaunchOrFocusPlugin = {
                    _args = [ "configuration" ];
                    floating = true;
                    move_to_focused_tab = true;
                  };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "p" ];
                  LaunchOrFocusPlugin = {
                    _args = [ "plugin-manager" ];
                    floating = true;
                    move_to_focused_tab = true;
                  };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "a" ];
                  LaunchOrFocusPlugin = {
                    _args = [ "zellij:about" ];
                    floating = true;
                    move_to_focused_tab = true;
                  };
                  SwitchToMode = "Normal";
                };
              }
            ];
          };
        }

        {
          tmux = {
            _children = [
              {
                bind = {
                  _args = [ "[" ];
                  SwitchToMode = "Scroll";
                };
              }
              {
                bind = {
                  _args = [ "Ctrl b" ];
                  Write = 2;
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "\"" ];
                  NewPane = "Down";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "%" ];
                  NewPane = "Right";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "z" ];
                  ToggleFocusFullscreen = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "c" ];
                  NewTab = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "," ];
                  SwitchToMode = "RenameTab";
                };
              }
              {
                bind = {
                  _args = [ "p" ];
                  GoToPreviousTab = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "n" ];
                  GoToNextTab = { };
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "Left" ];
                  MoveFocus = "Left";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "Right" ];
                  MoveFocus = "Right";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "Down" ];
                  MoveFocus = "Down";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "Up" ];
                  MoveFocus = "Up";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "h" ];
                  MoveFocus = "Left";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "l" ];
                  MoveFocus = "Right";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "j" ];
                  MoveFocus = "Down";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "k" ];
                  MoveFocus = "Up";
                  SwitchToMode = "Normal";
                };
              }
              {
                bind = {
                  _args = [ "o" ];
                  FocusNextPane = { };
                };
              }
              {
                bind = {
                  _args = [ "d" ];
                  Detach = { };
                };
              }
              {
                bind = {
                  _args = [ "Space" ];
                  NextSwapLayout = { };
                };
              }
              {
                bind = {
                  _args = [ "x" ];
                  CloseFocus = { };
                  SwitchToMode = "Normal";
                };
              }
            ];
          };
        }

        {
          shared_except = {
            _args = [ "locked" ];
            _children = [
              {
                bind = {
                  _args = [ "Ctrl g" ];
                  SwitchToMode = "Locked";
                };
              }
              {
                bind = {
                  _args = [ "Ctrl q" ];
                  Quit = { };
                };
              }
              {
                unbind = {
                  _args = [ "Alt f" ];
                };
              }
              {
                bind = {
                  _args = [ "Alt t" ];
                  ToggleFloatingPanes = { };
                };
              }
              {
                bind = {
                  _args = [ "Alt n" ];
                  NewPane = { };
                };
              }
              {
                bind = {
                  _args = [ "Alt i" ];
                  MoveTab = "Left";
                };
              }
              {
                bind = {
                  _args = [ "Alt o" ];
                  MoveTab = "Right";
                };
              }
              {
                unbind = {
                  _args = [
                    "Alt h"
                    "Alt Left"
                  ];
                };
              }
              {
                unbind = {
                  _args = [
                    "Alt l"
                    "Alt Right"
                  ];
                };
              }
              {
                unbind = {
                  _args = [
                    "Alt j"
                    "Alt Down"
                  ];
                };
              }
              {
                unbind = {
                  _args = [
                    "Alt k"
                    "Alt Up"
                  ];
                };
              }
              {
                bind = {
                  _args = [
                    "Alt ="
                    "Alt +"
                  ];
                  Resize = "Increase";
                };
              }
              {
                bind = {
                  _args = [ "Alt -" ];
                  Resize = "Decrease";
                };
              }
              {
                bind = {
                  _args = [ "Alt [" ];
                  PreviousSwapLayout = { };
                };
              }
              {
                bind = {
                  _args = [ "Alt ]" ];
                  NextSwapLayout = { };
                };
              }
            ];
          };
        }

        {
          shared_except = {
            _args = [
              "normal"
              "locked"
            ];
            _children = [
              {
                bind = {
                  _args = [
                    "Enter"
                    "Esc"
                  ];
                  SwitchToMode = "Normal";
                };
              }
            ];
          };
        }

        {
          shared_except = {
            _args = [
              "pane"
              "locked"
            ];
            _children = [
              {
                bind = {
                  _args = [ "Ctrl p" ];
                  SwitchToMode = "Pane";
                };
              }
            ];
          };
        }

        {
          shared_except = {
            _args = [
              "resize"
              "locked"
            ];
            _children = [
              {
                bind = {
                  _args = [ "Ctrl n" ];
                  SwitchToMode = "Resize";
                };
              }
            ];
          };
        }

        {
          shared_except = {
            _args = [
              "scroll"
              "locked"
            ];
            _children = [
              {
                bind = {
                  _args = [ "Ctrl s" ];
                  SwitchToMode = "Scroll";
                };
              }
            ];
          };
        }

        {
          shared_except = {
            _args = [
              "session"
              "locked"
            ];
            _children = [
              {
                bind = {
                  _args = [ "Ctrl o" ];
                  SwitchToMode = "Session";
                };
              }
            ];
          };
        }

        {
          shared_except = {
            _args = [
              "tab"
              "locked"
            ];
            _children = [
              {
                bind = {
                  _args = [ "Ctrl t" ];
                  SwitchToMode = "Tab";
                };
              }
            ];
          };
        }

        {
          shared_except = {
            _args = [
              "move"
              "locked"
            ];
            _children = [
              {
                bind = {
                  _args = [ "Ctrl h" ];
                  SwitchToMode = "Move";
                };
              }
            ];
          };
        }

        {
          shared_except = {
            _args = [
              "tmux"
              "locked"
            ];
            _children = [
              {
                bind = {
                  _args = [ "Ctrl b" ];
                  SwitchToMode = "Tmux";
                };
              }
            ];
          };
        }
      ];

      plugins = {
        tab-bar.location = "zellij:tab-bar";
        status-bar.location = "zellij:status-bar";
        strider.location = "zellij:strider";
        compact-bar.location = "zellij:compact-bar";
        session-manager.location = "zellij:session-manager";
        welcome-screen = {
          location = "zellij:session-manager";
          welcome_screen = true;
        };
        filepicker = {
          location = "zellij:strider";
          cwd = "/";
        };
        configuration.location = "zellij:configuration";
        plugin-manager.location = "zellij:plugin-manager";
        about.location = "zellij:about";
      };
    };
  };
}
