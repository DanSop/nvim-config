-- Function / symbol outline in a sidebar: <leader>a toggles it.
-- Symbols come from the LSP when one is attached (clangd, lua_ls) and from
-- treesitter otherwise, so it works in any file with a parser.

vim.pack.add {
  'https://github.com/stevearc/aerial.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

require('aerial').setup {
  backends = { 'lsp', 'treesitter', 'markdown', 'man' },
  nerd_font = vim.g.have_nerd_font,
  layout = {
    default_direction = 'right',
    min_width = 28,
  },
  show_guides = true,
  highlight_on_hover = true,
  autojump = false,
  -- Keep the outline readable in big C files: declarations, not every local.
  filter_kind = {
    'Class',
    'Constructor',
    'Enum',
    'Function',
    'Interface',
    'Module',
    'Method',
    'Struct',
  },
  on_attach = function(bufnr)
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = 'Previous symbol' })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = 'Next symbol' })
  end,
}

vim.keymap.set('n', '<leader>a', '<Cmd>AerialToggle!<CR>', { desc = 'Toggle symbol outline [A]erial', silent = true })
vim.keymap.set('n', '<leader>o', '<Cmd>AerialNavToggle<CR>', { desc = 'Toggle Aerial nav p[O]pup', silent = true })
