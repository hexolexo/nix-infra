{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    nix-index
  ];
  home.sessionVariables = {
    EDITOR = "vim";
    GOPATH = "${config.home.homeDirectory}/.go";
    OBSIDIAN_USE_WAYLAND = "1";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.go/bin"
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      neovim = "nvim";
      cd = "z";
      ls = "eza";
      nrs = "sudo -v && sudo nixos-rebuild switch --flake '/home/hexolexo/Programming/sysadmin/nix-infra#hexolexo' |& nom";
    };
    interactiveShellInit = ''
        set -gx EDITOR nvim
        function man
            nvim -c "Man $argv" -c "only"
        end
        function replay
            set -l cmd (history | ${pkgs.highlight}/bin/highlight --syntax=bash --out-format=ansi | ${pkgs.fzf}/bin/fzf --ansi --header='Select command to replay')
            if test -n "$cmd"
                set cmd (string replace -ra '\e\[[0-9;]*m' ''' $cmd)
                commandline $cmd
            end
        end
      function man
          nvim -c "Man $argv" -c "only"
      end
      function z
          set results (zoxide query --list $argv 2>/dev/null)
          if test (count $results) -eq 1
              cd $results[1]
          else
              zi $argv
      end
    '';
  };
  programs.pay-respects = {
    enable = true;
    enableFishIntegration = true;
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
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = "auto";
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
        # Needs connection timeouts
        compression = true;
      };
      "localgit" = {
        hostname = "server";
        port = 23231;
        user = "hexolexo";
        compression = true;
      };
    };
  };
  programs.starship = {
    enable = true;
    settings = {
      scan_timeout = 10;
    };
  };
  programs.zoxide = {
    enable = true;
  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "hexolexo";
      user.email = "hexolexo132@proton.me";
      core.sshCommand = "ssh -i ~/.ssh/id_ed25519";
      core.fsmonitor = true;
      core.untrackedcache = true;
    };
  };
}
