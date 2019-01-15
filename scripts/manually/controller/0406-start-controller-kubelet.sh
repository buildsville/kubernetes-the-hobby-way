#!/bin/bash
### start controller kubelet ###

sudo systemctl daemon-reload
sudo systemctl enable kubelet
sudo systemctl start kubelet
