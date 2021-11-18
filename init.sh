#!/bin/ash

CPU=$1
MEMERY=$2
ISOFILE=$3
USEKVM=$4

# disconnect all virtual terminals (for GPU passthrough to work)
test -e /sys/class/vtconsole/vtcon0/bind && echo 0 > /sys/class/vtconsole/vtcon0/bind
test -e /sys/class/vtconsole/vtcon1/bind && echo 0 > /sys/class/vtconsole/vtcon1/bind
test -e /sys/devices/platform/efi-framebuffer.0/driver && echo "efi-framebuffer.0" > /sys/devices/platform/efi-framebuffer.0/driver/unbind


# run qemu
#qemu-system-x86_64 -smp 2 -m 4G -drive if=none,id=disk0,cache=none,format=qcow2,aio=threads,file=/disk.qcow2 -vnc 0.0.0.0:0 -cdrom /iso/win7.iso  &

# disk visible
#qemu-system-x86_64 -smp 3,cores=3,threads=1,sockets=1 -m 3G  -net user -net nic,model=e1000 -soundhw all -usb -device usb-tablet -usb -device usb-mouse -hda /disk.qcow2  -vnc 0.0.0.0:0 -cdrom /iso/virtio.iso  &


if [ -n "$1" ]
then
CPU=$1
else
CPU=1
fi

if [ -n "$2" ]
then
MEMERY=$2
else
MEMERY=1G
fi

if [ -n "$3" ]
then
ISOFILE="-cdrom /iso/$3"
else
ISOFILE=
fi

if [ -n "$4" ]
then
USEKVM='-enable-kvm'
else
USEKVM=
fi

# open RDP Port for Docker
# -net user,hostfwd=tcp::3389-:3389
qemu-system-x86_64 -monitor stdio -smp $CPU,cores=$CPU,threads=1,sockets=1 -m $MEMERY -net user,hostfwd=tcp::3389-:3389 -net nic,model=e1000 -soundhw all -usb -device usb-tablet -usb -device usb-mouse -hda /disk.qcow2  -vnc 0.0.0.0:0 $ISOFILE $USEKVM &
QEMU_PID=$!

while [ -e /proc/$QEMU_PID ]; do sleep 1; done
