#!/bin/bash

set -ex

export PATH=${PATH}:${HOME}/.local/bin
export GITDIR=main


make SYNC_SDK=TRUE linux
make k8s

echo $(ls build)

mkdir -p minio/kubernetes/upstream
cp -vr build/${GITDIR}/k8s/html/* ./minio/kubernetes/upstream/

mkdir -p minio/linux
cp -vr build/${GITDIR}/linux/html/* ./minio/linux/
