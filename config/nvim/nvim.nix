# This is my configuration file for neovim.
# I've written it in nix for ease of use with home-manager, 
# but there are several vimscript and lua files imported as well.
# If you want more help understanding or modifying these configurations, 
# please submit an issue on Github or contact me on Discord 'notusknot#5622'
pkgs: 
let
    pears-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "pears-nvim";
        src = pkgs.fetchFromGitHub {
            owner = "steelsojka";
            repo = "pears.nvim";
            rev = "14e6c47c74768b74190a529e41911ae838c45254";
            sha256 = "04kg7g6v6k6jv2pmapaqvkvf6py1i211l822m3lsvf26jcyfs3ag";
        };
    };
    dusk-vim = pkgs.vimUtils.buildVimPlugin {
        name = "dusk-vim";
        src = pkgs.fetchFromGitHub {
            owner = "notusknot";
            repo = "dusk-vim";
            rev = "8eb71f092ebfa173a6568befbe522a56e8382756";
            sha256 = "09l4hda5jnyigc2hhlirv1rc8hsnsc4zgcv4sa4br8fryi73nf4g";
        };
    };

in
{
    enable = true;
    vimAlias = true;
    # A simple configuration for neovim, be sure to check out the sourced files.
    extraConfig = ''

        luafile $NIXOS_CONFIG_DIR/config/nvim/lua/galaxyline.lua
        luafile $NIXOS_CONFIG_DIR/config/nvim/lua/settings.lua
        luafile $NIXOS_CONFIG_DIR/config/nvim/lua/nvim-tree.lua
        luafile $NIXOS_CONFIG_DIR/config/nvim/lua/treesitter.lua
        luafile $NIXOS_CONFIG_DIR/config/nvim/lua/bufferline.lua

        lua << EOF

        vim.defer_fn(function()
            require "pears".setup()
            require 'colorizer'.setup()
            vim.cmd [[
                luafile $NIXOS_CONFIG_DIR/config/nvim/lua/nvim-toggleterm.lua
                luafile $NIXOS_CONFIG_DIR/config/nvim/lua/lsp.lua
                luafile $NIXOS_CONFIG_DIR/config/nvim/lua/neorg.lua
            ]]
        end, 70)
        EOF
    '';

    # This installs all the plugins without an external plugin manager.
    plugins = with pkgs.vimPlugins; [
        # File tree
        nvim-web-devicons
        nvim-tree-lua

        # LSP
        nvim-lspconfig
        nvim-compe

        # Languages
        vim-nix

        # Eyecandy 
        nvim-treesitter
        nvim-bufferline-lua
        galaxyline-nvim
        nvim-toggleterm-lua
        nvim-colorizer-lua

        dusk-vim

        # Telescope
        popup-nvim
        plenary-nvim
        telescope-nvim

        # Indent lines
        indent-blankline-nvim

        # Utility
        pears-nvim

        neorg

    ];
}

