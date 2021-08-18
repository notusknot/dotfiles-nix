{
    description = "NixOS configuration";

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

    outputs = { home-manager, nixpkgs, nur, neovim-nightly-overlay, ... }: {
        nixosConfigurations = {
            notuslap = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix ./config/laptop.nix
                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.notus = import ./config/home.nix;
                        nixpkgs.overlays = [ nur.overlay neovim-nightly-overlay.overlay ];
                    }
                ];
            };
            notusdesk = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix ./config/desktop.nix
                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.notus = import ./config/home.nix;
                        nixpkgs.overlays = [ nur.overlay neovim-nightly-overlay.overlay ];
                    }
                ];
            };
            notuspi = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix ./config/pi.nix
                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.notus = import ./config/home.nix;
                        nixpkgs.overlays = [ nur.overlay neovim-nightly-overlay.overlay ];
                    }
                ];
            };
        };
    };
}
