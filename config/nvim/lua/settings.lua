local opt = vim.opt
local g = vim.g

dofile("/home/notus/.config/nixos/config/nvim/lua/statusline.lua")
dofile("/home/notus/.config/nixos/config/nvim/lua/lsp.lua")
dofile("/home/notus/.config/nixos/config/nvim/lua/nvim-tree.lua")

vim.cmd [[
    filetype plugin indent off 

    colorscheme jabuti 
    function! Preserve(command)
        let w = winsaveview()
        execute a:command
        call winrestview(w)
    endfunction
    autocmd FileType nix map <nowait> <leader>u :call Preserve("%!update-nix-fetchgit --location=" . line(".") . ":" . col("."))<CR>
    autocmd BufWinEnter NvimTree setlocal nonumber
    map ; :
    highlight IndentBlanklineChar guifg = #393b4d
    au FileType markdown setlocal wrap linebreak spell
    nnoremap j gj
    nnoremap k gk
    augroup cmdline
        autocmd!
        autocmd CmdlineLeave : echo ''
    augroup end
    highlight NvimTreeNormal guibg=#252632
    highlight NvimTreeEndOfBuffer guibg=#252632 guifg=#252632
    set shiftwidth=4
]]

-- Enable plugins
require('bufferline').setup{}
require('pears').setup()
require('colorizer').setup()

-- Treesitter settings
require'nvim-treesitter.configs'.setup {
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true
    },
}

local map = vim.api.nvim_set_keymap
options = { noremap = true }
map('n', '<C-p>', ':NvimTreeToggle <CR>', options)
map('n', '<C-f>', ':Telescope find_files <CR>', options)
map('n', '<C-n>', ':Telescope live_grep <CR>', options)
map('n', '<C-o>', ':TZAtaraxis <CR>', options)
map('n', '<C-m>', ':TZMinimalist <CR>', options)
map('n', '<C-l>', ':noh <CR>', options)
map('i', '<C-Space>', '<Esc> [s1z=`]i <CR>', options)
vim.api.nvim_set_keymap('n', '0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", {silent = true, noremap = true, expr = true})
g.mapleader = ' '

-- Indent line
g.indent_blankline_char = '▏'

-- Performance
opt.lazyredraw = true;
opt.shell = "zsh"
opt.shadafile = "NONE"

-- Colors
opt.termguicolors = true

-- Undo files
opt.undofile = true

-- Indentation
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.expandtab = true
opt.scrolloff = 3

-- Set clipboard to use system clipboard
opt.clipboard = "unnamedplus"

-- Use mouse
opt.mouse = "a"

-- Nicer UI settings
opt.cursorline = true
opt.relativenumber = true
opt.number = true

-- Get rid of annoying viminfo file
opt.viminfo = ""
opt.viminfofile = "NONE"

-- Miscellaneous quality of life
opt.ignorecase = true
opt.ttimeoutlen = 5
opt.compatible = false
opt.hidden = true
opt.shortmess = "atI"
opt.wrap = false
opt.backup = false
opt.writebackup = false
opt.errorbells = false
opt.swapfile = false
opt.showmode = false
