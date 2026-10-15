return {
    {
        "MagicDuck/grug-far.nvim",
        cmd = "GrugFar",
        keys = {
            {
                "<leader>sp",
                function()
                    require("grug-far").open({ prefills = { paths = Snacks.git.get_root() or vim.fn.getcwd() } })
                end,
                desc = "Search and replace (project)",
            },
        },
        opts = { headerMaxWidth = 80 },
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
        keys = {
            { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
            { "<leader>qS", function() require("persistence").select() end, desc = "Select session" },
            {
                "<leader>ql",
                function() require("persistence").load({ last = true }) end,
                desc = "Restore last session",
            },
            { "<leader>qd", function() require("persistence").stop() end, desc = "Stop saving session" },
        },
    },
    {
        "stevearc/overseer.nvim",
        cmd = { "OverseerRun", "OverseerToggle", "OverseerTaskAction" },
        keys = {
            { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run project task" },
            { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Task panel" },
            { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
        },
        opts = {},
    },
}
