# This file goes in /etc/nixos/configuration.nix, and is the system-wide config file
# If you want to use this config for yourself, you might want to change the username,
# installed packages, and localizations. 

# Also, make sure to use the unstable branch of NixOS in order to install all the packages! 
# Read about it here: nixos.wiki/wiki/Nix_channels

{ config, pkgs, ... }:

{
  # Import the hardware-configuration and home-manager as a module
  imports = [ ./hardware-configuration.nix <home-manager/nixos> ];

  # Import neovim nightly to get more features
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  # Auto upgrades
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Auto cleanup
  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 8d";
    };
  };

  # Import and set up home-manager
  home-manager.users.notus = { imports = [ /etc/nixos/home.nix ]; };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Set up bootloader and clean /tmp/ on boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;

  # Set up networking
  networking.hostName = "nixos";
  networking.useDHCP = false;
  networking.interfaces.enp9s0.useDHCP = true;
  networking.interfaces.wlp8s0.useDHCP = true;

  # Set up locales (timezone and keyboard layout)
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.layout = "us";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # X settings (bspwm, lightdm, etc)
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager = {
    bspwm.enable = true;
  };

  # Enable audio
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Set up user and enable sudo
  users.users.notus = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 
    shell = pkgs.zsh;
  };

  # Install packages
    environment.systemPackages = with pkgs; [
    wget neovim-nightly nodejs zsh pfetch htop playerctl python3 unzip youtube-dl git cargo rustc cmus spotify-tui slop ffmpeg tmux
    firefox rxvt-unicode pavucontrol firefox pcmanfm lxappearance gimp 
    bspwm sxhkd dmenu feh polybar nordic lua gcc dunst libnotify sct fzf postgresql 
    nodePackages.pyright nodePackages.typescript-language-server ripgrep
    nodePackages.live-server pass gnupg pinentry-qt
    # Install spotifyd with more features
    (spotifyd.override {
      withPulseAudio = true;
      withMpris = true;
      withKeyring = true;
    })
  ];

  services.postgresql.enable = true; # Enable postgresql

  nixpkgs.config.permittedInsecurePackages = [ 
         "ffmpeg-2.8.17" # Allow ffmpeg to be installed
  ];

  # Install JetBrainsMono NerdFont
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Fix Steam
  hardware.opengl.driSupport32Bit = true;

  # Do not touch
  system.stateVersion = "20.09";
}
