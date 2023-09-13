cbsd jremove micro1
cbsd jcreate jname=micro1 baserw=1 ver=empty applytpl=0
cbsd copy-binlib basedir=/ chaselibs=1 dstdir=/usr/jails/jails-data/micro1-data filelist=/usr/local/cbsd/share/mfs/micro/list.txt
cbsd sysrc jname=micro1 sshd_flags="-oUseDNS=no -oPermitRootLogin=yes" sshd_enable=YES
cp -a /etc/ssh /usr/jails/jails-data/micro1-data/etc/
cp -a /etc/gss /usr/jails/jails-data/micro1-data/etc/
cp -a /etc/pam.d /usr/jails/jails-data/micro1-data/etc/
mkdir -p /usr/jails/jails-data/micro1-data/var/empty /usr/jails/jails-data/micro1-data/var/log /usr/jails/jails-data/micro1-data/var/run /usr/jails/jails-data/micro1-data/root
chmod 0700 /usr/jails/jails-data/micro1-data/var/empty
cbsd jstart micro1
cbsd jls

# для ISO нужны boot/cdboot и прочий хлам
# cbsd jail2iso dstdir=/tmp jname=micro1 media=iso
