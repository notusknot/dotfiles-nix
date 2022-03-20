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
            rev = "1b8412369cb23a45f68e201628201bce61c40088";
            sha256 = "sha256-CbqdlIBRd0+WiMCO2d89j9wJqrxTL4mv+8wCPLDoc0s=";
        };
    };

in
{
environment.systemPackages = with pkgs; [
    (neovim.override {
        configure = {
            packages.myPlugins = with pkgs.vimPlugins; {
                start = [ jabuti-nvim nvim-lspconfig nvim-treesitter nvim-cmp cmp-path cmp-nvim-lsp cmp-buffer];

                opt = [
                # File tree
                nvim-web-devicons 
                nvim-tree-lua

                # Languages
                vim-nix

                # Eyecandy 
                lualine-nvim
                bufferline-nvim
                nvim-colorizer-lua
                pears-nvim
                TrueZen-nvim
                toggleterm-nvim
                # Telescope
                telescope-nvim

                # Indent lines
                indent-blankline-nvim

            ];
        };
        customRC = ''
            lua dofile("/home/notus/.config/nixos/config/nvim/lua/settings.lua")
        '';
        };
    }
)];
}
