# Neovim Debugging with nvim-dap & nvim-dap-view

DAP (Debug Adapter Protocol) is like LSP but for debugging - lets Neovim talk to debuggers.

## Prerequisites

### codelldb (recommended for Rust — better type formatting)

```bash
# From VSCode extension
# Download codelldb-linux-x64.vsix from https://github.com/vadimcn/codelldb/releases
unzip codelldb-linux-x64.vsix -d codelldb-extract
cp codelldb-extract/extension/adapter/codelldb ~/.local/bin/
mkdir -p ~/.local/lldb/lib
cp -r codelldb-extract/extension/lldb/lib/* ~/.local/lldb/lib/

# Or: yay -S codelldb-bin  /  :MasonInstall codelldb
```

### lldb-dap (simpler alternative)

```bash
sudo apt install lldb-dap   # Ubuntu/Debian
brew install lldb           # macOS
which lldb-dap              # verify
```

### Rust project

```toml
# Cargo.toml
[profile.dev]
debug = true
```

## Keybindings

| Key | Command | Description |
|---|---|---|
| `<leader>pb` | `dap.toggle_breakpoint` | Toggle breakpoint |
| `<leader>pc` | `dap.continue` | Start/continue |
| `<leader>ps` | `dap.step_over` | Step over |
| `<leader>pi` | `dap.step_into` | Step into |
| `<leader>po` | `dap.step_out` | Step out |
| `<leader>pr` | `dap.restart` | Restart session |
| `<leader>pt` | `dap.terminate` | Stop session |
| `<leader>pv` | `:DapViewOpen` | Open DapView UI |

## Quick start

1. Open a Rust file, `<leader>pb` to set a breakpoint
2. `<leader>pc` to start — prompts for path to executable (default `target/debug/<project>`), or pick "Debug tests" to run `cargo test --no-run` first
3. `<leader>pv` to open DapView

## DapView UI

Winbar letters switch panes: **S**copes, **W**atches, **B**reakpoints, **T**hreads, **R**EPL, **C**onsole. `g?` for keymaps in any pane. Control bar (if enabled) gives clickable run/pause/step/stop.

No icons showing → install a Nerd Font (JetBrainsMono Nerd Font recommended).

## REPL commands

Both adapters: `frame variable <name>`, `breakpoint list`, `continue`, backtrace (`backtrace` codelldb / `bt` lldb-dap), `frame select N` to navigate frames.
codelldb also accepts plain `print <name>`.

## Troubleshooting

- **adapter not found** — `which codelldb` / `which lldb-dap`; not in PATH → use full path in adapter config
- **no source shown / can't find file** — run nvim from project root; rebuild with `cargo build` (not `--release`)
- **adapter not configured** — adapter name in `dap.adapters.*` must match `type` used in `dap.configurations.*`
- **no variables shown** — step into code first
- **executable not found** at launch prompt — give the full path

## Customize

Edit `lua/core/config_plugins/dap.lua`:

```lua
-- switch default adapter to lldb-dap
dap.configurations.rust[1].type = 'lldb'

-- add args to the Launch config
dap.configurations.rust[1].args = { '--arg1', 'value' }

-- add a language
dap.adapters.python = { type = 'executable', command = 'debugpy', args = { '-m', 'debugpy.adapter' } }
dap.configurations.python = {{
    name = 'Python: Current File', type = 'python', request = 'launch',
    program = '${file}', pythonPath = function() return vim.fn.exepath('python3') end,
}}
```

## Related files

- `lua/core/plugins.lua` — plugin specs (nvim-dap, nvim-dap-view)
- `lua/core/config_plugins/dap.lua` — adapters, configurations, keymaps
