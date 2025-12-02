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

# Platform and sed detection for cross-platform compatibility
UNAME_S := $(shell uname -s)
SED_IS_GNU := $(shell sed --version 2>/dev/null | grep -q "GNU sed" && echo "yes" || echo "no")

# Define the correct sed in-place command based on the system
ifeq ($(SED_IS_GNU),yes)
    SED_INPLACE := sed -i
else ifeq ($(UNAME_S),Darwin)
    SED_INPLACE := sed -i ''
else
    SED_INPLACE := sed -i
endif

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


	@(./stage.sh)


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

mindocs:
	@echo "--------------------------------------"
	@echo "         Building for MinIO           "
	@echo "--------------------------------------"
	@cp source/default-conf.py source/conf.py
	@make sync-deps
	@make sync-operator-version
	@make sync-deps
ifeq ($(SYNC_SDK),TRUE)
	@make sync-sdks
else
	@echo "Not synchronizing SDKs, pass SYNC_SDK=TRUE to synchronize SDK content"
endif
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@
	@echo -e "Building $@ Complete\n--------------------------------------\n"

# Synchronization targets
# Cross-platform compatibility is handled by the SED_INPLACE variable defined at the top

sync-operator-version:
	@echo "Retrieving latest Operator version"
	@$(eval OPERATOR = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/operator/releases/latest | sed "s/https:\/\/github.com\/minio\/operator\/releases\/tag\///" | sed "s/v//"))
	@$(eval K8SFLOOR = $(shell curl -sL https://raw.githubusercontent.com/minio/operator/master/testing/kind-config-floor.yaml | grep -F -m 1 'node:v' | awk 'BEGIN { FS = ":" } ; {print $$3}'))

	@echo "Updating Operator to ${OPERATOR}"
	@$(SED_INPLACE) "s|OPERATOR|${OPERATOR}|g" source/conf.py
	@$(SED_INPLACE) "s|K8SFLOOR|${K8SFLOOR}|g" source/conf.py

	@echo "Updating Helm Charts"
#	@$(shell curl --retry 10 -Ls -o source/includes/k8s/operator-values.yaml https://raw.githubusercontent.com/minio/operator/v${OPERATOR}/helm/operator/values.yaml)

sync-kes-version:
	@echo "Retrieving latest stable KES version"
	@$(eval KES = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/kes/releases/latest | sed "s/https:\/\/github.com\/minio\/kes\/releases\/tag\///"))
	@$(SED_INPLACE) "s|KESLATEST|${KES}|g" source/conf.py

sync-minio-server-docs:
	@echo "Retrieving select docs from github.com/minio/minio/docs"
	@(./sync-minio-server-docs.sh)

sync-minio-version:
	@echo "Retrieving MinIO latest version and download URLs"
	@(./sync-minio-version.sh)

sync-sdks:
	@(./sync-docs.sh)

sync-operator-crd:
	@(./sync-minio-operator-crd.sh)

# Can probably safely remove this at some point
sync-deps:
# C++ and Rust repos do not have any releases yet.
	@echo "Synchronizing all external dependencies"
#	@make sync-minio-version
	@make sync-kes-version
	@make sync-minio-server-docs

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@echo -e "----------------------------------------"
	@echo -e "make mindocs"
	@echo -e "Clean targets with 'make clean-<target>'"
	@echo -e "Clean all targets with 'make clean'"
	@echo -e "----------------------------------------"
