#!/bin/sh
tmpver=$( uname -r )
ver=${tmpver%%-*}
unset tmpver

cp -a /root/BSDBOOT/loader.conf /usr/jails/jails-system/micro1/

# 
echo "cbsd jcreate jname=mfs baserw=1 runasap=1 astart=0 ip4_addr=DHCP"
echo "PRUNE RESCUE"
#cbsd jcreate jname=mfs baserw=1 runasap=1 astart=0 ip4_addr=DHCP
echo "PRUNE RESCUE"

cat /root/BSDBOOT/prunelist | while read _line; do
	echo "rm -rf /usr/jails/jails-data/micro1-data/${_line}"
	rm -rf /usr/jails/jails-data/micro1-data/${_line}
done

rm -rf /usr/jails/jails-data/micro1-data/rescue
cp -a /usr/local/cbsd/share/mfs/mfsbsd /usr/jails/jails-data/micro1-data/etc/rc.d/

sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf hostname="mfs.my.domain"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf CBSD_PERF_DISTRO="1"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf sshd_enable="YES"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf sshd_flags="-oUseDNS=no -oPermitRootLogin=yes -oX11Forwarding=yes -oX11UseLocalhost=no"

# Turn off some defaults:
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf kldxref_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf utx_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf cleanvar_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf gptboot_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf netif_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf resolv_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf cron_enable="NO"       # Run the periodic job daemon.
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf savecore_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf crashinfo_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf linux_mounts_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf virecover_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf newsyslog_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf mixer_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf rctl_enable="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf rc_startmsgs="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf sendmail_cert_create="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf check_quotas="NO"
sysrc -qf /usr/jails/jails-data/micro1-data/etc/rc.conf update_motd="NO"       # update version info in /var/run/motd (or NO)

touch /usr/jails/jails-data/micro1-data/etc/fstab

#cp -a /usr/jails/basejail/FreeBSD-kernel_GENERIC_amd64_${ver}/boot/kernel/zfs.ko /usr/jails/jails-data/micro1-data/root/
#cp -a /usr/jails/basejail/FreeBSD-kernel_GENERIC_amd64_${ver}/boot/kernel/opensolaris.ko /usr/jails/jails-data/micro1-data/root/
#cp -a /usr/jails/basejail/FreeBSD-kernel_GENERIC_amd64_${ver}/boot/kernel/geom_gate.ko /usr/jails/jails-data/micro1-data/root/

rm -rf /usr/jails/jails-data/micro1-data/boot
cp -a /usr/jails/basejail/base_amd64_amd64_${ver}/boot /usr/jails/jails-data/micro1-data/

#cp -a /boot/kernel/aesni.ko /usr/jails/jails-data/micro1-data/boot/modules/
# 
[ -d /usr/jails/jails-data/micro1-data/usr/share/keys ] && rm -rf /usr/jails/jails-data/micro1-data/usr/share/keys
[ ! -d /usr/jails/jails-data/micro1-data/usr/share/ ] && mkdir -p /usr/jails/jails-data/micro1-data/usr/share/
cp -a /usr/share/keys /usr/jails/jails-data/micro1-data/usr/share/

truncate -s0 /usr/jails/jails-data/micro1-data/var/run/motd

