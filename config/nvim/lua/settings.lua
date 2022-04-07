local o = vim.opt
local g = vim.g

vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- Lazy load
vim.defer_fn(function()
    vim.cmd [[
        packadd jabuti-nvim
        colorscheme jabuti
    ]]

    vim.defer_fn(function()
        -- Enable and config plugins
        dofile("/home/notus/.config/nixos/config/nvim/lua/plugins.lua")

        -- Autocmds
        local agrp = vim.api.nvim_create_augroup
        local acmd = vim.api.nvim_create_autocmd

        acmd({ "FileType" }, { pattern = "markdown", command = "setlocal wrap linebreak spell" })
        acmd({ "FileType" }, { pattern = "markdown", command = ":lua require('cmp').setup.buffer { enabled = false }" })
        acmd({ "BufWinEnter" }, { pattern = "NvimTree", command = "setlocal nonumber" })

        vim.cmd [[
        augroup CursorLine
            au!
            au VimEnter * setlocal cursorline
            au WinEnter * setlocal cursorline
            au BufWinEnter * setlocal cursorline
            au WinLeave * setlocal nocursorline
        augroup END

        function! s:MDGoToSection()
            let raw_filename = expand('<cfile>')
            let arg = substitute(raw_filename, '\([^#]*\)\(#\{1,6\}\)\([^#]*\)', '+\/\2\\\\s\3 \1.md', 'g')
            execute "edit" arg
        endfunction

        nnoremap <Enter> :call <SID>MDGoToSection()<CR>
        nnoremap gf :call <SID>MDGoToSection()<CR>

        ]]

        -- Keybinds
        local map = vim.api.nvim_set_keymap
        local opts = { silent = true, noremap = true }

        map("n", "<C-h>", "<C-w>h", opts)
        map("n", "<C-j>", "<C-w>j", opts)
        map("n", "<C-k>", "<C-w>k", opts)
        map("n", "<C-l>", "<C-w>l", opts)
        map('n', '<C-p>', ':NvimTreeToggle <CR>', opts)
        map('n', '<C-n>', ':Telescope live_grep <CR>', opts)
        map('n', '<C-f>', ':Telescope find_files <CR>', opts)
        map('n', '<C-o>', ':TZAtaraxis <CR>', opts)
        --map('n', '<C-m>', ':TZMinimalist <CR>', opts)
        map('n', '<C-Space>', ':noh <CR>', opts)
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
        g.loaded_python3_provider = 0
        g.loaded_ruby_provider = 0
        g.loaded_nodejs_provider = 0
        g.loaded_perl_provider = 0

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
end, 100)
