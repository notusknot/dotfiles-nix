{ inputs, lib, config, pkgs, ... }:
let
    cfg = config.modules.nvim;
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
in {
    options.modules.nvim = { enable = mkEnableOption "nvim"; };
    config = mkIf cfg.enable {

        home.file.".config/nvim/settings.lua".source = ./init.lua;
        
        home.packages = with pkgs; [
            rnix-lsp nixfmt # Nix
            sumneko-lua-language-server stylua # Lua
        ];

        programs.zsh = {
            initExtra = ''
                export EDITOR="nvim"
            '';

            shellAliases = {
                v = "nvim -i NONE";
                nvim = "nvim -i NONE";
            };
        };

        programs.neovim = {
            enable = true;
            withNodeJs = false;
            withPython3 = false;
            withRuby = false;
            plugins = with pkgs.vimPlugins; [ 
                vim-nix
                plenary-nvim
                {
                    plugin = jabuti-nvim;
                    config = "colorscheme jabuti";
                }
                {
                    plugin = impatient-nvim;
                    config = "lua require('impatient')";
                }
                {
                    plugin = lualine-nvim;
                    config = "lua require('lualine').setup()";
                }
                {
                    plugin = telescope-nvim;
                    config = "lua require('telescope').setup()";
                }
                {
                    plugin = indent-blankline-nvim;
                    config = "lua require('indent_blankline').setup()";
                }
                {
                    plugin = nvim-treesitter;
                    config = ''
                    lua << EOF
                    require('nvim-treesitter.configs').setup {
                        ensure_installed = "nix", "rust", "c", "python", "lua", "html", "css", "javascript",
                        highlight = {
                            enable = true,
                            disable = { "gdresource", "hack", "gdscript", "fusion", "glimmer", "glsl" }
                        },
                        ignore_install = { "gdresource", "hack", "gdscript", "fusion", "glimmer", "glsl" },
                    }
                    EOF
                    '';
                }
            ];

            extraConfig = ''
                luafile ~/.config/nvim/settings.lua
            '';
        };
    };
}
