{ config, lib, pkgs, modulesPath, ... }:

{
    networking.hostName = "vps";


    # enable NAT
    networking.nat.enable = true;
    networking.nat.externalInterface = "eth0";
    networking.nat.internalInterfaces = [ "wg0" ];

    networking.wireguard.interfaces = {
        wg0 = {
            ips = [ "10.100.0.1/24" ];

            listenPort = 51820;

            postSetup = ''
                ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
            '';

            postShutdown = ''
                ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
            '';

            privateKeyFile = "/home/notus/keys/wg-private";

            peers = [
                { 
                    publicKey = "ar0hDNb8rINHFOuuzngoUzLGNAvBlnxC2BvIP8VEXVs=";
                    allowedIPs = [ "10.100.0.2/32" ];
                }
            ];
        };
    };



    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot = {
        initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        kernelModules = [ "kvm-amd" ];
    };

    fileSystems."/" = {
        device = "/dev/disk/by-uuid/bd1e247e-9db1-4871-ae5a-f1d9dd0d09fb";
        fsType = "ext4";
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/62D7-547D";
        fsType = "vfat";
    };

    swapDevices = [ { device = "/dev/disk/by-uuid/e8eac985-dcd4-4f52-8681-751e13b37e28"; } ];
}
