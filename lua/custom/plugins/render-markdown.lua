-- Renders markdown in the buffer: headings, tables, bullets, code blocks, quotes.
-- The cursor line shows the raw text. <leader>tm toggles rendering.
-- The defaults use Nerd Font glyphs; without one they are swapped for plain text.

vim.pack.add {
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim', version = vim.version.range '*' },
}

local opts = {}

if not vim.g.have_nerd_font then
  opts = {
    heading = { sign = false, icons = {} },
    code = { sign = false, language_icon = false },
    checkbox = { enabled = false },
    link = { enabled = false },
    callout = {
      note = { rendered = 'Note' },
      tip = { rendered = 'Tip' },
      important = { rendered = 'Important' },
      warning = { rendered = 'Warning' },
      caution = { rendered = 'Caution' },
    },
  }
end

require('render-markdown').setup(opts)

vim.keymap.set('n', '<leader>tm', '<Cmd>RenderMarkdown toggle<CR>', { desc = '[T]oggle [M]arkdown render', silent = true })
