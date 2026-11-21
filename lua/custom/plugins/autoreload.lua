-- Reloads buffers when their file changes on disk (AI agent, git, formatters),
-- also while nvim has no focus: a timer runs :checktime on the visible buffers.
-- 'autoread' reloads a buffer without edits. A buffer with unsaved edits is
-- never touched, it only gets a warning, and :w still asks before overwriting.

vim.o.autoread = true

local group = vim.api.nvim_create_augroup('custom-autoreload', { clear = true })
local pending, level = {}, vim.log.levels.INFO

local function report()
  vim.notify(vim.fn.strcharpart(table.concat(pending, ', '), 0, vim.o.columns - 20), level)
  pending, level = {}, vim.log.levels.INFO
end

-- One line per batch, warnings first, cut to the screen width: no "Press ENTER"
-- after a git checkout.
local function note(buf, what, warn)
  if #pending == 0 then vim.schedule(report) end
  table.insert(pending, warn and 1 or #pending + 1, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t') .. ' ' .. what)
  if warn then level = vim.log.levels.WARN end
end

-- Runs when nvim cannot just reload: unsaved edits, or the file is gone.
-- Leaving v:fcs_choice empty keeps the buffer and skips the blocking prompt.
vim.api.nvim_create_autocmd('FileChangedShell', {
  group = group,
  callback = function(ev)
    local deleted = vim.v.fcs_reason == 'deleted'
    if vim.v.fcs_reason == 'conflict' then
      note(ev.buf, 'not reloaded (unsaved edits)', true)
    elseif deleted and not vim.b[ev.buf].autoreload_deleted then
      note(ev.buf, 'deleted on disk', true)
    end
    vim.b[ev.buf].autoreload_deleted = deleted or nil
  end,
})

-- A buffer opened before its file existed gets a blocking question (W13) from
-- :checktime once the file appears, so the timer leaves those alone.
vim.api.nvim_create_autocmd('BufNewFile', {
  group = group,
  callback = function(ev) vim.b[ev.buf].autoreload_new = true end,
})
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
  group = group,
  callback = function(ev)
    vim.b[ev.buf].autoreload_new = nil
    vim.b[ev.buf].autoreload_deleted = nil
  end,
})

vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = group,
  callback = function(ev)
    if not vim.b[ev.buf].autoreload_new then note(ev.buf, 'reloaded') end
  end,
})

local function check()
  local mode = vim.api.nvim_get_mode().mode
  -- Not in the command line or a prompt, not halfway a mapping or an autocommand.
  if mode:find '^[cr!]' or vim.fn.getcmdwintype() ~= '' or vim.fn.state 'mx' ~= '' then return end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if not vim.b[buf].autoreload_new then vim.cmd('silent! checktime ' .. buf) end
  end
end

local timer = assert(vim.uv.new_timer())
timer:start(
  1000,
  1000,
  vim.schedule_wrap(function()
    local ok, err = pcall(check)
    if ok then return end
    timer:stop()
    vim.notify('autoreload stopped: ' .. err, vim.log.levels.ERROR)
  end)
)
