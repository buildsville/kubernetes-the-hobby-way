#!/bin/bash
### start worker service ###

sudo systemctl daemon-reload
sudo systemctl enable kubelet containerd
sudo systemctl start kubelet containerd
