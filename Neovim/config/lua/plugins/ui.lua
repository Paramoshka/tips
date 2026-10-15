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
                c.comment = "#8793b8"
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
                hl.TreesitterContext = { bg = c.bg_float }
                hl.TreesitterContextBottom = { sp = c.fg_gutter, underline = true }
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
                ignore_focus = { "snacks_picker_list", "snacks_picker_input", "snacks_layout_box" },
                section_separators = "",
                component_separators = "",
                disabled_filetypes = { statusline = { "snacks_dashboard" } },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = {
                    { "filename", path = 1, symbols = { modified = " ●", readonly = " \u{f023}" } },
                    {
                        function()
                            if not package.loaded["neotest"] then return "" end
                            local state = require("neotest").state
                            local passed, failed, total = 0, 0, 0
                            for _, id in ipairs(state.adapter_ids()) do
                                local counts = state.status_counts(id, { buffer = vim.api.nvim_get_current_buf() })
                                if counts then
                                    passed = passed + counts.passed
                                    failed = failed + counts.failed
                                    total = total + counts.total
                                end
                            end
                            return total > 0 and string.format("Tests ✓ %d  ✗ %d", passed, failed) or ""
                        end,
                    },
                },
                lualine_x = {
                    {
                        function()
                            if not package.loaded["dap"] then return "" end
                            return require("dap").status()
                        end,
                        color = { fg = "#ffc777" },
                    },
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
                indicator = { style = "underline" },
                separator_style = "thin",
                max_name_length = 28,
                always_show_bufferline = false,
                show_buffer_close_icons = false,
                offsets = {
                    { filetype = "snacks_layout_box", text = "Project", text_align = "left", separator = true },
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
                { "<leader>d", group = "debug" },
                { "<leader>f", group = "find" },
                { "<leader>g", group = "git" },
                { "<leader>gh", group = "hunks" },
                { "<leader>o", group = "tasks" },
                { "<leader>q", group = "session / quit" },
                { "<leader>s", group = "search" },
                { "<leader>t", group = "tests" },
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
