LINUX_KERNEL="linux-4.10.6.tar.xz"
BUSYBOX="busybox-1.26.2.tar.bz2"
LINUX_URL="https://cdn.kernel.org/pub/linux/kernel/v4.x/$LINUX_KERNEL"
BUSYBOX_URL="https://busybox.net/downloads/$BUSYBOX"
INSTALLATION_TYPE="typical"

###################################################################
# usage
#
# Input Parameters:
#     none
#
# Description:
#     This function prints the usage.
#
# Return:
#     None
###################################################################
usage()
{
    echo "Usage: ./tiny_linux.sh [<installation type]"
    echo "Where:"
    echo "    <installation type> could be "typical" and "minimal"."
    echo "    The defaul is typical."
}

###################################################################
# operating_system_not_supported
#
# Input Parameters:
#     none
#
# Description:
#     This function prints the "Operating system not supported" error
#     message.
#
# Return:
#     None
###################################################################
operating_system_not_supported()
{
    echo "ERROR: Operating system not supported."
    echo "       This script has been tested only on RHE Worksation."
}

###################################################################
# parse_params
#
# Input Parameters:
#     none
#
# Description:
#     This function parse the input parameters.
#
# Return:
#     None
###################################################################
parse_params()
{
    if [ $# -gt 1 ]
    then
        usage
        exit 1
    fi

    while [[ $# > 0 ]]
    do
        case $1 in
        typical | minimal)
            INSTALLATION_TYPE=$1
            shift
        ;;
        *)
            echo "ERROR: Unrecognized parameter(s): $*"
            usage
            exit 1
        ;;
        esac
    done

}

###################################################################
# check_prerequisites
#
# Input Parameters:
#     none
#
# Description:
#     This function checks prerequisites to build the tiny linux image.
#
# Return:
#     None
###################################################################
check_prerequisites()
{
    if [ -f /etc/redhat-release ]
    then
        grep "Red Hat Enterprise Linux Workstation" /etc/redhat-release > /dev/null
        if [ $? -ne 0 ]
        then
            operating_system_not_supported
            exit 2
        fi
    else
        operating_system_not_supported
        exit 3
    fi
}

###################################################################
# Main block
###################################################################
parse_params "$@"
check_prerequisites

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
if [ $INSTALLATION_TYPE = "typical" ]
then
    make O=$TOP/obj/linux-x86-basic x86_64_defconfig
    make O=$TOP/obj/linux-x86-basic kvmconfig
    make O=$TOP/obj/linux-x86-basic -j2
else
    make O=../obj/linux-x86-alldefconfig alldefconfig
    cp $TOP/kconfig/.config.minimal $TOP/obj/linux-x86-alldefconfig/.config
    make O=../obj/linux-x86-alldefconfig kvmconfig
    make O=../obj/linux-x86-alldefconfig -j2 
fi
