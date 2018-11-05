IMAGE="quamotion/android-x86:7.1-r2"
LIVECD="android-x86_64-7.1-r2.iso"
ISO_URL="https://osdn.net/dl/android-x86/android-x86_64-7.1-r2.iso"

all: docker

docker: system.tar
	sudo docker build -t ${IMAGE} .

system.tar:
	[ -f ${LIVECD} ] || wget ${ISO_URL}

	[ -d iso ] || mkdir iso
	sudo mount -o loop ${LIVECD} iso
	cp iso/system.sfs system.sfs
	sudo umount iso

	7z e -y system.sfs system.img

	[ -d system ] || mkdir system
	sudo mount -o ro system.img system
	sudo tar --exclude="system/lost+found" -cpf system.tar system
	sudo umount system

clean:
	[ -d system ] && rmdir system
	rm ${LIVECD} system.sfs system.img
