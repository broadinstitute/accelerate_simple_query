#!/bin/bash
# merge, dev, alpha, staging, producton
env=(merge dev alpha staging production)
version=${1:-1.38.0-SNAPSHOT}
if [ ! -f "endpoints.json" ]; then
  # This file gets deleted at the beginning of the generate_report.py file
  gsutil -q cp gs://deployment-tracking/endpoints.json .
fi

for i in ${env[@]}; do
  input=$(jq '.data[] | select(.semVer | contains("'"$version"'")) | select(.env | contains("'"$i"'"))' endpoints.json | jq -s '.')
  echo $input | jq -r -c .[0]
done
