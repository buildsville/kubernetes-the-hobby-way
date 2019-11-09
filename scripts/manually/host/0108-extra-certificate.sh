#!/bin/bash
### generate TLS certs for extra ###

# for metrics-server
cat >  metrics-server-csr.json <<EOF
{
  "CN": "metrics-server",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "JP",
      "L": "Kita-ku",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tokyo"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=127.0.0.1,metrics-server.kube-system.svc.cluster.local,metrics-server.kube-system,metrics-server.kube-system.svc \
  -profile=kubernetes \
  metrics-server-csr.json | cfssljson -bare metrics-server

# for node-hosts-converter
cat >  node-hosts-converter-csr.json <<EOF
{
  "CN": "node-hosts-converter",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "JP",
      "L": "Kita-ku",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tokyo"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  node-hosts-converter-csr.json | cfssljson -bare node-hosts-converter
