IMAGE="quamotion/android-x86:7.1-r2"
LIVECD="android-x86_64-7.1-r2.iso"
ISO_URL="https://osdn.net/dl/android-x86/android-x86_64-7.1-r2.iso"

all: docker

docker: system.tar initrd.tar ramdisk.tar
	sudo docker build -t ${IMAGE} .

system.img:
	[ -f ${LIVECD} ] || wget ${ISO_URL}

	[ -d iso ] || mkdir iso
	sudo mount -o loop ${LIVECD} iso
	cp iso/system.sfs system.sfs
	cp iso/initrd.img initrd.img
	cp iso/ramdisk.img ramdisk.img
	cp iso/kernel kernel
	sudo umount iso

	unsquashfs -f -d . system.sfs system.img

kernel: system.img
ramdisk.img: system.img
initrd.img: system.img

system.tar: system.img
	[ -d system ] || mkdir system
	sudo mount -o ro system.img system
	sudo tar --exclude="system/lost+found" -cpf system.tar system
	sudo umount system

initrd.tar: initrd.img
	[ -d initrd ] || mkdir initrd
	(cd initrd && zcat ../initrd.img | cpio -idv)
	sudo tar -cpf initrd.tar -C initrd .

ramdisk.tar: ramdisk.img
	[ -d ramdisk ] || mkdir ramdisk
	(cd ramdisk && zcat ../ramdisk.img | cpio -idv)
	sudo tar -cpf ramdisk.tar -C ramdisk .

clean:
	[ -d system ] && rmdir system
	rm ${LIVECD} system.sfs system.img
