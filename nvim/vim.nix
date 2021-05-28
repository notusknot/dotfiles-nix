# This is my configuration file for neovim.
# I've written it in nix for ease of use with home-manager, 
# but there are several vimscript and lua files imported as well.
# If you want more help understanding or modifying these configurations, 
# please submit an issue on Github or contact me on Discord 'notusknot#5622'

pkgs: 
{
  enable = true;
  vimAlias = true;
  # A simple configuration for neovim, be sure to check out the sourced files.
  extraConfig = ''
    " Source all the extra configuration files (explanations are in all the files).
    source /etc/nixos/nvim/colors/dusk.vim
    source /etc/nixos/nvim/vimscript/tree.vim
    luafile /etc/nixos/nvim/lua/statusline.lua
    luafile /etc/nixos/nvim/lua/treesitter.lua
    luafile /etc/nixos/nvim/lua/compe.lua

    syntax on
    set nowrap
    set termguicolors
    set autoread
    set smartindent
    set smartcase
    set noswapfile
    set noerrorbells
    set nu
    set tabstop=4 
    set shiftwidth=4
    set expandtab
    set undodir=$HOME/.cache
    set undofile
    set incsearch
    set viminfo=""
    set viminfofile=NONE
    nmap <C-n> :Files <CR>
    set hidden
    set nobackup
    set nowritebackup
    set cmdheight=2
    set updatetime=300
    set shortmess+=c
    '';
    # This installs all the plugins without an external plugin manager.
    plugins = with pkgs.vimPlugins; [
      vim-nix
      rust-vim
      nvim-web-devicons
      nvim-lspconfig
      nvim-compe
      auto-pairs
      galaxyline-nvim
      nvim-treesitter
      fzf-vim
      colorizer
      rust-tools-nvim
      vim-vsnip
      nvim-tree-lua
  ];
}

