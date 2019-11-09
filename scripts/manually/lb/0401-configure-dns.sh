#!/bin/bash
### create coredns and node-hosts-converter service ###

cat <<EOF | sudo tee /etc/coredns/Corefile
. {
        errors
        log
        hosts /etc/node-hosts-converter/hosts {
                fallthrough
        }
        forward . 8.8.8.8 8.8.4.4
        loop
        reload
}
EOF

cat <<EOF | sudo tee /etc/systemd/system/coredns.service
[Unit]
Description=coredns service
Documentation=https://coredns.io/
After=network.target

[Service]
ExecStart=/usr/local/bin/coredns \\
	-conf=/etc/coredns/Corefile
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF | sudo tee /etc/systemd/system/node-hosts-converter.service
[Unit]
Description=node hosts converter
Documentation=https://github.com/buildsville/node-hosts-converter
After=network.target

[Service]
Environment=KUBECONFIG=/etc/node-hosts-converter/kubeconfig
ExecStart=/usr/local/bin/node-hosts-converter \\
	-hostsFilePath=/etc/node-hosts-converter/hosts \\
        -logtostderr
Restart=always
RestartSec=30
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
EOF
