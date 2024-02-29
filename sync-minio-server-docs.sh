#!/bin/bash

set -e
set -x

function main() {
   curl --retry 10 -Ls https://raw.githubusercontent.com/minio/minio/master/docs/metrics/prometheus/list.md | csplit - /"# Bucket Metrics"/
   mv xx00 source/includes/common-metrics-cluster.md

   # Kludgy. Does csplit again on the Bucket Metrics file fragment
   # Tried to get smart using `grep '^# [A-Za-z]` to get line numbers but got stuck

   cat xx01 | csplit - /"# Resource Metrics"/

   mv xx00 source/includes/common-metrics-bucket.md
   mv xx01 source/includes/common-metrics-resource.md
}

main "$@"