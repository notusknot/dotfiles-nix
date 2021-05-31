{ config, pkgs, ... }:

# Make sure to use the master/unstable branch of home-manager!

# Home-manager is installed as a module on my system, meaning you dont have it
# in your path, but you can update the configuration with nixos-rebuild switch.
# Read about it here: nixos.wiki/wiki/Home_Manager

let 
  # Import extra files
  vimsettings = import ./nvim/vim.nix;
  zshsettings = import ./zsh/zsh.nix;

  # Import Ibhagwan Picom fork with rounded corners and borders
  newPicom = pkgs.picom.overrideAttrs (old: {
      version = "git"; # usually harmless to omit
      src = pkgs.fetchFromGitHub {
          owner = "ibhagwan";
          repo = "picom";
          rev = "60eb00ce1b52aee46d343481d0530d5013ab850b";
          sha256 = "1m17znhl42sa6ry31yiy05j5ql6razajzd6s3k2wz4c63rc2fd1w";
        };
    });

in 
{ 
  programs.home-manager.enable = true;
  xsession.enable = true;

  # Source extra files that are too big for this one 
  programs.neovim = vimsettings pkgs;
  programs.zsh = zshsettings pkgs;

  # Settings for bspwm
  xsession.windowManager.bspwm = {
    enable = true;
    extraConfig = ''
      xrandr --rate 144 &
      watch -n 1800 $HOME/stuff/scripts/health.sh &
      dunst &
      feh --bg-fill --no-fehbg $HOME/stuff/wallpapers/nord.jpg &
      rm -rf $HOME/.xsession-errors $HOME/.xsession-errors.old

      bspc monitor -d 1 2 3 4 5
      bspc config border_width         4
      bspc config window_gap           20
      bspc config split_ratio          0.618
      bspc config top_padding          40
      bspc config focused_border_color "#9699b7"
      bspc config normal_border_color "#2e303e"
   '';
  };

  # Keybinds for sxhkd
  services.sxhkd = {
    enable = true;
    extraConfig = ''
      super + Return
          urxvt
      super + r
          dmenu_run
      super + d
          firefox
      super + c 
          $HOME/stuff/scripts/screen.sh
      super + p
          pcmanfm
      super + alt + {q,r}
          bspc {quit,wm -r}
      super + {_,shift + }v
          bspc node -{c,k}
      super + {t,s,f}
          bspc node -t {tiled,floating,fullscreen}
      super + {_,shift + }{h,j,k,l}
          bspc node -{f,s} {west,south,north,east}
      super + {_,shift + }{1-9,0}
          bspc {desktop -f,node -d} '^{1-9,10}'
      super + ctrl + {h,j,k,l}
          bspc node -p {west,south,north,east}
      super + ctrl + {1-9}
          bspc node -o 0.{1-9}
      super + Escape
          bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel
      super + alt + {h,j,k,l}
          bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}
      super + alt + shift + {h,j,k,l}
          bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}
      super + {w,a,s,d}
    '';
  };

    # Settings for Xresources (URxvt, in my case)
  xresources = {
    extraConfig = ''
      URxvt*scrollBar: false
      URxvt*foreground:  White
      URxvt.internalBorder:  30
      URxvt.font: xft:JetBrainsMono Nerd Font Mono:size=12  
      Xft*dpi:                96
      Xft*antialias:          true

      *.foreground:   #e3e6ee
      *.background:   #2e303e
      *.cursorColor:  #e3e6ee
      *.color0:       #393b4d
      *.color8:       #44465c
      *.color1:       #e95678
      *.color9:       #ec6a88
      *.color2:       #29d398
      *.color10:      #3fdaa4
      *.color3:       #efb993
      *.color11:      #efb993
      *.color4:       #59e3e3
      *.color12:      #6be6e6
      *.color5:       #b072d1
      *.color13:      #b771dc
      *.color6:       #26bbd9
      *.color14:      #3fc6de
      *.color7:       #9699b7
      *.color15:      #e3e6ee
    '';
  };

  # Settings for picom compositor (shadows, fading, etc)
  services.picom = {
    enable = true;
    shadow = true;
    package = newPicom;
    shadowOpacity = "0.35";
    extraOptions = ''
      shadow-radius = 20;
      corner-radius = 12;
      round-borders = 1;
   '';
    fade = true;
    fadeDelta = 4;
    backend = "glx";
  };


  # Settings for tmux
  programs.tmux = {
    enable = true;
    extraConfig = ''
      unbind C-b
      set -g prefix C-Space
      set -ga terminal-overrides ",rxvt-unicode-256color:RGB"
    '';
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

  # Settings for git
  programs.git = {
    enable = true;
    userName = "notusknot";
    userEmail = "notusknot@gmail.com";
    extraConfig = {
      init = { defaultBranch = "main"; };
    };
  };
  
  # Do not touch
  home.stateVersion = "21.03";
}
