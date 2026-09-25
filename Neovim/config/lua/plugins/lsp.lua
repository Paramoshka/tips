-- LSP via the native Neovim 0.11 API (vim.lsp.config / vim.lsp.enable).
-- nvim-lspconfig only provides default server configs; mason installs missing binaries.
local servers = {
    clangd = {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu",
            "--completion-style=detailed", "--function-arg-placeholders" },
    },
    gopls = {
        settings = {
            gopls = {
                gofumpt = false,
                usePlaceholders = true,
                staticcheck = true,
                analyses = { unusedparams = true, unusedwrite = true, nilness = true },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
            },
        },
    },
    pyright = {},
    ruff = {}, -- fast python linter; pyright handles types
    lua_ls = {
        settings = {
            Lua = {
                workspace = { checkThirdParty = false },
                completion = { callSnippet = "Replace" },
                diagnostics = { globals = { "vim", "Snacks" } },
                hint = { enable = true },
            },
        },
    },
    bashls = {},
    jsonls = {},
    yamlls = {},
}

-- Tools mason installs if missing. `needs` skips a package whose installer
-- can't work on this machine (e.g. a container without node).
local function has(bin) return function() return vim.fn.executable(bin) == 1 end end
local function has_python_venv()
    if vim.fn.executable("python3") == 0 then return false end
    vim.fn.system({ "python3", "-c", "import ensurepip" })
    return vim.v.shell_error == 0
end
local mason_packages = {
    { "lua-language-server" },
    { "stylua" },
    { "shfmt" },
    { "ruff", needs = has_python_venv },
    { "bash-language-server", needs = has("npm") },
    { "json-lsp", needs = has("npm") },
    { "yaml-language-server", needs = has("npm") },
}

return {
    {
        "mason-org/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonLog" },
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        opts = { ui = { border = "rounded" } },
        config = function(_, opts)
            require("mason").setup(opts)
            local registry = require("mason-registry")
            registry.refresh(function()
                for _, spec in ipairs(mason_packages) do
                    local ok, pkg = pcall(registry.get_package, spec[1])
                    if ok and not pkg:is_installed() and not pkg:is_installing()
                        and (not spec.needs or spec.needs()) then
                        pkg:install()
                    end
                end
            end)
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
        config = function()
            vim.lsp.config("*", {
                capabilities = require("blink.cmp").get_lsp_capabilities(),
            })
            -- Enable only servers whose binary exists (mason-installed ones
            -- become available after the first install + restart)
            for name, cfg in pairs(servers) do
                vim.lsp.config(name, cfg)
                local cmd = vim.lsp.config[name] and vim.lsp.config[name].cmd
                if type(cmd) ~= "table" or vim.fn.executable(cmd[1]) == 1 then
                    vim.lsp.enable(name)
                end
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    local function map(keys, fn, desc, mode)
                        vim.keymap.set(mode or "n", keys, fn, { buffer = ev.buf, desc = desc })
                    end
                    map("K", function() vim.lsp.buf.hover() end, "Hover")
                    map("gK", function() vim.lsp.buf.signature_help() end, "Signature help")
                    map("<C-k>", function() vim.lsp.buf.signature_help() end, "Signature help", "i")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
                    map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
                    map("<F2>", vim.lsp.buf.rename, "Rename symbol")
                    map("<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP info")

                    if client and client.name == "clangd" then
                        map("<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", "Switch source/header")
                    end
                    -- ruff and pyright both give hover; let pyright own it
                    if client and client.name == "ruff" then
                        client.server_capabilities.hoverProvider = false
                    end
                end,
            })
        end,
    },
}
