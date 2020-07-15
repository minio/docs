#Requirements

Python3 (any version should be fine, latest is ideal)

Suggest creating a virtual environment to keep things clean and simple:

Start by cloning the repository. `cd` into the cloned repo and `git checkout dev`. You might need to `git fetch` to refresh the repo.

Once in the repository root, run the following.

```shell

python3 -m venv venv

source venv/bin/activate

pip3 install -r requirements.txt
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

#TODO

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

