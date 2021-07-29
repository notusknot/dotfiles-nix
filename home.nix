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
  # programs.neovim = customNeovim pkgs;

  services.spotifyd = {
      enable = true;
      package = pkgs.spotifyd.override {
          withMpris = true;
          withPulseAudio = true;
      };
      settings = {
          global = {
              username = "pkj258alfons";
              backend = "alsa";
              device = "default";
              mixer = "PCM";
              volume-controller = "alsa";
              device_name = "spotifyd";
              device_type = "speaker";
              bitrate = 96;
              cache_path = ".cache/spotifyd";
              volume-normalisation = true;
              normalisation-pregain = -10;
              initial_volume = "50";
          };
      };
  };

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

  home.file = {
    ".local/share/dwm/autostart.sh" = {
      executable = true;
      text = "
      #!/bin/sh
      feh --no-fehbg --bg-tile $NIXOS_CONFIG_DIR/config/nix-tile.png
      xrandr --rate 144
      while true; do
        xsetroot -name \"$(date)\"
        sleep 60
      done";
    };
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
