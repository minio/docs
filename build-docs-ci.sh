#!/bin/bash

set -ex

export PATH=${PATH}:${HOME}/.local/bin


make SYNC_SDK=TRUE linux
make windows macos container k8s openshift eks aks gke
ls -lR build/


mkdir -p minio/kubernetes/upstream
cp -vr build/HEAD/k8s/html/* ./minio/kubernetes/upstream/

mkdir -p minio/kubernetes/eks
cp -vr build/HEAD/eks/html/* ./minio/kubernetes/eks/


mkdir -p minio/kubernetes/gke
cp -vr build/HEAD/gke/html/* ./minio/kubernetes/gke/

mkdir -p minio/kubernetes/aks
cp -vr build/HEAD/aks/html/* ./minio/kubernetes/aks/

mkdir -p minio/kubernetes/openshift
cp -vr build/HEAD/openshift/html/* ./minio/kubernetes/openshift/

mkdir -p minio/container
cp -vr build/HEAD/container/html/* ./minio/container/

mkdir -p minio/linux
cp -vr build/HEAD/linux/html/* ./minio/linux/

mkdir -p minio/macos
cp -vr build/HEAD/macos/html/* ./minio/macos/

mkdir -p minio/windows
cp -vr build/HEAD/windows/html/* ./minio/windows/
