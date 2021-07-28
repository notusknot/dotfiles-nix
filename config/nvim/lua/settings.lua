local opt = vim.opt
local g = vim.g

-- Lazy load everything!

vim.cmd [[
    set nowrap
    set nobackup
    set nowritebackup
    set noerrorbells
    set noswapfile
    
    colorscheme dusk

    function! Preserve(command)
      let w = winsaveview()
      execute a:command
      call winrestview(w)
    endfunction

    autocmd FileType nix map <nowait> <leader>u :call Preserve("%!update-nix-fetchgit --location=" . line(".") . ":" . col("."))<CR>

    autocmd BufWinEnter NvimTree setlocal nonumber

    set shiftwidth=4

    map ; :

    highlight IndentBlanklineChar guifg = #393b4d
]]

-- Lazy load some plugins
vim.defer_fn(function()
    require 'pears'.setup()
    require 'colorizer'.setup()
end, 70)

local function map(mode, combo, mapping, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, combo, mapping, options)
end

-- Performance
opt.lazyredraw = true;
opt.shell = "/bin/sh"
opt.shadafile = "NONE"

local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfileplugin",
    "matchit"
}

for plugin in pairs(disabled_built_ins) do
    vim.g["loaded" .. plugin] = 1
end

map('n', '<C-p>', ':NvimTreeToggle <CR>', {noremap = true})
map('n', '<C-f>', ':Telescope find_files <CR>', {noremap = true})
map('n', '<C-n>', ':Telescope live_grep <CR>', {noremap = true})

g.mapleader = ' '

-- Indent line
g.indent_blankline_char = '▏'

-- Colors
opt.termguicolors = true

-- Undo files
opt.undofile = true
opt.undodir = "/home/notus/.cache/"

-- Indentation
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.expandtab = true

-- Set clipboard to use system clipboard
opt.clipboard = "unnamedplus"

-- Use mouse
opt.mouse = "a"

-- Nicer UI settings
opt.cursorline = true
opt.relativenumber = true

-- Get rid of annoying viminfo file
opt.viminfo = ""
opt.viminfofile = "NONE"

-- Miscellaneous quality of life
opt.smartcase = true
opt.ttimeoutlen = 5
opt.compatible = false
opt.hidden = true
opt.shortmess = "atI"


