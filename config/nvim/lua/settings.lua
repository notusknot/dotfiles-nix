local s = {}
local opt = vim.opt
local g = vim.g
local api = vim.api

s.load = function()
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
    map ; :
    highlight IndentBlanklineChar guifg = #393b4d
  ]]
  
  local map = vim.api.nvim_set_keymap
  options = { noremap = true }
  map('n', '<C-p>', ':NvimTreeToggle <CR>', options)
  map('n', '<C-f>', ':Telescope find_files <CR>', options)
  map('n', '<C-n>', ':Telescope live_grep <CR>', options)
  map('n', '<C-l>', ':noh <CR>', options)
  map('n', '<C-s>', ':!xclip -sel c -o | pygmentize -f html | xclip -sel c <CR> <CR>', options)
  api.nvim_set_keymap('n', '0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", {silent = true, noremap = true, expr = true})
  g.mapleader = ' '

  -- Indent line
  g.indent_blankline_char = '▏'
end

s.loadPlugins = function()
  require('bufferline').setup{}
  require('pears').setup()
  require('colorizer').setup()
  
  -- Tersitter Setings
  require('nvim-treesitter.configs').setup {
    ensure_installed = "all",
    hightlight.enable = true,
  }
end

s.config = {
  -- Performance
  lazyredraw = true,
  shell = "zsh",
  shadafile = "NONE",
  -- Colors
  termguicolors = true,
  -- Undo files
  undofile = true,
  -- Indentation
  smartindent = true,
  tabstop = 4,
  shiftwidth = 4,
  shiftround = true,
  expandtab = true,
  scrolloff = 3,
  -- Clipboard
  clipboard = "unnamedplus",
  -- Enable Mouse
  mouse = "a"
  -- Nicer UI Settings
  cursorline = true,
  relativenumber = true,
  number = true,
  -- Fuck you vim info file
  viminfo = "",
  viminfofile = "NONE",
  -- Miscellaneous quality of life
  ignorecase = true,
  timeoutlen = 5,
  compatible = false,
  hidden = true,
  shortmess = "atI",
}

return s
