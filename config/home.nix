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
    #programs.neovim = nvimsettings pkgs;
    programs.firefox = ffsettings pkgs;

    # Direnv
    programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
    };

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

    # SwayWM setup
    wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true; # so that gtk works properly
        config = {
            terminal = "footclient";
            menu = "bemenu-run";
            modifier = "Mod4";

            bars = [];

            gaps.inner = 12;

            window.border = 4;

            startup = [ 
                { command = "swaybg --image .config/nixos/pics/wallpaper.png"; } 
                { command = "$HOME/stuff/start.sh"; } 
                { command = "foot --server"; } 
            ];
        };

        extraConfig = ''
            # Border Images: needs sway-borders which is finicky at the moment
            #border_images.focused ${../pics/rounded.png}
            #border_images.focused_inactive ${../pics/rounded.png}
            #border_images.unfocused ${../pics/rounded.png}
            #border_images.urgent ${../pics/rounded.png}
            bindsym Mod4+n exec cd ~/stuff/notes && footclient -a foot-notes sh -c "nvim ~/stuff/notes/journal/$(date '+%Y-%m-%d').md"
            bindsym --locked XF86MonBrightnessUp exec doas brillo -u 150000 -A 10 && notify-send --hint=string:x-dunst-stack-tag:vol "Brightness: $(brillo)"
            bindsym --locked XF86MonBrightnessDown exec doas brillo -u 150000 -U 10 && notify-send --hint=string:x-dunst-stack-tag:vol "Brightness: $(brillo)"
            bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume 0 +5% && notify-send --hint=string:x-dunst-stack-tag:vol "Volume: $(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')"
            bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume 0 -5% && notify-send --hint=string:x-dunst-stack-tag:vol "Volume: $(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')"
            bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute 0 toggle # mute sound

            # Property Name         Border  BG      Text    Indicator Child Border
            client.focused          #44465c #44465c #d9e0ee #d9e0ee #44465c
            client.focused_inactive #292a37 #292a37 #d9e0ee #d9e0ee #44465c
            client.unfocused        #292a37 #292a37 #d9e0ee #d9e0ee #292a37
            client.urgent           #292a37 #292a37 #ec6a88 #d9e0ee #ec6a88

            for_window [app_id="foot-notes"] floating enable
            for_window [app_id="pqiv"] floating enable
            for_window [app_id="pqiv"] sticky enable
            for_window [app_id=pqiv] move position 0 0
        '';
    };

    # Dunst (notifications) settings
    services.dunst = {
        enable = true;
        settings = {
            global = {
                origin = "top-left";
                offset = "12x12";
                separator_height = 2;
                padding = 12;
                horizontal_padding = 12;
                text_icon_padding = 12;
                frame_width = 4;
                separator_color = "frame";
                idle_threshold = 120;
                font = "JetBrainsMono 12";
                line_height = 0;
                format = "<b>%s</b>\n%b";
                alignment = "center";
                icon_position = "off";
                startup_notification = "false";
                corner_radius = 12;
                set_stack_tag = "vol";
                stack_tag = "vol";

                frame_color = "#44465c";
                background = "#303241";
                foreground = "#d9e0ee";
                timeout = 2;
            };
        };
    };

    # Foot (terminal emulator) settings
    programs.foot = {
        enable = true;
        settings = {
            main = {
                font = "JetBrainsMono NerdFont:size=6";
                pad = "12x12";
            };
            colors = {
                foreground = "d9e0ee";
                background = "292a37";
                ## Normal/regular colors (color palette 0-7)
                regular0="303241";  # black
                regular1="ec6a88";
                regular2="3fdaa4";
                regular3="efb993";
                regular4="3fc6de";
                regular5="b771dc";
                regular6="6be6e6";
                regular7="d9e0ee";

                bright0="393a4d"; # bright black
                bright1="e95678"; # bright red
                bright2="29d398";# bright green
                bright3="efb993";# bright yellow
                bright4="26bbd9";
                bright5="b072d1";# bright magenta
                bright6="59e3e3";# bright cyan
                bright7="d9e0ee";# bright white
            };
        };
    };

    # Widgets
    programs.eww = {
        enable = false;
        configDir = ./eww;
    };

    # Settings for git
    programs.git = {
        enable = true;
        userName = "notusknot";
        userEmail = "notusknot@gmail.com";
        extraConfig = {
            init = { defaultBranch = "main"; };
            core = {
                excludesfile = "$NIXOS_CONFIG_DIR/scripts/gitignore";
            };
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
