{ config, pkgs, ... }:

let 
    # Import config files
    zshsettings = import ./zsh/zsh.nix;
    nvimsettings = import ./nvim/nvim.nix;
    ffsettings = import ./firefox/firefox.nix;
in 
{ 
    # Enable home-manager
    programs.home-manager.enable = true;

    # Source extra files that are too big for this one 
    programs.zsh = zshsettings pkgs;
    programs.neovim = nvimsettings pkgs;
    programs.firefox = ffsettings pkgs;

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


    wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true; # so that gtk works properly
        config = {
            terminal = "st";
            menu = "bemenu-run";
            modifier = "Mod4";

            bars = [];

            gaps.inner = 12;

            window.border = 4;

            startup = [ 
                { command = "swaybg --image .config/nixos/config/pics/wallpaper.png"; } 
            ];
        };

        extraConfig = ''
            # Border Images: needs sway-borders which is finicky at the moment
            #border_images.focused ${./pics/rounded.png}
            #border_images.focused_inactive ${./pics/rounded.png}
            #border_images.unfocused ${./pics/rounded.png}
            #border_images.urgent ${./pics/rounded.png}
            bindsym --locked XF86MonBrightnessUp exec light -S "$(light -G | awk '{ print int(($1 + .72) * 1.4) }')" 
            bindsym --locked XF86MonBrightnessDown exec light -S "$(light -G | awk '{ print int($1 / 1.4) }')"

            # Property Name         Border  BG      Text    Indicator Child Border
            client.focused          #44465c #44465c #d9e0ee #d9e0ee #44465c
            client.focused_inactive #292a37 #292a37 #d9e0ee #d9e0ee #44465c
            client.unfocused        #292a37 #292a37 #d9e0ee #d9e0ee #292a37
            client.urgent           #292a37 #292a37 #ec6a88 #d9e0ee #ec6a88
        '';
    };

    # Widgets
    programs.eww = {
        enable = true;
        configDir = ./eww;
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

    # Do not touch
    home.stateVersion = "21.03";
}
