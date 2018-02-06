# Tiny Linux

Tiny Linux is a minimal Linux operating system you can run inside qemu. The operating system is 6.4Mb in size and a boot time of 0.55 secs. The project is based on the following [tutorial](http://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html).

Tiny Linux has been tested only on Linux Red Hat Enterprise Workstation. If you have a different Linux flavor you have to play a bit with the tiny_linux.sh script and adapt it to your operating system.

## How to build OS tiny image

To create the OS tiny image do the following steps:

1. cd <temp folder>
2. git clone github.com/sasadangelo/tiny_linux.git
3. cd tiny_linux
4. ./tiny_linux.sh

## How to run OS tiny image

To run the OS tiny image use the following command:

./run.sh
