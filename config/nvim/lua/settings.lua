local o = vim.opt
local g = vim.g

-- Lazy load
vim.defer_fn(function()
    vim.cmd [[
        packadd jabuti-nvim
        colorscheme jabuti
    ]]

    vim.defer_fn(function()

        -- Enable and config plugins
        dofile("/home/notus/.config/nixos/config/nvim/lua/plugins.lua")

        vim.cmd [[
            let g:loaded_python3_provider = 0
            let g:loaded_ruby_provider = 0
            let g:loaded_nodejs_provider = 0
            let g:loaded_perl_provider = 0

            filetype plugin indent off 

            au FileType markdown setlocal wrap linebreak spell
            au FileType markdown :lua require('cmp').setup.buffer { enabled = false }
            au BufWinEnter NvimTree setlocal nonumber

            augroup cmdline
                autocmd!
                autocmd CmdlineLeave : echo ''
            augroup end
        ]]

        -- Keybinds
        local map = vim.api.nvim_set_keymap
        local opts = { silent = true, noremap = true }

        map('n', '<C-p>', ':NvimTreeToggle <CR>', opts)
        map('n', '<C-n>', ':Telescope live_grep <CR>', opts)
        map('n', '<C-f>', ':Telescope find_files <CR>', opts)
        map('n', '<C-o>', ':TZAtaraxis <CR>', opts)
        map('n', '<C-m>', ':TZMinimalist <CR>', opts)
        map('n', '<C-l>', ':noh <CR>', opts)
        map('n', 'j', 'gj', opts)
        map('n', 'k', 'gk', opts)
        map('n', ';', ':', { noremap = true } )

        g.mapleader = ' '

        -- Indent line
        g.indent_blankline_char = '▏'

        -- Performance
        o.lazyredraw = true;
        o.shell = "zsh"
        o.shadafile = "NONE"

        -- Colors
        o.termguicolors = true

        -- Undo files
        o.undofile = true

        -- Indentation
        o.smartindent = true
        o.tabstop = 4
        o.shiftwidth = 4
        o.shiftround = true
        o.expandtab = true
        o.scrolloff = 3

        -- Set clipboard to use system clipboard
        o.clipboard = "unnamedplus"

        -- Use mouse
        o.mouse = "a"

        -- Nicer UI settings
        o.cursorline = true
        o.relativenumber = true
        o.number = true

        -- Get rid of annoying viminfo file
        o.viminfo = ""
        o.viminfofile = "NONE"

        -- Miscellaneous quality of life
        o.ignorecase = true
        o.ttimeoutlen = 5
        o.hidden = true
        o.shortmess = "atI"
        o.wrap = false
        o.backup = false
        o.writebackup = false
        o.errorbells = false
        o.swapfile = false
        o.showmode = false
        o.laststatus = 3
        o.pumheight = 6
        o.splitright = true
        o.splitbelow = true
        o.completeopt = "menuone,noselect"
    end, 15)
end, 0)
