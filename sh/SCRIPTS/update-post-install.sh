#!/bin/bash

if [ -f post-install.tgz ]; then
    rm post-install.tgz
fi
tar -czvf post-install.tgz /etc/hosts.atcanet \
			    /etc/nsswitch.conf \
			    /etc/yp.conf \
			    /etc/resolv.conf \
			    /etc/sysconfig/i18n \
			    /etc/sysconfig/network.atcanet \
			    /etc/sysconfig/networking/devices/ifcfg-eth0.atcanet
			    

chown :atcanet post-install.tgz
chmod g+w post-install.tgz
