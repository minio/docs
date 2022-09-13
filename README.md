# MinIO Documentation

## Build Instructions

MinIO uses [Sphinx](https://www.sphinx-doc.org/en/master/index.html) to generate static HTML pages using ReSTructured Text (rST).

### Prerequisites

- Any GNU/Linux Operating System.
- python 3.10.x and python-pip
- sphinx 4.3.2
- nodejs 14.5.0 or later
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

4. Build all targets at once:

```
make all
```

5. View the generated documentation visit http://localhost:8000:

```
python -m http.server --directory build/YOUR_BRANCH/<PLATFORM>/html
```

# License

This project is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/legalcode). See [CONTRIBUTING.md](https://github.com/minio/docs/tree/master/CONTRIBUTING.md) guide for more information on contributing to the MinIO Documentation project.
