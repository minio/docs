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

	@echo "Replacing Variables"

	@cp source/default-conf.py source/conf.py

	@sed -i "s|MINIOLATEST|${MINIO}|g" source/conf.py
	@sed -i "s|DEBURL|${DEB}|g" source/conf.py
	@sed -i "s|RPMURL|${RPM}|g" source/conf.py

stage:
	@make clean && make html
	python -m http.server --directory $(BUILDDIR)/$(GITDIR)/html
	
publish:
	@make sync-minio-version
	@make clean
	make html

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)" $(SPHINXOPTS) $(O)
	@npm run build
