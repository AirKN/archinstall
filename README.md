# Arch Install
This is an Arch Linux install script to automate most of the os installation and configuration, except for the drive partitioning and necessary user input ofc lol, take what u need, use it as it is if u wish, replace pacmanlist and aurlist with ur own package list and enjoy a pitch black themed minimal Arch Linux installation

## What it does
- Partitions mainly by user but less pain
- Langs/Region, Host, User, Grub
- Pacman, AUR helper, Package Repositories including Chaotic-aur and Archstrike
- My Arch/Programs configs from my ([dotfiles Repository](https://github.com/hamedxyz/dotfiles)), and sets them up
- My Window Manager([dwm](https://github.com/hamedxyz/dwm)), Status Bar([dwmblocks](https://github.com/hamedxyz/dwmblocks)), Terminal Emulator([st](https://github.com/hamedxyz/st)) and ([other programs](https://github.com/hamedxyz/othersrc)). all from my github
- Optional: Install NVIDIA proprietary drivers, The whole Pentesting Bundle from Archstrike

## How to use
(You need to be connected to the internet first)

use the iwctl command to connect to wifi on arch live iso
```
curl -LO raw.githubusercontent.com/hamedxyz/archinstall/main/archinstall && chmod +x archinstall && ./archinstall
```
You might want to delete the leftover files after rebooting that are gonna be in the root (/) directory
