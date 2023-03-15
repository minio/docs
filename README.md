# MinIO Documentation

## Build Instructions

MinIO uses [Sphinx](https://www.sphinx-doc.org/en/master/index.html) to generate static HTML pages using ReSTructured Text (rST).

### Prerequisites

- Any GNU/Linux Operating System, or macOS 12.3 or later.
- python 3.10.x and python-pip
- python3.10-venv
- sphinx 4.3.2
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

4. Build your desired platform targets.

```
make linux
```
```
make linux k8s container
```

5. View the generated documentation at http://localhost:8000.

```
python -m http.server --directory build/YOUR_BRANCH/<PLATFORM>/html
```

### Stage

The `make stage-PLATFORM` command uses the `mc` utility to copy the contents of the current git branch build output for the specified `PLATFORM` to a configured MinIO or S3-compatible bucket.

For the command to work, you must have a configured `mc` alias `docs-staging` with general read/write (`s3:*`) permissions on the `staging` bucket.
The `staging` bucket should have public or anonymous access enabled.

For example:

```
make stage-linux
```

Does the following:

1. Check that the `build/GITDIR/linux` folder exists
2. Copies the contents of `build/GITDIR/linux/html/*` to `docs-staging/staging/GITDIR/linux`

# License

This project is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/legalcode). See [CONTRIBUTING.md](https://github.com/minio/docs/tree/master/CONTRIBUTING.md) guide for more information on contributing to the MinIO Documentation project.

> NOTE: This work was previously licensed under AGPL3.0. You can find all AGPL3.0 licensed code at commit:[73772c7f8485809446cc890188a89ece1afb93f6](https://github.com/minio/docs/tree/73772c7f8485809446cc890188a89ece1afb93f6)
