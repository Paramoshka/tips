local group = vim.api.nvim_create_augroup("user_config", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

-- Flash yanked text
autocmd("TextYankPost", {
    group = group,
    callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

-- Restore cursor position when reopening a file
autocmd("BufReadPost", {
    group = group,
    callback = function(ev)
        local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
        local lines = vim.api.nvim_buf_line_count(ev.buf)
        if mark[1] > 0 and mark[1] <= lines and vim.bo[ev.buf].filetype ~= "gitcommit" then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Equalize splits when the terminal is resized
autocmd("VimResized", {
    group = group,
    command = "tabdo wincmd =",
})

-- Close helper windows with q
autocmd("FileType", {
    group = group,
    pattern = { "help", "qf", "man", "lspinfo", "checkhealth", "notify", "startuptime" },
    callback = function(ev)
        vim.bo[ev.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
    end,
})

-- Go uses tabs; YAML/JSON/Lua/web prefer 2 spaces
autocmd("FileType", {
    group = group,
    pattern = "go",
    callback = function() vim.opt_local.expandtab = false end,
})
autocmd("FileType", {
    group = group,
    pattern = { "lua", "yaml", "json", "jsonc", "javascript", "typescript", "html", "css", "markdown" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- Wrap and spellcheck prose
autocmd("FileType", {
    group = group,
    pattern = { "markdown", "gitcommit", "text" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})
