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
    };

    # All outputs for the system (configs)
    outputs = { home-manager, nixpkgs, nur, neovim-nightly-overlay, ... }: {
        nixosConfigurations = {
            # Laptop config
            laptop = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix ./hosts/laptop.nix ./config/packages.nix 
                    { nix.registry.nixpkgs.flake = nixpkgs; }
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

            # Desktop config
            desktop = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix ./hosts/desktop.nix ./config/packages.nix 
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
