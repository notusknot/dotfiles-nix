{
    description = "NixOS configuration";

    # All inputs for the system
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        neovim-nightly-overlay = {
            url = "github:nix-community/neovim-nightly-overlay";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        cmp-nvim-dev = {
            url = "github:hrsh7th/nvim-cmp/dev";
            inputs.nixpkgs.follows = "nixpkgs";
            flake = false;
        };
    };

    # All outputs for the system (configs)
    outputs = { home-manager, nixpkgs, nur, neovim-nightly-overlay, cmp-nvim-dev, ... }: {
        nixosConfigurations = {

            # Laptop config
            laptop = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix ./config/hosts/laptop.nix ./config/packages.nix 
                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.notus = import ./config/home.nix;
                        nixpkgs.overlays = [ 
                            nur.overlay neovim-nightly-overlay.overlay
                            (prev: final: rec {
                                nvim-cmp = prev.vimUtils.buildVimPluginFrom2Nix {
                                    pname = "nvim-cmp";
                                    version = "dev";
                                    src = cmp-nvim-dev;
                            };})
                        ];
                    }
                ];
            };

            # Desktop config
            desktop = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix ./config/hosts/desktop.nix ./config/packages.nix 
                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.notus = import ./config/home.nix;
                        nixpkgs.overlays = [ 
                            nur.overlay neovim-nightly-overlay.overlay 
                        ];
                    }
                ];
            };
        };
    };
}
