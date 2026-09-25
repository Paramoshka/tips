return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "▁" },
                topdelete = { text = "▔" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            on_attach = function(buf)
                local gs = require("gitsigns")
                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buf, desc = desc })
                end
                map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
                map("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<cr>", "Stage hunk")
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<cr>", "Reset hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
                map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview hunk")
                map("n", "<leader>ghd", gs.diffthis, "Diff this")
                map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
                map("n", "<leader>ub", gs.toggle_current_line_blame, "Toggle inline blame")
                map({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<cr>", "Select hunk")
            end,
        },
    },
}
