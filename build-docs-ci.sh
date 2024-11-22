#!/bin/bash

set -ex

export PATH=${PATH}:${HOME}/.local/bin
export GITDIR=main


make SYNC_SDK=TRUE linux
make windows macos container k8s openshift eks aks gke

mkdir -p minio/kubernetes/upstream
cp -vr build/${GITDIR}/k8s/html/* ./minio/kubernetes/upstream/

mkdir -p minio/kubernetes/eks
cp -vr build/${GITDIR}/eks/html/* ./minio/kubernetes/eks/


mkdir -p minio/kubernetes/gke
cp -vr build/${GITDIR}/gke/html/* ./minio/kubernetes/gke/

mkdir -p minio/kubernetes/aks
cp -vr build/${GITDIR}/aks/html/* ./minio/kubernetes/aks/

mkdir -p minio/kubernetes/openshift
cp -vr build/${GITDIR}/openshift/html/* ./minio/kubernetes/openshift/

mkdir -p minio/container
cp -vr build/${GITDIR}/container/html/* ./minio/container/

mkdir -p minio/linux
cp -vr build/${GITDIR}/linux/html/* ./minio/linux/

mkdir -p minio/macos
cp -vr build/${GITDIR}/macos/html/* ./minio/macos/

mkdir -p minio/windows
cp -vr build/${GITDIR}/windows/html/* ./minio/windows/
