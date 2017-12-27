#!/bin/bash
kubectl delete secret cert
kubectl create secret generic cert --from-file="./ananware.systems.key" --from-file="./ananware.systems.pem" --from-file="./ananware.systems.crt"
