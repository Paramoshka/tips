# Neovim: readable colors and mode-aware cursor

Tweaks for [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) (lazy.nvim spec)
when code feels hard to read: softer background, brighter comments, no italics.
Pair it with a Nerd Font in the terminal — see `KDE/konsole-nerd-font.md`.

## Colorscheme

`lua/plugins/ui.lua`:

```lua
{
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        style = "moon", -- softer than "night"
        -- Italic comments render thin in most terminal fonts; keep everything upright
        styles = { comments = { italic = false }, keywords = { italic = false } },
        -- Default palette is low-contrast: lift comments, gutter and selection
        on_colors = function(c)
            c.comment = "#9aa5c4"
            c.fg_gutter = "#69739a"
            c.bg_sidebar = "#1b1e2d"
            c.bg_float = "#1b1e2d"
            c.border_highlight = c.blue
            c.bg_visual = "#33467c"
        end,
        on_highlights = function(hl, c)
            hl.LineNr = { fg = c.fg_gutter }
            hl.LineNrAbove = { fg = c.fg_gutter }
            hl.LineNrBelow = { fg = c.fg_gutter }
            hl.CursorLineNr = { fg = c.orange, bold = true }
            hl.LspInlayHint = { fg = c.dark5, bg = c.bg_highlight }
            hl.MatchParen = { fg = c.orange, bold = true, underline = true }
            hl.Whitespace = { fg = c.bg_highlight }
            hl.WinSeparator = { fg = c.fg_gutter, bg = c.bg }
            hl.FloatTitle = { fg = c.blue, bold = true }
            hl.SnacksPickerTitle = { fg = c.blue, bold = true }
            hl.SnacksPickerInputBorder = { fg = c.blue, bg = c.bg_float }
            hl.Directory = { fg = c.comment }
            hl.SnacksPickerDirectory = { fg = c.comment }
            hl.SnacksPickerDir = { fg = c.comment }
            hl.SnacksPickerTree = { fg = c.fg_gutter }
            hl.SnacksPickerListCursorLine = { bg = c.bg_visual, bold = true }
            hl.TreesitterContext = { bg = c.bg_float }
            hl.TreesitterContextBottom = { sp = c.fg_gutter, underline = true }
        end,
    },
    config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd.colorscheme("tokyonight")
    end,
},
```

## Mode-aware cursor

`lua/config/options.lua`:

```lua
-- Make Normal mode easy to distinguish from Insert mode.
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25-blinkwait300-blinkon500-blinkoff400,r-cr-o:hor20"
```

- The actual bar width is drawn by the terminal; `ver25` vs `ver10` look the same in Konsole.
- Normal mode uses a visible block; Insert uses a blinking bar, Replace an underline.

## Quieter project navigation

The Explorer uses a compact input with a bottom border, muted directory names,
and a highlighted selected row. Hidden files are visible by default; `H` toggles
them, `I` toggles ignored files, and `Z` collapses directories.

Start Neovim from the project root. The statusline shows the current directory
name, a shortened Git branch and the relative file path. LSP names and percentage
progress are omitted; test and debug status appear when available.

`<Space>fe` reveals the current file in the Explorer.

## Buffer navigation cheatsheet

| Keys | Action |
|------|--------|
| `Shift+h` / `Shift+l` | prev / next buffer (`:bprevious` / `:bnext`) |
| `Ctrl+^` | toggle last buffer |
| `:b <name>` | jump by part of the file name |
| `:ls` | list buffers |
