#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

query-package () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

OLD_NAME=4.4.11-ntc
NAME=4.4.11-rt20

uname -r | grep $OLD_NAME > /dev/null
if [ $? -eq 1 ]; then
    echo "current kernel != $OLD_NAME, will not install RT-PREEMPT kernel"
    PREEMPT=0
else
    echo "current kernel == $OLD_NAME, will install RT-PREEMPT kernel"
    PREEMPT=1
fi

if [ $(query-package machinekit-rt-preempt) -eq 1 ]; then
    echo "Machinekit already installed"
else
    echo "Adding Machinekit repository"
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 43DDF224
    sudo sh -c \
    "echo 'deb http://deb.machinekit.io/debian jessie main' > \
    /etc/apt/sources.list.d/machinekit.list"
    sudo apt update
    echo "Installing Machinekit packages"
    if [ $PREEMPT -eq 1 ]; then
        apt install -y machinekit-rt-preempt
    else
        apt install -y machinekit-posix
    fi
fi

if [ $PREEMPT -eq 0 ]; then
    echo "Skipping kernel install"
    exit 0
fi

echo "Download precompiled RT-PREEMPT kernel"
# download pre-compiled kernel RT-PREEMPT
cd /tmp
wget https://raw.githubusercontent.com/machinekoder/machinekit-chip/master/kernel/$NAME.tar.gz
echo "Installing RT-PREEMPT kernel"
# extract and install
tar xfz $NAME.tar.gz
cd deploy
cp -r -v $NAME+ /lib/modules/
cp -r -v linux-image-$NAME+ /usr/lib/
mkdir -p /boot/dtbs/$NAME/
cp -v linux-image-$NAME+/sun5i-r8-chip.dtb /boot/dtbs/$NAME/sun5i-r8-chip.dtb
cp -v System.map-$NAME+ config-$NAME+ vmlinuz-$NAME+ /boot/
cd /boot/
# overwrite Linux image
cp -v vmlinuz-$NAME+ zImage
# copy initrd
cp -v initrd.img-4.4.11-ntc initrd.img-$NAME
# cleanup
cd /tmp
rm $NAME.tar.gz
rm -r deploy
echo "Kernel install completed"
echo "The system will automatically restart in 5 seconds..."
sleep 1
echo "4.."
sleep 1
echo "3.."
sleep 1
echo "2.."
sleep 1
echo "1.."
sleep 1
# reboot the CHIP
reboot
