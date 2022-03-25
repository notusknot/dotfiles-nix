{ config, pkgs, inputs, ... }:

{
    # Configure neovim
    imports = [ ./config/nvim/nvim.nix ];

    # Remove unecessary preinstalled packages
    environment.defaultPackages = [ ];
    services.xserver.desktopManager.xterm.enable = false;

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
            keep-outputs = true
            keep-derivations = true
        '';
    };

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

    # Set up user and enable sudo
    users.users.notus = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; 
        shell = pkgs.zsh;
    };

    # Set up networking and secure it
    networking = {
        wireless.iwd.enable = true;
        interfaces.enp0s25.useDHCP = false;
        firewall = {
            enable = true;
            allowedTCPPorts = [ 443 80 ];
            allowedUDPPorts = [ 443 80 44857 ];
            allowPing = false;
        };
    };

    # Set environment variables
    environment.variables = {
        NIXOS_CONFIG="$HOME/.config/nixos/configuration.nix"; 
        NIXOS_CONFIG_DIR="$HOME/.config/nixos/"; 
        XDG_DATA_HOME="$HOME/.local/share";
        PASSWORD_STORE_DIR="$HOME/.local/share/password-store";
        GTK_RC_FILES="$HOME/.local/share/gtk-1.0/gtkrc";
        GTK2_RC_FILES="$HOME/.local/share/gtk-2.0/gtkrc";
        MOZ_ENABLE_WAYLAND = "1";
        ZK_NOTEBOOK_DIR = "$HOME/stuff/notes/";
        EDITOR = "nvim";
        DIRENV_LOG_FORMAT = "";
    };

    # Security 
    security = {
        sudo.enable = false;
        doas = {
            enable = true;
            extraRules = [{
                users = [ "notus" ];
                keepEnv = true;
                persist = true;  
            }];
            extraConfig = "permit nopass notus cmd brillo";
        };

        # Extra security
        protectKernelImage = true;
    };

    # Do not touch
    system.stateVersion = "20.09";
}
