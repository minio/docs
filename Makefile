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

linux:
ifeq ($(BUILD_DEPENDENCIES),FALSE)
	@echo "Skipping Dependencies"
else
	@cp source/default-conf.py source/conf.py
	@make sync-minio-version
	@make sync-kes-version
	@make sync-sdks
endif
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@

windows:
ifeq ($(BUILD_DEPENDENCIES),FALSE)
	@echo "Skipping Dependencies"
else
	@cp source/default-conf.py source/conf.py
	@make sync-minio-version
	@make sync-kes-version
	@make sync-sdks
endif
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@

macos:
ifeq ($(BUILD_DEPENDENCIES),FALSE)
	@echo "Skipping Dependencies"
else
	@cp source/default-conf.py source/conf.py
	@make sync-minio-version
	@make sync-kes-version
	@make sync-sdks
endif
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@

k8s:
ifeq ($(BUILD_DEPENDENCIES),FALSE)
	@echo "Skipping Dependencies"
else
	@cp source/default-conf.py source/conf.py
	@make sync-operator-version
	@make sync-minio-version
	@make sync-kes-version
	@make sync-sdks
endif
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@

container:
ifeq ($(BUILD_DEPENDENCIES),FALSE)
	@echo "Skipping Dependencies"
else
	@cp source/default-conf.py source/conf.py
	@make sync-minio-version
	@make sync-kes-version
	@make sync-sdks
endif
	@npm run build
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)/$@" $(SPHINXOPTS) $(O) -t $@

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

