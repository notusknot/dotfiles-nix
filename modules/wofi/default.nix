{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.wofi;

in {
    options.modules.wofi = { enable = mkEnableOption "wofi"; };
    config = mkIf cfg.enable {
        programs.zsh.shellAliases.wofi = "wofi --show drun --xoffset=44 --yoffset=12 --width=12% --height=984 --style=$HOME/.config/wofi.css";

        home.file.".config/wofi.css".source = ./wofi.css;
    };
}
