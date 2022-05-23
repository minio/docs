# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?= -n
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = source
BUILDDIR      = build
GITDIR        = $(shell git rev-parse --abbrev-ref HEAD)
DEB			  = $(curl https://min.io/assets/downloads-minio.json | jq '.Linux."MinIO Server".amd64.DEB.download')

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

sync-minio-version:
	@echo "Retrieving current MinIO version"
	$(shell wget -O /tmp/downloads-minio.json https://min.io/assets/downloads-minio.json)
	$(eval DEB = $(shell cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".amd64.DEB.download'))
	$(eval RPM = $(shell cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".amd64.RPM.download'))
	$(eval MINIO = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio/releases/latest | sed "s/https:\/\/github.com\/minio\/minio\/releases\/tag\///"))

	@cp source/default-conf.py source/conf.py

	@kname=$(uname -s)
	@case "${kname}" in \
	Darwin) \
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

	@if [ "$(shell git diff --name-only | grep 'conf.py')" == "" ]; then \
		echo "MinIO Server Version already latest"; \
	else \
		echo "New MinIO Server Version available" ; \
		git add source/conf.py && git commit -m "Updating MinIO server to ${MINIO}"; \
	fi

sync-java-docs:
	@echo "Retrieving Java docs from github.com/minio/minio-java"
	@$(eval LATEST = $(shell wget -q https://api.github.com/repos/minio/minio-java/releases/latest -O - | jq -r '.tag_name'))
	@echo "Latest stable is ${LATEST}"
	$(shell wget -q -O source/sdk/java/API.md https://raw.githubusercontent.com/minio/minio-java/${LATEST}/docs/API.md)

sync-python-docs:
	@echo "Retrieving Python docs from github.com/minio/minio-py"
	@$(eval LATEST = $(shell wget -q https://api.github.com/repos/minio/minio-py/releases/latest -O - | jq -r '.tag_name'))
	@echo "Latest stable is ${LATEST}"
	$(shell wget -q -O source/sdk/python/API.md https://raw.githubusercontent.com/minio/minio-py/${LATEST}/docs/API.md)

sync-go-docs:
	@echo "Retrieving Python docs from github.com/minio/minio-py"
	@$(eval LATEST = $(shell wget -q https://api.github.com/repos/minio/minio-go/releases/latest -O - | jq -r '.tag_name'))
	@echo "Latest stable is ${LATEST}"
	$(shell wget -q -O source/sdk/go/API.md https://raw.githubusercontent.com/minio/minio-go/${LATEST}/docs/API.md)

sync-dotnet-docs:
	@echo "Retrieving Python docs from github.com/minio/minio-py"
	@$(eval LATEST = $(shell wget -q https://api.github.com/repos/minio/minio-dotnet/releases/latest -O - | jq -r '.tag_name'))
	@echo "Latest stable is ${LATEST}"
	$(shell wget -q -O source/sdk/dotnet/API.md https://raw.githubusercontent.com/minio/minio-dotnet/${LATEST}/Docs/API.md)

sync-deps:
	@echo "Synchronizing all external dependencies"
	@make sync-minio-version
	@make sync-java-docs
	@make sync-python-docs
	@make sync-go-docs
	@make sync-dotnet-docs

stage:
	@make clean && make html
	python -m http.server --directory $(BUILDDIR)/$(GITDIR)/html
	
publish:
	@make clean
	make html

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)" $(SPHINXOPTS) $(O)
	@npm run build
