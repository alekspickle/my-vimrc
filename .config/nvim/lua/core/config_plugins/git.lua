-- vgit.nvim
local vgit = require('vgit')

vgit.setup({
    settings = {
        live_blame = { enabled = false },
    },
})

-- hunks (C-j/C-k taken by move-lines)
vim.keymap.set('n', ']h', vgit.hunk_down, { desc = "next hunk" })
vim.keymap.set('n', '[h', vgit.hunk_up, { desc = "prev hunk" })
vim.keymap.set('n', '<leader>gp', vgit.buffer_hunk_preview, { desc = "hunk preview" })
vim.keymap.set('n', '<leader>gs', vgit.buffer_hunk_stage, { desc = "hunk stage" })
vim.keymap.set('n', '<leader>gr', vgit.buffer_hunk_reset, { desc = "hunk reset" })
-- buffer
vim.keymap.set('n', '<leader>gd', vgit.buffer_diff_preview, { desc = "buffer diff" })
vim.keymap.set('n', '<leader>gh', vgit.buffer_history_preview, { desc = "buffer history" })
vim.keymap.set('n', '<leader>gb', vgit.buffer_blame_preview, { desc = "line blame" })
vim.keymap.set('n', '<leader>gS', vgit.buffer_stage, { desc = "stage buffer" })
vim.keymap.set('n', '<leader>gU', vgit.buffer_unstage, { desc = "unstage buffer" })
vim.keymap.set('n', '<leader>gR', vgit.buffer_reset, { desc = "reset buffer to HEAD" })
-- project
vim.keymap.set('n', '<leader>gD', vgit.project_diff_preview, { desc = "project diff/status" })
vim.keymap.set('n', '<leader>gc', vgit.project_commit_preview, { desc = "git commit" })
vim.keymap.set('n', '<leader>gC', vgit.project_commits_preview, { desc = "list commits" })
vim.keymap.set('n', '<leader>gl', vgit.project_logs_preview, { desc = "git log" })
vim.keymap.set('n', '<leader>gz', vgit.project_stash_preview, { desc = "stash" })
-- merge conflicts
vim.keymap.set('n', '<leader>go', vgit.buffer_conflict_accept_current, { desc = "conflict: accept ours" })
vim.keymap.set('n', '<leader>gi', vgit.buffer_conflict_accept_incoming, { desc = "conflict: accept theirs" })
vim.keymap.set('n', '<leader>ga', vgit.buffer_conflict_accept_both, { desc = "conflict: accept both" })
-- toggles
vim.keymap.set('n', '<leader>gtx', vgit.toggle_diff_preference, { desc = "toggle split/unified diff" })
vim.keymap.set('n', '<leader>gtb', vgit.toggle_live_blame, { desc = "toggle live blame" })
vim.keymap.set('n', '<leader>gtg', vgit.toggle_live_gutter, { desc = "toggle gutter signs" })
-- vgit has no push/pull, shell fallback
vim.keymap.set('n', '<leader>gP', '<cmd>!git push<cr>', { desc = "git push" })
vim.keymap.set('n', '<leader>gF', '<cmd>!git pull<cr>', { desc = "git pull" })
