#!/bin/bash

set -ex

export PATH=${PATH}:${HOME}/.local/bin
export GITDIR=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)


make SYNC_SDK=TRUE mindocs

mkdir -p minio/
cp -vr build/${GITDIR}/mindocs/html/* ./minio/
