-- snacks.nvim: picker, file explorer, terminal, notifications, dashboard, indent guides...
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        notifier = { enabled = true, timeout = 3000 },
        input = { enabled = true },
        indent = { enabled = true, animate = { enabled = false } },
        scope = { enabled = true },
        words = { enabled = true }, -- highlight references under cursor, jump with ]] / [[
        statuscolumn = { enabled = true },
        explorer = { replace_netrw = true },
        picker = {
            sources = {
                explorer = { layout = { layout = { width = 32 } } },
                files = { hidden = true },
                grep = { hidden = true },
            },
        },
        terminal = { win = { style = "terminal" } },
        dashboard = {
            preset = {
                keys = {
                    { icon = "\u{f002} ", key = "f", desc = "Find file", action = ":lua Snacks.picker.files()" },
                    { icon = "\u{f1da} ", key = "r", desc = "Recent files", action = ":lua Snacks.picker.recent()" },
                    { icon = "\u{f422} ", key = "g", desc = "Grep", action = ":lua Snacks.picker.grep()" },
                    { icon = "\u{f07c} ", key = "e", desc = "Explorer", action = ":lua Snacks.explorer()" },
                    { icon = "\u{f013} ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
                    { icon = "\u{f04b2} ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = "\u{f011} ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
            sections = {
                { section = "keys", gap = 1, padding = 1 },
                { section = "startup" },
            },
        },
    },
    keys = {
        -- Find
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Find files (smart)" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config files" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
        -- Search
        { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep word / selection", mode = { "n", "x" } },
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer lines" },
        { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help pages" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume last picker" },
        { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
        { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "TODOs" },
        { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command history" },
        { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification history" },
        -- LSP navigation (picker-powered)
        { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto definition" },
        { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto declaration" },
        { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto implementation" },
        { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto type definition" },
        { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
        { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" },
        -- Git
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git log (file)" },
        { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser", mode = { "n", "v" } },
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
        -- Buffers
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
        -- Terminal
        { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },
        { "<C-_>", function() Snacks.terminal() end, desc = "which_key_ignore", mode = { "n", "t" } },
        -- Misc
        { "<leader>z", function() Snacks.zen() end, desc = "Zen mode" },
        { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file" },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Toggles under <leader>u
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.inlay_hints():map("<leader>uh")
                Snacks.toggle.indent():map("<leader>ug")
                Snacks.toggle.new({
                    id = "autoformat",
                    name = "Format on save",
                    get = function() return not vim.g.disable_autoformat end,
                    set = function(on) vim.g.disable_autoformat = not on end,
                }):map("<leader>uf")
            end,
        })
    end,
}
