# accelerate_simple_query

Generate a report of the time to deploy for individual TDR versions.  This requires Python 3

To, run, execute:
`python generate_report.py`

This will write output to output.csv.  You can increase the versions to check for by editing the min_version and max_version variables in generate_report.py

To examine deployment timings for an individual release, simply run:
`./list.sh <the version>`

Note: the versions file is cached locally. To refresh the version stats, delete the `endpoints.json` file.  The python script does this automatically