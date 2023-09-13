#!/bin/sh
tmpver=$( uname -r )
ver=${tmpver%%-*}
unset tmpver

cbsd jremove myb1
cbsd jcreate jname=myb1 baserw=1 ver=empty applytpl=0
[ ! -d /usr/jails/jails-data/myb1-data/dev ] && mkdir -p /usr/jails/jails-data/myb1-data/dev
[ ! -d /usr/jails/jails-data/myb1-data/etc ] && mkdir -p /usr/jails/jails-data/myb1-data/etc

cbsd install-pkg-world destdir=/tmp/test ver=14.0 cmd_helper=0 packages=\"FreeBSD-runtime\"

#cbsd copy-binlib basedir=/usr/jails/basejail/base_amd64_amd64_${ver} chaselibs=1 dstdir=/usr/jails/jails-data/myb1-data filelist=/root/BSDBOOT/list_${ver}.txt
#cbsd sysrc jname=myb1 sshd_flags="-oUseDNS=no -oPermitRootLogin=yes" sshd_enable=YES
cp -a /etc/ssh /usr/jails/jails-data/myb1-data/etc/
cp -a /etc/gss /usr/jails/jails-data/myb1-data/etc/
cp -a /etc/pam.d /usr/jails/jails-data/myb1-data/etc/
mkdir -p /usr/jails/jails-data/myb1-data/var/empty /usr/jails/jails-data/myb1-data/var/log /usr/jails/jails-data/myb1-data/var/run /usr/jails/jails-data/myb1-data/root /usr/jails/jails-data/myb1-data/tmp
chmod 0777 /usr/jails/jails-data/myb1-data
chmod u+t /usr/jails/jails-data/myb1-data
chmod 0700 /usr/jails/jails-data/myb1-data/var/empty

for i in master.passwd passwd pwd.db spwd.db; do
	cp -a /root/BSDBOOT/micro/${i} /usr/jails/jails-data/myb1-data/etc/${i}
done

#cbsd jstart myb1
#cbsd jls

# для ISO нужны boot/cdboot и прочий хлам
# cbsd jail2iso dstdir=/tmp jname=myb1 media=iso
