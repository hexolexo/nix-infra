{ ... }:
{
  programs.nixvim = {
    enable = true;
    opts = {
      number = true;
      termguicolors = true;
      relativenumber = true;
    };

    clipboard.providers.wl-copy.enable = true;
    globals.mapleader = " ";
    globals.maplocalleader = " ";
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
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "super-tab";
          };
          sources.default = [
            "lsp"
            "path"
            "buffer"
          ];
        };
      };
      plugins.todo-comments.enable = true;
      web-devicons.enable = true;
      lualine.enable = true;
      telescope.enable = true;
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      lsp = {
        enable = true;
        servers = {
          nil.enable = true;
          gopls.enable = true;
          bashls.enable = true;
        };
      };
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            go = [
              "gofmt"
              "goimports"
            ];
            nix = [ "nixfmt" ];
            bash = [ "shfmt" ];
          };
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
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
      {
        mode = "n";
        key = "<leader>s";
        action = "[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]";
      }
    ];
    extraConfigLua = ''
      vim.opt.termguicolors = true
      vim.opt.clipboard = 'unnamedplus'
      vim.o.timeoutlen = 500
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
