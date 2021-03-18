#!/bin/bash
# merge, dev, alpha, staging, producton
env=(merge dev alpha staging production)
version=${1:-1.38.0-SNAPSHOT}
gsutil -q cp gs://deployment-tracking/endpoints.json .
for i in ${env[@]}; do
  input=$(jq '.data[] | select(.semVer | contains("'"$version"'")) | select(.env | contains("'"$i"'"))' endpoints.json | jq -s '.')
  echo $input | jq -r .[0]
done