sync-cpp-docs:
# C++ repo does not have any releases yet.
	@echo "Retrieving C++ docs from github.com/minio/minio-js"
	@$(eval CPPLATEST = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio-cpp/releases/latest | sed "s/https:\/\/github.com\/minio\/minio-cpp\/releases\/tag\///"))
	@echo "Latest stable is ${CPPLATEST}"
	$(shell wget -q -O source/developers/cpp/API.md https://raw.githubusercontent.com/minio/minio-cpp/${CPPLATEST}/docs/API.md)
	$(shell wget -q -O source/developers/cpp/quickstart.md https://raw.githubusercontent.com/minio/minio-cpp/${CPPLATEST}/README.md)

	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|CPPVERSION|${CPPLATEST}|g" source/conf.py;\
		;; \
	*) \
		sed -i "s|CPPVERSION|${CPPLATEST}|g" source/conf.py; \
		;; \
	esac

sync-dotnet-docs:
	@echo "Retrieving .NET docs from github.com/minio/minio-dotnet"
	@$(eval DOTNETLATEST = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio-dotnet/releases/latest | sed "s/https:\/\/github.com\/minio\/minio-dotnet\/releases\/tag\///"))
	@echo "Latest stable is ${DOTNETLATEST}"
	$(shell wget -q -O source/developers/dotnet/API.md https://raw.githubusercontent.com/minio/minio-dotnet/${DOTNETLATEST}/Docs/API.md)
#	$(shell wget -q -O source/developers/dotnet/quickstart.md https://raw.githubusercontent.com/minio/minio-dotnet/${DOTNETLATEST}/README.md)

	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|DOTNETVERSION|${DOTNETLATEST}|g" source/conf.py;\
		;; \
	*) \
		sed -i "s|DOTNETVERSION|${DOTNETLATEST}|g" source/conf.py; \
		;; \
	esac

sync-go-docs:
	@echo "Retrieving Go docs from github.com/minio/minio-go"
	@$(eval GOLATEST = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio-go/releases/latest | sed "s/https:\/\/github.com\/minio\/minio-go\/releases\/tag\///"))
	@echo "Latest stable is ${GOLATEST}"
	$(shell wget -q -O source/developers/go/API.md https://raw.githubusercontent.com/minio/minio-go/${GOLATEST}/docs/API.md)
	$(shell wget -q -O source/developers/go/quickstart.md https://raw.githubusercontent.com/minio/minio-go/${GOLATEST}/README.md)

	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|GOVERSION|${GOLATEST}|g" source/conf.py;\
		;; \
	*) \
		sed -i "s|GOVERSION|${GOLATEST}|g" source/conf.py; \
		;; \
	esac

sync-haskell-docs:
	@echo "Retrieving Haskell docs from github.com/minio/minio-hs"
	@$(eval HASKELLLATEST = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio-hs/releases/latest | sed "s/https:\/\/github.com\/minio\/minio-hs\/releases\/tag\///"))
	@echo "Latest stable is ${HASKELLLATEST}"
	$(shell wget -q -O source/developers/haskell/API.md https://raw.githubusercontent.com/minio/minio-hs/${HASKELLLATEST}/docs/API.md)
	$(shell wget -q -O source/developers/haskell/quickstart.md https://raw.githubusercontent.com/minio/minio-hs/${HASKELLLATEST}/README.md)

	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|HASKELLVERSION|${HASKELLLATEST}|g" source/conf.py;\
		;; \
	*) \
		sed -i "s|HASKELLVERSION|${HASKELLLATEST}|g" source/conf.py; \
		;; \
	esac

sync-java-docs:
	@echo "Retrieving Java docs from github.com/minio/minio-java"
	@$(eval JAVALATEST = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio-java/releases/latest | sed "s/https:\/\/github.com\/minio\/minio-java\/releases\/tag\///"))
	@echo "Latest stable is ${JAVALATEST}"
	$(shell wget -q -O source/developers/java/API.md https://raw.githubusercontent.com/minio/minio-java/${JAVALATEST}/docs/API.md)
	$(shell wget -q -O source/developers/java/quickstart.md https://raw.githubusercontent.com/minio/minio-java/${JAVALATEST}/README.md)
	@$(eval JAVAJARURL = https://repo1.maven.org/maven2/io/minio/minio/${JAVALATEST}/)

	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|JAVAVERSION|${JAVALATEST}|g" source/conf.py;\
		sed -i "" "s|JAVAURL|${JAVAJARURL}|g" source/conf.py;\
		;; \
	*) \
		sed -i "s|JAVAVERSION|${JAVALATEST}|g" source/conf.py; \
		sed -i "s|JAVAURL|${JAVAJARURL}|g" source/conf.py;\
		;; \
	esac

sync-javascript-docs:
	@echo "Retrieving JavaScript docs from github.com/minio/minio-js"
	@$(eval JAVASCRIPTLATEST = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio-js/releases/latest | sed "s/https:\/\/github.com\/minio\/minio-js\/releases\/tag\///"))
	@echo "Latest stable is ${JAVASCRIPTLATEST}"
	$(shell wget -q -O source/developers/javascript/API.md https://raw.githubusercontent.com/minio/minio-js/${JAVASCRIPTLATEST}/docs/API.md)
	$(shell wget -q -O source/developers/javascript/quickstart.md https://raw.githubusercontent.com/minio/minio-js/${JAVASCRIPTLATEST}/README.md)

	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|JAVASCRIPTVERSION|${JAVASCRIPTLATEST}|g" source/conf.py;\
		;; \
	*) \
		sed -i "s|JAVASCRIPTVERSION|${JAVASCRIPTLATEST}|g" source/conf.py; \
		;; \
	esac

sync-python-docs:
	@echo "Retrieving Python docs from github.com/minio/minio-py"
	@$(eval PYTHONLATEST = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio-py/releases/latest | sed "s/https:\/\/github.com\/minio\/minio-py\/releases\/tag\///"))
	@echo "Latest stable is ${PYTHONLATEST}"
	$(shell wget -q -O source/developers/python/API.md https://raw.githubusercontent.com/minio/minio-py/${PYTHONLATEST}/docs/API.md)
	$(shell wget -q -O source/developers/python/quickstart.md https://raw.githubusercontent.com/minio/minio-py/${PYTHONLATEST}/README.md)

	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|PYTHONVERSION|${PYTHONLATEST}|g" source/conf.py;\
		;; \
	*) \
		sed -i "s|PYTHONVERSION|${PYTHONLATEST}|g" source/conf.py; \
		;; \
	esac

sync-rust-docs:
# Rust repo does not have any releases yet.
	@echo "Retrieving Rust docs from github.com/minio/minio-js"
	@$(eval RUSTLATEST = $(shell curl --retry 10 -Ls -o /dev/null -w "%{url_effective}" https://github.com/minio/minio-rust/releases/latest | sed "s/https:\/\/github.com\/minio\/minio-rust\/releases\/tag\///"))
	@echo "Latest stable is ${RUSTLATEST}"
#	$(shell wget -q -O source/developers/rust/API.md https://raw.githubusercontent.com/minio/minio-rs/${RUSTLATEST}/docs/API.md)
	$(shell wget -q -O source/developers/rust/quickstart.md https://raw.githubusercontent.com/minio/minio-rs/${RUSTLATEST}/README.md)

	@$(eval kname = $(shell uname -s))

	@case "${kname}" in \
	"Darwin") \
		sed -i "" "s|RUSTVERSION|${RUSTLATEST}|g" source/conf.py;\
		;; \
	*) \
		sed -i "s|RUSTVERSION|${RUSTLATEST}|g" source/conf.py; \
		;; \
	esac

sync-sdks:
# C++ and Rust repos do not have any releases yet.
#	@make sync-cpp-docs
	@make sync-dotnet-docs
	@make sync-go-docs
	@make sync-haskell-docs
	@make sync-java-docs
	@make sync-javascript-docs
	@make sync-python-docs
#	@make sync-rust-docs

sync-deps:
# C++ and Rust repos do not have any releases yet.
	@echo "Synchronizing all external dependencies"
	@make sync-minio-version
	@make sync-kes-version
#	@make sync-cpp-docs
	@make sync-dotnet-docs
	@make sync-go-docs
	@make sync-haskell-docs
	@make sync-java-docs
	@make sync-javascript-docs
	@make sync-python-docs
#	@make sync-rust-docs

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@echo -e "Specify one of the following supported build outputs"
	@echo -e "- make linux\n- make macos\n- make windows\n- make k8s\n- make container"
	@echo -e "Clean targets with 'make clean-<target>'"
	@echo -e "Clean all targets with `make clean`"
