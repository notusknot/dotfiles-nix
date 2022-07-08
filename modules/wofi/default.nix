{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.wofi;

in {
    options.modules.wofi = { enable = mkEnableOption "wofi"; };
    config = mkIf cfg.enable {
        home.file.".config/wofi.css".source = ./wofi.css;
    };
}
