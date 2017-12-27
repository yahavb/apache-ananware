#!/bin/bash

new_a_record=`kubectl get svc | grep apachesvc | awk '{print $3}'`
echo $new_a_record
while [ "$new_a_record" == "pending" ]
do
  echo "Waiting for gce to provision LoadBalancer public IP"
  sleep 10
  new_a_record=`kubectl get svc | grep apachesvc | awk '{print $3}'`
  echo $new_a_record
done
