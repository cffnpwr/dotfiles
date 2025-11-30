{
  zen-browser,
  ...
}:
let
  mkExtensionSettings = builtins.mapAttrs (
    _: pluginId: {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
      installation_mode = "force_installed";
    }
  );
in
{
  imports = [
    zen-browser.homeModules.default
  ];

  programs.zen-browser = {
    enable = true;

    # Policies for custom extension installation (not in firefox-addons)
    policies.ExtensionSettings = mkExtensionSettings {
      "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}" = "youtube_addon";
      "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = "auto-tab-discard";
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden";
      "clipper@obsidian.md" = "web-clipper-obsidian";
      "simple-translate@sienori" = "simple-translate";
      "uBlock0@raymondhill.net" = "ublock-origin";
    };

    profiles = {
      default = {
        name = "Default (release)";
        isDefault = true;

        # Zen Workspaces (Spaces) - declarative management
        spaces = {
          space = {
            name = "Space";
            id = "1e9b5412-c41f-47bc-82cf-41248b19ad46";
            position = 1000;
            icon = "chrome://browser/skin/zen-icons/selectable/cafe.svg";
            container = 1;
            theme = {
              type = "gradient";
              opacity = 0.339;
              rotation = null;
              texture = 0.0;
              colors = [
                {
                  red = 197;
                  green = 175;
                  blue = 233;
                  custom = false;
                  algorithm = "analogous";
                  primary = true;
                  lightness = 80;
                  position.x = 172;
                  position.y = 103;
                  type = "explicit-lightness";
                }
                {
                  red = 237;
                  green = 171;
                  blue = 228;
                  custom = false;
                  algorithm = "analogous";
                  primary = false;
                  lightness = 80;
                  position.x = 222;
                  position.y = 128;
                  type = "explicit-lightness";
                }
                {
                  red = 176;
                  green = 192;
                  blue = 232;
                  custom = false;
                  algorithm = "analogous";
                  primary = false;
                  lightness = 80;
                  position.x = 120;
                  position.y = 124;
                  type = "explicit-lightness";
                }
              ];
            };
          };
          tmcit = {
            name = "tmcit";
            id = "e3594164-6dfc-4450-8073-3a25ab5c9f11";
            position = 2000;
            icon = "chrome://browser/skin/zen-icons/selectable/school.svg";
            container = 2;
            theme = {
              type = "gradient";
              opacity = 0.362;
              rotation = null;
              texture = 0.0;
              colors = [
                {
                  red = 76;
                  green = 230;
                  blue = 204;
                  custom = false;
                  algorithm = "analogous";
                  primary = true;
                  lightness = 60;
                  position.x = 138;
                  position.y = 189;
                  type = "explicit-lightness";
                }
                {
                  red = 80;
                  green = 163;
                  blue = 226;
                  custom = false;
                  algorithm = "analogous";
                  primary = false;
                  lightness = 60;
                  position.x = 133;
                  position.y = 158;
                  type = "explicit-lightness";
                }
                {
                  red = 68;
                  green = 238;
                  blue = 79;
                  custom = false;
                  algorithm = "analogous";
                  primary = false;
                  lightness = 60;
                  position.x = 164;
                  position.y = 206;
                  type = "explicit-lightness";
                }
              ];
            };
          };
        };

        # Zen Pins - declarative management
        pins = {
          # === Container 1 (Space workspace) - Essential Pins ===
          submarin = {
            id = "2af105b4-6c89-40cd-aa49-1a81b42344ac";
            url = "https://submarin.online/";
            container = 1;
            position = 0;
            isEssential = true;
          };
          youtube = {
            id = "e0ee94d5-2560-45c8-9ca3-37995a77c132";
            url = "https://www.youtube.com/";
            container = 1;
            position = 1;
            isEssential = true;
          };
          personal-mail = {
            id = "ae95b3cd-33af-493f-aca0-96e39009e9ef";
            url = "https://mail.google.com/mail/u/0/#inbox";
            container = 1;
            position = 2;
            isEssential = true;
          };
          github = {
            id = "e04d0b68-e2a4-4577-a300-fdae82a49260";
            url = "https://github.com/";
            container = 1;
            position = 3;
            isEssential = true;
          };
          calendar = {
            title = "Google カレンダー";
            id = "63c76868-9bee-440f-8609-1aedcac43dd7";
            url = "https://calendar.google.com/calendar/u/0/r?pli=1";
            container = 1;
            position = 4;
            isEssential = true;
          };
          messages = {
            title = "Google メッセージ";
            id = "8266cc43-a0f4-4173-9161-4cf8d7822e11";
            url = "https://messages.google.com/web/conversations";
            container = 1;
            position = 5;
            isEssential = true;
          };

          # === Container 2 (tmcit workspace) - Essential Pins ===
          gnumbers = {
            id = "3ed02d85-2992-4884-a3f2-8f31efa10975";
            url = "https://webcit-5.edu.metro-cit.ac.jp/gnumbers/33729";
            container = 2;
            position = 0;
            isEssential = true;
          };
          tmcit-mail = {
            id = "1b2a46a9-c134-4118-9db4-84d40333ddf7";
            url = "https://mail.google.com/mail/u/0/#inbox";
            container = 2;
            position = 1;
            isEssential = true;
          };
        };

        settings = {
          # Accessibility
          "accessibility.typeaheadfind.flashBar" = 0;

          # UI Preferences
          "border-shadow-disabled" = true;
          "tab-shadow-enabled" = true;

          # Privacy & Security
          "browser.contentblocking.category" = "standard";
          "privacy.donottrackheader.enabled" = true;
          "privacy.globalprivacycontrol.was_ever_enabled" = true;
          "privacy.history.custom" = true;
          "privacy.clearOnShutdown_v2.formdata" = true;
          "signon.rememberSignons" = false;

          # Network & Performance
          "network.dns.disablePrefetch" = true;
          "network.http.speculative-parallel-limit" = 0;
          "network.prefetch-next" = false;
          "network.proxy.type" = 0; # 0 = No proxy, change if needed
          "network.trr.mode" = 5;
          "network.trr.excluded-domains" = "metro-cit.ac.jp";

          # Downloads
          "browser.download.lastDir" = "/Users/cffnpwr/Downloads";
          "browser.download.panel.shown" = true;
          "browser.download.viewableInternally.typeWasRegistered.avif" = true;
          "browser.download.viewableInternally.typeWasRegistered.jxl" = true;
          "browser.download.viewableInternally.typeWasRegistered.webp" = true;

          # Bookmarks
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.bookmarks.showMobileBookmarks" = false;

          # Search
          "browser.search.region" = "JP";
          "browser.search.suggest.enabled" = true;
          "browser.search.suggest.enabled.private" = true;
          "browser.urlbar.placeholderName" = "Google";

          # New Tab
          "browser.newtabpage.pinned" =
            ''[{"url":"https://amazon.com","label":"@amazon","searchTopSite":true}]'';

          # Locale
          "intl.locale.requested" = "ja,en-US";

          # Fonts
          "font.name.monospace.ja" = "0xProto Nerd Font Mono";
          "font.name.sans-serif.ja" = "Koruri";

          # Developer Tools
          "devtools.toolbox.host" = "right";
          "devtools.toolbox.sidebar.width" = 696;
          "devtools.toolbox.splitconsole.open" = true;

          # Extensions
          "extensions.formautofill.creditCards.enabled" = false;

          # Zen-specific UI settings
          "zen.view.compact" = true;
          "zen.view.compact.enable-at-startup" = true;
          "zen.view.sidebar-expanded" = true;
          "zen.view.use-single-toolbar" = true;
          "zen.welcome-screen.seen" = true;
          "zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = true;
          "zen.site-data-panel.show-callout" = false;
          "zen.swipe.is-fast-swipe" = false;

          # Zen UI customization
          "user-browser-scale" = "0.98";
          "user-tab-movement" = "2%";
          "user-tab-radius" = "8px";
          "user-browser-ease-reset" = "0.2, 1.4, 0.3, 1";
          "user-browser-ease-swipe" = "0.3, 1.2, 0.5, 1";

          # Zen Cleaner URL Bar Mod
          "mod.cleanedurlbar.customcolor" = "hsl(0 0 10)";
          "mod.cleanedurlbar.customselectcolor" = "rgba(80, 80, 250, 0.75)";
          "mod.cleanedurlbar.customselectfontcolor" = "rgba(255,255,255,1)";
          "mod.cleanedurlbar.customtransparency" = "40%";

          # Better Find Bar Theme
          "theme.better_find_bar.hide_find_status" = false;
          "theme.better_find_bar.hide_found_matches" = false;
          "theme.better_find_bar.hide_highlight" = "not_hide";
          "theme.better_find_bar.hide_match_case" = "not_hide";
          "theme.better_find_bar.hide_match_diacritics" = "not_hide";
          "theme.better_find_bar.hide_whole_words" = "not_hide";
          "theme.better_find_bar.horizontal_position" = "default";
          "theme.better_find_bar.textbox_width" = "800";
          "theme.better_find_bar.transparent_background" = true;
          "theme.better_find_bar.vertical_position" = "default";

          # Sidebar
          "sidebar.visibility" = "hide-sidebar";

          # Migration tracking
          "browser.migration.version" = 160;
        };

        # User preferences (user.js equivalent)
        extraConfig = ''
          // Zen Browser Custom Settings
          user_pref("browser.startup.homepage", "about:home");
          user_pref("browser.urlbar.suggest.searches", true);
        '';
      };
    };
  };
}
