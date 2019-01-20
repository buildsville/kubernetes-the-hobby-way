#!/bin/bash
### generate TLS certs for contoller's kubelet ###

for instance in controller-0 controller-1 controller-2; do
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "JP",
      "L": "Kita-ku",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tokyo"
    }
  ]
}
EOF

EXTERNAL_IP=10.240.0.40

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${instance},${EXTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done
