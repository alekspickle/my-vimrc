-- for small setups of plugins

-- undo-tree
vim.keymap.set('n', '<leader>u', vim.cmd.Undotree, {desc = "toggle undo tree"})

-- enable no-neck-pain on enter
-- require('no-neck-pain').setup{ autocmds = { enableOnVimEnter = true } }
