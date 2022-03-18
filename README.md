# MinIO Docs

# Build Instructions

MinIO uses [Sphinx](https://www.sphinx-doc.org/en/master/index.html) to generate
static HTML pages using ReSTructured Text (rST).

## Prerequisites

- Python 3.10.X and pip

- Sphinx 4.3.2

- NodeJS 14.5.0 or later and npm

- gulp.js

- `git` or a git-compatible client

- Access to https://github.com/minio/docs

## Build Process

### Linux

1. Run `git checkout https://github.com/minio/docs` and `cd docs` to move into
   the working directory.

2. Create a new virtual environment `python3 -m venv venv`. Activate it using
   `source venv/bin/activate`.

3. Run `pip install -r requirements.txt` to setup the Python environment.

4. Run `make stage`

5. Open your browser to http://localhost:8000 to view the staged output.

### MacOS

1. Run `git checkout https://github.com/minio/docs` and `cd docs` to move into
   the working directory.

2. Create a new virtual environment `python3 -m venv venv`. Activate it using
   `source venv/bin/activate`.

3. Run `pip install -r requirements.txt` to setup the Python environment.

4. Run `npm install`

5. Run `npm run build`

6. Run `make stage`

7. Open your browser to http://localhost:8000 to view the staged output.

### Windows

Prereq:

- Checkout the MinIO docs repository using your preferred `git` method
  
  `git checkout https://github.com/minio/docs`

All instructions use PowerShell running as an administrator.

1. Set policies
   
   `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
2. Navigate to the folder with the cloned docs
3. Start virtual environment
   
   `python -m venv venv`
4. Activate virtual environment
   
   `.\venv\Scripts\Activate.ps1`
5. Install docs requirements
   
   `pip install -r requirements.txt`
6. (optional) Delete the Build directory
   
   `Remove-Item build\`
7. Generate CSS from SCSS files
   
   `npm run build`
8. Build the docs
   
   `sphinx-build -M html source\ build\master -n`
9.  Start the http server
    
    `python -m http.server --directory build\master\html`
10. View the staged output in a browser by going to `localhost:8000`


This project is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/legalcode).

See [CONTRIBUTIONS](https://github.com/minio/docs/tree/master/CONTRIBUTING.md) for more information on contributing content to the MinIO Documentation project.