-- File tree in a sidebar: <leader>n toggles it, \ reveals the current file.
-- Icons follow vim.g.have_nerd_font (set in init.lua): without a Nerd Font the
-- glyphs would render as boxes, so plain ASCII is used instead.

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

local nerd = vim.g.have_nerd_font

require('neo-tree').setup {
  close_if_last_window = true,
  popup_border_style = 'rounded',
  default_component_configs = {
    icon = nerd and {} or {
      folder_closed = '+',
      folder_open = '-',
      folder_empty = 'o',
      default = ' ',
    },
    git_status = nerd and {} or {
      symbols = {
        added = 'A',
        modified = 'M',
        deleted = 'D',
        renamed = 'R',
        untracked = '?',
        ignored = 'I',
        unstaged = 'U',
        staged = 'S',
        conflict = '!',
      },
    },
  },
  filesystem = {
    follow_current_file = { enabled = true },
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      never_show = { '.git' },
    },
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}

vim.keymap.set('n', '<leader>n', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle file tree [N]eo-tree', silent = true })
vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })
