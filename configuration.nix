{ config, pkgs, ... }:

{
    # Set environment variables


    environment.defaultPackages = [ ];

    # Nix settings, auto cleanup and enable flakes
    nix = {
        settings.auto-optimise-store = true;
        settings.allowed-users = [ "notus" ];
        gc = {
            automatic = true;
            dates = "daily";
        };
        package = pkgs.nixUnstable;
        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };

    services.xserver.desktopManager.xterm.enable = false;

    # Boot settings: clean /tmp/, latest kernel and enable bootloader
    boot = {
        cleanTmpDir = true;
        loader = {
            systemd-boot.enable = true;
            systemd-boot.editor = false;
            efi.canTouchEfiVariables = true;
            timeout = 0;
        }; 
    };

    # Set up locales (timezone and keyboard layout)
    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };
    
    # Enable audio
    sound.enable = true;

    hardware = {
        pulseaudio.enable = true;
        opengl = {
            enable = true;
            driSupport = true;
        };
    };

    # Set up user and enable sudo
    users.users.notus = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; 
        shell = pkgs.zsh;
    };

    # Install fonts
    fonts.fonts = with pkgs; [
        jetbrains-mono
        roboto
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    # Set up networking and secure it
    networking = {
        wireless.iwd.enable = true;
        firewall = {
            enable = true;
            allowedTCPPorts = [ 443 80 ];
            allowedUDPPorts = [ 443 80 44857 ];
            allowPing = false;
        };
    };

    security.protectKernelImage = true;

    environment.variables = {
        NIXOS_CONFIG="$HOME/.config/nixos/configuration.nix"; 
        NIXOS_CONFIG_DIR="$HOME/.config/nixos/"; 
        XDG_DATA_HOME="$HOME/.local/share";
        XAUTHORITY="$HOME/.Xauthority";
        CARGO_HOME="$XDG_DATA_HOME/cargo";
        GEM_HOME="$HOME/.local/share/gem";
        PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store";
        USERXSESSION="$XDG_CACHE_HOME/X11/xsession";
        USERXSESSIONRC="$XDG_CACHE_HOME/X11/xsessionrc";
        ALTUSERXSESSION="$XDG_CACHE_HOME/X11/Xsession";
        ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors";
        GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc";
        GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
        MOZ_ENABLE_WAYLAND = "1";
    };

    xdg = {
        portal = {
            enable = true;
            extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
            ];
            gtkUsePortal = true;
        };
    };

    # Do not touch
    system.stateVersion = "20.09";
}
