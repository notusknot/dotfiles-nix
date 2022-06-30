{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.direnv;

in {
    options.modules.direnv= { enable = mkEnableOption "direnv"; };
    config = mkIf cfg.enable {
        programs.direnv = {
            enable = true;
            nix-direnv.enable = true;
            enableZshIntegration = true;
        };
    };
}
