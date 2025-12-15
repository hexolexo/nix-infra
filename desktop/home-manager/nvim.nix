{...}: {
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };

    plugins = {
      oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          delete_to_trash = true;
          skip_confirm_for_simple_edits = true;
          view_options = {
            show_hidden = true;
          };
        };
      };
      lualine.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          gopls.enable = true;
          bashls.enable = true;
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<cr>";
        options.desc = "Open parent directory";
      }
      {
        mode = "n";
        key = "<leader>pf";
        action.__raw = ''
          function()
               require('telescope.builtin').find_files()
             end
        '';
      }
    ];
    extraConfigLua = ''
      vim.o.timeoutlen = 500
            vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '
                local builtin = require('telescope.builtin')

            vim.keymap.set('n', '<leader>ps', function()
              builtin.grep_string({ search = vim.fn.input('Grep > ') })
            end, { desc = '[P]roject [S]earch' })
              local keymap = vim.keymap.set
              keymap('n', 'n', 'h', { noremap = true })
              keymap('n', 'e', 'k', { noremap = true })
              keymap('n', 'i', 'j', { noremap = true })
              keymap('n', 'o', 'l', { noremap = true })
              keymap('n', 'h', 'b', { noremap = true })
              keymap('n', "'", 'e', { noremap = true })
              keymap('n', ',', 'o', { noremap = true })

              keymap('v', 'n', 'h', { noremap = true })
              keymap('v', 'e', 'k', { noremap = true })
              keymap('v', 'i', 'j', { noremap = true }) -- Error is happening here
              keymap('v', 'o', 'l', { noremap = true })
              keymap('v', 'h', 'b', { noremap = true })
              keymap('v', "'", 'e', { noremap = true })
              keymap('v', ',', 'o', { noremap = true })

              keymap('n', ';', 'p', { noremap = true })
              keymap('n', 'u', 'i', { noremap = true })
              keymap('n', 'l', 'u', { noremap = true })

              -- Include uppercase
              keymap('n', 'U', 'I', { noremap = true })
    '';
  };
}
