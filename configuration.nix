{ config, pkgs, ... }:

{
    # Neovim configuration
    imports = [ ./config/nvim/nvim.nix ];

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

    nixpkgs.config.allowBroken = true;

    # Boot settings: clean /tmp/, latest kernel and enable bootloader
    boot = {
        cleanTmpDir = true;
        kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_5_10.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
            url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
            sha256 = "sha256-8rckm5kEnIQzjaCebIV9MZyXq3o5bQA1ysv7bnPhNQc=";
      };
      version = "5.10.45";
      modDirVersion = "5.10.45";
      };
  });
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
            touchpad.naturalScrolling = true;
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
