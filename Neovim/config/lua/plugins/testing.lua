return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio",
            { "fredrikaverpil/neotest-golang", version = "^1" }, -- Treesitter master grammar
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
            { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%:p")) end, desc = "Run file tests" },
            { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run last test" },
            { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test output panel" },
            { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop test" },
            {
                "<leader>td",
                function()
                    require("lazy").load({ plugins = { "nvim-dap" } })
                    require("neotest").run.run({ strategy = "dap" })
                end,
                desc = "Debug nearest test",
            },
        },
        opts = function()
            return {
                adapters = {
                    require("neotest-golang")({ go_test_args = { "-v", "-count=1", "-timeout=60s" } }),
                },
                -- Discover on demand: these projects can contain many Go modules.
                discovery = { enabled = false },
                status = { virtual_text = false },
                summary = { open = "botright vsplit | vertical resize 42" },
                output_panel = { open = "botright split | resize 12" },
            }
        end,
    },
}
