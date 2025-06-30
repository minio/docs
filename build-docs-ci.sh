#!/bin/bash

set -ex

export PATH=${PATH}:${HOME}/.local/bin
export GITDIR=main


make SYNC_SDK=TRUE mindocs

mkdir -p minio/
cp -vr build/${GITDIR}/mindocs/html/* ./minio/
