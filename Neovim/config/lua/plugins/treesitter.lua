return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = {
                "c", "cpp", "go", "gomod", "gosum", "gowork", "python", "lua", "luadoc", "vim", "vimdoc",
                "bash", "json", "yaml", "toml", "make", "cmake", "dockerfile", "markdown", "markdown_inline",
                "query", "regex", "diff", "git_config", "gitcommit", "gitignore",
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    node_decremental = "<bs>",
                    scope_incremental = false,
                },
            },
            textobjects = {
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                    goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                },
            },
        },
    },

    -- Show current function/struct at the top when scrolling
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        opts = { max_lines = 3 },
    },
}
