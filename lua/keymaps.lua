-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Reap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap half page step with center cursor
vim.keymap.set({ 'n', 'v' }, '<C-k>', '20kzz')
vim.keymap.set({ 'n', 'v' }, '<C-j>', '20jzz')

-- Remap switch screen
vim.keymap.set({ 'n' }, '<C-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<C-l>', '<C-w>l')

-- Remap yank line
vim.keymap.set('n', 'Y', 'yy')

-- Remap delete line
vim.keymap.set('n', 'D', 'dd')

-- Exit from terminal mode
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Escape Escape exits terminal mode' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
