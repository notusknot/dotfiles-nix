{ pkgs, config, ... }:

{
    nixpkgs.config.allowUnfree = true;
    # Install all the packages
    environment.systemPackages = with pkgs; [

        # Rice/desktop
        bemenu zsh dunst wl-clipboard swaybg sway brillo wlsunset

        # Command-line tools
        ripgrep ffmpeg tealdeer exa htop
        pass gnupg slop bat unzip afetch
        lowdown zk grim slurp imagemagick
       
        # GUI applications
        mpv brave firefox pqiv 

        # Development
        git zig

        # Language servers for neovim; change these to whatever languages you code in
        # Please note: if you remove any of these, make sure to also remove them from nvim/config/nvim/lua/lsp.lua!!
        rnix-lsp
        sumneko-lua-language-server
        rust-analyzer
    ];
}
