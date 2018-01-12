LINUX_KERNEL="linux-4.10.6.tar.xz"
BUSYBOX="busybox-1.26.2.tar.bz2"
LINUX_URL="https://cdn.kernel.org/pub/linux/kernel/v4.x/$LINUX_KERNEL"
BUSYBOX_URL="https://busybox.net/downloads/$BUSYBOX"

TOP=$HOME/tiny_linux
mkdir -pv $TOP
cd $TOP
curl $LINUX_URL | tar xJf -
curl $BUSYBOX_URL | tar xjf -
cd $TOP/busybox-1.26.2
mkdir -pv $TOP/obj/busybox-x86
make O=$TOP/obj/busybox-x86 defconfig
cp $TOP/obj/busybox-x86/.config $TOP/obj/busybox-x86/.config.old
sed -i "s/# CONFIG_STATIC is not set/CONFIG_STATIC=y/g" $TOP/obj/busybox-x86/.config
cd $TOP/obj/busybox-x86
make -j2
make install
mkdir -pv $TOP/initramfs/x86-busybox
cd $TOP/initramfs/x86-busybox
mkdir -pv {bin,sbin,etc,proc,sys,usr/{bin,sbin}}
cp -av $TOP/obj/busybox-x86/_install/* .
cp $TOP/init .
chmod +x init
find . -print0 \
	| cpio --null -ov --format=newc \
	| gzip -9 > $TOP/obj/initramfs-busybox-x86.cpio.gz
cd $TOP/linux-4.10.6
make O=$TOP/obj/linux-x86-basic x86_64_defconfig
make O=$TOP/obj/linux-x86-basic kvmconfig
make O=$TOP/obj/linux-x86-basic -j2
