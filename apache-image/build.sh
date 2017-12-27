#!/bin/bash
existing_a_record=`gcloud dns record-sets list --zone=ananware | grep ananware.systems. | egrep " A " | awk '{print $NF}'`


cd ~/apache-ananware/apache-image
ver=0.14
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
echo "Waiting for gce to provision new LoadBalancer public IP"
sleep 10
echo existing_a_record=$existing_a_record
new_a_record=`kubectl get svc | grep apachesvc | awk '{print $3}'`
echo new_a_record=$new_a_record
while [ "$new_a_record" == "<pending>" ]
do
  echo "Waiting for gce to provision LoadBalancer public IP"
  sleep 5
  new_a_record=`kubectl get svc | grep apachesvc | awk '{print $3}'`
  echo $new_a_record
done

gcloud dns record-sets transaction abort -z=ananware
gcloud dns record-sets transaction start -z=ananware
gcloud dns record-sets transaction remove --zone=ananware --name=ananware.systems. --ttl=300 --type=A $existing_a_record
gcloud dns record-sets transaction add -z=ananware --name=ananware.systems. --type=A --ttl=300 $new_a_record
gcloud dns record-sets transaction describe -z=ananware
gcloud dns record-sets transaction execute -z=ananware
