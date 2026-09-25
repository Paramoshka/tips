# Neovim: readable colors and a thin cursor

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
            c.comment = "#7f8bb8"
            c.fg_gutter = "#545c7e"
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
        end,
    },
    config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd.colorscheme("tokyonight")
    end,
},
```

## Thin cursor

`lua/config/options.lua`:

```lua
-- Thin bar cursor everywhere; insert mode blinks, replace mode is an underline
vim.opt.guicursor = "n-v-c-sm:ver25,i-ci-ve:ver25-blinkwait300-blinkon500-blinkoff400,r-cr-o:hor20"
```

- The actual bar width is drawn by the terminal; `ver25` vs `ver10` look the same in Konsole.
- To keep a block in Normal mode: `n-v-c-sm:block`.

## Buffer navigation cheatsheet

| Keys | Action |
|------|--------|
| `Shift+h` / `Shift+l` | prev / next buffer (`:bprevious` / `:bnext`) |
| `Ctrl+^` | toggle last buffer |
| `:b <name>` | jump by part of the file name |
| `:ls` | list buffers |
