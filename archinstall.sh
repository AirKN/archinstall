#Arch setup installer
#part1
printf '\033c'
echo "Welcome to air's arch installer script"
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacman --noconfirm -Sy archlinux-keyring
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
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^#part2$/d' `basename $0` > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
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

curl -LO raw.githubusercontent.com/AirKN/archinstall/main/packagelist

pacman -S --noconfirm xorg-server xorg-xinit xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop \
	noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-jetbrains-mono ttf-joypixels ttf-font-awesome \
	sxiv mpv imagemagick  \
	fzf man-db xwallpaper unclutter xclip maim \
	zip unzip unrar p7zip xdotool papirus-icon-theme brightnessctl  \
	dosfstools ntfs-3g git sxhkd zsh pipewire pipewire-pulse \
	emacs-nox arc-gtk-theme rsync dash \
	xcompmgr libnotify dunst dmenu slock jq aria2 cowsay \
	dhcpcd connman wpa_supplicant rsync pamixer mpd ncmpcpp \
	zsh-syntax-highlighting xdg-user-dirs libconfig \
	bluez bluez-utils


pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort packagelist))
pacman -Rsu $(comm -23 <(pacman -Qq | sort) <(sort packagelist)) 

systemctl enable connman.service
rm /bin/sh
ln -s dash /bin/sh
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel -s /bin/zsh $username
passwd $username
echo "Pre-Installation Finish Reboot now"
ai3_path=/home/$username/arch_install3.sh
sed '1,/^#part3$/d' arch_install2.sh > $ai3_path
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username
exit

