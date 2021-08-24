{ config, pkgs, ... }:

{
    # Import the necessary modules and files

    # Set environment variables
    environment.variables = {
        NIXOS_CONFIG="$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR="$HOME/.config/nixos/";
    };

    # Nix settings, auto cleanup and enable flakes
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

    # Boot settings: clean /tmp/, latest kernel and enable bootloader
    boot = {
        cleanTmpDir = true;
        kernelPackages = pkgs.linuxPackages_latest;
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        }; 
    };

    # Set up locales (timezone and keyboard layout)
    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    # X server settings
    services.xserver = {
        layout = "us";
        enable = true;

        # Display manager and window manager
        displayManager.lightdm.enable = true;
        windowManager.dwm.enable = true;

        # Touchpad scrolling
        libinput = {
            enable = true;
            naturalScrolling = true;
        };
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

    # Install fonts
    fonts.fonts = with pkgs; [
        jetbrains-mono 
        roboto
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    # Set up networking and secure it
    networking = {
        networkmanager.enable = true;
        nameservers = [ "1.1.1.1" "1.0.0.1" ];
        firewall = {
            enable = true;
            allowedTCPPorts = [ 22 443 80 8183 ];
            allowedUDPPorts = [ 22 443 80 8183 ];
            allowPing = false;
        };
    };

    # Openssh settings for security
    services.openssh = {
        enable = true;
        extraConfig = "
            AddressFamily inet
        ";
        ports = [ 8183 ];
        permitRootLogin = "no";
        passwordAuthentication = false;
    };

    # Cron jobs
    services.cron = {
        enable = true;
        systemCronJobs = [
            "@reboot endlessh -p 22"
        ];
    };

    # Do not touch
    system.stateVersion = "20.09";
}
