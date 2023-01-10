# Launching a New Platform

## Overview

The documentation URLs take the path min.io/docs/$program/$platform/

Where:
- `$program` is `minio`, `kes`, or similar
- `$platform` is `kubernetes/upstream`, `kubernetes/openshift`, `macos`, `container`, `windows`, `linux`, and similar
- Not every `$program` has `$platform` specific versions of their docs

## Steps

When launching docs for a new `$program` or `$platform`, the following steps must be completed:

1. Update the `makefile` in this repo to include the new docs
   
   - Use an existing `$platform` or `$program` section as a template.
   - This creates a build command specific for the new `$platform` or `$program` docs.

2. Add an `elif` section for the new `$program` or `$platform` to the `source/default-conf.py` file in this repo
   
   - Use an existing `elif` section as a template to follow.
   - This allows you to exclude files that are not necessary from the build.
   - Use the `url-excludes.yaml` file to specify URLs to exclude from that platforms build

3. Update `build-docs.sh` in this repo to automatically build the docs for the web server on each merge to the `main` branch

   - Add the platform or program to the second `make` line.
   - Create the commands to clear and add the path to the new docs using an existing section as a template.
   - Kubernetes platforms should go under `/docs/kubernetes/$platform`   
   - You can test by running locally (might need `sudo sh ./build-docs.sh`).
     You can then use `python -m http.server --directory /var/www/docs/minio/` and testing URLs

4. Update the doc main nav bar (`/source/_templates/content-navigation.html`) to include the `$program` and/or `$platform`

   Work with the website design team as needed.

5. Update the `sitemap_index.xml` file

   - Contact a member of the website design to to add the new `$program` or `$platform` sitemap.xml path to the sitemap_index.xml on the min.io root website server.

6. Update the Algolia crawler
   
   - Add the new `$program` or `$platform` sitemap.xml path to the **minio** Algolia crawler configuration at https://crawler.algolia.com.
   - Select the **minio** index from the list, then select the Editor tab on the left nav
   - Add the path to the `discoveryPatterns` section
   - Add the path to the `pathsToMatch` section
   - Click **Save**
  
7. Reindex the docs site
   
   After the docs are published, manually launch the **minio** index crawler from https://crawler.algolia.com by selecting **Restart crawling**.