return {
    -- Colorscheme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "moon",
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

    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                theme = "auto",
                globalstatus = true,
                section_separators = "",
                component_separators = "",
                disabled_filetypes = { statusline = { "snacks_dashboard" } },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = {
                    { "filename", path = 1, symbols = { modified = " ●", readonly = " \u{f023}" } },
                },
                lualine_x = {
                    "diagnostics",
                    {
                        function()
                            local names = vim.tbl_map(function(c) return c.name end,
                                vim.lsp.get_clients({ bufnr = 0 }))
                            return #names > 0 and "\u{f085} " .. table.concat(names, ",") or ""
                        end,
                    },
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            extensions = { "lazy", "trouble", "quickfix" },
        },
    },

    -- Buffer tabs
    {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "VeryLazy",
        keys = {
            { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
            { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
            { "[b", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
            { "]b", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
        },
        opts = {
            options = {
                close_command = function(n) Snacks.bufdelete(n) end,
                right_mouse_command = function(n) Snacks.bufdelete(n) end,
                diagnostics = "nvim_lsp",
                always_show_bufferline = false,
                show_buffer_close_icons = false,
                offsets = {
                    { filetype = "snacks_layout_box", text = "", separator = true },
                },
            },
        },
    },

    -- Keymap hints
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
            spec = {
                { "<leader>b", group = "buffer" },
                { "<leader>c", group = "code" },
                { "<leader>f", group = "find" },
                { "<leader>g", group = "git" },
                { "<leader>gh", group = "hunks" },
                { "<leader>q", group = "quit" },
                { "<leader>s", group = "search" },
                { "<leader>u", group = "toggle" },
                { "<leader>w", group = "window" },
                { "<leader>x", group = "diagnostics" },
                { "[", group = "prev" },
                { "]", group = "next" },
                { "g", group = "goto" },
            },
        },
        keys = {
            { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
        },
    },
}
