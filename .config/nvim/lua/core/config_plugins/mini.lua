require("mini.starter").setup {}
require("mini.tabline").setup {}
require("mini.indentscope").setup {}
require("mini.trailspace").setup {}
require("mini.bracketed").setup {}
require("mini.pairs").setup {}
require("mini.icons").setup()
-- impersonate nvim-web-devicons for plugins that require it (vgit.nvim)
MiniIcons.mock_nvim_web_devicons()
require('mini.jump').setup()
require('mini.jump2d').setup()
require("mini.comment").setup()
require("mini.files").setup {
    -- options = { use_as_default_explorer = false },
}

require("mini.completion").setup {
    delay = { completion = 50, info = 50, signature = 20 },
}
require("mini.notify").setup {
    -- Notifications about LSP progress
    lsp_progress = {
        enable = false,
        duration_last = 500,
    },
    window = {
        max_width_share = 0.4,
        -- winblend = 25,
    },
}
require("mini.surround").setup {
    -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
    highlight_duration = 1000,
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
    },
    -- silent = true,
}


-- require("mini.sessions").setup {
--     directory = vim.fn.stdpath "config" .. "/sessions",
-- }
require("mini.snippets").setup {
    snippets = {
        { prefix = '#der', body = '#[derive(Debug, Clone, Default)]', desc = 'Derive common traits' },
        { prefix = '#ser', body = '#[derive(Debug, Clone, Default, Serialize, Deserialize)]', desc = 'Derive common & serde traits' },
        {
            prefix = '#test',
            body = '#[cfg(test)]\nmod tests{\n\tuse super::*;\n\n\t#[test]\n\tfn $0(){\n\t}\n}',
            desc = 'Create boilerplate test mod'
        },
        {
            prefix = '#rng',
            body = 'let mut rng = thread_rng();',
            desc = 'declare thread rng'
        },
        {
            prefix = '#deref',
            body = 'impl Deref for $1 {\n\ttype Target = $0;\n\n\tfn deref(&self) -> &Self::Target{\n\n\t}\n}\nimpl DerefMut for $1 {\n\tfn deref_mut(&mut self) -> &mut Self::Target{\n\n\t}\n}',
            desc = 'Deref and DerefMut impls'
        },

    },
    mappings = {
        -- Expand snippet at cursor position. Created globally in Insert mode.
        expand = '<C-i>',

        -- Interact with default `expand.insert` session.
        -- Created for the duration of active session(s)
        jump_next = 'L',
        jump_prev = 'H',
        stop = '<C-c>',
    },
}
MiniSnippets.start_lsp_server()

local minimap = require("mini.map")
minimap.setup {
    symbols = {
        -- - Line - '🮚', '▶'.
        -- - View - '╎', '┋', '┋'.
        scroll_line = '▶',
        scroll_view = '┋',
    },
    window = {
        show_integration_count = false,
        width = 7,
        winblend = 25,
        zindex = 10,
    },
}

-- Have some clue about what you are about to do. Awesome for learning nvim
local miniclue = require('mini.clue')
miniclue.setup({
    triggers = {
        -- Bracketed
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },

        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
    },

    clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
    },
    window = {
        delay = 300, -- Delay before showing clue window
        -- Keys to scroll inside the clue window
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
    },
})


-- Mini plugins key mappings
-- mini.map
vim.keymap.set('n', '<Leader>m', minimap.toggle, {desc = "map toggle"})
-- mini.files
vim.keymap.set('n', '<leader>b', MiniFiles.open, {desc = "open file tree"})
-- mini.completion
vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { noremap = true, expr = true })
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { noremap = true, expr = true })
vim.keymap.set('i', '<CR>', [[pumvisible() ? "\<C-y>" : "\<CR>"]], { noremap = true, expr = true })

-- grug-far fo mini.files
local files_grug_far_replace = function(path)
    -- works only if cursor is on the valid file system entry
    local cur_entry_path = MiniFiles.get_fs_entry().path
    local prefills = { paths = vim.fs.dirname(cur_entry_path) }
    local grug_far = require "grug-far"

    -- instance check
    if not grug_far.has_instance "explorer" then
        grug_far.open {
            instanceName = "explorer",
            prefills = prefills,
            staticTitle = "Find and Replace from Explorer",
        }
    else
        grug_far.get_instance('explorer'):open()
        -- updating the prefills without crealing the search and other fields
        grug_far.get_instance('explorer'):update_input_values(prefills, false)
    end
end

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
        vim.keymap.set("n", "gs", files_grug_far_replace, { buffer = args.data.buf_id, desc = "Search in directory" })
    end,
})
