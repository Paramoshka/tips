# Neovim as an IDE (C / Go / Python / Lua / Helm)

Full config lives in [`config/`](config/) — copy it to `~/.config/nvim` and start `nvim`.
Plugins are managed by lazy.nvim; versions are pinned in `config/lazy-lock.json`.

Same config is used in [c-devbox](https://github.com/Paramoshka/c-devbox) (Docker dev container).

## What's inside

| Area | Plugin |
|------|--------|
| Plugin manager | lazy.nvim |
| Colorscheme | tokyonight (`moon`, higher contrast) |
| Picker, explorer, terminal, dashboard, notifications | snacks.nvim |
| LSP | native `vim.lsp.config` (Neovim 0.11) + nvim-lspconfig + mason |
| Completion | blink.cmp + friendly-snippets |
| Formatting | conform.nvim (format on save) |
| Syntax | nvim-treesitter + textobjects + context |
| Git | gitsigns.nvim, lazygit via snacks |
| Diagnostics panel | trouble.nvim |
| UI | lualine, bufferline, which-key |
| Editing | mini.pairs, mini.surround, mini.ai, flash.nvim, todo-comments + plenary |
| Helm templates | helm-ls.nvim + Helm LS + Helm/Go-template parsers |
| Go tests | neotest + neotest-golang (1.x) |
| Go debugging | nvim-dap (0.10.x), nvim-dap-go, nvim-dap-ui + Delve |
| Project search and replace | grug-far.nvim |
| Sessions / tasks | persistence.nvim / overseer.nvim |

LSP servers: `clangd`, `gopls`, `pyright`, `ruff`, `lua_ls`, `bashls`, `jsonls`, `yamlls`, `helm_ls`.
The config enables installed servers; optional language tools can be added later.
`nvim-dap` stays on 0.10.x and `neotest-golang` on 1.x to support Neovim 0.11.0
and the current Treesitter `master` grammars. Keep `lazy-lock.json` when copying.

The visual setup uses Tokyo Night Moon, darker side panels, clearer comments and
line numbers, underlined active tabs, and test/debug status in the statusline.
The dashboard includes recent projects and manual session restore.

## Requirements

- **Neovim 0.11+** (uses `vim.lsp.config` / `vim.lsp.enable`)
- `git`, `curl`, `unzip`, C compiler (`gcc`/`clang`) and `make` — for lazy.nvim, mason and treesitter parsers
- `ripgrep` — grep picker
- A **Nerd Font** in the terminal — see [`../KDE/konsole-nerd-font.md`](../KDE/konsole-nerd-font.md)

Ubuntu / Debian:

```bash
sudo apt install git curl unzip gcc make ripgrep python3-venv
```

Neovim 0.11 (AppImage, apt versions are usually older):

```bash
curl -LO https://github.com/neovim/neovim/releases/download/v0.11.0/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
```

### Language tools (install what you need)

Mason installs automatically: `lua-language-server`, `stylua`, `shfmt`,
`helm-ls`, `delve` (needs Go), `ruff` (needs `python3-venv`),
`bash-language-server` / `json-lsp` / `yaml-language-server` (need `npm`).
Install Helm separately for Helm LS; install Go to use Go tests and Delve.

The rest — manually:

```bash
# C / C++
sudo apt install clangd clang-format

# Go
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest

# Python types
npm install -g pyright        # or: :MasonInstall pyright

# Git UI (optional, <leader>gg)
# Install lazygit separately and make sure it is in PATH.
# See https://github.com/jesseduffield/lazygit#installation
```

## Install

```bash
# back up the current config and state
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null

git clone https://github.com/Paramoshka/tips.git /tmp/tips
cp -r /tmp/tips/Neovim/config ~/.config/nvim
nvim
```

On first start lazy.nvim installs plugins, mason installs tools, treesitter compiles parsers.
Wait until it finishes, then restart `nvim` once so the new LSP binaries are picked up.

Check health:

```vim
:checkhealth
:Lazy
:Mason
```

## Keymaps

Leader is `Space`. Press `Space` and wait — which-key shows everything.

### Files and search

| Keys | Action |
|------|--------|
| `<leader><space>` | find files (smart) |
| `<leader>ff` / `<leader>fr` | files / recent files |
| `<leader>fb` | open buffers |
| `<leader>/` | grep in project |
| `<leader>sw` | grep word under cursor |
| `<leader>e` | file explorer |
| `<leader>sk` | search keymaps |

### Buffers and windows

| Keys | Action |
|------|--------|
| `Shift+h` / `Shift+l` | prev / next buffer |
| `<leader>bd` / `<leader>bo` | close buffer / close others |
| `Ctrl+h/j/k/l` | move between windows |
| `<leader>-` / `<leader>\|` | split below / right |
| `Ctrl+/` | toggle terminal at the bottom |
| `Esc Esc`, then `Ctrl+h/j/k/l` | leave terminal input and move to another window |

### Code

| Keys | Action |
|------|--------|
| `gd` / `gr` / `gI` / `gy` | definition / references / implementation / type |
| `K` | hover docs |
| `<leader>ca` | code action |
| `<leader>cr` or `F2` | rename symbol |
| `<leader>cf` | format (auto on save, toggle `<leader>uf`) |
| `<leader>ch` | switch source/header (C) |
| `]d` / `[d`, `]e` / `[e` | next/prev diagnostic / error |
| `<leader>xx` | diagnostics panel |
| `<leader>cs` | symbols outline |
| `s` + 2 chars | flash jump |

### Git

| Keys | Action |
|------|--------|
| `]h` / `[h` | next / prev hunk |
| `<leader>ghs` / `<leader>ghr` | stage / reset hunk |
| `<leader>ghp` | preview hunk |
| `<leader>gb` | blame line |
| `<leader>gs` / `<leader>gl` | git status / log |
| `<leader>gg` | lazygit |

### Go tests and debugging

| Keys | Action |
|------|--------|
| `<leader>tt` / `<leader>tf` | nearest test / tests in the current file |
| `<leader>tl` / `<leader>tS` | rerun last / stop test |
| `<leader>ts` / `<leader>to` | test tree / test output |
| `<leader>tO` | combined test output panel |
| `<leader>td` | debug nearest test through Neotest |
| `F9` / `F5` | breakpoint / start or continue debugging |
| `F10` / `F11` / `F12` | step over / into / out |
| `<leader>dB` / `<leader>de` | conditional breakpoint / evaluate expression |
| `<leader>du` / `<leader>dq` | debug panels / terminate session |

Go tests use `-count=1 -timeout=60s`; adjust `go_test_args` for longer tests.
Discovery runs on demand rather than scanning every Go module in the background.
Ginkgo `Describe`/`It` specs need the project's own runner; this setup does not
provide a separate Ginkgo test tree. Go debugging requires Go and Delve;
C/C++ debug adapters are not configured.

### Replace, sessions and tasks

| Keys | Action |
|------|--------|
| `<leader>sp` | search and replace under the Git project root |
| `<leader>qs` / `<leader>qS` | restore / select session |
| `<leader>ql` / `<leader>qd` | last session / stop saving this session |
| `<leader>or` / `<leader>ot` | run project task / task panel |

In Grug Far, review the matches and use `\r` to replace (local leader is `\`).
Sessions save on exit after a file has been opened; restoration is manual.

### Helm diagnostics

Templates use `helm` filetype, Helm LS and Treesitter highlighting. Ordinary YAML
continues to use `yamlls`. The experimental YAML diagnostics inside Helm LS are
disabled because mutually exclusive template branches produce false duplicate-key
errors. Completion/hover and Helm lint remain enabled. Use the project's template
tests to validate rendered output. Inline diagnostic text is shown for the current
line; `<leader>xx` shows the full diagnostic panel.

## Update

```vim
:Lazy sync      " update plugins, then copy lazy-lock.json back to the repo
:MasonUpdate
:TSUpdate
```

See also: [`readable-theme-and-cursor.md`](readable-theme-and-cursor.md) — why the colors/cursor look the way they do.
