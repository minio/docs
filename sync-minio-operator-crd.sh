#!/bin/bash

set -e

function main() {
   OPERATOR=$(curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/operator/releases/latest | sed "s/https:\/\/github.com\/minio\/operator\/releases\/tag\///" | sed "s/v//");

   curl --retry 10 -Ls https://raw.githubusercontent.com/minio/operator/v${OPERATOR}/docs/tenant_crd.adoc | asciidoc -b docbook - | pandoc -f docbook -t markdown_strict - -o source/includes/k8s/ext-tenant-crd.md

   # To make the include nicer, this strips out the top H1 and reorders all headers thereafter

   KNAME=$(uname -s)
   case "${KNAME}" in
   "Darwin")
      sed -i '' 's%# API Reference%%g' source/includes/k8s/ext-tenant-crd.md
      sed -i '' 's%minio.min.io/v2%Operator CRD v2 Reference%g' source/includes/k8s/ext-tenant-crd.md
      sed -i '' 's%# % %g' source/includes/k8s/ext-tenant-crd.md;;
   *)
      sed -i 's%# API Reference%%g' source/includes/k8s/ext-tenant-crd.md
      sed -i 's%minio.min.io/v2%Operator CRD v2 Reference%g' source/includes/k8s/ext-tenant-crd.md
      sed -i 's%# % %g' source/includes/k8s/ext-tenant-crd.md;;
   esac
}

main