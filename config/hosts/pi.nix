{ config, lib, pkgs, modulesPath, ... }:

{
    networking.hostName = "pi";

    # Nix settings
    nix = {
        package = pkgs.nixUnstable;
        allowedUsers = [ "notus" ];
        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };

    boot.cleanTmpDir = true;

    boot.loader.raspberryPi.firmwareConfig = "
        dtoverlay=act-led

        dtparam=act_led_trigger=none
        dtparam=act_led_activelow=off

        dtparam=pwr_led_trigger=none
        dtparam=pwr_led_activelow=off

        dtparam=eth_led0=4
        dtparam=eth_led1=4

        dtoverlay=pi3-disable-bt
        dtovrelay=pi3-disable-wifi
    ";

    # Set up user and enable sudo
    users.users.notus = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; 
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGT2HfLDD+Hp4GjoIIoQ2S6zxQ1m8psYijVfwpLhUoFXEq6X6tsMqn5lGkHmQET2s9BIEHjud4ySLsFn35yqC18WBIGLFkbE0wl9OcMXA06rkZwy6eeLczG0YoOuT0TbQkB2344j5F09e4b04g79jNq6FGJtS8CMyE0NiKu7hHy9+hrbz7aJFd1qzd8zdI9P22fBa9GbGsgVXO8ug9Sk9qk/YZwA+Zg4dNtj3ag6LSUZaSezwU4sb0P4P1wKw0b2u4flq7ZuDHrQlYqCltmv7CpmvtLc85L2raMEbfC0gaPYkO82GSEuOj6B4SuDNyr+3mCVCgFM+Fb2APKsgiUfGkMNE8mfqrUa4pPnqZrwjzM9qYjfl8yOF5NZNEfeJpYybk4FG8Uz47M3U7PXsC9cy4EslESdUvVZZghem1b0ecfIW5T2PlJxde6Rua7sYkkerdsPxo2wqRPzfQz/jR9dFNqKtlx/CxkSQE7x8YBCgoHBjCfQlfvRtGxYo0xzFDFdM= notus@notuslap" ];
    };

    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGT2HfLDD+Hp4GjoIIoQ2S6zxQ1m8psYijVfwpLhUoFXEq6X6tsMqn5lGkHmQET2s9BIEHjud4ySLsFn35yqC18WBIGLFkbE0wl9OcMXA06rkZwy6eeLczG0YoOuT0TbQkB2344j5F09e4b04g79jNq6FGJtS8CMyE0NiKu7hHy9+hrbz7aJFd1qzd8zdI9P22fBa9GbGsgVXO8ug9Sk9qk/YZwA+Zg4dNtj3ag6LSUZaSezwU4sb0P4P1wKw0b2u4flq7ZuDHrQlYqCltmv7CpmvtLc85L2raMEbfC0gaPYkO82GSEuOj6B4SuDNyr+3mCVCgFM+Fb2APKsgiUfGkMNE8mfqrUa4pPnqZrwjzM9qYjfl8yOF5NZNEfeJpYybk4FG8Uz47M3U7PXsC9cy4EslESdUvVZZghem1b0ecfIW5T2PlJxde6Rua7sYkkerdsPxo2wqRPzfQz/jR9dFNqKtlx/CxkSQE7x8YBCgoHBjCfQlfvRtGxYo0xzFDFdM= notus@notuslap" ];

    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;
    networking.useDHCP = false;
    networking.interfaces.eth0.useDHCP = true;

    boot.initrd.availableKernelModules = [ "usbhid" ];
    fileSystems."/" = { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888"; fsType = "ext4"; };

    swapDevices = [];

    environment.systemPackages = with pkgs; [ neovim git tmux ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    
    services.tlp.enable = true;
    powerManagement.powertop.enable = true;



}
