import subprocess
import os
import json
from datetime import datetime

# Execute this file to generate a report of deployment latency.  Update max_version to get more recent releases and min_versions to go back further
max_version = 50
min_version = 10

if os.path.exists("endpoints.json"):
    print("Removing endpoints file")
    os.remove("endpoints.json")

f = open('output.csv', 'w')
f.write("%s\t%s\t%s\t%s\t%s\t%s\n" % ("version", "merge_date", "last_prod_date", "delta (second)", "delta (hours)", "delta (days)"))

last_prod_date = ""
for i in range(max_version, min_version , -1):
    version = "1.%s.0" % i
    print("Checking version %s" % version)
    process = subprocess.Popen(["./list.sh", version], stdout=subprocess.PIPE)
    merge_date = ""
    prod_date = ""
    for l in process.stdout.readlines():
        line = l.strip()
        if line != b"null":
            dep = json.loads(line)
            if (dep["env"] == "merge"):
                merge_date = datetime.strptime(dep["date"], "%Y-%m-%d %H:%M:%S")
            if (dep["env"] == "production"):
                last_prod_date = datetime.strptime(dep["date"], "%Y-%m-%d %H:%M:%S")

    if merge_date != "" or last_prod_date != "":
        delta_seconds = ""
        delta_hours = ""
        delta_days = ""
        if merge_date != "" and last_prod_date != "":
            delta_seconds = (last_prod_date - merge_date).total_seconds()
            delta_hours = delta_seconds / 60 / 60
            delta_days = delta_hours / 24

        f.write("%s\t%s\t%s\t%s\t%s\t%s\n" % (version, merge_date, last_prod_date, delta_seconds, delta_hours, delta_days ))

f.close()