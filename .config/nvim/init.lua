vim.loader.enable()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("core.options")
require("core.keymaps")
require("core.plugins")
require("core.config_plugins")
