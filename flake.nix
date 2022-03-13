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

        st-src = {
            url = "github:notusknot/st";
            inputs.nixpkgs.follows = "nixpkgs";
            flake = false;
        };

        sway = {
            url = "github:fluix-dev/sway-borders";
            inputs.nixpkgs.follows = "nixpkgs";
            flake = false;
        };

        wlroots-src = { 
            url = "github:swaywm/wlroots"; 
            flake = false; 
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    # All outputs for the system (configs)
    outputs = { home-manager, nixpkgs, nur, neovim-nightly-overlay, st-src, sway, ... }: {
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
                            (final: prev: {
                                st = prev.st.overrideAttrs (o: {
                                    src = st-src;
                                });
                                sway-borders = prev.sway-unwrapped.overrideAttrs (o: {
                                    src = sway;
                                });
                            })
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
