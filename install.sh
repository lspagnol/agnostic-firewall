#!/bin/bash

apt-get -y install at

[ -d /usr/local/firewall/ ] || mkdir /usr/local/firewall/
cp sbin/* /usr/local/firewall/
chmod 774 /usr/local/firewall/firewall
ln -fs /usr/local/firewall/firewall /usr/local/sbin/firewall
chmod 644 /usr/local/firewall/firewall.lib
chown -R root:root /usr/local/firewall/

[ -d /etc/firewall ] || mkdir /etc/firewall
if [ -d etc-urca ] ; then
	cp etc-urca/firewall/*.dist /etc/firewall/
else
	cp etc/firewall/*.dist /etc/firewall/
fi
for f in $(ls /etc/firewall/*.dist) ; do
	[ -f ${f%.dist} ] || cp ${f} ${f%.dist}
done
chown -R root:root /etc/firewall/
cp etc/init.d/firewall.init /etc/init.d/firewall
chmod 774 /etc/init.d/firewall
chown root:root /etc/init.d/firewall
update-rc.d -f firewall defaults
