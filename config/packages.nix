{ pkgs, config, ... }:

{
    nixpkgs.config.allowUnfree = true;
    # Install all the packages
    environment.systemPackages = with pkgs; [

        # Rice/desktop
        dwm dmenu eww feh zsh dunst st i3lock xidlehook picom

        # Command-line tools
        fzf ripgrep ffmpeg tealdeer exa htop
        pass gnupg slop bat unzip xclip afetch
        libnotify update-nix-fetchgit lowdown
       
        # GUI applications
        mpv anki brave 

        # Development
        git 

        # Language servers for neovim; change these to whatever languages you code in
        # Please note: if you remove any of these, make sure to also remove them from nvim/config/nvim/lua/lsp.lua!!
        rnix-lsp
        sumneko-lua-language-server
    ];
}
