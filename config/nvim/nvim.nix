# This is my configuration file for neovim.
# I've written it in nix for ease of use with home-manager, 
# but there are several vimscript and lua files imported as well.
# If you want more help understanding or modifying these configurations, 
# please submit an issue on Github or contact me on Discord 'notusknot#5622'
{ pkgs, config, ... }:

let
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
    
environment.systemPackages = with pkgs; [
    (neovim.override {
        configure = {
            packages.myPlugins = with pkgs.vimPlugins; {
                start = [ popup-nvim plenary-nvim nvim-compe neorg ];
                opt = [
                # File tree
                nvim-web-devicons 
                nvim-tree-lua

                # LSP
                nvim-lspconfig

                # Languages
                vim-nix

                # Eyecandy 
                nvim-treesitter
                bufferline-nvim
                galaxyline-nvim
                nvim-colorizer-lua

                dusk-vim
                pears-nvim

                # Telescope
                telescope-nvim

                # Indent lines
                indent-blankline-nvim

            ];
        };
        customRC = ''
            lua << EOF

            vim.cmd [[
                syntax off
                filetype off
                filetype plugin indent off
            ]]

            vim.defer_fn(function()

                vim.cmd [[
                    syntax on
                    filetype on
                    filetype plugin indent on
                    packadd nvim-treesitter
                    packadd dusk-vim
                    colorscheme dusk
                    
                    packadd plenary-nvim
                    packadd nvim-web-devicons
                    packadd nvim-tree-lua
                    packadd nvim-lspconfig
                    packadd nvim-compe
                    packadd vim-nix
                    packadd nvim-treesitter
                    packadd bufferline-nvim	
                    packadd galaxyline-nvim
                    packadd nvim-colorizer-lua
                    packadd telescope-nvim
                    packadd indent-blankline-nvim
                    packadd pears-nvim
                    packadd neorg

                    doautocmd BufRead
                ]]

                vim.defer_fn(function()
                    dofile("/home/notus/.config/nixos/config/nvim/lua/settings.lua")
                end, 15)
            end, 0)
            EOF
        '';
        };
    }
)];
}
