#!/bin/bash

set -e
set -x

function replace() {
    tmp_prefix=${RANDOM}
    old_IFS=$IFS
    IFS=$'\n'
    while read -r line
    do
	echo "${line/"${1}"/""${2}""}"
    done < source/conf.py > source/conf.py.${tmp_prefix}
    IFS=$old_IFS
    mv -f source/conf.py.${tmp_prefix} source/conf.py
}

function main() {
    if [ "$#" -eq 0 ]; then
	SDKS="dotnet go java js py hs"
    fi

    for sdk in ${SDKS}; do
	sdk_version=$(curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio-${sdk}/releases/latest | sed "s,https://github.com/minio/minio-${sdk}/releases/tag/,,g")
	echo "latest stable ${sdk} for ${sdk_version}"
	sdk_dir="docs"
	if [ "${sdk}" == "dotnet" ]; then
	    sdk_dir="Docs"
	fi
	source_dir=${sdk}
	case ${sdk} in
	    "js")
		source_dir="javascript"
		;;
	    "py")
		source_dir="python"
		;;
	    "hs")
		source_dir="haskell"
		;;
	esac
	curl --retry 10 -Ls -o source/developers/${source_dir}/API.md https://raw.githubusercontent.com/minio/minio-${sdk}/${sdk_version}/${sdk_dir}/API.md
	curl --retry 10 -Ls -o source/developers/${source_dir}/quickstart.md https://raw.githubusercontent.com/minio/minio-${sdk}/${sdk_version}/README.md

	case ${sdk} in
	    "dotnet")
		replace DOTNETVERSION ${sdk_version}
		;;
	    "go")
		replace GOVERSION ${sdk_version}
		;;
	    "java")
		replace JAVAVERSION ${sdk_version}
                replace JAVAURL https://repo1.maven.org/maven2/io/minio/minio/${sdk_version}/
	        ;;
	    "js")
		replace JAVASCRIPTVERSION ${sdk_version}
		;;
	    "py")
		replace PYTHONVERSION ${sdk_version}
		;;
	    "hs")
		replace HASKELLVERSION ${sdk_version}
		;;
	esac
    done
}

main "$@"
