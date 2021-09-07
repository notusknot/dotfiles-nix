pkgs:
{
  enable = true;
  dotDir =  ".config/zsh";
  initExtra = ''

    PROMPT="%F{blue}%m %~%b "$'\n'"%(?.%F{green}%Bλ%b.%F{red}?) %f"

    # Variables
    export EDITOR="nvim"
    export TERMINAL="urxvt"
    export BROWSER="firefox"

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
        df = "duf";
        unziptar = "tar -xvzf";
        mkdir = "mkdir -vp";
        rm = "rm -rifv";
        mv = "mv -iv";
        cp = "cp -riv";
        cat = "bat --paging=never --style=plain";
        fzf = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
        ls = "exa -a --icons";
        tree = "exa --tree --icons";
        zshrc = "nvim $NIXOS_CONDIF_DIR/config/zsh/zsh.nix";
        home = "nvim $NIXOS_CONFIG_DIR/home.nix";
        config = "nvim $NIXOS_CONFIG_DIR/configuration.nix";
        nvimconf = "nvim $NIXOS_CONFIG_DIR/config/nvim/nvim.nix";
        rebuild = "sudo nixos-rebuild switch -I nixos-config=$HOME/.config/nixos/configuration.nix";
        nd = "nix develop -c $SHELL";
    };

    # Source all plugins, nix-style
    plugins = [
    {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
            owner = "zdharma";
            repo = "fast-syntax-highlighting";
            rev = "817916dfa907d179f0d46d8de355e883cf67bd97";
            sha256 = "0m102makrfz1ibxq8rx77nngjyhdqrm8hsrr9342zzhq1nf4wxxc";
        };
    }
    {
        name = "auto-ls";
        src = pkgs.fetchFromGitHub {
            owner = "notusknot";
            repo = "auto-ls";
            rev = "62a176120b9deb81a8efec992d8d6ed99c2bd1a1";
            sha256 = "08wgs3sj7hy30x03m8j6lxns8r2kpjahb9wr0s0zyzrmr4xwccj0";
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
    }];
}
