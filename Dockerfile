FROM alpine
RUN apk add qemu-system-x86_64 qemu-img ovmf socat
COPY TU102.rom /
COPY start.sh /
COPY init.sh /
RUN cp /usr/share/OVMF/OVMF_VARS.fd /qemu-win10.nvram
CMD sh /init.sh $CPU $MEMERY $ISOFILE $USEKVM
