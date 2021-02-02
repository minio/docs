# MinIO Docs

## Requirements

- python3 (any version should be fine, latest is ideal)
- suggest creating a virtual environment to keep things clean and simple:
- start by cloning the repository. `cd` into the cloned repo. You might need to `git fetch` to refresh the repo.
- once in the repository root, run the following.

```shell
python3 -m venv venv
```

```shell
source venv/bin/activate
```

```shell
pip3 install -r requirements.txt
```

```shell
nvm install v14.5.0
nvm use v14.5.0
npm install
```

To make the build, do:

```shell
make html
```

Artifacts output to the `build/` directory as HTML. Just open `index.html` to get started poking around.

If you modify things, I suggest doing clean builds to make sure all artifacts are fresh:

```shell
rm -rf build/ && make html
```

Still need to work out deployment steps, but this should work for testing locally.

The `source` directory contains all of the source files, including css and js.

The `sphinxext` directory contains some python stuff related to the custom directive/roles, and its a rats nest right now.

## TODO

- Finish the remainder of the `mc`, `mc admin`, and `minio` reference material
- Refine structure of reference pages
- Transition all MinIO Features from legacy documentation and format for RST
- Flesh out Kubernetes section (pending operator/plugin work completion)
- Flesh out introduction / concepts section
- Re-write security docs
- Create references for KES, Sidekick, MCS, Gateway
- Transition cookbook material as needed
- Flesh out Baremetal deployment section
- Scan for any remaining legacy material that needs migration
