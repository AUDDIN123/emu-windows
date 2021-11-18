docker run \
  --volume $PWD/win7.qcow2:/disk.qcow2 `# the persistent volume` \
  --volume $PWD/iso:/iso `# the iso folder` \
  --interactive --tty \
  -p 6901:5900 \
  -p 9833:3389 \
  -e CPU='2' \
  -e MEMERY='3G' \
  -e ISOFILE='virtio.iso' \
  `# -e USEKVM='true'` \
  \
  --device /dev/kvm `# use hardware acceleration` \
  --device /dev/vfio/vfio ` # vfio is used for PCIe passthrough` \
  --device /dev/vfio/1 `# the vfio IOMMU group` \
  --ulimit memlock=-1:-1 `# so DMA can happen for the vfio passthrough` \
  --device /dev/bus/usb `# since we use usb-host device passthrough (note you can specify specific devices too)` \
  --volume /dev/bus/usb:/dev/bus/usb `# to allow for hot-plugging of USB devices` \
  --volume /lib/modules:/lib/modules `# needed for loading vfio` \
  --privileged `# needed for allowing hot-plugging of USB devices, but should be able to replace with cgroup stuff? also needed for modprobe commands` \
  emu-windows
  
# ash

#  --detach \
#  --restart unless-stopped \
#  -e USEKVM='true' \
