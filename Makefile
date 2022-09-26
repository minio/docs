# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?= -n -j auto -w "build.log"
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = source
BUILDDIR      = build
GITDIR        = $(shell git rev-parse --abbrev-ref HEAD)

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
	python -m http.server --directory $(BUILDDIR)/$(GITDIR)/$*/html/
	@echo "Visit http://localhost:8000 to view the staged output"

# Platform build commands
# All platforms follow the same general pattern:
#   - Rebuild source/conf.py
#   - Synchronize relevant versions
#   - If built with make SYNC_SDK=TRUE <platform>, synchronize SDK content from github
#   - Compile SCSS
#   - Build docs via Sphinx

linux:
	@cp source/default-conf.py source/conf.py
	@make sync-minio-version
	@make sync-kes-version
ifeq ($(SYNC_SDK),TRUE)
	@make sync-sdks
else
	@echo "Not synchronizing SDKs, pass SYNC_SDK=TRUE to synchronize SDK content"
endif
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@

windows:
	@cp source/default-conf.py source/conf.py
	@make sync-minio-version
	@make sync-kes-version
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@

macos:
	@cp source/default-conf.py source/conf.py
	@make sync-minio-version
	@make sync-kes-version
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@

k8s:
	@cp source/default-conf.py source/conf.py
	@make sync-operator-version
	@make sync-minio-version
	@make sync-kes-version
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@

container:
	@cp source/default-conf.py source/conf.py
	@make sync-minio-version
	@make sync-kes-version
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@

# Synchronization targets
# Note that the @case statements are required to account for differences between Linux and MacOS binaries
# Specifically, MacOS does not use GNU utils, so syntax is slightly different for things like sed
# Annoying but necessary

sync-operator-version:
	@echo "Retrieving latest Operator version"
	@$(eval OPERATOR = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/operator/releases/latest | sed "s/https:\/\/github.com\/minio\/operator\/releases\/tag\///"))
	@$(eval kname = $(shell uname -s))

	@echo "Updating Operator to ${OPERATOR}"

	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|OPERATOR|${OPERATOR}|g" source/conf.py;\
		;; \
	*) \
		sed -i "s|OPERATOR|${OPERATOR}|g" source/conf.py; \
		;; \
	esac

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

sync-minio-version:
	@echo "Retrieving current MinIO version"
	$(eval DEB = $(shell curl -s https://min.io/assets/downloads-minio.json | jq '.Linux."MinIO Server".amd64.DEB.download' | sed "s|linux-amd64|linux-amd64/archive|g"))
	$(eval RPM = $(shell curl -s https://min.io/assets/downloads-minio.json | jq '.Linux."MinIO Server".amd64.RPM.download' | sed "s|linux-amd64|linux-amd64/archive|g"))
	$(eval MINIO = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio/releases/latest | sed "s/https:\/\/github.com\/minio\/minio\/releases\/tag\///"))

	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|MINIOLATEST|${MINIO}|g" source/conf.py; \
		sed -i "" "s|DEBURL|${DEB}|g" source/conf.py; \
		sed -i "" "s|RPMURL|${RPM}|g" source/conf.py; \
		;; \
	*) \
		sed -i "s|MINIOLATEST|${MINIO}|g" source/conf.py; \
		sed -i "s|DEBURL|${DEB}|g" source/conf.py; \
		sed -i "s|RPMURL|${RPM}|g" source/conf.py; \
		;; \
	esac

sync-sdks:
	@(./sync-docs.sh)

# Can probably safely remove this at some point
sync-deps:
# C++ and Rust repos do not have any releases yet.
	@echo "Synchronizing all external dependencies"
	@make sync-minio-version
	@make sync-kes-version

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@echo -e "Specify one of the following supported build outputs"
	@echo -e "- make linux\n- make macos\n- make windows\n- make k8s\n- make container"
	@echo -e "Clean targets with 'make clean-<target>'"
	@echo -e "Clean all targets with `make clean`"
