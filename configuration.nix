# This file goes in /etc/nixos/configuration.nix, and is the system-wide config file
# If you want to use this config for yourself, you might want to change the username,
# installed packages, and localizations. 

# Also, make sure to use the unstable branch of NixOS in order to install all the packages! 
# Read about it here: nixos.wiki/wiki/Nix_channels

{ config, pkgs, ... }:

{
    # Import the necessary modules and files
    imports = [ ./hardware-configuration.nix ./config/nvim/nvim.nix ./config/packages.nix ];

    environment.variables = {
        NIXOS_CONFIG="$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR="$HOME/.config/nixos/";
    };
    # Import neovim nightly to get more features
    nixpkgs.overlays = [
        (final: prev: {
        dwm = prev.dwm.overrideAttrs (old: { 
            src = pkgs.fetchFromGitHub { 
            owner="notusknot"; 
            repo="dwm"; 
            rev="603beed93d299b5a00a3f2cbd950c0c19668d1fd";
            sha256="1n0rv2w76jqbimzlswdb4ql8jmwdcdpb5hq9f6vl0slwfs3g9cfm";
            };
        });
        })
    ];

        # Auto cleanup
    nix = {
        autoOptimiseStore = true;
        gc = {
            automatic = true;
            dates = "daily";
        };
        package = pkgs.nixUnstable;
        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };

    # Set up bootloader and clean /tmp/ on boot
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.cleanTmpDir = true;

    # Set up networking
    networking = {
        hostName = "nixos";
        networkmanager.enable = true;
    };

    # Set up locales (timezone and keyboard layout)
    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    # X settings (bspwm, lightdm, etc)
    services.xserver = {
        layout = "us";
        enable = true;
        libinput.enable = true;
        displayManager.lightdm.enable = true;
        windowManager.dwm.enable = true;
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

    # Install JetBrainsMono NerdFont
    fonts.fonts = with pkgs; [
        jetbrains-mono 
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    # Fix Steam
    hardware.opengl.driSupport32Bit = true;

    # Do not touch
    system.stateVersion = "20.09";
}
