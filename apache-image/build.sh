#!/bin/bash
ver=0.9
image=`docker build . | grep "Successfully built"| awk '{print $NF}'`
if [ -z "$image" ]
then
  echo "error in docker build"
  exit
fi
docker tag $image us.gcr.io/ananware-186718/apache-ssl:$ver
gcloud docker -- push us.gcr.io/ananware-186718/apache-ssl:$ver
helm delete `helm list | egrep -v 'nginx' | grep -v NAME|awk '{print $1}'`
cd ../
helm install ./
