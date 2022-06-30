{ config, lib, pkgs, modulesPath, ... }:
{
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot = {
        initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        initrd.kernelModules = [ "amdgpu" ];
        kernelModules = [ "wireguard" "kvm-amd" "msr" ];
        extraModulePackages = [ ];
    };

    hardware.opengl.extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
    ];

    fileSystems."/" = { 
        device = "/dev/disk/by-uuid/bd1e247e-9db1-4871-ae5a-f1d9dd0d09fb";
        fsType = "ext4";
    };

    fileSystems."/boot" = { 
        device = "/dev/disk/by-uuid/62D7-547D";
        fsType = "vfat";
    };

    swapDevices = [ { device = "/dev/disk/by-uuid/e8eac985-dcd4-4f52-8681-751e13b37e28"; } ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
