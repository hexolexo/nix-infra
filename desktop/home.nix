{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./home-manager/nvim.nix
  ];
  home.stateVersion = "25.11";

  home.sessionVariables = {
    EDITOR = "nvim";
    GOPATH = "${config.home.homeDirectory}/.go";
    OBSIDIAN_USE_WAYLAND = "1";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.go/bin"
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      neovim = "nvim";
      cd = "z";
    };
    interactiveShellInit = ''
      function man
          nvim -c "Man $argv" -c "wincmd k" -c "q"
      end

      function replay
          set -l cmd (history | ${pkgs.highlight}/bin/highlight --syntax=bash --out-format=ansi | ${pkgs.fzf}/bin/fzf --ansi --header='Select command to replay')
          if test -n "$cmd"
              set cmd (string replace -ra '\e\[[0-9;]*m' ''' $cmd)
              commandline $cmd
          end
      end
    '';
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        controlMaster = "auto";
        controlPath = "~/.ssh/control-%r@%h:%p";
        controlPersist = "600";
      };
      "server" = {
        port = 6000;
        user = "hexolexo";
        compression = true;
      };
      "localgit" = {
        hostname = "server";
        port = 23231;
        user = "hexolexo";
        compression = true;
      };
      "localhost" = {
        extraOptions = {
          UserKnownHostsFile = "/dev/null";
        };
      };
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "hexolexo";
      user.email = "hexolexo132@proton.me";
    };
  };

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "rebuild" (builtins.readFile ./../rebuild.sh))
    fzf
    highlight
  ];

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 20;
        margin-bottom = 0;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "custom/music"
          "pulseaudio"
          "network"
          "custom/temp"
          "custom/battery"
        ];

        clock = {
          format = "{:%I:%M %p}";
          tooltip-format = "{:%A, %d %B %Y}";
          on-click = "wl-copy \"$(date +'%I:%M %p - %A, %d %B %Y')\"";
        };

        "custom/battery" = {
          exec = "~/.config/waybar/scripts/battery.sh";
          interval = 5;
          format = "{}";
        };

        "custom/music" = {
          exec = "~/.config/waybar/scripts/music.sh";
          format = "{}";
          on-click = "mpc toggle";
        };

        "custom/temp" = {
          exec = "printf '%d°C' $(($(</sys/class/thermal/thermal_zone3/temp) / 1000))";
          interval = 5;
          format = "{}";
        };

        network = {
          format-wifi = "{essid} | {signalStrength}%";
          format-ethernet = "Wired";
          format-disconnected = "Disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };
      };
    };

    style = ''
      * {
          font-family: monospace;
          font-size: 13px;
      }

      window#waybar {
          background: transparent;
          color: #B4A6BB;
      }

      #clock, #pulseaudio, #network, #custom-battery, #custom-music, #custom-temp{
          background: rgba(41, 45, 61, 0.3);
          padding: 0 12px;
          margin: 2px;
          border-radius: 8px;
      }

      #workspaces {
          background: rgba(41, 45, 61, 0.3);
          padding: 4px 4px;
          margin: 4px;
          border-radius: 8px;
      }
      #workspaces button {
          padding: 2px 2px;
          min-width: 16px;
          min-height: 16px;
          margin: 2px;
      }
      #workspaces button.active {
          background: rgba(236, 93, 66, 0.4);
          color: #B4A6BB;
      }
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "FiraCode Nerd Font";
        size = 12;
      };

      cursor.style = "Beam";

      mouse.hide_when_typing = true;

      env.TERM = "xterm-256color";

      colors = {
        primary = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
          dim_foreground = "#CDD6F4";
          bright_foreground = "#CDD6F4";
        };

        cursor = {
          text = "#1E1E2E";
          cursor = "#F5E0DC";
        };

        vi_mode_cursor = {
          text = "#1E1E2E";
          cursor = "#B4BEFE";
        };

        search = {
          matches = {
            foreground = "#1E1E2E";
            background = "#A6ADC8";
          };
          focused_match = {
            foreground = "#1E1E2E";
            background = "#A6E3A1";
          };
        };

        footer_bar = {
          foreground = "#1E1E2E";
          background = "#A6ADC8";
        };

        hints = {
          start = {
            foreground = "#1E1E2E";
            background = "#F9E2AF";
          };
          end = {
            foreground = "#1E1E2E";
            background = "#A6ADC8";
          };
        };

        selection = {
          text = "#1E1E2E";
          background = "#F5E0DC";
        };

        normal = {
          black = "#45475A";
          red = "#F38BA8";
          green = "#A6E3A1";
          yellow = "#F9E2AF";
          blue = "#89B4FA";
          magenta = "#F5C2E7";
          cyan = "#94E2D5";
          white = "#BAC2DE";
        };

        bright = {
          black = "#585B70";
          red = "#F38BA8";
          green = "#A6E3A1";
          yellow = "#F9E2AF";
          blue = "#89B4FA";
          magenta = "#F5C2E7";
          cyan = "#94E2D5";
          white = "#A6ADC8";
        };

        dim = {
          black = "#45475A";
          red = "#F38BA8";
          green = "#A6E3A1";
          yellow = "#F9E2AF";
          blue = "#89B4FA";
          magenta = "#F5C2E7";
          cyan = "#94E2D5";
          white = "#BAC2DE";
        };

        indexed_colors = [
          {
            index = 16;
            color = "#FAB387";
          }
          {
            index = 17;
            color = "#F5E0DC";
          }
        ];
      };
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "alacritty";
        font = "FiraCode Nerd Font:size=12";
      };
      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        match = "89b4faff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        selection-match = "89b4faff";
        border = "89b4faff";
      };
      border = {
        width = 2;
        radius = 8;
      };
    };
  };
  home.file.".config/waybar/scripts/battery.sh" = {
    source = ./scripts/battery.sh;
    executable = true;
  };
  home.file.".config/waybar/scripts/music.sh" = {
    source = ./scripts/music.sh;
    executable = true;
  };
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      modules = [
        "title"
        "separator"
        "os"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "display"
        "de"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "localip"
        "poweradapter"
        "locale"
        "break"
        "colors"
      ];
    };
  };
}
