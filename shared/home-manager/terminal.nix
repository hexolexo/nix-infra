{
  pkgs,
  config,
  ...
}: {
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
}
