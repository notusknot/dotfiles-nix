# This is my configuration file for neovim.
# I've written it in nix for ease of use with home-manager, 
# but there are several vimscript and lua files imported as well.
# If you want more help understanding or modifying these configurations, 
# please submit an issue on Github or contact me on Discord 'notusknot#5622'
{ pkgs, config, ... }:

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
    neorg-unstable = pkgs.vimUtils.buildVimPlugin {
        name = "neorg";
        src = pkgs.fetchFromGitHub {
            owner = "vhyrro";
            repo = "neorg";
            rev = "bf1b812663b4a75221b4b8901edf578a49ba2f16";
            sha256 = "5tA/yRYY+8HBAdHDz8uPx2TtzCbseEXGkj7e/NAjDe4=";
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
    
environment.systemPackages = with pkgs; [
    (neovim.override {
        configure = {
            packages.myPlugins = with pkgs.vimPlugins; {
                start = [ popup-nvim plenary-nvim nvim-compe neorg-unstable ];
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
                nvim-bufferline-lua
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
                    packadd nvim-bufferline-lua
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
