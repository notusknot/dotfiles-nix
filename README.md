# ❄️ NixOS dotfiles

*My configuration files for NixOS. Feel free to look around and copy!* 

# Special thanks to:
- [Siduck76's NvChad](https://github.com/siduck76/nvchad/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Epsyle's NixOS Dotfiles](https://github.com/epsyle/snowflake/)

![Screenshot of my desktop](https://github.com/notusknot/dotfiles-nix/blob/main/pics/screenshot.png)

<details> <summary> <b> Neovim showcase </b> </summary>

![General Neovim setup](https://github.com/notusknot/dotfiles-nix/blob/main/pics/nvim.png)
![Telescope](https://github.com/notusknot/dotfiles-nix/blob/main/pics/telescope.png)

</details>

## Table of contents

- [Installation](#installation)
- [configuration.nix](#configuration.nix)
- [home.nix](#home.nix)
- [Conclusion](#conclusion)

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

You can then copy this to a the `hosts/` directory:

```bash
cp /etc/nixos/hardware-configuration.nix ~/.config/nixos/
```

You can either add or create your own output in `flakes.nix`, by following this template:
```nix
# Rename this to your computer
yourComputer = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
        # Import whatever modules you want. Remember to import your hardware config!!
        ./configuration.nix ./hosts/yourComputer.nix ./config/packages.nix 
        { nix.registry.nixpkgs.flake = nixpkgs; }
        home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # If you change your username, remember to change 'notus' here as well!
            home-manager.users.notus = import ./config/home.nix;

            # Select whatever overlays you want
            nixpkgs.overlays = [ 
                nur.overlay neovim-nightly-overlay.overlay
            ];
        }
    ];
};
```

Lastly, build the configuration with 

```bash
sudo nixos-rebuild switch --flake .#yourComputer
```

And that should be it! If there are any issues please don't hesistate to [submit an issue](https://github.com/notusknot/dotfiles-nix/issues) or contact me.

## What each file does
| File name        | Description                   |
| ---------------- | ------------------------------|
| configuration.nix| Configures the base system    |
| flake.nix        | Sets up pinned inputs/outputs |
| home.nix         | Configures some programs      |
| nvim.nix         | Configures neovim             | 
| zsh.nix          | Configures zsh                |
| firefox.nix      | Configures firefox            |
| packages.nix     | Installs packages             |
| laptop.nix       | Laptop-specific settings      |
| desktop.nix      | Desktop-specific settings     |

## Info
- RAM usage on startup: ~175mb
- Package count: :package: 626
- Uses the [jabuti](https://github.com/jabuti-theme) theme
- Terminal emulator: :foot: foot
- Window manager: :herb: sway
- Shell: :shell: zsh
- Editor: :pencil: neovim
- Browser: :fox_face: Firefox
- Other: dunst, swaybg, brillo, bemenu

## Pro tips
- Mod4 + n spawns a terminal with neovim ready to take notes
- Mod4 + brightness keys adjusts brightness accordingly
- Mod4 + volume keys adjusts volume accordingly
- Firefox preconfigured to be less annoying and have better privacy
- [screen](scripts/screen) script provides a popup of the recently taken screenshot
- Uses [Steven Black's host file](https://github.com/stevenblack/hosts) to block junk
- Uses Xwayland for compadibility with Xorg programs
- Uses doas instead of sudo for better security

## ⚙️ configuration.nix
*It is likely you need to change a few things in this file to tailor the experience to what you use; I've included instructions in a comment at the top of the file.*
This file basically just serves to make sure my system runs fine. The real configuration comes in the [home.nix](#home.nix).

## 🏠 home.nix

*This section is about home-manager, if you want a better explanation on how it works and how to use it, check out the [home-manager documentation](https://github.com/nix-community/home-manager#usage)*

This file sets up and configures home-manager. Home-manager is an awesome tool for managing your user's configurations, which not only makes it much easier to manage them, but also declutters your home directory. It is possible to have all your configs in one file, but I split the zsh and nvim configs into seperate files just to keep it clean.
I recommend that you make your own home-manager configuration, since mine will probably not suit how you want to use your system. The home-manager docs are great and I recommend checking them out.

Home-manager is used by setting options. These options define what program you want to configure, and then a certain set of settings to apply to said program. What home-manager actually does is take in options from your `home.nix` file (or whatever other file you use to configure it) and translates it to the native syntax for the program. This means that;
- All of your config files can have one syntax/file format
- You can have your entire system configured in one file (or as many as you like)
- The config is entirely reproduceable between any NixOS system
- Since some of the config files are moved, your home directory will generally be a little bit less cluttered

Sometimes home-manager has native support for configuration options, and sometimes you can just copy-paste your current config into a field (usually `extraConfig` or `extraOptions`). For example, for picom, you can use some of built-in configuration options: 
```nix
services.picom = {
    enable = true;
    shadow = true;
    shadowOpacity = "0.3";
    extraOptions = ''
        shadow-radius = 20;
    '';
  };
```

You can see that some of the settings you would see in a picom.conf file are here, but with a different syntax. `shadow = true;` uses the Nix language syntax to enable picom shadows, because it is a native setting with home-manager. 

There are also some settings that are not supported by home-manager, in which case you can usually use the `extraOptions` setting (note: this is not a guarantee; check the man page for home-manager to config all the settings for your program). You can see that I have `shadow-radius = 20;` in `extraOptions`, which is what you would put in picom.conf.

This general idea is how you configure home-manager, you can look at my `zsh.nix` file for a more in-depth config. 

## 📦 config/packages.nix

This file is what properly installs all of my packages/programs. It is not necessary to have this file, and most people will have this list in their configuration.nix. However, I like to seperate it into another file and source it in my configuration.nix, just to keep things neater. In the packages directory, it also imports a custom build of st and dwm. If you don't know or don't care about my builds or you want to use your own, you can remove the imports or change the custom package files.

## scripts/

This directory is exactly what it sounds like; a set of scripts that I use often to make my life a little bit easier. They are very simple. Feel free to poke around and use them for yourself.

## 📝 neovim 
Neovim Nightly is imported in the `flake.nix`, and it is configured in it's own files (the main one being nix and the others being lua)
It is entirely possible to have your entire nvim config in the `home.nix`, but unless it is pretty small, things will get very messy, very quickly. I manage my plugins with the nix package manager, which makes it simple to install and apply plugins. If your desired plugins are not available, its possible to use vim-plug ([or you can add it to the nixpkgs repo!](https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/vim.section.md)). The rest of the config for neovim is pretty standard: the basic stuff goes in vim.nix and cofigs for specific plugins are sourced from their own seperate files.

## 🐚 zsh

My zsh config is also in it's own file, but much smaller than the neovim one. Home-manager has pretty good support for zsh configurations, which is very convenient. For plugin management, I use the fetchFromGitHub function in NixOS, but you can use oh-my-zsh, prezto, and a few others.

## TODO
- Source jabuti-theme properly with flakes
- Source zsh plugins properly with flakes
- Fix eww
- Format everything properly with nixfmt

## Conclusion
And thats about it for my configuration. The code is registered under the MIT license, meaning you are allowed to use or distribute the code as you please, and if you need any help or have any suggestions, you can reach me on Discord at `notusknot#5622` or email me at `notusknot@pm.me`.
