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
    source /etc/nixos/config/nvim/colors/dusk.vim
    luafile /etc/nixos/config/nvim/lua/settings.lua
    luafile /etc/nixos/config/nvim/lua/bufferline.lua
    luafile /etc/nixos/config/nvim/lua/statusline.lua

    lua << EOF
    vim.defer_fn(function()
      vim.cmd [[
        luafile /etc/nixos/config/nvim/lua/lsp.lua
        luafile /etc/nixos/config/nvim/lua/tree.lua
        luafile /etc/nixos/config/nvim/lua/treesitter.lua
        luafile /etc/nixos/config/nvim/lua/neorg.lua
      ]]
    end, 70)
    EOF

    let g:indentLine_color_term = 8
    let g:indentLine_char_list = ['▏', '▏', '▏', '▏']

    map ; :

    let g:python_host_skip_check=1
    let g:loaded_python3_provider=1

    hi! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg
    nmap <C-p> :NvimTreeToggle <CR>

    set nowrap
    set nobackup
    set nowritebackup
    set noerrorbells
    set noswapfile

    '';


    # This installs all the plugins without an external plugin manager.
    plugins = with pkgs.vimPlugins; [

        # File tree
        nvim-web-devicons
        nvim-tree-lua

        # Lsp and auto completion
        nvim-lspconfig
        nvim-compe

        # Eyecandy
        galaxyline-nvim
        nvim-treesitter
        indentLine
        nvim-bufferline-lua

        # Languages
        vim-nix 

        # Assorted web dev plugins
        nvim-colorizer-lua
        vim-closetag
        pears-nvim

        # Misc
        neorg
        plenary-nvim
        markdown-preview-nvim
  ];
}