cat > /usr/jails/jails-data/micro1-data/etc/sysctl.conf <<EOF
security.bsd.see_other_uids = 0
kern.init_shutdown_timeout = 900
security.bsd.see_other_gids = 0
net.inet.icmp.icmplim = 0
net.inet.tcp.fast_finwait2_recycle = 1
net.inet.tcp.recvspace = 262144
net.inet.tcp.sendspace = 262144
kern.ipc.shm_use_phys = 1
kern.ipc.shmall = 262144
kern.ipc.shmmax = 1073741824
kern.maxfiles = 2048000
kern.maxfilesperproc = 200000
net.inet.ip.intr_queue_maxlen = 2048
net.inet.ip.portrange.first = 1024
net.inet.ip.portrange.last = 65535
net.inet.ip.portrange.randomized = 0
net.inet.tcp.msl = 10000
net.inet.tcp.nolocaltimewait = 1
net.inet.tcp.syncookies = 1
net.inet.udp.maxdgram = 18432
net.local.stream.recvspace = 262144
net.local.stream.sendspace = 262144
vfs.zfs.prefetch.disable = 1
kern.corefile = /var/coredumps/%N.core
kern.sugid_coredump = 1
kern.ipc.shm_allow_removed = 1
kern.shutdown.poweroff_delay = 500
kern.vt.enable_bell = 0
dev.netmap.buf_size = 24576
net.inet.ip.forwarding = 1
net.inet6.ip6.forwarding = 1
net.inet6.ip6.rfc6204w3 = 1
vfs.nfsd.enable_stringtouid = 1
vfs.nfs.enable_uidtostring = 1
vfs.zfs.min_auto_ashift = 12
security.bsd.see_jail_proc = 0
security.bsd.unprivileged_read_msgbuf = 0
net.bpf.zerocopy_enable = 1
net.inet.raw.maxdgram = 16384
net.inet.raw.recvspace = 16384
net.route.netisr_maxqlen = 2048
net.bpf.optimize_writers = 1
net.inet.ip.redirect = 0
net.inet6.ip6.redirect = 0
hw.intr_storm_threshold = 9000
hw.pci.do_power_nodriver = 3
net.inet.icmp.reply_from_interface = 1
kern.ipc.maxsockbuf = 16777216
EOF


