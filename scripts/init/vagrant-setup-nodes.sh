#!/bin/bash

swapoff -a
sed -i -e '/swap/d' /etc/fstab

sysctl -w net.ipv4.conf.all.forwarding=1
echo 'net.ipv4.conf.all.forwarding = 1' >> /etc/sysctl.conf

systemctl disable systemd-resolved
systemctl stop systemd-resolved
rm /etc/resolv.conf
echo "nameserver	10.240.0.40" >/etc/resolv.conf
