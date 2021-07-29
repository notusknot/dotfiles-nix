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
    # Install all the packages
    environment.systemPackages = with pkgs; [
        # Rice/desktop
        dwm dmenu feh zsh dunst

        (st.overrideAttrs (oldAttrs: rec {
          src = fetchFromGitHub {
            owner = "notusknot";
            repo = "st";
            rev = "7444f4a1526b398b0d8e6988f06e69c8324d042f";
            sha256 = "0ahjimcfs9yw964ji19dp28al6xs2r1a88h39v1imkmr56xrph8p";
          };
        }))


        # Command-line tools
        fzf ripgrep tree 
        spotify-tui playerctl pass gnupg slop ffmpeg
        libnotify sct update-nix-fetchgit hyperfine tldr 
        
        # GUI applications
        firefox mpv vial

        # Development
        git gcc gnumake lua jdk11 python3 nodejs

        # Language servers for neovim; change these to whatever languages you code in
        # Please note: if you remove any of these, make sure to also remove them from nvim/config/nvim/lua/lsp.lua!!
        rnix-lsp
        sumneko-lua-language-server
    ];
}
