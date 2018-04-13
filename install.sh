#!/bin/bash

apt-get -y install at iptables

# Scripts & librairie
[ -d /usr/local/firewall/ ] || mkdir /usr/local/firewall/
cp sbin/* /usr/local/firewall/
chmod 774 /usr/local/firewall/firewall
ln -fs /usr/local/firewall/firewall /usr/local/sbin/firewall
chmod 644 /usr/local/firewall/firewall.lib
chown -R root:root /usr/local/firewall/

# Configuration
[ -d /etc/firewall ] || mkdir /etc/firewall
if [ -d etc-urca ] ; then
	# Conf spécifique URCA
	cp etc-urca/firewall/*.dist /etc/firewall/
	cp /etc/firewall/Base.rules.dist /etc/firewall/Base.rules
	cp /etc/firewall/Admin.rules.dist /etc/firewall/Admin.rules
	cp etc-urca/firewall/*.sh /etc/firewall/
	ln -fs /etc/firewall/post-start.sh /etc/firewall/post-save.sh
else
	cp etc/firewall/*.dist /etc/firewall/
fi
for f in $(ls /etc/firewall/*.dist) ; do
	[ -f ${f%.dist} ] || cp ${f} ${f%.dist}
done
chown -R root:root /etc/firewall/

# Suppression démarrage automatique Simpleban
if [ -f /etc/init.d/sban ] ; then
	update-rc.d -f sban remove
	rm /etc/init.d/sban
fi

# Démarrage automatique firewall
cp etc/init.d/firewall.init /etc/init.d/firewall
chmod 774 /etc/init.d/firewall
chown root:root /etc/init.d/firewall
update-rc.d -f firewall defaults
