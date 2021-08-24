{ pkgs, config, ... }:

{
    # Install all the packages
    environment.systemPackages = with pkgs; [

        # Rice/desktop
        dwm dmenu feh zsh dunst

        # Import my build of st
        (st.overrideAttrs (oldAttrs: rec {
            src = fetchFromGitHub {
                owner = "notusknot";
                repo = "st";
                rev = "7444f4a1526b398b0d8e6988f06e69c8324d042f";
                sha256 = "0ahjimcfs9yw964ji19dp28al6xs2r1a88h39v1imkmr56xrph8p";
            };
        }))

        (dwm.overrideAttrs (oldAttrs: rec { 
            src = fetchFromGitHub { 
                owner="notusknot"; 
                repo="dwm"; 
                rev="603beed93d299b5a00a3f2cbd950c0c19668d1fd";
                sha256="1n0rv2w76jqbimzlswdb4ql8jmwdcdpb5hq9f6vl0slwfs3g9cfm";
            };
        }))

        # Command-line tools
        fzf ripgrep newsboat ffmpeg tealdeer exa duf 
        spotify-tui playerctl pass gnupg slop bat endlessh
        libnotify sct update-nix-fetchgit hyperfine 
       
        # GUI applications
        firefox mpv 

        # Development
        git gcc gnumake python3 

        # Language servers for neovim; change these to whatever languages you code in
        # Please note: if you remove any of these, make sure to also remove them from nvim/config/nvim/lua/lsp.lua!!
        rnix-lsp
        sumneko-lua-language-server
    ];
}
