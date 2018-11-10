#!/bin/sh
set -xe
image_name=android-x86

if [ -f $image_name.img ]; then rm $image_name.img; fi
if [ mountpoint -q /mnt/$image_name ]; then umount /mnt/$image_name; fi
if [ -d /mnt/$image_name ]; then rm -rf /mnt/$image_name; fi

dd if=/dev/zero of=$image_name.img bs=1M count=$((1024*4))
sfdisk $image_name.img < android-x86.sfdisk

lofile=`sudo losetup -f`

losetup -fP $image_name.img

mkfs -t ext3 ${lofile}p1
mkdir /mnt/$image_name
mount ${lofile}p1 /mnt/$image_name

mkdir -p /mnt/$image_name/boot/
mkdir -p /mnt/$image_name/grub/

echo "(hd0) $lofile" > $image_name.map
grub-install --no-floppy --grub-mkdevicemap=$image_name.map --modules="part_msdos" --boot-directory=/mnt/android-x86 $lofile

cp grub.cfg /mnt/$image_name/grub
cp kernel /mnt/$image_name/
cp initrd.img /mnt/$image_name/
cp ramdisk.img /mnt/$image_name/

mkdir -p /mnt/$image_name/data
mkdir -p /mnt/$image_name/system
tar xf system.tar -C /mnt/$image_name/

ls /mnt/$image_name/system

umount /mnt/$image_name
losetup -d $lofile

qemu-img convert -f raw -O vpc $image_name.img $image_name.vhd
tar -zvcf $image_name.tar.gz $image_name.vhd
