#!/bin/bash

cat <<EOF> calico-quay-crd.yaml
---
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  calicoNetwork:
    ipPools:
      - blockSize: 26
        cidr: 192.168.0.0/16
        encapsulation: VXLANCrossSubnet
        natOutgoing: Enabled
        nodeSelector: all()
  registry: quay.io
EOF

helm repo add projectcalico https://docs.tigera.io/calico/charts
helm install calico projectcalico/tigera-operator --version v3.27.5 --namespace tigera-operator --create-namespace

# kubectl taint node node1.example.com node-role.kubernetes.io/control-plane:NoSchedule-

kubectl apply -f calico-quay-crd.yaml
kubectl -n calico-system get pod
