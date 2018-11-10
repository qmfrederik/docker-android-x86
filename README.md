# x86_64 Android in a Docker container

Status: experimental

The goal of this project is to find out whether there's an easy way to host x86_64 Android in a Docker container.

Our use case is to get to a state where the copy of Android running in the container is able to accept simple commands
over `adb`. Think being able to start a shell, install and list applications, copy files.

Being able to launch Android apps or having GUI access is not an immediate goal at this moment.

The current approach is:
- Use android-x86_64 as the base for the Docker image. It contains a fully configured Android environment for x86_64 environments.
- Work around the dependency of Android on a custom Linux kernel by using [Kata Containers](https://katacontainers.io/)
- Kata Containers may also provide GPU access if required.

This very much a work in progress.

--

# Things learned so far

## Building and customizing the Android-x86 kernel
The Android(-x86) kernel is a fork of the Linux kernel. Some components of the kernel are disabled by default, but most 'standard' Linux-functionality can be (re-)enabled by recompiling the kernel.

You can limit the amount of sources you need to pull to build a custom Android-x86 kernel by:
- Not fetching any history (using a commit depth of 1)
- Only sync'ing the required repositories.

See the `make-kernel.sh` script for the details.

To figure out which features need to be enabled:
- For Docker: https://wiki.gentoo.org/wiki/Docker#Kernel
- For Azure: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-upload-generic#linux-kernel-requirements
- For Kata containers: https://github.com/kata-containers/documentation/blob/master/Developer-Guide.md#install-guest-kernel-images

## Creating an Android VHD image

You can create a custom `.vhd` image which you can use to boot Android-x86 in VirtualBox, Hyper-V or Azure, using the Android-x86 installer `.iso` file, and the custom kernel.

See the `make-vhd.sh` for the details, and make sure to use ext4.

References:
- https://forum.xda-developers.com/android/general/guide-triple-boot-android-ubuntu-t3092913
- http://my-zhang.github.io/blog/2014/06/28/make-bootable-linux-disk-image-with-grub2/
- https://superuser.com/questions/130955/how-to-install-grub-into-an-img-file 

## Docker

A binary distribution of Docker, which runs on glibc and musl-based Linux, is available at https://download.docker.com/linux/static/stable/x86_64/. The binaries run on Android as well.

To get Docker running, you need to start `dockerd`. This process expects a Linux-like disk layout (`/var`, `/run`). These directories ar e not available in a standard Android installation.
