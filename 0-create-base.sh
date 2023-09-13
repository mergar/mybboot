#!/bin/sh
# Need in sync with PKG builder

tmpver=$( uname -r )
ver=${tmpver%%-*}
unset tmpver

if [ 1 -gt 2 ]; then
cbsd removekernel
cbsd removebase

case "${ver}" in
	14.0)
		cbsd srcup rev=4e027ca1514
		;;
	13.2)
		cbsd srcup ver=${ver}
		;;
	*)
		echo "Unsupported version: ${ver}"
		exit 1
		;;
esac

cbsd world && cbsd kernel
fi


exit 0
make -C /usr/ports/net/realtek-re-kmod clean
make -C /usr/ports/net/realtek-re-kmod
cp -a /usr/ports/net/realtek-re-kmod/work/stage/boot/modules/if_re.ko /usr/jails/basejail/FreeBSD-kernel_GENERIC_amd64_${ver}/boot/kernel

file -s /usr/jails/basejail/FreeBSD-kernel_GENERIC_amd64_${ver}/boot/kernel/if_re.ko
ret=$?
exit ${ret}
