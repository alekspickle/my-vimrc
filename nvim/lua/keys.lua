--[[ keys.lua ]]
local map = vim.api.nvim_set_keymap

-- mode: the mode you want the key bind to apply to (e.g., insert mode, normal mode, command mode, visual mode).
-- sequence: the sequence of keys to press.
-- command: the command you want the keypresses to execute.
-- options: an optional Lua table of options to configure (e.g., silent or noremap).

-- alacritty + zellij + nvim are not perfect in unicode handling not even sure this helps
-- it is an attempt to get Ctrl + Tab switch buffers working, and they do
-- but I'm not sure if it's the one that helps and at this point I'm too afraid to remove it
-- if vim.env.TERM == 'alacritty' then
--   vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
--   vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
-- end

-- remap the key used to leave insert mode
map('i', 'jk', '', {})

-- intuitive copy in visual mode
map('v', '<C-c>', '"+y', { noremap = true })
-- Toggle plugin stuff
-- Tree toggle
map('n', '<C-b>', [[:NvimTreeToggle<cr>]], {})
-- vim.keymap.set("n", "<C-b>", ":Neotree filesystem reveal left<CR>", {})
-- vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
-- map('n', 'L', [[:IndentLinesToggle<cr>]], {})
-- map('n', 't', [[:TagbarToggle<cr>]], {})

-- Telescope setup
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

-- Rust compile
-- map('n', '<C-r>', [[:FloatermNew --height=0.6 --width=0.4 --wintype=float --name=floaterm1 --position=topleft --autoclose=2 ranger --cmd="echo lol"]], {})

-- Buffer switch
map('n', '<C-i>', [[:bn<cr>]], {})
-- map('n', 'S-i', [[:bp<cr>]], {})
--map('n', 'cs-Right', [[:bn<cr>]], {})
--map('n', 'cs-Left', [[:bp<cr>]], {})
