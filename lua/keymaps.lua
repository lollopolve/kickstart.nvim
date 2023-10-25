-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Reap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap half page step with center cursor
vim.keymap.set('n', '<C-k>', '<C-u>zz')
vim.keymap.set('n', '<C-j>', '<C-d>zz')

-- Remap start and end of code line
vim.keymap.set('n', '<C-h>', '^')
vim.keymap.set('n', '<C-l>', '$')

-- Remap yank line
vim.keymap.set('n', 'Y', 'yy')

-- Remap delete line
vim.keymap.set('n', 'D', 'dd')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
