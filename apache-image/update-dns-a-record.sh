#!/bin/bash
echo $existing_a_record
new_a_record=`kubectl get svc | grep apachesvc | awk '{print $3}'`
gcloud dns record-sets transaction abort -z=ananware
gcloud dns record-sets transaction start -z=ananware
gcloud dns record-sets transaction remove --zone=ananware --name=ananware.systems. --ttl=300 --type=A $existing_a_record
gcloud dns record-sets transaction add -z=ananware --name=ananware.systems. --type=A --ttl=300 $new_a_record
gcloud dns record-sets transaction describe -z=ananware
gcloud dns record-sets transaction execute -z=ananware
