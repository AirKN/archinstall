#!/bin/bash

#Arch install script
#written by and customized specifically for:
#    _    ___ ____
#   / \  |_ _|  _ \
#  / _ \  | || |_) |
# / ___ \ | ||  _ <
#/_/   \_\___|_| \_\
#
#part1
echo "Welcome to air's arch install script"
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
loadkeys us
timedatectl set-ntp true
lsblk
echo "Enter the drive: "
read drive
cfdisk $drive
echo "Enter the linux partition: "
read partition
mkfs.ext4 $partition
echo "Enter the boot partition: "
read bootpart
mkfs.ext4 $bootpart

#read -p "Did you also create efi partition? [y/n]" answer
#if [[ $answer = y ]] ; then
#  echo "Enter EFI partition: "
#  read efipartition
#  mkfs.vfat -F 32 $efipartition
#fi

mount $partition /mnt
mkdir /mnt/boot
mount $bootpart /mnt/boot
lsblk
pacman --noconfirm -Sy archlinux-keyring
pacman-key --init && pacman-key --populate archlinux
pacstrap /mnt base base-devel linux linux-firmware vim
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^#part2$/d' `basename $0` > /mnt/archinstall2.sh
chmod +x /mnt/archinstall2.sh
cd /mnt
arch-chroot /mnt ./archinstall2.sh
exit

#part2
clear
pacman -S --noconfirm sed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
ln -sf /usr/share/zoneinfo/Africa/Tunis /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "Hostname: "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts
passwd
pacman --noconfirm -S networkmanager grub
systemctl enable NetworkManager
echo "Enter the drive: "
read drive
grub-install $drive
grub-mkconfig -o /boot/grub/grub.cfg

# Make pacman colorful, concurrent downloads and Pacman eye-candy.
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
sed -Ei "s/^#(ParallelDownloads).*/\1 = 5/;/^#Color$/s/#//" /etc/pacman.conf
# Use all cores for compilation.
sed -i "s/-j2/-j$(nproc)/;/^#MAKEFLAGS/s/^#//" /etc/makepkg.conf

cd /opt
git clone https://aur.archlinux.org/yay-git.git
chown -R air:air ./yay-git
cd yay-git
makepkg -si
cd -

curl -LO raw.githubusercontent.com/airkn/archinstall/main/pacmanlist
curl -LO raw.githubusercontent.com/airkn/archinstall/main/aurlist

pacman -S --noconfirm --needed $(comm -12 <(pacman -Slq | sort) <(sort pacmanlist))
#pacman -Rsu --noconfirm $(comm -23 <(pacman -Qq | sort) <(sort packagelist))
yay -S --noconfirm --needed $(comm -12 <(yay -Slq | sort) <(sort ~/repos/archinstall/aurlist))



#rm /bin/sh
#ln -s dash /bin/sh
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Defaults !tty_tickets" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m $username -G wheel
passwd $username

#gets rid of beep?
rmmod pcspkr
echo "blacklist pcspkr" >/etc/modprobe.d/nobeep.conf
echo "Pre-Installation Finish Reboot now"

#part3

mkdir /home/$username/.local/src

git clone https://github.com/airkn/dwm /home/$username/.local/src/dwm
make -C /home/$username/.local/src/dwm clean install

git clone https://github.com/airkn/dwmblocks /home/$username/.local/src/dwmblocks
make -C /home/$username/.local/src/dwmblocks clean install

git clone https://github.com/airkn/st /home/$username/.local/src/st
make -C /home/$username/.local/src/st clean install

git clone https://github.com/airkn/dmenu /home/$username/.local/src/dmenu
make -C /home/$username/.local/src/dmenu clean install

git clone https://github.com/airkn/othersrc /home/$username/.local/src/othersrc
make -C /home/$username/.local/src/othersrc/sxiv clean install
make -C /home/$username/.local/src/othersrc/slock clean install


mkdir /home/$username/downloads

git clone https://github.com/airkn/dotfiles /home/$username/dotfiles
mv /home/$username/dotfiles/* /home/$username/dotfiles/.* /home/$username

pacman -Syu
pacman -S --noconfirm lib32-pipewire

echo "Would you like to install NVIDIA proprietary drivers? [y/n] "
read answer1
if [[ $answer1 = y ]] ; then
  mkdir -p /etc/X11/xorg.conf.d
  mv /home/$username/dotfiles/nvidia/20-nvidia.conf /etc/X11/xorg.conf.d
  sleep 1s
  pacman -S --noconfirm --needed nvidia nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
fi

echo "Any additional packages you'd like to install? [y/n] "
read answer2
if [[ $answer2 = y ]] ; then
  echo "Which packages? "
  read packages
  pacman -S --noconfirm $packages
fi

rm -rf /home/$username/dotfiles

chown -R /home/$username $username

clear
echo "Installation Complete! Please reboot now!"

sleep 2s
exit
