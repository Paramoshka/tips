local opt = vim.opt

-- Line numbers / UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
-- Thin bar cursor everywhere; insert mode blinks, replace mode is an underline
opt.guicursor = "n-v-c-sm:ver25,i-ci-ve:ver25-blinkwait300-blinkon500-blinkoff400,r-cr-o:hor20"
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false -- mode is shown in lualine
opt.laststatus = 3 -- single global statusline
opt.cmdheight = 1
opt.pumheight = 10
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " ", fold = " ", foldopen = "\u{f078}", foldclose = "\u{f054}", foldsep = " " }
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.winborder = "rounded"

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.shiftround = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split" -- live preview of :s

-- Behaviour
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.updatetime = 200
opt.timeoutlen = 300
opt.confirm = true -- ask to save instead of failing
opt.virtualedit = "block"
opt.completeopt = "menu,menuone,noselect"
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Folding via treesitter, everything open by default
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldtext = ""

-- Diagnostics
vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 2, prefix = "●", source = "if_many" },
    float = { border = "rounded", source = "if_many" },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "\u{f057} ",
            [vim.diagnostic.severity.WARN] = "\u{f071} ",
            [vim.diagnostic.severity.HINT] = "\u{f0eb} ",
            [vim.diagnostic.severity.INFO] = "\u{f05a} ",
        },
    },
})
