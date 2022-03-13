pkgs:
{
  enable = true;
  initExtra = ''

    PROMPT="%F{blue}%m %~%b "$'\n'"%(?.%F{green}%Bλ%b.%F{red}?) %f"

    export PATH=$NIXOS_CONFIG_DIR/scripts/:$PATH
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
        mkdir = "mkdir -vp";
        rm = "rm -rifv";
        mv = "mv -iv";
        cp = "cp -riv";
        cat = "bat --paging=never --style=plain";
        ls = "exa -a --icons";
        tree = "exa --tree --icons";
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
