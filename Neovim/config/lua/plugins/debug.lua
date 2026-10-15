return {
    {
        "mfussenegger/nvim-dap",
        version = "0.10.*", -- compatible with the installed Neovim 0.11.0
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "leoluz/nvim-dap-go",
        },
        keys = {
            { "<F5>", function() require("dap").continue() end, desc = "Debug: start / continue" },
            { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: breakpoint" },
            { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
            { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
            { "<F12>", function() require("dap").step_out() end, desc = "Debug: step out" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
            {
                "<leader>dB",
                function()
                    vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
                        if condition and condition ~= "" then require("dap").set_breakpoint(condition) end
                    end)
                end,
                desc = "Conditional breakpoint",
            },
            { "<leader>dc", function() require("dap").continue() end, desc = "Start / continue" },
            { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
            { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
            { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
            { "<leader>dl", function() require("dap").run_last() end, desc = "Run last debug session" },
            { "<leader>du", function() require("dapui").toggle() end, desc = "Debug panels" },
            { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Evaluate expression" },
            { "<leader>dq", function() require("dap").terminate() end, desc = "Terminate debug session" },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            require("dap-go").setup()
            dapui.setup({
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.5 },
                            { id = "watches", size = 0.2 },
                            { id = "stacks", size = 0.2 },
                            { id = "breakpoints", size = 0.1 },
                        },
                        size = 44,
                        position = "right",
                    },
                    {
                        elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
                        size = 12,
                        position = "bottom",
                    },
                },
            })
            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
            vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })
            dap.listeners.after.event_initialized.user_dapui = function() dapui.open() end
            dap.listeners.before.event_terminated.user_dapui = function() dapui.close() end
            dap.listeners.before.event_exited.user_dapui = function() dapui.close() end
        end,
    },
}
