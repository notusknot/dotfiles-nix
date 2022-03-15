# This is my configuration file for neovim.
# I've written it in nix for ease of use with home-manager, 
# but there are several vimscript and lua files imported as well.
# If you want more help understanding or modifying these configurations, 
# please submit an issue on Github or contact me on Discord 'notusknot#5622'
{ pkgs, config, ... }:

let
    jabuti-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "jabuti-nvim";
        src = pkgs.fetchFromGitHub {
            owner = "jabuti-theme";
            repo = "jabuti-nvim";
            rev = "cd29976adfc6d210b06f86d8762c2e1c4d7c2f46";
	    sha256 = "sha256-VyixL0B0xVBUKePPPkIoCMACN3IZopkSqP1p9hD1Vyo=";
        };
    };

in
{
    enable = true;
    plugins = with pkgs.vimPlugins; [
        # File tree
        nvim-web-devicons 
        nvim-tree-lua

        # LSP
        nvim-lspconfig

        # Languages
        vim-nix

        # Eyecandy 
        lualine-nvim
        nvim-treesitter
        bufferline-nvim
        nvim-colorizer-lua
        jabuti-nvim
        pears-nvim
        TrueZen-nvim
        glow-nvim

        # Lsp and completion
        nvim-lspconfig
        nvim-cmp
        cmp-path
        cmp-nvim-lsp
        cmp-buffer
        cmp-cmdline

        # Telescope
        telescope-nvim

        # Indent lines
        indent-blankline-nvim
    ];
    extraConfig = ''
        luafile /home/notus/.config/nixos/config/nvim/lua/settings.lua
    '';

    extraPackages = with pkgs; [
          python39Packages.virtualenv
    ];
}
