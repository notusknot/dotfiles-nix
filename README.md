# ❄️ NixOS dotfiles

*My configuration files for NixOS. Feel free to look around and copy!* 

# Special thanks to:
- [Sioodmy's dotfiles](https://github.com/sioodmy/dotfiles)
- [Syndrizzle's dotfiles](https://github.com/syndrizzle/hotfiles)
- [Javacafe01's dotfiles](https://github.com/javacafe01/dotfiles)
- [Siduck76's NvChad](https://github.com/siduck76/nvchad/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Epsyle's NixOS Dotfiles](https://github.com/epsyle/snowflake/)

![Screenshot of my desktop](https://github.com/notusknot/dotfiles-nix/blob/main/pics/screenshot.png)
<video src="https://github.com/notusknot/dotfiles-nix/blob/main/pics/recording.mp4" width="100%"></video>

## Installation

** IMPORTANT: do NOT use my laptop.nix and/or desktop.nix! These files include settings that are specific to MY drives and they will mess up for you if you try to use them on your system. **

Please be warned that it may not work perfectly out of the box.
For best security, read over all the files to confirm there are no conflictions with your current system. 

Prerequisites:
- [NixOS installed and running](https://nixos.org/manual/nixos/stable/index.html#ch-installation)
- [Flakes enabled](https://nixos.wiki/wiki/flakes)
- Root access

Clone the repo and cd into it:

```bash
git clone https://github.com/notusknot/dotfiles-nix ~/.config/nixos && cd ~/.config/nixos
```

First, create a hardware configuration for your system:

```bash
sudo nixos-generate-config
```

You can then copy this to a the `hosts/` directory (note: change `yourComputer` with whatever you want):

```
mkdir hosts/yourComputer
cp /etc/nixos/hardware-configuration.nix ~/.config/nixos/hosts/yourComputer/
```

You can either add or create your own output in `flake.nix`, by following this template:
```nix
nixosConfigurations = {
    # Now, defining a new system is can be done in one line
    #                                Architecture   Hostname
    laptop = mkSystem inputs.nixpkgs "x86_64-linux" "laptop";
    desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";
    # ADD YOUR COMPUTER HERE! (feel free to remove mine)
    yourComputer = mkSystem inputs.nixpkgs "x86_64-linux" "yourComputer";
};
```

Next, create `hosts/yourComputer/user.nix`, a configuration file for your system for any modules you want to enable:
```nix
{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {
        # gui
        hyprland.enable = true;

        # cli
        nvim.enable = true;

        # system
        xdg.enable = true;
    };
}
```
The above config installs and configures hyprland, nvim, and xdg user directories. Each config is modularized so you don't have to worry about having to install the software alongside it, since the module does it for you. Every available module can be found in the `modules` directory.

Lastly, build the configuration with 

```bash
sudo nixos-rebuild switch --flake .#yourComputer
```

And that should be it! If there are any issues please don't hesistate to [submit an issue](https://github.com/notusknot/dotfiles-nix/issues) or contact me.

## Info
- RAM usage on startup: ~180mb
- Package count: :package: 582
- Uses the [jabuti](https://github.com/jabuti-theme) theme
- Terminal emulator: :foot: foot
- Window manager: :herb: Hyprland
- Shell: :shell: zsh
- Editor: :pencil: neovim
- Browser: :fox_face: Firefox
- Other: dunst, swaybg, eww, wofi

## Conclusion
And thats about it for my configuration. The code is registered under the MIT license, meaning you are allowed to use or distribute the code as you please, and if you need any help or have any suggestions, you can reach me on Discord at `notusknot#5622` or email me at `notusknot@pm.me`.
