{ config, pkgs, ... }:

{
    # Set environment variables
    environment.variables = {
        NIXOS_CONFIG="$HOME/.config/nixos/configuration.nix"; NIXOS_CONFIG_DIR="$HOME/.config/nixos/"; };
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

    # Boot settings: clean /tmp/, latest kernel and enable bootloader
    boot = {
        cleanTmpDir = true;
        loader = {
            systemd-boot.enable = true;
            systemd-boot.editor = false;
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
            touchpad.naturalScrolling = false;
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
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGT2HfLDD+Hp4GjoIIoQ2S6zxQ1m8psYijVfwpLhUoFXEq6X6tsMqn5lGkHmQET2s9BIEHjud4ySLsFn35yqC18WBIGLFkbE0wl9OcMXA06rkZwy6eeLczG0YoOuT0TbQkB2344j5F09e4b04g79jNq6FGJtS8CMyE0NiKu7hHy9+hrbz7aJFd1qzd8zdI9P22fBa9GbGsgVXO8ug9Sk9qk/YZwA+Zg4dNtj3ag6LSUZaSezwU4sb0P4P1wKw0b2u4flq7ZuDHrQlYqCltmv7CpmvtLc85L2raMEbfC0gaPYkO82GSEuOj6B4SuDNyr+3mCVCgFM+Fb2APKsgiUfGkMNE8mfqrUa4pPnqZrwjzM9qYjfl8yOF5NZNEfeJpYybk4FG8Uz47M3U7PXsC9cy4EslESdUvVZZghem1b0ecfIW5T2PlJxde6Rua7sYkkerdsPxo2wqRPzfQz/jR9dFNqKtlx/CxkSQE7x8YBCgoHBjCfQlfvRtGxYo0xzFDFdM= notus@notuslap" ];
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
        firewall = {
            enable = true;
            allowedTCPPorts = [ 443 80 ];
            allowedUDPPorts = [ 443 80 44857 ];
            allowPing = false;

            # Allow wireguard
            logReversePathDrops = true;
            extraCommands = ''
                ip46tables -t raw -I nixos-fw-rpfilter -p udp -m udp --sport 44857 -j RETURN
                ip46tables -t raw -I nixos-fw-rpfilter -p udp -m udp --dport 44857 -j RETURN
            '';
            extraStopCommands = ''
                ip46tables -t raw -D nixos-fw-rpfilter -p udp -m udp --sport 44857 -j RETURN || true
                ip46tables -t raw -D nixos-fw-rpfilter -p udp -m udp --dport 44857 -j RETURN || true
            '';
        };
    };

    # Openssh settings for security
    services.openssh = {
        enable = true;
        permitRootLogin = "no";
        passwordAuthentication = false;
    };

    security.protectKernelImage = true;

    # Do not touch
    system.stateVersion = "20.09";
    
}
