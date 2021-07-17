{ config, pkgs, ... }:

# Make sure to use the master/unstable branch of home-manager!

# Home-manager is installed as a module on my system, meaning you dont have it
# in your PATH, but you can update the configuration with nixos-rebuild switch.
# Read about it here: nixos.wiki/wiki/Home_Manager

let 
  # Import extra files
  #  vimsettings = import ./config/nvim/nvim.nix;
  zshsettings = import ./config/zsh/zsh.nix;
  customNeovim = import ./config/nvim/nvim.nix;

in 
  { 
  # Enable home-manager
  programs.home-manager.enable = true;
  # Source extra files that are too big for this one 
  programs.zsh = zshsettings pkgs;
  programs.neovim = customNeovim pkgs;
  
  xdg.configFile."nvim/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
  xdg.configFile."nvim/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
  xdg.configFile."nvim/parser/python.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
  xdg.configFile."nvim/parser/bash.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-bash}/parser";
  xdg.configFile."nvim/parser/html.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-html}/parser";
  xdg.configFile."nvim/parser/css.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-css}/parser";
  xdg.configFile."nvim/parser/javascript.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-javascript}/parser";
  xdg.configFile."nvim/parser/nix.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";

  # Settings for XDG user directory, to declutter home directory
  xdg.userDirs = {
    enable = true;
    documents = "$HOME/stuff/other/";
    download = "$HOME/stuff/other/";
    videos = "$HOME/stuff/other/";
    music = "$HOME/stuff/music/";
    pictures = "$HOME/stuff/pictures/";
    desktop = "$HOME/stuff/other/";
    publicShare = "$HOME/stuff/other/";
    templates = "$HOME/stuff/other/";
  };

  # Settings for git
  programs.git = {
    enable = true;
    userName = "notusknot";
    userEmail = "notusknot@gmail.com";
    extraConfig = {
      init = { defaultBranch = "main"; };
    };
  };

  # Settings for gpg
  programs.gpg = {
    enable = true;
  };

  # Fix pass
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
  };


  # Do not touch
  home.stateVersion = "21.03";
}
