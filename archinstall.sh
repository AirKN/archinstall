#Arch setup installer
#part1
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
pacstrap /mnt base base-devel linux linux-firmware vim
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^#part2$/d' `basename $0` > /mnt/archinstall2.sh
chmod +x /mnt/archinstall2.sh
cd /mnt
arch-chroot /mnt ./archinstall2.sh
exit

#part2
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

curl -LO raw.githubusercontent.com/AirKN/archinstall/main/packagelist

pacman -S --noconfirm --needed $(comm -12 <(pacman -Slq | sort) <(sort packagelist))
#pacman -Rsu --noconfirm $(comm -23 <(pacman -Qq | sort) <(sort packagelist)) 

#rm /bin/sh
#ln -s dash /bin/sh
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m $username -G wheel 
passwd $username
echo "Pre-Installation Finish Reboot now"
#ai3path=/home/$username/archinstall3.sh
#sed '1,/^#part3$/d' archinstall2.sh > $ai3path
#chown $username:$username $ai3_path
#chmod +x $ai3path
#su -c $ai3path -s /bin/sh $username
umount -R /mnt
exit

