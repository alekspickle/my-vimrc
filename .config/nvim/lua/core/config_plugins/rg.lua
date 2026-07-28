local grug = require('grug-far')
local opts = {
    transient = true,
    -- extra args that you always want to pass to rg
    extraArgs = '',
    -- whether to start in insert mode,
    -- startInInsertMode = false,
    -- row in the window to position the cursor at at start
    startCursorRow = 3,

    -- shortcuts for the actions you see at the top of the buffer
    -- set to '' to unset. Unset mappings will be removed from the help header
    -- They are all mappings for both insert and normal mode except for gotoLocation
    -- which is normal mode only. The distinction is mostly due to how they tend to
    -- be used and in order to show something that is not too busy-looking in the help menu
    keymaps = {
        -- normal and insert mode
        replace = '<leader>p',
        syncLocations = '<leader>o',
        -- normal mode only
        gotoLocation = '<leader>l',
    },

    -- separator between inputs and results, default depends on nerdfont
    resultsSeparatorLineChar = '',

    -- spinner states, default depends on nerdfont, set to false to disable
    spinnerStates = {
        '󱑋 ', '󱑌 ', '󱑍 ', '󱑎 ', '󱑏 ', '󱑐 ', '󱑑 ', '󱑒 ', '󱑓 ', '󱑔 ', '󱑕 ', '󱑖 '
    },

    -- icons for UI, default ones depend on nerdfont
    -- set individul ones to '' to disable, or set enabled = false for complete disable
    icons = {
        -- whether to show icons
        enabled = true,

        searchInput = ' ',
        replaceInput = ' ',
        filesFilterInput = ' ',
        flagsInput = '󰮚 ',

        resultsStatusReady = '󱩾 ',
        resultsStatusError = ' ',
        resultsStatusSuccess = '󰗡 ',
        resultsActionMessage = '  '
    },

    -- strings to auto-fill in each input area at start
    -- those are not necessarily useful as global defaults but quite useful as overrides
    -- when lauching through the lua api. For example, this is how you would lauch grug-far.nvim
    -- with the current word under the cursor as the search string
    --
    -- require('grug-far').grug_far({ prefills = { search = vim.fn.expand("<cword>") } })
    --
    prefills = {
        search = vim.fn.expand("<cword>"),
        replacement = "",
        filesFilter = "",
        flags = ""
    }
}

grug.setup(opts)

-- instance name = current working directory's basename
local function instance_name()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
end

-- toggle grug-far instance for this directory (open/hide, keeps state)
vim.keymap.set('n', 'gs', function()
    grug.toggle_instance({ instanceName = instance_name() })
end, { desc = 'Grug-far: toggle instance' })

-- open/focus, prefilled with word under cursor
vim.keymap.set('n', 'gsw', function()
    local name = instance_name()
    local word = vim.fn.expand('<cword>')
    local inst = grug.get_instance(name)
    if inst then
        inst:open()
        inst:update_input_values({ search = word }, true)
    else
        grug.open({ instanceName = name, prefills = { search = word } })
    end
end, { desc = 'Grug-far: search word under cursor' })

-- open/focus, prefilled with visual selection (creates instance if missing)
vim.keymap.set('v', 'gs', function()
    local name = instance_name()
    if grug.has_instance(name) then
        local selection = grug.get_current_visual_selection(true)
        local inst = grug.get_instance(name)
        inst:open()
        inst:update_input_values({ search = selection }, true)
    else
        grug.with_visual_selection({ instanceName = name })
    end
end, { desc = 'Grug-far: search visual selection' })

-- close instance for this directory
vim.keymap.set('n', 'gsq', function()
    grug.kill_instance(instance_name())
end, { desc = 'Grug-far: close instance' })
