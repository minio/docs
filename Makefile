# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?= -n -j auto -w "build.log"
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = source
BUILDDIR      = build
GITDIR        = $(shell git rev-parse --abbrev-ref HEAD)
STAGINGURL    = http://192.241.195.202:9000/staging

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# dry-run build command to double check output build dirs
dryrun:
	@echo "$(SPHINXBUILD) -M $@ '$(SOURCEDIR)' '$(BUILDDIR)/$(GITDIR)' $(SPHINXOPTS) $(O)"

clean:
	@echo "Cleaning $(BUILDDIR)/$(GITDIR)"
	@rm -rf $(BUILDDIR)/$(GITDIR)

clean-%:
	@echo "Cleaning $(BUILDDIR)/$(GITDIR)/$*"
	@rm -rf $(BUILDDIR)/$(GITDIR)/$*

stage-%:
	@if [ ! -d "$(BUILDDIR)/$(GITDIR)/$*" ]; then \
		echo "$* build not found in $(BUILDDIR)/$(GITDIR)"; \
		exit 1; \
	fi

	@if [ ! $(shell command -v mc) ]; then \
	   echo "mc not found on this host, exiting" ; \
		exit 1; \
	fi

	@if [ $(shell mc alias list --json docs-staging | jq '.status') = "error" ]; then \
		echo "doc-staging alias not found on for host mc configuration, exiting" ; \
		exit 1; \
	fi

	@if [ $(shell mc stat --json docs-staging/staging | jq '.status') = "error" ]; then \
		echo "docs-staging/staging bucket not found, exiting" ; \
		exit 1; \
	fi

	@echo "Copying contents of $(BUILDDIR)/$(GITDIR)/$*/html/* to docs-staging/staging/$(GITDIR)/$*/"
	@mc cp -r $(BUILDDIR)/$(GITDIR)/$*/html/* docs-staging/staging/$(GITDIR)/$*/
	@echo "Copy complete, visit $(STAGINGURL)/$(GITDIR)/$*/index.html"

# Commenting out the older method
# python -m http.server --directory $(BUILDDIR)/$(GITDIR)/$*/html/
# @echo "Visit http://localhost:8000 to view the staged output"

# Platform build commands
# All platforms follow the same general pattern:
#   - Rebuild source/conf.py
#   - Synchronize relevant versions
#   - If built with make SYNC_SDK=TRUE <platform>, synchronize SDK content from github
#   - Compile SCSS
#   - Build docs via Sphinx

linux:
	@echo "--------------------------------------"
	@echo "Building for $@ Platform"
	@echo "--------------------------------------"
	@cp source/default-conf.py source/conf.py
	@make sync-deps
ifeq ($(SYNC_SDK),TRUE)
	@make sync-sdks
else
	@echo "Not synchronizing SDKs, pass SYNC_SDK=TRUE to synchronize SDK content"
endif
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@
	@echo -e "Building $@ Complete\n--------------------------------------\n"

windows:
	@echo "--------------------------------------"
	@echo "Building for $@ Platform"
	@echo "--------------------------------------"
	@cp source/default-conf.py source/conf.py
	@make sync-deps
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@
	@echo -e "Building $@ Complete\n--------------------------------------\n"

macos:
	@echo "--------------------------------------"
	@echo "Building for $@ Platform"
	@echo "--------------------------------------"
	@cp source/default-conf.py source/conf.py
	@make sync-deps
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@
	@echo -e "Building $@ Complete\n--------------------------------------\n"

k8s:
	@echo "--------------------------------------"
	@echo "Building for $@ Platform"
	@echo "--------------------------------------"
	@cp source/default-conf.py source/conf.py
	@make sync-operator-version
	@make sync-deps
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@
	@echo -e "Building $@ Complete\n--------------------------------------\n"

openshift:
	@echo "--------------------------------------"
	@echo "Building for $@ Platform"
	@echo "--------------------------------------"
	@cp source/default-conf.py source/conf.py
	@make sync-operator-version
	@make sync-deps
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@ -t k8s
	@echo -e "Building $@ Complete\n--------------------------------------\n"

eks:
	@echo "--------------------------------------"
	@echo "Building for $@ Platform"
	@echo "--------------------------------------"
	@cp source/default-conf.py source/conf.py
	@make sync-operator-version
	@make sync-deps
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@ -t k8s
	@echo -e "Building $@ Complete\n--------------------------------------\n"

gke:
	@echo "--------------------------------------"
	@echo "Building for $@ Platform"
	@echo "--------------------------------------"
	@cp source/default-conf.py source/conf.py
	@make sync-operator-version
	@make sync-deps
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@ -t k8s
	@echo -e "Building $@ Complete\n--------------------------------------\n"

aks:
	@echo "--------------------------------------"
	@echo "Building for $@ Platform"
	@echo "--------------------------------------"
	@cp source/default-conf.py source/conf.py
	@make sync-operator-version
	@make sync-deps
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@ -t k8s
	@echo -e "Building $@ Complete\n--------------------------------------\n"

