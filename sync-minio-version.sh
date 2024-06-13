#!/bin/bash

set -e

function main() {

    if test -f /tmp/downloads-minio.json; then
        rm /tmp/downloads-minio.json
    fi

    curl --retry 10 -Ls https://min.io/assets/downloads-minio.json -o /tmp/downloads-minio.json

    if test -f /tmp/downloads-minio.json; then
        echo "Populated downloads-minio.json from latest, proceeding"
    fi

#  AMD64 arch

	MINIOAMD64=$(cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".amd64.Binary.download')
	DEB=$(cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".amd64.DEB.download')
	RPM=$(cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".amd64.RPM.download')

#  ARM64 arch

	MINIOARM64=$(cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".arm64.Binary.download')
	DEBARM64=$(cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".arm64.DEB.download')
	RPMARM64=$(cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".arm64.RPM.download')
	
#  ppc64le arch

	MINIOPPC64LE=$(cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".ppc64le.Binary.download')
	DEBPPC64LE=$(cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".ppc64le.DEB.download')
	RPMPPC64LE=$(cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".ppc64le.RPM.download')


	MINIO=$(curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio/releases/latest | sed "s/https:\/\/github.com\/minio\/minio\/releases\/tag\///")

	kname=$(uname -s)

	case "${kname}" in \
	"Darwin") \
		sed -i "" "s|MINIOLATEST|${MINIO}|g" source/conf.py; \
		sed -i "" "s|DEBURL|${DEB}|g" source/conf.py; \
		sed -i "" "s|RPMURL|${RPM}|g" source/conf.py; \
		sed -i "" "s|MINIOURL|${MINIOAMD64}|g" source/conf.py; \
		sed -i "" "s|DEBARM64URL|${DEBARM64}|g" source/conf.py; \
		sed -i "" "s|RPMARM64URL|${RPMARM64}|g" source/conf.py; \
		sed -i "" "s|MINIOARM64URL|${MINIOARM64}|g" source/conf.py; \
		sed -i "" "s|DEBPPC64LEURL|${DEBPPC64LE}|g" source/conf.py; \
		sed -i "" "s|RPMPPC64LEURL|${RPMPPC64LE}|g" source/conf.py; \
		sed -i "" "s|MINIOPPC64LEURL|${MINIOPPC64LE}|g" source/conf.py; \
		;; \
	*) \
		sed -i "s|MINIOLATEST|${MINIO}|g" source/conf.py; \
		sed -i "s|DEBURL|${DEB}|g" source/conf.py; \
		sed -i "s|RPMURL|${RPM}|g" source/conf.py; \
		sed -i "s|MINIOURL|${MINIOAMD64}|g" source/conf.py; \
		sed -i "s|DEBARM64URL|${DEBARM64}|g" source/conf.py; \
		sed -i "s|RPMARM64URL|${RPMARM64}|g" source/conf.py; \
		sed -i "s|MINIOARM64URL|${MINIOARM64}|g" source/conf.py; \
		sed -i "s|DEBPPC64LEURL|${DEBPPC64LE}|g" source/conf.py; \
		sed -i "s|RPMPPC64LEURL|${RPMPPC64LE}|g" source/conf.py; \
		sed -i "s|MINIOPPC64LEURL|${MINIOPPC64LE}|g" source/conf.py; \
		;; \
	esac

}

main
