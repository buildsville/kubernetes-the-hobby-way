#!/bin/bash
### start dns service ###

sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved

sudo systemctl enable coredns node-hosts-converter
sudo systemctl start coredns node-hosts-converter
