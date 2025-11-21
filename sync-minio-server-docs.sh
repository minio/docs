#!/bin/bash

set -e

function main() {

   # Extract metrics v2 list

   curl --retry 10 -Ls https://raw.githubusercontent.com/minio/minio/master/docs/metrics/prometheus/list.md | csplit - /"# Bucket Metrics"/
   mv xx00 source/includes/common-metrics-cluster.md

   # Kludgy. Does csplit again on the Bucket Metrics file fragment
   # Tried to get smart using `grep '^# [A-Za-z]` to get line numbers but got stuck

   cat xx01 | csplit - /"# Resource Metrics"/

   mv xx00 source/includes/common-metrics-bucket.md
   mv xx01 source/includes/common-metrics-resource.md

   # Extract metrics v3 list

   # Get the full list

   curl --retry 10 -Ls https://raw.githubusercontent.com/minio/minio/3a0cc6c86e6d0c500d8f1f508ffde8152efb8c7e/docs/metrics/v3.md | csplit - /"## Metric Categories"/

   # Ignore xx00, contains intro text
   # Overwritten in second csplit anyway

   # Split remainder of file into categories by H3
   # Number of times to match must be exact
   cat xx01 | csplit - /"^### "/ '{9}'

   # Copy each category into an include file
   # Order below must match section order in source file

   # Ignore xx00 again, more intro text
   rm xx00

   # API (Renamed from Request)
   # Hopefully ex works the same on both Mac and Linux, unlike sed
   ex -sc '%s/### Request metrics/### API metrics/' -c 'x' xx01
   mv xx01 source/includes/common-metrics-v3-api.md

   # Audit
   mv xx02 source/includes/common-metrics-v3-audit.md

   # Cluster
   mv xx03 source/includes/common-metrics-v3-cluster.md

   # Debug
   mv xx04 source/includes/common-metrics-v3-debug.md

   # ILM
   mv xx05 source/includes/common-metrics-v3-ilm.md

   # Logger Webhook
   mv xx06 source/includes/common-metrics-v3-logger-webhook.md

   # Notification
   mv xx07 source/includes/common-metrics-v3-notification.md

   # Replication
   mv xx08 source/includes/common-metrics-v3-replication.md

   # Scanner
   mv xx09 source/includes/common-metrics-v3-scanner.md

   # System
   mv xx10 source/includes/common-metrics-v3-system.md

}

main "$@"
