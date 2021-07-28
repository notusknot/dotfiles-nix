pkgs:
{
  enable = true;
  dotDir =  ".config/zsh";
  initExtra = ''


    # Variables
    export EDITOR="nvim"
    export TERMINAL="urxvt"
    export BROWSER="firefox"

    # Fix java gui
    export _JAVA_AWT_WM_NONREPARENTING=1

    export NIXOS_CONFIG=$HOME/.config/nixos/configuration.nix
    export NIXOS_CONFIG_DIR=$HOME/.config/nixos/
    export PATH=$NIXOS_CONFIG_DIR/scripts/:$PATH

    # Clean up
    export XDG_DATA_HOME="$HOME/.local/share"
    export XAUTHORITY="$HOME/.Xauthority"
    export CARGO_HOME="$XDG_DATA_HOME/cargo"
    export GEM_HOME="$HOME/.local/share/gem"
    export XCOMPOSECACHE="$XDG_CACHE_HOME"/X11/xcompose
    export XCOMPOSEFILE="$XDG_CONFIG_HOME"/X11/xcompose
    export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
    export USERXSESSION="$XDG_CACHE_HOME/X11/xsession"
    export USERXSESSIONRC="$XDG_CACHE_HOME/X11/xsessionrc"
    export ALTUSERXSESSION="$XDG_CACHE_HOME/X11/Xsession"
    export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
    export LESSHISTFILE=-
    export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc
    export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc

    # Spaceship prompt
    SPACESHIP_CHAR_SYMBOL="λ "
    SPACESHIP_HG_SHOW=false
    SPACESHIP_PACKAGE_SHOW=false
    SPACESHIP_NODE_SHOW=false
    SPACESHIP_RUBY_SHOW=false
    SPACESHIP_ELM_SHOW=false
    SPACESHIP_ELIXIR_SHOW=false
    SPACESHIP_GOLANG_SHOW=false
    SPACESHIP_SWIFT_SHOW=false
    SPACESHIP_PHP_SHOW=false
    SPACESHIP_JULIA_SHOW=false
    SPACESHIP_RUST_SHOW=false
    SPACESHIP_DOCKER_SHOW=false
    SPACESHIP_VI_MODE_SHOW=false
    SPACESHIP_EXIT_CODE_SHOW=true

    # I honestly don't know what this does
    autoload -U colors && colors
    eval "$(dircolors -b)"
    setopt histignorealldups sharehistory

    # Enable completion
    autoload -Uz compinit
    zstyle ":completion:*" menu select
    zstyle ":completion:*" list-colors ""
    zmodload zsh/complist
    compinit -d $HOME/.cache/zcompdump
    _comp_options+=(globdots)

    # Set vi-mode and bind ctrl + space to accept autosuggestions
    bindkey '^ ' autosuggest-accept
    '';

  # Tweak settings for history
  history = {
    save = 1000;
    size = 1000;
    path = "$HOME/.cache/zsh_history";
  };

  # Set some aliases
  shellAliases = {
    v = "nvim";
    c = "clear";
    ls = "ls --color=auto -A";
    unziptar = "tar -xvzf";
    mkdir = "mkdir -p";
    zshrc = "nvim $NIXOS_CONDIF_DIR/config/zsh/zsh.nix";
    home = "nvim $NIXOS_CONFIG_DIR/home.nix";
    config = "nvim $NIXOS_CONFIG_DIR/configuration.nix";
    nvimconf = "nvim $NIXOS_CONFIG_DIR/config/nvim/nvim.nix";
    rebuild = "sudo nixos-rebuild switch -I nixos-config=$HOME/.config/nixos/configuration.nix";
  };

  # Source all plugins, nix-style
  plugins = [
    {
      name = "spaceship-prompt";
      file = "spaceship.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "spaceship-prompt";
        repo = "spaceship-prompt";
        rev = "6e380e2d3a6d5f909ea59c089cfa47c63795a0fe";
        sha256 = "1as7wxa1lz6syw82fa34vwsm8zcgcvbiv3gnwsq0pnzsqs3mm8dl";
      };
    }
    {
      name = "auto-ls";
      src = pkgs.fetchFromGitHub {
        owner = "notusknot";
        repo = "auto-ls";
        rev = "6f5a72b5f4dfea8479014af1310d359f6a3af509";
        sha256 = "15m7awvds6ljcgamj2nbhqmaddz667gk99q2wpym5skjilf1vc4w";
      };
    }
    {
      name = "zsh-syntax-highlighting";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-syntax-highlighting";
        rev = "894127b221ab73847847bf7cf31eeb709bc16dc5";
        sha256 = "1a3ischgiwqag2caapdh3zmdlsaz57x07zgnk0l3l80g9gxlinib";
      };
    }
    {
      name = "zsh-autosuggestions";
      src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
          sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
      };
    }
  ];
}
