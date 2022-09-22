#Arch setup installer
#part1
printf '\033c'
echo "Welcome to air's arch installer script"
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
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash
exit

#part2
printf '\033c'
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
mkinitcpio -P
passwd
pacman --noconfirm -S grub
echo "Enter the drive: "
read drive
grub-install $drive
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S --noconfirm xorg-server xorg-xinit xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop \
	noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-jetbrains-mono ttf-joypixels ttf-font-awesome \
	sxiv mpv imagemagick  \
	fzf man-db xwallpaper unclutter xclip maim \
	zip unzip unrar p7zip xdotool papirus-icon-theme brightnessctl  \
	dosfstools ntfs-3g git sxhkd zsh pipewire pipewire-pulse \
	arc-gtk-theme rsync dash \
	xcompmgr libnotify dunst dmenu slock \
	dhcpcd rsync pamixer mpd ncmpcpp \
	zsh-syntax-highlighting xdg-user-dirs libconfig 


curl -LO raw.githubusercontent.com/AirKN/archinstall/main/packagelist

pacman -S --noconfirm --needed $(comm -12 <(pacman -Slq | sort) <(sort packagelist))
pacman -Rsu --noconfirm $(comm -23 <(pacman -Qq | sort) <(sort packagelist)) 

#rm /bin/sh
#ln -s dash /bin/sh
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel -s /bin/zsh $username
passwd $username
echo "Pre-Installation Finish Reboot now"
exit

