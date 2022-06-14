# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?= -n -j "auto"
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

clean-all:
	@echo "Cleaning $(BUILDDIR)/$(GITDIR)"
	@rm -rf $(BUILDDIR)/$(GITDIR)

clean-%:

	@echo "Cleaning $(BUILDDIR)/$(GITDIR)/$*"
	@rm -rf $(BUILDDIR)/$(GITDIR)/$*

stage-%:
	python -m http.server --directory $(BUILDDIR)/$(GITDIR)/$*/html/
	@echo "Visit http://localhost:8000 to view the staged output"

linux:
	@cp source/default-conf.py source/conf.py
	@make sync-minio-version
	@make sync-kes-version
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@
	@npm run build

windows:
	@cp source/default-conf.py source/conf.py
	@make sync-minio-version
	@make sync-kes-version
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@
	@npm run build

macos:
	@cp source/default-conf.py source/conf.py
	@make sync-minio-version
	@make sync-kes-version
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@
	@npm run build

k8s:
	@cp source/default-conf.py source/conf.py
	@make sync-minio-version
	@make sync-kes-version
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@
	@npm run build

sync-operator-version:
	@echo "Retrieving latest Operator version"
	$(shell wget -O /tmp/downloads-operator.json https://api.github.com/repos/minio/operator/releases/latest)
	$(eval OPERATOR = $(shell cat /tmp/downloads-operator.json | jq '.tag_name[1:]'))

	@echo "Replacing variables"

	@cp source/default-conf.py source/conf.py

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
	@$(shell wget -qO /tmp/downloads-minio.json https://min.io/assets/downloads-minio.json)
	@$(eval DEB = $(shell cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".amd64.DEB.download'))
	@$(eval RPM = $(shell cat /tmp/downloads-minio.json | jq '.Linux."MinIO Server".amd64.RPM.download'))
	@$(eval MINIO = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio/releases/latest | sed "s/https:\/\/github.com\/minio\/minio\/releases\/tag\///"))

	@cp source/default-conf.py source/conf.py

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

sync-java-docs:
	@echo "Retrieving Java docs from github.com/minio/minio-java"
	@$(eval LATEST = $(shell wget -q https://api.github.com/repos/minio/minio-java/releases/latest -O - | jq -r '.tag_name'))
	@echo "Latest stable is ${LATEST}"
	$(shell wget -q -O source/developers/java/API.md https://raw.githubusercontent.com/minio/minio-java/${LATEST}/docs/API.md)
	$(shell wget -q -O source/developers/java/quickstart.md https://raw.githubusercontent.com/minio/minio-java/${LATEST}/README.md)

sync-python-docs:
	@echo "Retrieving Python docs from github.com/minio/minio-py"
	@$(eval LATEST = $(shell wget -q https://api.github.com/repos/minio/minio-py/releases/latest -O - | jq -r '.tag_name'))
	@echo "Latest stable is ${LATEST}"
	$(shell wget -q -O source/developers/python/API.md https://raw.githubusercontent.com/minio/minio-py/${LATEST}/docs/API.md)
	$(shell wget -q -O source/developers/python/quickstart.md https://raw.githubusercontent.com/minio/minio-py/${LATEST}/README.md)

sync-go-docs:
	@echo "Retrieving Go docs from github.com/minio/minio-go"
	@$(eval LATEST = $(shell wget -q https://api.github.com/repos/minio/minio-go/releases/latest -O - | jq -r '.tag_name'))
	@echo "Latest stable is ${LATEST}"
	$(shell wget -q -O source/developers/go/API.md https://raw.githubusercontent.com/minio/minio-go/${LATEST}/docs/API.md)
	$(shell wget -q -O source/developers/go/quickstart.md https://raw.githubusercontent.com/minio/minio-go/${LATEST}/README.md)

sync-dotnet-docs:
	@echo "Retrieving Python docs from github.com/minio/minio-py"
	@$(eval LATEST = $(shell wget -q https://api.github.com/repos/minio/minio-dotnet/releases/latest -O - | jq -r '.tag_name'))
	@echo "Latest stable is ${LATEST}"
	$(shell wget -q -O source/developers/dotnet/API.md https://raw.githubusercontent.com/minio/minio-dotnet/${LATEST}/Docs/API.md)
	$(shell wget -q -O source/developers/dotnet/quickstart.md https://raw.githubusercontent.com/minio/minio-dotnet/${LATEST}/README.md)

sync-deps:
	@echo "Synchronizing all external dependencies"
	@make sync-minio-version
	@make sync-kes-version
	@make sync-java-docs
	@make sync-python-docs
	@make sync-go-docs
	@make sync-dotnet-docs

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@echo -e "Specify one of the following supported build outputs"
	@echo -e "- make linux\n- make macos\n- make windows\n- make k8s"
	@echo -e "Clean targets with 'make clean-<target>'"
	@echo -e "Clean all targets with `make clean-all`"
