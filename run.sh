TOP=$HOME/tiny_linux
cd $TOP
/usr/libexec/qemu-kvm \
	-kernel obj/linux-x86-basic/arch/x86_64/boot/bzImage \
	-initrd obj/initramfs-busybox-x86.cpio.gz \
	-nographic -append "console=ttyS0" -enable-kvm
