# Arch Install
Arch install script, customized to my preferences and settings
This is only designed to work for me, or anyone who understands it enough to change what he needs to change
+ It's a messy script lol, or rather a sequence of commands, some are unreliable and im just too lazy to change atm, it works well for now

## What it does
- Partitions mainly by user but less pain
- Langs/Region, Host, User, Grub
- Pacman, AUR helper, Mirrors including Chaotic-aur and Archstrike
- My Arch/Programs configs from my ([dotfiles Repository](https://github.com/airkn/dotfiles)), and sets them up
- My Window Manager([dwm](https://github.com/airkn/dwm)), Status Bar([dwmblocks](https://github.com/airkn/dwmblocks)), Terminal Emulator([st](https://github.com/airkn/st)) and ([other programs](https://github.com/airkn/othersrc)). all from my github
- Optional: Install NVIDIA proprietary drivers, The whole Pentesting Bundle from Archstrike

## How to use
(You need to be connected to the internet first)
```
curl raw.githubusercontent.com/airkn/archinstall/main/archinstall | sh
```
You might want to delete the leftover files after rebooting that are gonna be in the root (/) directory
