{ ... }:
{
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

  home.file.".config/waybar/scripts/battery.sh" = {
    source = ./scripts/battery.sh;
    executable = true;
  };
  home.file.".config/waybar/scripts/music.sh" = {
    source = ./scripts/music.sh;
    executable = true;
  };
}
