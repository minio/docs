# MinIO Documentation

As of October 10, 2025, the MinIO object store documentation was pulled from web hosting.

Moving forward, community users can build and host the documentation themselves using the instructions below.

No further development of the documentation is planned at this time. The project maintainers will make best efforts to review and merge PRs from the community.

## Build Instructions

MinIO uses [Sphinx](https://www.sphinx-doc.org/en/master/index.html) to generate static HTML pages using ReSTructured Text (rST).

### Prerequisites

- Any GNU/Linux Operating System, or macOS 12.3 or later.
- python 3.10.x and python-pip
- python3.10-venv
- sphinx 6.2.1
- nodejs 14.5.0 or later
- npm 16.19.1 or later
- `git` or a git-compatible client

### Build

> NOTE: following instructions do work on macOS for testing purposes, however for production builds GNU/Linux is recommended.

1. Clone docs repository locally.

```
git clone https://github.com/minio/docs && cd docs/
```

2. Create a new Python virtual environment.

```
python3 -m venv venv && source venv/bin/activate
```

3. Install all the python and nodejs dependencies

```
pip install -r requirements.txt && npm install && npm run build
```

4. Build

```
make SYNC_SDK=true mindocs
```

`SYNC_SDK=true` pulls down SDK-related dependencies from MinIO's community S3 libraries.
You can omit `SYNC_SDK` on subsequent builds.

5. View the generated documentation at http://localhost:8000.

```
python -m http.server --directory build/YOUR_BRANCH/<PLATFORM>/html
```

# Syncing Operator CRD Docs

For importing the Operator CRD Docs specifically, you must have:

- pandoc (latest stable)
- asciidoc (latest stable)

In addition to all other prerequisites.

Run

```
make sync-operator-crd
```

This script does three things:

- Downloads and converts the `tenant-crd.adoc` from the MinIO Operator Github repository
- Downloads the Operator Helm `values.yaml` from the Operator Github repository
- Downloads the Tenant Helm `values.yaml` from the Operator Github repository

For the the `tenant-crd.adoc` , it converts the asciidoc to XML, then to markdown.
Finally, it does some `sed` find/replace to tidy up the file for Sphinx ingest.

You can run this when we have a new Operator release being documented, assuming there are changes to the CRD as part of that release.
It should make it somewhat easier to periodically sync these docs instead of pulling them down every single build, when we do not expect or need to doc changes in latest stable.

# License

This project is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/legalcode). See [CONTRIBUTING.md](https://github.com/minio/docs/tree/master/CONTRIBUTING.md) guide for more information on contributing to the MinIO Documentation project.

> NOTE: This work was previously licensed under AGPL3.0. You can find all AGPL3.0 licensed code at commit:[73772c7f8485809446cc890188a89ece1afb93f6](https://github.com/minio/docs/tree/73772c7f8485809446cc890188a89ece1afb93f6)
