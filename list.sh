#!/bin/bash
# merge, dev, alpha, staging, producton
env=(merge production)
version=${1:-1.38.0-SNAPSHOT}
gsutil -q cp gs://deployment-tracking/endpoints.json .
mergedate=""
proddate=""
for i in ${env[@]}; do
  input=$(jq '.data[] | select(.semVer | contains("'"$version"'")) | select(.env | contains("'"$i"'"))' endpoints.json | jq -s '.')
  if [[ $(echo $input | jq -r .[0].env) == "merge" ]]; then
    mergedate=$(echo $input | jq -r .[0].date)
    A=$(echo ${mergedate} | awk '{print $1}')
    printf "${version}: merge date: $A\n"
  else
    proddate=$(echo $input | jq -r .[0].date)
    B=$(echo ${proddate} | awk '{print $1}' )
    printf "${version}: production date: $B\n"
  fi
done
printf "Number of days to Production: $(((`date -jf %Y-%m-%d $B +%s` - `date -jf %Y-%m-%d $A +%s`)/86400))\n"
