#!/bin/bash

swapoff -a
sed -i -e '/swap/d' /etc/fstab
sysctl -w net.ipv4.conf.all.forwarding=1
echo 'net.ipv4.conf.all.forwarding = 1' >> /etc/sysctl.conf
