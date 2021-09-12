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

        dwm = {
            url = "github:notusknot/dwm";
            inputs.nixpkgs.follows = "nixpkgs";
            flake = false;
        };

        st = {
            url = "github:notusknot/st";
            inputs.nixpkgs.follows = "nixpkgs";
            flake = false;
        };

        neovim-nightly-overlay = {
            url = "github:nix-community/neovim-nightly-overlay";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    # All outputs for the system (configs)
    outputs = { home-manager, nixpkgs, nur, neovim-nightly-overlay, st, dwm, ... }: {
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
                            (final: prev: {
                                st = prev.st.overrideAttrs (o: {
                                    src = st;
                                });
                            })
                            (final: prev: {
                                dwm = prev.dwm.overrideAttrs (o: {
                                    src = dwm;
                                });
                            })
                            nur.overlay neovim-nightly-overlay.overlay 
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
                            (final: prev: {
                                st = prev.st.overrideAttrs (o: {
                                    src = st;
                                });
                            })
                            (final: prev: {
                                dwm = prev.dwm.overrideAttrs (o: {
                                    src = dwm;
                                });
                            })
                            nur.overlay neovim-nightly-overlay.overlay 
                        ];
                    }
                ];
            };

            # Oracle VPS config
            vps = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./config/hosts/vps.nix
                ];
            };
            
            # Raspberry Pi config
            pi = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./config/hosts/pi.nix
                ];
            };

        };
    };
}
