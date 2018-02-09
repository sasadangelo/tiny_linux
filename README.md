# Tiny Linux

Tiny Linux is a minimal Linux operating system you can run inside qemu. The project is based on the following [tutorial](http://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html).

Tiny Linux has been tested only on Linux Red Hat Enterprise Workstation. If you have a different Linux flavor you have to play a bit with the tiny_linux.sh script and adapt it to your operating system.

## OS image types

There are basically two types of OS image you can create:

1.  Typical. This option build the linux kernel with default configuration (x86_64_defconfig).
2.  Minimal. This option build the linux kernel with default setting for each configuration parameter (alldefconfig). The Kbuild defaults are generally quite conservative since Linus Torvalds has declared that in the kernel unless the feature cures cancer, it’s not on by default, as opposed to the x86_64_defconfig which is meant to provide a lot of generally useful features and work on a wide variety of x86 targets.

## How to build OS tiny image

To create the OS tiny image do the following steps:

1. cd \<temp folder\>
2. git clone github.com/sasadangelo/tiny_linux.git
3. cd tiny_linux
4. ./tiny_linux.sh

## How to run OS tiny image

To run the OS tiny image use the following command:

./run.sh

## OS image performance

1. Typical. Kernel size is 6.4 Mb. Boot Time is 0.55 s.
2. Minimal. Kernel size is 2.3 Mb. Boot Time is 0.12 s.
