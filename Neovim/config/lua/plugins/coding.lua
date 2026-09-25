return {
    -- Completion
    {
        "saghen/blink.cmp",
        version = "1.*", -- prebuilt fuzzy matcher binary
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = {
            keymap = {
                preset = "default",
                ["<CR>"] = { "accept", "fallback" },
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
            },
            appearance = { nerd_font_variant = "mono" },
            completion = {
                list = { selection = { preselect = true, auto_insert = false } },
                documentation = { auto_show = true, auto_show_delay_ms = 200 },
                menu = {
                    draw = { treesitter = { "lsp" }, columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } } },
                },
            },
            signature = { enabled = true },
            sources = { default = { "lsp", "path", "snippets", "buffer" } },
            cmdline = { completion = { menu = { auto_show = true } } },
        },
    },

    -- Formatting (format on save, <leader>cf manually, <leader>uf to toggle)
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        cmd = "ConformInfo",
        keys = {
            { "<leader>cf", function() require("conform").format({ async = true }) end, mode = { "n", "v" }, desc = "Format" },
        },
        opts = {
            formatters_by_ft = {
                c = { "clang_format" },
                cpp = { "clang_format" },
                go = { "goimports", "gofmt", stop_after_first = true },
                python = { "ruff_organize_imports", "ruff_format" },
                lua = { "stylua" },
                sh = { "shfmt" },
            },
            formatters = {
                -- use project .clang-format if present, otherwise Google style
                clang_format = { prepend_args = { "--style=file", "--fallback-style=Google" } },
            },
            default_format_opts = { lsp_format = "fallback" },
            format_on_save = function()
                if vim.g.disable_autoformat then return end
                return { timeout_ms = 1000 }
            end,
        },
    },

    -- Auto pairs, surround (sa/sd/sr), better text objects (a/i + f, c, a, q...)
    { "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },
    { "echasnovski/mini.surround", event = "VeryLazy", opts = {} },
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        config = function()
            local ai = require("mini.ai")
            ai.setup({
                n_lines = 500,
                custom_textobjects = {
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                },
            })
        end,
    },

    -- Fast jumping: s + 2 chars
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = { modes = { search = { enabled = false } } },
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
        },
    },

    -- TODO/FIXME/HACK highlighting
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
        },
    },

    -- Diagnostics / symbols panel
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = { focus = true },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (project)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
            { "<leader>cs", "<cmd>Trouble symbols toggle win.position=right<cr>", desc = "Symbols outline" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
            { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "TODOs" },
        },
    },
}
