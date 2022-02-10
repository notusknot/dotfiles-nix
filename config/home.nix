{ config, pkgs, ... }:

let 
    # Import zsh config file
    zshsettings = import ./zsh/zsh.nix;
    nvimsettings = import ./nvim/nvim.nix;
in 
{ 
    # Enable home-manager
    programs.home-manager.enable = true;

    # Source extra files that are too big for this one 
    programs.zsh = zshsettings pkgs;
    programs.neovim = nvimsettings pkgs;

    # Settings for XDG user directory, to declutter home directory
    xdg.userDirs = {
        enable = true;
        documents = "$HOME/stuff/other/";
        download = "$HOME/stuff/other/";
        videos = "$HOME/stuff/other/";
        music = "$HOME/stuff/music/";
        pictures = "$HOME/stuff/pictures/";
        desktop = "$HOME/stuff/other/";
        publicShare = "$HOME/stuff/other/";
        templates = "$HOME/stuff/other/";
    };

    home.file = {
        ".local/share/dwm/autostart.sh" = {
            executable = true;
            text = "
            #!/bin/sh
            status () { 
                echo -n BAT: \"$(acpi | awk '{print $4}' | sed s/,//) | $(date '+%m/%d %H:%M') \" 
            }
            feh --no-fehbg --bg-fill $NIXOS_CONFIG_DIR/config/pics/wallpaper.png
            rm $HOME/.xsession-errors $HOME/.xsession-errors.old .bash_history
            xrandr --rate 144
            xidlehook --not-when-audio --not-when-fullscreen --timer 300 'i3lock -c 000000' '' &
            while true; do
                xsetroot -name \"$(status)\"
                sleep 30
            done";
        };
    };

    # Settings for git
    programs.git = {
        enable = true;
        userName = "notusknot";
        userEmail = "notusknot@gmail.com";
        extraConfig = {
            init = { defaultBranch = "main"; };
        };
    };

    # Settings for gpg
    programs.gpg = {
        enable = true;
    };

    # Fix pass
    services.gpg-agent = {
        enable = true;
        pinentryFlavor = "qt";
    };

    # Settings for picom compositor (shadows, fading, etc)
    services.picom = {
        enable = true;
        shadow = true;
        shadowOpacity = "0.3";
        extraOptions = ''
            shadow-radius = 10;
            corner-radius = 9;
            round-borders = 1;
        '';
        fade = true;
        fadeDelta = 2;
        backend = "glx";
    };

    # Do not touch
    home.stateVersion = "21.03";
}
