{ pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.modules.scripts;
in {
    options.modules.scripts = { enable = mkEnableOption "scripts"; };
    config = mkIf cfg.enable {
        home.packages = [
            screen bandw maintenance
        ];
    };
}
