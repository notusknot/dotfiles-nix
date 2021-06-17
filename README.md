# NixOS dotfiles

*My configuration files for NixOS. Feel free to look around and copy!* 

## Table of contents

- [Installation](#installation)
- [configuration.nix](#configuration.nix)
- [home.nix](#home.nix)
- [Conclusion](#conclusion)

## Installation

If you already have NixOS installed, using my configs should be a breeze. Simply clone this repo and drop it into /etc/nixos/. Please be warned that it may not work perfectly out of the box. For best security, read over all the files to confirm there are no conflictions with your current system. 

## configuration.nix
*It is likely you need to change a few things in this file to tailor the experience to what you use; I've included instructions in a comment at the top of the file.*

This file is the meat and potatoes of a NixOS configuration. It does all the basics, like setting up a hostname, users, networking, etc. Most of the stuff in here is pretty boring. Some points of interest include: 
- *The imports at top of the file*; this imports the hardware-configuration.nix file (which should not be touched) and the [home-manager module](https://nixos.wiki/wiki/Home_Manager).
- *The Neovim Nightly overlay*; this essentially installs the latest and greatest neovim release, which I like since there are more features. 
- *environment.systemPackages*; this section defines all the packages that I want installed on my system. This is the beauty of NixOS; a declarative configuration makes it 100x easier to manage. If you dont need some of these programs, you can remove them. 

Otherwise, this file basically just serves to make sure my system runs fine. The real configuration comes in the [home.nix](#home.nix).
## home.nix

This file sets up and configures home-manager. Home-manager is an awesome tool for managing your user's configurations, which not only makes it much easier to manage them, but also declutters your home directory. It is possible to have all your configs in one file, but I split the zsh and nvim configs into seperate files just to keep it clean.

Home-manager is used by making modules. These modules define what program you want to configure, and then a certain set of settings to apply to said program. Sometimes home-manager has native support for configuration options (see the picom section of my home.nix), and sometimes you can just copy-paste your current config into a field (usually extraConfig or extraOptions). 

For my neovim configuration, since there are several lua and vimscript files I also want to source, I decided to create an entire directory for it. It is entirely possible to have your entire config in the home.nix, but unless it is pretty small, things will get very messy, very quickly. I manage my plugins with the native home-manager vim plugin manager (I think its vim-addon-manager, but I'm not sure), which makes it simple to install and apply plugins. If your desired plugins are not available, its possible to use vim-plug ([or you can add it to the nixpkgs repo!](https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/vim.section.md)). The rest of the config for neovim is pretty standard: the basic stuff goes in vim.nix and cofigs for specific plugins are sourced from their own seperate files.

My zsh config is also in it's own file, but much smaller than the neovim one. Home-manager has pretty good support for zsh configurations, which is very convenient. For plugin management, I use the fetchFromGitHub function in NixOS, but you can use oh-my-zsh, prezto, and a few others. The only other file in my zsh directory is the configuration for [powerlevel10k](https://github.com/romkatv/powerlevel10k).

## Conclusion
And thats about it for my configuration. The code is registered under the MIT license, meaning you are allowed to use or distribute the code as you please, and if you need any help or have any suggestions, you can reach me on Discord at `notusknot#5622` or email me at `notusknot@gmail.com`.
