{ config, lib, pkgs, modulesPath, ... }:

{
    networking.hostName = "vps";

    # Nix settings
    nix = {
        package = pkgs.nixUnstable;
        allowedUsers = [ "notus" ];
        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };

    boot.cleanTmpDir = true;

    # Set up user and enable sudo
    users.users.notus = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; 
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGT2HfLDD+Hp4GjoIIoQ2S6zxQ1m8psYijVfwpLhUoFXEq6X6tsMqn5lGkHmQET2s9BIEHjud4ySLsFn35yqC18WBIGLFkbE0wl9OcMXA06rkZwy6eeLczG0YoOuT0TbQkB2344j5F09e4b04g79jNq6FGJtS8CMyE0NiKu7hHy9+hrbz7aJFd1qzd8zdI9P22fBa9GbGsgVXO8ug9Sk9qk/YZwA+Zg4dNtj3ag6LSUZaSezwU4sb0P4P1wKw0b2u4flq7ZuDHrQlYqCltmv7CpmvtLc85L2raMEbfC0gaPYkO82GSEuOj6B4SuDNyr+3mCVCgFM+Fb2APKsgiUfGkMNE8mfqrUa4pPnqZrwjzM9qYjfl8yOF5NZNEfeJpYybk4FG8Uz47M3U7PXsC9cy4EslESdUvVZZghem1b0ecfIW5T2PlJxde6Rua7sYkkerdsPxo2wqRPzfQz/jR9dFNqKtlx/CxkSQE7x8YBCgoHBjCfQlfvRtGxYo0xzFDFdM= notus@notuslap" ];
    };

    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGT2HfLDD+Hp4GjoIIoQ2S6zxQ1m8psYijVfwpLhUoFXEq6X6tsMqn5lGkHmQET2s9BIEHjud4ySLsFn35yqC18WBIGLFkbE0wl9OcMXA06rkZwy6eeLczG0YoOuT0TbQkB2344j5F09e4b04g79jNq6FGJtS8CMyE0NiKu7hHy9+hrbz7aJFd1qzd8zdI9P22fBa9GbGsgVXO8ug9Sk9qk/YZwA+Zg4dNtj3ag6LSUZaSezwU4sb0P4P1wKw0b2u4flq7ZuDHrQlYqCltmv7CpmvtLc85L2raMEbfC0gaPYkO82GSEuOj6B4SuDNyr+3mCVCgFM+Fb2APKsgiUfGkMNE8mfqrUa4pPnqZrwjzM9qYjfl8yOF5NZNEfeJpYybk4FG8Uz47M3U7PXsC9cy4EslESdUvVZZghem1b0ecfIW5T2PlJxde6Rua7sYkkerdsPxo2wqRPzfQz/jR9dFNqKtlx/CxkSQE7x8YBCgoHBjCfQlfvRtGxYo0xzFDFdM= notus@notuslap" ];

    # Set up networking and secure it
    /* networking = {
        networkmanager.enable = true;
        firewall = {
            enable = true;
            allowedTCPPorts = [ 443 80 8183 53 ];
            allowedUDPPorts = [ 443 80 8183 53 51820 ];
            allowPing = true;
        };
    };

    # Openssh settings for security
    services.openssh = {
        enable = true;
        ports = [ 8183 ];
        permitRootLogin = "no";
        passwordAuthentication = false;
    };
    # enable NAT
    networking.nat.enable = true;
    networking.nat.externalInterface = "eth0";
    networking.nat.internalInterfaces = [ "wg0" ];

    networking.wireguard.interfaces = {
        wg0 = {
            ips = [ "150.230.34.68/24" ];

            listenPort = 51820;

            postSetup = ''
                ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 150.230.34.68/24 -o eth0 -j MASQUERADE
            '';

            privateKeyFile = "/home/notus/keys/wg-private";

            peers = [
                { 
                    publicKey = "ar0hDNb8rINHFOuuzngoUzLGNAvBlnxC2BvIP8VEXVs=";
                    allowedIPs = [ "73.170.139.156/32" ];
                }
            ];
        };
    }; */

    security.acme = {
        acceptTerms = true;
        email = "notusknot@pm.me";
    };

    services.nginx = {
        enable = true;

        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

        virtualHosts = {
            "notusknot.com" = {
                forceSSL = true;
                enableACME = true;
                root = "/home/notus/blog";

                locations."/" = {};
                locations."/".extraConfig = ''
                    autoindex on;
                '';
            };
        };
    };

    imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

    boot.loader.grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
    };

    fileSystems."/boot" = { device = "/dev/disk/by-uuid/1F17-62E7"; fsType = "vfat"; };
    boot.initrd.kernelModules = [ "nvme" ];
    fileSystems."/" = { device = "/dev/sda3"; fsType = "xfs"; };

    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

}
