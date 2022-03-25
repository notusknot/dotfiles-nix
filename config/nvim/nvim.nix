# This is my configuration file for neovim.
# I've written it in nix for ease of use with home-manager, 
# but there are several vimscript and lua files imported as well.
# If you want more help understanding or modifying these configurations, 
# please submit an issue on Github or contact me on Discord 'notusknot#5622'
{ pkgs, config, ... }:

let
    # Source my theme
    jabuti-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "jabuti-nvim";
        src = pkgs.fetchFromGitHub {
            owner = "jabuti-theme";
            repo = "jabuti-nvim";
            rev = "17f1b94cbf1871a89cdc264e4a8a2b3b4f7c76d2";
            sha256 = "sha256-iPjwx/rTd98LUPK1MUfqKXZhQ5NmKx/rN8RX1PIuDFA=";
        };
    };

in
{
environment.systemPackages = with pkgs; [
    (neovim.override {
        configure = {
            packages.myPlugins = with pkgs.vimPlugins; {
                start = [ jabuti-nvim nvim-cmp cmp-path cmp-nvim-lsp cmp-buffer ];

                opt = [
                # File tree
                nvim-web-devicons 
                nvim-tree-lua

                nvim-lspconfig nvim-treesitter

                # Languages
                vim-nix

                # Eyecandy 
                lualine-nvim
                bufferline-nvim
                nvim-colorizer-lua
                nvim-autopairs
                TrueZen-nvim
                toggleterm-nvim
                # Telescope
                telescope-nvim

                # Indent lines
                indent-blankline-nvim

            ];
        };
        customRC = ''
            let g:loaded_matchit           = 1
            let g:loaded_logiPat           = 1
            let g:loaded_rrhelper          = 1
            let g:loaded_tarPlugin         = 1
            " let g:loaded_man               = 1
            let g:loaded_gzip              = 1
            let g:loaded_zipPlugin         = 1
            let g:loaded_2html_plugin      = 1
            let g:loaded_shada_plugin      = 1
            let g:loaded_spellfile_plugin  = 1
            let g:loaded_netrw             = 1
            let g:loaded_netrwPlugin       = 1
            let g:loaded_tutor_mode_plugin = 1
            let g:loaded_remote_plugins    = 1

            lua dofile("/home/notus/.config/nixos/config/nvim/lua/settings.lua")
        '';
        };
    }
)];
}
