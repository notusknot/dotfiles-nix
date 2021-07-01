{ pkgs, config, ... }:

# This file going in /etc/nixos/packages.nix. It is not necessary,
# but I choose to have it in a seperate file to keep it more clean.
# This file also imports my custom build of st.

# Import the custom builds of st
let 
  # Import custom st build
  st = pkgs.callPackage ./st.nix {};
  customPackages = with pkgs; [
    st
  ];

  # Choose all the packages I want on my system
  regularPackages = with pkgs; [

    # Rice/desktop
    dwm dmenu feh zsh dunst

    # Command-line tools
    fzf ripgrep appimage-run tree 
    spotify-tui playerctl pass gnupg slop ffmpeg
    libnotify sct update-nix-fetchgit cordless

    # GUI applications
    firefox 

    # Development
    neovim git gcc gnumake gnupatch lua jdk8 python3 nodejs

    # Language servers for neovim; change these to whatever languages you code in
    # Please note: if you remove any of these, make sure to also remove them from nvim/config/nvim/lua/lsp.lua!!
    nodePackages.pyright
    rnix-lsp
    nodePackages.vls
    sumneko-lua-language-server
  ];
in
{
  # Install all the packages
  environment.systemPackages = regularPackages ++ customPackages;
}
