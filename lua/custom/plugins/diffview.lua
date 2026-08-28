vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }
require('diffview').setup {}

vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = '[G]it [D]iff view' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<cr>', { desc = '[G]it [H]istory' })
vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<cr>', { desc = '[G]it diff [C]lose' })
