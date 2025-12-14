{
  config,
  pkgs,
  ...
}: {
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
        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["custom/music" "pulseaudio" "network" "custom/temp" "custom/battery"];

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
  home.file.".config/waybar/scripts/battery.sh" = {
    source = ./scripts/battery.sh;
    executable = true;
  };
  home.file.".config/waybar/scripts/music.sh" = {
    source = ./scripts/music.sh;
    executable = true;
  };
}
