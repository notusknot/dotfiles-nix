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

        # Imports fortuneteller2k's custom packages, including sway-borders
        #nixpkgs-f2k = {
        #    url = "github:fortuneteller2k/nixpkgs-f2k";
        #    inputs.nixpkgs.follows = "nixpkgs";
        #};
    };

    # All outputs for the system (configs)
    outputs = { home-manager, nixpkgs, nur, neovim-nightly-overlay, ... }: 
        let
            system = "x86_64-linux"; #current system

        in {
            nixosConfigurations = {
            # Laptop config
            laptop = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ./configuration.nix ./hosts/laptop.nix ./config/packages.nix 
                    { nix.registry.nixpkgs.flake = nixpkgs; }
                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.notus = import ./config/home.nix;
                        nixpkgs.overlays = [ 
                            nur.overlay neovim-nightly-overlay.overlay  
                            # ( import ./overlays/sf-mono.nix )
                        ];
                    }
                ];
            };

            # Desktop config
            desktop = nixpkgs.lib.nixosSystem {
                inherit system
                modules = [
                    ./configuration.nix ./hosts/desktop.nix ./config/packages.nix 
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
        };
    };
}
