# Neovim Debugging with nvim-dap & nvim-dap-view

This guide covers the debugging setup in your Neovim configuration. It's aimed at beginners new to debugging in Neovim.

## What is DAP?

**DAP** (Debug Adapter Protocol) is like LSP but for debugging - it allows Neovim to talk to debuggers. Both your editor and debugger need to support DAP.

## Prerequisites

### 1. Install codelldb (recommended for Rust)

codelldb provides the best Rust debugging experience with better type formatting:

```bash
# From VSCode Extension (recommended)
# Download codelldb-linux-x64.vsix from https://github.com/vadimcn/codelldb/releases
# Extract the adapter binary:
unzip codelldb-linux-x64.vsix -d codelldb-extract
cp codelldb-extract/extension/adapter/codelldb ~/.local/bin/
mkdir -p ~/.local/lldb/lib
cp -r codelldb-extract/extension/lldb/lib/* ~/.local/lldb/lib/
```

Or via your system package manager (if available):
```bash
# Arch Linux
yay -S codelldb-bin

# Or use Mason in Neovim (requires Mason):
:MasonInstall codelldb
```

### 2. Or install lldb-dap (simpler alternative)

```bash
# Ubuntu/Debian
sudo apt install lldb-dap

# macOS
brew install lldb

# Verify
which lldb-dap
```

### 3. Rust project setup

In your `Cargo.toml`, ensure debug symbols are enabled:

```toml
[profile.dev]
debug = true
```

## Quick Start

1. Open a Rust file in your project
2. Press `<leader>db` to toggle a breakpoint
3. Press `<leader>dc` to start debugging (continue)
4. Press `<leader>dv` to open DapView UI

## Keybindings

| Keybinding | Command | Description |
|------------|---------|-------------|
| `<leader>db` | `dap.toggle_breakpoint` | Toggle a breakpoint |
| `<leader>dc` | `dap.continue` | Start/continue debugging |
| `<leader>ds` | `dap.step_over` | Step over (next line) |
| `<leader>di` | `dap.step_into` | Step into (follow function calls) |
| `<leader>do` | `dap.step_out` | Step out (exit current function) |
| `<leader>dr` | `dap.restart` | Restart debug session |
| `<leader>dt` | `dap.terminate` | Stop debugging |
| `<leader>dv` | `:DapViewOpen` | Open the DapView UI |

## DapView UI

Once in a debugging session, run `:DapViewOpen` to open the visual debugger. It shows:

- **Scopes** - Variables in current context
- **Watches** - Custom expressions to monitor
- **Breakpoints** - All breakpoints
- **Threads** - Running threads
- **REPL** - Debugger console
- **Control bar** - Run/pause/step buttons (if enabled)

### Navigation

Use the **winbar** letters to switch views:
- **S** - Scopes
- **W** - Watches
- **B** - Breakpoints
- **T** - Threads
- **R** - REPL
- **C** - Console

Press `g?` to see all keymaps in any view.

### Control Bar Icons

The control bar shows clickable buttons for common actions when enabled:
- **Run** - Start/restart session
- **Pause** - Pause execution
- **Step** - Step over/into/out
- **Stop** - Terminate session

## Debugging Configurations

### Debug a binary

```bash
# Build with debug symbols
cargo build

# In Neovim:
# 1. Set breakpoint: <leader>db
# 2. Start: <leader>dc
# 3. Enter path to executable (default: target/debug/yourproject)
```

### Debug tests

```bash
# Set breakpoint in test file
# When starting, select "Debug tests" configuration
# Or manually:
cargo test --no-run
```

### Debug with arguments

Edit `lua/core/config_plugins/dap.lua` to add args:

```lua
dap.configurations.rust = {
    {
        name = 'Launch',
        type = 'codelldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        args = { '--arg1', 'value' },  -- Add your args here
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}
```

## REPL Commands

### codelldb commands:

```
# Print variable
print my_variable
frame variable my_variable

# List breakpoints
breakpoint list

# Continue execution
continue

# Backtrace
backtrace

# Navigate frames
frame select 0  # current
frame select 1  # caller
```

### lldb-dap commands:

```
# Print variable
frame variable my_variable

# List breakpoints
breakpoint list

# Continue
continue

# Backtrace
bt
```

## Troubleshooting

### "adapter not found" error

codelldb not in PATH:
```bash
# Verify
which codelldb
# Or use full path in config
```

### No source files shown

- Make sure you're in the project directory
- Check binary was compiled with debug symbols
- Try: `cargo build` (not `cargo build --release`)

### DapView not showing icons

- Install a Nerd Font (JetBrainsMono Nerd Font recommended)
- Enable control bar: `:DapViewOpen` then control bar should appear

### Debug session won't start

1. Check breakpoint was set
2. Verify executable path is correct
3. Try rebuilding: `cargo build`

### Common Issues

- **Error: adapter not configured** - Check adapter name in config matches
- **Error: executable not found** - Provide full path when prompted
- **No varables shown** - May need to step into code first

## Custom Configuration

Edit `lua/core/config_plugins/dap.lua`:

### Change adapter

```lua
-- Use lldb instead of codelldb
dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-dap',
    args = {},
}

dap.configurations.rust = {
    {
        name = 'Launch',
        type = 'lldb',  -- Changed
        -- ...
    },
}
```

### Add Python debugging

```lua
dap.adapters.python = {
    type = 'executable',
    command = 'debugpy',
    args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
    {
        name = 'Python: Current File',
        type = 'python',
        request = 'launch',
        program = '${file}',
        pythonPath = function()
            return vim.fn.exepath('python3')
        end,
    },
}
```

### Change keybindings

Edit keymaps in the config file:

```lua
vim.keymap.set('n', '<leader>dd', dap.continue, { desc = 'Start debug' })
```

## Related Files

- `lua/core/plugins.lua` - Plugin definitions (nvim-dap, nvim-dap-view)
- `lua/core/config_plugins/dap.lua` - DAP configuration