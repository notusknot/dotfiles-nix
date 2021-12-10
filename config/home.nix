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

    
    # Settings for the newsboat rss feed reader
    programs.newsboat = {
        enable = true;
        autoReload = true;
        reloadTime = 120;
        extraConfig = ''
            show-read-feeds yes
            feed-sort-order unreadarticlecount-asc

            color listnormal cyan default
            color listfocus black yellow standout bold
            color listnormal_unread blue default
            color listfocus_unread yellow default bold
            color info red black bold
            color article cyan default

            highlight article "^Feed:.*" color5 color0
            highlight article "^Title:.*" color3 color0 bold
            highlight article "^Author:.*" color2 color0
            highlight article "^Date:.*" color223 color0
            highlight article "^Link:.*" color4 color0
            highlight article "^Flags:.*" color9 color0
            highlight article "\\[[0-9][0-9]*\\]" color12 default bold
            highlight article "\\[image [0-9][0-9]*\\]" color8 default bold
            highlight article "\\[embedded flash: [0-9][0-9]*\\]" color12 default bold

            color info black default reverse
            color listnormal_unread yellow default
            color listfocus blue default reverse bold
            color listfocus_unread blue default reverse bold

            refresh-on-startup yes

            macro y set browser "mpv %u" ; open-in-browser ; set browser "elinks %u"

            bind-key j down feedlist
            bind-key k up feedlist
            bind-key j next articlelist
            bind-key k prev articlelist
            bind-key J next-feed articlelist
            bind-key K prev-feed articlelist
            bind-key j down article
            bind-key k up article
        '';
        urls = [
            { url = "https://lukesmith.xyz/rss.xml"; }
            { url = "https://odysee.com/$/rss/@BrodieRobertson:5"; }
            { url = "https://odysee.com/$/rss/@AlphaNerd:8"; }
            { url = "https://jacobneplokh.com/atom.xml"; }
            { url = "https://christine.website/blog.rss"; }
            { url = "https://reddit.com/r/vimporn.rss"; }
            { url = "https://reddit.com/r/commandline.rss"; }
            { url = "https://www.rockyourcode.com/index.xml"; }
            { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCfp86n--4JvqKbunwSI2lYQ"; }
        ];
    };

    # Do not touch
    home.stateVersion = "21.03";
}