[ ! -d /usr/jails/jails-data/micro1-data/etc/ssl ] && mkdir -p /usr/jails/jails-data/micro1-data/etc/ssl
cp -a /etc/ssl/* /usr/jails/jails-data/micro1-data/etc/ssl/
[ ! -d /usr/jails/jails-data/micro1-data/usr/local/etc ] && mkdir -p /usr/jails/jails-data/micro1-data/usr/local/etc
cp -a /usr/local/etc/ssl /usr/jails/jails-data/micro1-data/usr/local/etc/
[ ! -d /usr/jails/jails-data/micro1-data/usr/local/share ] && mkdir -p /usr/jails/jails-data/micro1-data/usr/local/share
cp -a /usr/local/share/certs /usr/jails/jails-data/micro1-data/usr/local/share

cp -a /root/BSDBOOT/distribution /usr/jails/jails-data/micro1-data/bin/distribution
cp -a /root/BSDBOOT/netkldload /usr/jails/jails-data/micro1-data/bin/netkldload
chmod +x /usr/jails/jails-data/micro1-data/bin/netkldload
fetch -o /usr/jails/jails-data/micro1-data/bin/distribution https://pkg.convectix.com/FreeBSD:14:amd64/latest/distribution
chmod +x /usr/jails/jails-data/micro1-data/bin/distribution

#cp -a /usr/jails/share/FreeBSD-jail-skel/etc/spwd.db /usr/jails/jails-data/micro1-data/etc/
#cp -a /usr/jails/share/FreeBSD-jail-skel/etc/pwd.db /usr/jails/jails-data/micro1-data/etc/
#cp -a /usr/jails/share/FreeBSD-jail-skel/etc/passwd /usr/jails/jails-data/micro1-data/etc/
cp -a /usr/jails/share/FreeBSD-jail-skel/etc/login.conf.db /usr/jails/jails-data/micro1-data/etc/
cp -a /usr/jails/share/FreeBSD-jail-skel/etc/login.conf /usr/jails/jails-data/micro1-data/etc/

cp -a /root/BSDBOOT/.cshrc /usr/jails/jails-data/micro1-data/root/

echo "/usr/local/bin/dynmotd.sh" >> /usr/jails/jails-data/micro1-data/etc/profile

[ ! -d /usr/jails/jails-data/micro1-data/usr/local/bin ] && mkdir -p /usr/jails/jails-data/micro1-data/usr/local/bin
cp -a /root/BSDBOOT/dynmotd.sh /usr/jails/jails-data/micro1-data/usr/local/bin/

[ ! -d /usr/jails/jails-data/micro1-data/usr/local/libdata/ldconfig ] && mkdir -p /usr/jails/jails-data/micro1-data/usr/local/libdata/ldconfig

[ ! -d /usr/jails/jails-data/micro1-data/etc/pkg ] && mkdir -p /usr/jails/jails-data/micro1-data/etc/pkg
cat >/usr/jails/jails-data/micro1-data/etc/pkg/CBSD-base-in-pkg.conf <<EOF
CBSD-base-in-pkg: {
        conservative_upgrade: no,
        url: "http://pkg.convectix.com/\${ABI}/latest",
        mirror_type: "none",
        enabled: yes,
        priority: 0
}
EOF

cat > /usr/jails/jails-data/micro1-data/etc/pkg/FreeBSD.conf <<EOF
FreeBSD: {
  url: "pkg+http://pkg.FreeBSD.org/\${ABI}/latest",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "/usr/share/keys/pkg",
  priority: 100,
  enabled: yes
}
EOF

# purge in boot
for i in loader_4th loader_4th.efi loader_lua loader_lua.efi loader_simp loader_simp.efi userboot.so userboot_4th.so userboot_lua.so zfsboot zfsloader; do
	rm -f /usr/jails/jails-data/micro1-data/boot/${i}
done

rm -f /usr/jails/jails-data/micro1-data/lib/libdtrace*
rm -f /usr/jails/jails-data/micro1-data/usr/bin/ex

cp -a /usr/local/cbsd/share/mfs/mfsbsd /usr/jails/jails-data/micro1-data/etc/rc.d/
cp -a /root/BSDBOOT/bsdboot /usr/jails/jails-data/micro1-data/bin/

cbsd jstop micro1
/usr/jails/jails-data/micro1-data/bin/distribution init /usr/jails/jails-data/micro1-data
#cbsd jail2iso jname=micro1 dstdir=/tmp media=mfs efi=1 mfsbsd_nameservers=8.8.8.8 mfsbsd_ip_addr=10.0.100.200 mfsbsd_defaultrouter=10.0.100.1 mfsbsd_interface=auto
cbsd jail2iso jname=micro1 dstdir=/tmp media=mfs efi=1 ip4_addr=0

#cbsd jail2iso jname=mfs dstdir=/tmp media=mfs efi=1 ver=native mfsbsd_ip_addr="10.0.100.102/24,2a05:3580:d811:802::22/64" mfsbsd_defaultrouter="10.0.100.1,2a05:3580:d811:802::2" mfsbsd_mac_boot="00:a0:98:1b:a9:b8" mfsbsd_nameserver="8.8.4.4"
#cbsd jail2iso jname=mfs dstdir=/tmp media=mfs efi=1 ver=native ip4_addr=0
#cbsd jail2iso jname=mfs dstdir=/tmp media=mfs efi=1 ver=native mfsbsd_ip_addr="209.127.117.38/30" mfsbsd_defaultrouter="209.127.117.37" mfsbsd_mac_boot="d0:50:99:fc:54:9b" mfsbsd_nameserver="8.8.4.4"

# REMOTE
#zfs create  -V 64424640512 -s -o volblocksize=32K -o checksum=on -o compression=zstd-19 -o primarycache=none -o secondarycache=none -o dedup=off -o volmode=dev -o snapshot_limit=none -o sync=disabled zroot/ROOT/remote
# echo "172.16.0.3 RW /dev/zvol/zroot/ROOT/remote" >> /etc/gg.exports
# ggated
#/dev/zvol/zroot/ROOT/remote
# CL
# kldload geom_gate
# opensolaris.ko zfs.ko to
# ggatec create -o rw 172.16.0.1 /dev/zvol/zroot/ROOT/remote 



# zfs create ggate0/zroot -o compression=zstd-19
#zpool create zroot ggate0
#zfs set compression=zstd-19 zroot

#zpool create zroot/root
#zpool create zroot/home
#zpool create zroot/usr
#zpool create zroot/var

# comporession
#zfs set mountpoint=..



# NEW
#ggatec create -o rw 172.16.0.1 /dev/zvol/zroot/ROOT/remote
#zpool import -f zroot
#zfs mount -a
#/etc/rc.d/ldconfig restart

# CACHE
# zpool add zroot cache /dev/nvd0p4
