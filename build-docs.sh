#!/bin/bash

branch=$(git branch --show-current)

make clean-all
make k8s
make linux
make container
make windows
make macos

sudo mkdir -p /var/www/docs/minio/windows
sudo mkdir -p /var/www/docs/minio/macos

sudo rm -rf /var/www/docs/minio/kubernetes/upstream
sudo mkdir -p /var/www/docs/minio/kubernetes/upstream
sudo cp -vr build/${branch}/k8s/html/* /var/www/docs/minio/kubernetes/upstream/

sudo rm -rf /var/ww/docs/minio/container
sudo mkdir -p /var/www/docs/minio/container
sudo cp -vr build/${branch}/container/html/* /var/www/docs/minio/container/

sudo rm -rf /var/www/docs/minio/linux
sudo mkdir -p /var/www/docs/minio/linux
sudo cp -vr build/${branch}/linux/html/* /var/www/docs/minio/linux/

sudo rm -rf /var/www/docs/minio/macos
sudo mkdir -p /var/www/docs/minio/macos
sudo cp -vr build/${branch}/macos/html/* /var/www/docs/minio/macos/


sudo rm -rf /var/www/docs/minio/windows
sudo mkdir -p /var/www/docs/minio/windows
sudo cp -vr build/${branch}/windows/html/* /var/www/docs/minio/windows/
