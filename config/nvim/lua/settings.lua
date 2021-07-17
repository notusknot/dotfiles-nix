local opt = vim.opt
local g = vim.g

vim.cmd [[
    set nowrap
    set nobackup
    set nowritebackup
    set noerrorbells
    set noswapfile
    
    colorscheme dusk

    set termguicolors

    function! Preserve(command)
      let w = winsaveview()
      execute a:command
      call winrestview(w)
    endfunction

    autocmd FileType nix map <nowait> <leader>u :call Preserve("%!update-nix-fetchgit --location=" . line(".") . ":" . col("."))<CR>

    autocmd BufWinEnter NvimTree setlocal nonumber

    set fillchars+=vert:\ 

    let g:indentLine_color_gui = '#393b4d'

    map ; :

]]

require 'colorizer'.setup()

local function map(mode, combo, mapping, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, combo, mapping, options)
end

map('n', '<C-p>', ':NvimTreeToggle <CR>', {noremap = true})
map('n', '<C-f>', ':Telescope find_files <CR>', {noremap = true})
map('n', '<C-n>', ':Telescope live_grep <CR>', {noremap = true})

g.mapleader = ' '
g.indentLine_char = '│'
g.indent_blankline_char = '│'
g.indent_blankline_use_treesitter = true
g.indent_blankline_show_current_context = true

-- Undo files
opt.undofile = true
opt.undodir = "/home/notus/.cache/"

-- Indentation
opt.smartindent = true
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Set clipboard to use system clipboard
opt.clipboard = "unnamedplus"

-- Use mouse
opt.mouse = "a"

-- Nicer UI settings
opt.cursorline = true
opt.number = true

-- Get rid of annoying viminfo file
opt.viminfo = ""
opt.viminfofile = "NONE"

-- Miscellaneous quality of life
opt.smartcase = true
opt.ttimeoutlen = 5
opt.compatible = false
opt.autoread = true
opt.incsearch = true
opt.hidden = true
opt.shortmess = "atI"

