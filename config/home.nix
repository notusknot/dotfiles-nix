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
            terminal = "kitty";
            menu = "dmenu_run";
            modifier = "Mod4";

            bars = [];

            gaps.inner = 15;

            window.border = 5;

            startup = [ 
                { command = "swaybg --image .config/nixos/config/pics/wallpaper.png"; } 
                { command = "kitty"; } 
            ];
        };
    };

    programs.kitty = {
        enable = true;
        extraConfig = ''
            window_padding_width 12.0
            font_family JetBrainsMono NerdFont
            font_size 12.0

            # The basic colors
            foreground              #D9E0EE
            background              #292a37
            selection_foreground    #D9E0EE
            selection_background    #9699b7
            cursor_text_color       #292a37
            inactive_border_color   #9699b7
            active_tab_background   #9699b7
            inactive_tab_foreground #D9E0EE
            inactive_tab_background #292a37
            tab_bar_background      #393a4d
            mark1_foreground #292a37
            mark2_foreground #292a37
            mark3_foreground #292a37
            color0 #9699b7
            color8 #9699b7
            color1 #ec6a88
            color9 #e95678
            color2  #3fdaa4
            color10 #29d398
            color3  #efb993
            color11 #efb993
            color4  #3fc6de
            color12 #26bbd9
            color5  #b771dc
            color13 #b072d1
            color6  #6be6e6
            color14 #59e3e3
            color7  #D9E0EE
            color15 #D9E0EE
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
