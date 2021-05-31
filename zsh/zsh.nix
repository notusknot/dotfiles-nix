pkgs:
{
  enable = true;
  dotDir =  ".config/zsh/";
  initExtra = ''
    source /etc/nixos/zsh/p10k.zsh

    export CARGO_HOME="$XDG_DATA_HOME/cargo"
    export XAUTHORITY="$HOME/.Xauthority"
    export EDITOR="nvim"
    export TERMINAL="urxvt"
    export BROWSER="firefox"

    autoload -U colors && colors
    eval "$(dircolors -b)"
    setopt histignorealldups sharehistory

    autoload -Uz compinit
    zstyle ":completion:*" menu select
    zstyle ":completion:*" list-colors ""
    zmodload zsh/complist
    compinit -d $HOME/.cache/zcompdump
    _comp_options+=(globdots)
    '';
  history = {
    save = 1000;
    size = 1000;
    path = "$HOME/.cache/zsh_history";
  };

  shellAliases = {
    v = "nvim";
    c = "clear";
    ls = "ls --color=auto -a";
    unziptar = "tar -xvzf";
    mkdir = "mkdir -p";
    
    home = "sudo nvim /etc/nixos/home.nix";
    config = "sudo nvim /etc/nixos/configuration.nix";
    vimconf = "sudo nvim /etc/nixos/nvim/vim.nix";
    rebuild = "sudo nixos-rebuild switch";
  };
  
  plugins = [
    {
      name = "powerlevel10k";
      file = "powerlevel10k.zsh-theme";
      src = pkgs.fetchFromGitHub {
        owner = "romkatv";
        repo = "powerlevel10k";
        rev = "c7ad00b5a5ec92c9b6edf8051502f42659f820b5";
        sha256 = "03nz94valxa62pqypd19m4nf0wxap73rgcahrmqa634qv8gnffay";
      };
    }
    {
      name = "auto-ls";
      src = pkgs.fetchFromGitHub {
        owner = "desyncr";
        repo = "auto-ls";
        rev = "88704f2717fb176b91cdd4b7dbab05242bd02ddf";
        sha256 = "0z2qkd4g3k44wr28hydklgdnvp155g3kvxwr4xplxbbpyn21drqv";
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
  ];
}
