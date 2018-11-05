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