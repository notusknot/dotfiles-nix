{ pkgs, config, ... }:

{
    nixpkgs.config.allowUnfree = true;
    # Install all the packages
    environment.systemPackages = with pkgs; [

        # Rice/desktop
        dmenu eww zsh dunst wl-clipboard swaybg

        # Command-line tools
        ripgrep ffmpeg tealdeer exa htop
        pass gnupg slop bat unzip xclip afetch
        libnotify lowdown
       
        # GUI applications
        mpv brave 

        # Development
        git zig

        # Language servers for neovim; change these to whatever languages you code in
        # Please note: if you remove any of these, make sure to also remove them from nvim/config/nvim/lua/lsp.lua!!
        rnix-lsp
        sumneko-lua-language-server
    ];
}
