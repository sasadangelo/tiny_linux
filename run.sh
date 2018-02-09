TOP=$HOME/tiny_linux
cd $TOP
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
    echo "Usage: ./run.sh [<installation type]"
    echo "Where:"
    echo "    <installation type> could be "typical" and "minimal"."
    echo "    The defaul is typical."
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

if [ $INSTALLATION_TYPE = "typical" ]
then
    if [ ! -d obj/linux-x86-basic ]
    then
        echo "ERROR: cannot run a typical OS image."
        echo "       Make sure to run ./tiny_linux.sh typical"
        exit 1
    fi
    /usr/libexec/qemu-kvm \
	-kernel obj/linux-x86-basic/arch/x86_64/boot/bzImage \
	-initrd obj/initramfs-busybox-x86.cpio.gz \
	-nographic -append "console=ttyS0" -enable-kvm
else
    if [ ! -d obj/linux-x86-alldefconfig ]
    then
        echo "ERROR: cannot run a minimal OS image."
        echo "       Make sure to run ./tiny_linux.sh minimal"
        exit 1
    fi
    /usr/libexec/qemu-kvm \
	-kernel obj/linux-x86-alldefconfig/arch/x86_64/boot/bzImage \
	-initrd obj/initramfs-busybox-x86.cpio.gz \
	-nographic -append "console=ttyS0" -enable-kvm	
fi
