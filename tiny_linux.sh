if [ -f /etc/redhat-release ]
then
    grep "Red Hat Enterprise Linux Workstation" /etc/redhat-release > /dev/null
    if [ $? -eq 0 ]
    then
    . ./rhew/tiny_linux.sh
    fi
else
    echo "Operating system not supported!"
fi
