{ inputs, pkgs, config, ... }:

{
    # Install all the packages
    environment.systemPackages = with pkgs; [

        # Rice/desktop
        wofi zsh dunst wl-clipboard swaybg wlsunset 

        # Command-line tools
        ripgrep ffmpeg tealdeer exa htop fzf
        pass gnupg slop bat unzip libnotify
        lowdown zk grim slurp imagemagick age
       
        # GUI applications
        mpv brave firefox pqiv 

        # Development
        git zig python3 lua
    ];
}