container:
	@echo "--------------------------------------"
	@echo "Building for $@ Platform"
	@echo "--------------------------------------"
	@cp source/default-conf.py source/conf.py
	@make sync-deps
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@
	@echo -e "Building $@ Complete\n--------------------------------------\n"

# Synchronization targets
# Note that the @case statements are required to account for differences between Linux and MacOS binaries
# Specifically, MacOS does not use GNU utils, so syntax is slightly different for things like sed
# Annoying but necessary

sync-operator-version:
	@echo "Retrieving latest Operator version"
	@$(eval OPERATOR = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/operator/releases/latest | sed "s/https:\/\/github.com\/minio\/operator\/releases\/tag\///" | sed "s/v//"))
	@$(eval kname = $(shell uname -s))
	@$(eval K8SFLOOR = $(shell curl -sL https://raw.githubusercontent.com/minio/operator/master/testing/kind-config-floor.yaml | grep -F -m 1 'node:v' | awk 'BEGIN { FS = ":" } ; {print $$3}'))

	@echo "Updating Operator to ${OPERATOR}"

	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|OPERATOR|${OPERATOR}|g" source/conf.py;\
		sed -i "" "s|K8SFLOOR|${K8SFLOOR}|g" source/conf.py; \
		;; \
	*) \
		sed -i "s|OPERATOR|${OPERATOR}|g" source/conf.py; \
		sed -i "s|K8SFLOOR|${K8SFLOOR}|g" source/conf.py; \
		;; \
	esac

	@echo "Updating Helm Charts"
#	@$(shell curl --retry 10 -Ls -o source/includes/k8s/operator-values.yaml https://raw.githubusercontent.com/minio/operator/v${OPERATOR}/helm/operator/values.yaml)

sync-kes-version:
	@echo "Retrieving latest stable KES version"
	@$(eval KES = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/kes/releases/latest | sed "s/https:\/\/github.com\/minio\/kes\/releases\/tag\///"))
	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|KESLATEST|${KES}|g" source/conf.py;\
		;; \
	*) \
		sed -i "s|KESLATEST|${KES}|g" source/conf.py; \
		;; \
	esac

sync-minio-server-docs:
	@echo "Retrieving select docs from github.com/minio/minio/docs"
	@(./sync-minio-server-docs.sh)

sync-minio-version:
	@echo "Retrieving current MinIO version"
	$(eval DEB = $(shell curl -s https://min.io/assets/downloads-minio.json | jq '.Linux."MinIO Server".amd64.DEB.download' | sed "s|linux-amd64|linux-amd64/archive|g"))
	$(eval RPM = $(shell curl -s https://min.io/assets/downloads-minio.json | jq '.Linux."MinIO Server".amd64.RPM.download' | sed "s|linux-amd64|linux-amd64/archive|g"))
	$(eval DEBARM64 = $(shell curl -s https://min.io/assets/downloads-minio.json | jq '.Linux."MinIO Server".arm64.DEB.download' | sed "s|linux-arm64|linux-arm64/archive|g"))
	$(eval RPMARM64 = $(shell curl -s https://min.io/assets/downloads-minio.json | jq '.Linux."MinIO Server".arm64.RPM.download' | sed "s|linux-arm64|linux-arm64/archive|g"))
	$(eval MINIO = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio/releases/latest | sed "s/https:\/\/github.com\/minio\/minio\/releases\/tag\///"))

	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|MINIOLATEST|${MINIO}|g" source/conf.py; \
		sed -i "" "s|DEBURL|${DEB}|g" source/conf.py; \
		sed -i "" "s|RPMURL|${RPM}|g" source/conf.py; \
		sed -i "" "s|DEBARM64URL|${DEBARM64}|g" source/conf.py; \
		sed -i "" "s|RPMARM64URL|${RPMARM64}|g" source/conf.py; \
		;; \
	*) \
		sed -i "s|MINIOLATEST|${MINIO}|g" source/conf.py; \
		sed -i "s|DEBURL|${DEB}|g" source/conf.py; \
		sed -i "s|RPMURL|${RPM}|g" source/conf.py; \
		sed -i "s|DEBARM64URL|${DEBARM64}|g" source/conf.py; \
		sed -i "s|RPMARM64URL|${RPMARM64}|g" source/conf.py; \
		;; \
	esac

sync-sdks:
	@(./sync-docs.sh)

sync-operator-crd:
	@(./sync-minio-operator-crd.sh)

# Can probably safely remove this at some point
sync-deps:
# C++ and Rust repos do not have any releases yet.
	@echo "Synchronizing all external dependencies"
	@make sync-minio-version
	@make sync-kes-version
	@make sync-minio-server-docs

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@echo -e "----------------------------------------"
	@echo -e "Specify one of the following supported build outputs"
	@echo -e "- make linux\n- make macos\n- make windows\n- make k8s\n- make openshift\n- make eks\n- make gke\n- make aks\n- make container"
	@echo -e "Clean targets with 'make clean-<target>'"
	@echo -e "Clean all targets with 'make clean'"
	@echo -e "----------------------------------------"
