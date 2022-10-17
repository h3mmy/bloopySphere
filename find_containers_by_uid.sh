#!/bin/bash

uid_file=$(cat container_list_backup)

for uid in $uid_file; do
    kubectl get po -A -o custom-columns=PodName:.metadata.name,PodUID:.metadata.uid | grep $uid >> found_uuids.txt
done
