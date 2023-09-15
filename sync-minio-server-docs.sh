#!/bin/bash

set -e
set -x

function main() {
   curl --retry 10 -Ls https://raw.githubusercontent.com/minio/minio/master/docs/metrics/prometheus/list.md | csplit - /"# Bucket Metrics"/
   mv xx00 source/includes/common-metrics-cluster.md
   mv xx01 source/includes/common-metrics-bucket.md
}

main "$@"