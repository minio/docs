# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
import yaml

# The current working dir seems to be /source, so we have to pop up a level
sys.path.append(os.path.abspath('../sphinxext'))


# sys.path.insert(0, os.path.abspath('.'))


# The full version, including alpha/beta/rc tags
release = '0.2'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.extlinks',
    'minio',
    'cond',
    'sphinx_copybutton',
    'sphinx-prompt',
    'sphinx_substitution_extensions',
    'sphinx_togglebutton',
    'sphinx_sitemap',
    'sphinxcontrib.images',
    'myst_parser',
    'sphinx_design',
    'sphinx.ext.intersphinx',
]

# -- External Links

# Add roots for short external link references in the documentation. 
# Helpful for sites we tend to make lots of references to.

extlinks = {
    'kube-docs'       : ('https://kubernetes.io/docs/%s', None),
    'minio-git'       : ('https://github.com/minio/%s', None),
    'github'          : ('https://github.com/%s', None),
    'kube-api'        : ('https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.19/%s', None),
    'aws-docs'        : ('https://docs.aws.amazon.com/%s', None),
    's3-docs'         : ('https://docs.aws.amazon.com/AmazonS3/latest/userguide/%s', None),
    's3-api'          : ('https://docs.aws.amazon.com/AmazonS3/latest/API/%s', None),
    'iam-docs'        : ('https://docs.aws.amazon.com/IAM/latest/UserGuide/%s', None),
    'minio-release'   : ('https://github.com/minio/minio/releases/tag/%s', None),
    'mc-release'      : ('https://github.com/minio/mc/releases/tag/%s', None),
    'prometheus-docs' : ('https://prometheus.io/docs/%s', None),
    'podman-docs'     : ('https://docs.podman.io/en/latest/%s', None),
    'podman-git'      : ('https://github.com/containers/podman/%s', None),
    'docker-docs'     : ('https://docs.docker.com/%s', None),
    'openshift-docs'  : ('https://docs.openshift.com/container-platform/4.11/%s', None),
    'influxdb-docs'   : ('https://docs.influxdata.com/influxdb/v2.4/%s', None),
    'eks-docs'        : ('https://docs.aws.amazon.com/eks/latest/userguide/%s', None),
    'minio-web'       : ('https://min.io/%s?ref=docs', None),
    'minio-docs'      : ('https://min.io/docs/%s?ref=docs-internal', None),
    'gke-docs'        : ('https://cloud.google.com/kubernetes-engine/docs/%s', None),
    'gcp-docs'        : ('https://cloud.google.com/compute/docs/%s', None),
    'gcs-docs'        : ('https://cloud.google.com/storage/docs/%s', None),
    'aks-docs'        : ('https://learn.microsoft.com/en-us/azure/aks/%s', None),
    'azure-docs'      : ('https://learn.microsoft.com/en-us/azure/%s', None),

}

suppress_warnings = [
    'toc.excluded',
    'myst.header',
    'myst.xref_missing',
    'ref.myst'
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
#
# We can safely ignore everything in `includes`

exclude_patterns = ['includes/*', '*-template.rst']

# template for adding custom exclude paths if necessary for a given tag
# html_baseurl is used by sphinx_sitemap extension to generate a sitemap.xml for each platform.
# The sitemaps are combined in a sitemapindex.xml file at the root level.

sitemap_url_scheme = "{link}"

excludes = []

if tags.has("linux"):
    html_baseurl = 'https://min.io/docs/minio/linux/'
    with open('url-excludes.yaml','r') as f:
      for i in (yaml.safe_load_all(f)):
         if i['tag'] == 'linux':
            excludes = i['excludes']
            break

elif tags.has("macos"):
    html_baseurl = 'https://min.io/docs/minio/macos/'
    with open('url-excludes.yaml','r') as f:
      for i in (yaml.safe_load_all(f)):
         if i['tag'] == 'macos':
            excludes = i['excludes']
            break

elif tags.has("windows"):
    # html_baseurl is used for generating the sitemap.xml for each platform. These are combined in a sitemapindex.xml.
    html_baseurl = 'https://min.io/docs/minio/windows/'
    with open('url-excludes.yaml','r') as f:
      for i in (yaml.safe_load_all(f)):
         if i['tag'] == 'windows':
            excludes = i['excludes']
            break

elif tags.has("container"):
    html_baseurl = 'https://min.io/docs/minio/container/'
    with open('url-excludes.yaml','r') as f:
      for i in (yaml.safe_load_all(f)):
         if i['tag'] == 'container':
            excludes = i['excludes']
            break

elif tags.has("k8s") and not (tags.has("openshift") or tags.has("eks") or tags.has("gke") or tags.has("aks")):
    html_baseurl = 'https://min.io/docs/minio/kubernetes/upstream/'
    with open('url-excludes.yaml','r') as f:
      for i in (yaml.safe_load_all(f)):
         if i['tag'] == 'k8s':
            excludes = i['excludes']
            break

elif tags.has("openshift"):
    html_baseurl = 'https://min.io/docs/minio/kubernetes/openshift/'
    with open('url-excludes.yaml','r') as f:
      for i in (yaml.safe_load_all(f)):
         if i['tag'] == 'openshift':
            excludes = i['excludes']
            break

elif tags.has("eks"):
    html_baseurl = 'https://min.io/docs/minio/kubernetes/eks/'
    with open('url-excludes.yaml','r') as f:
      for i in (yaml.safe_load_all(f)):
         if i['tag'] == 'eks':
            excludes = i['excludes']
            break

elif tags.has("gke"):
    html_baseurl = 'https://min.io/docs/minio/kubernetes/gke/'
    with open('url-excludes.yaml','r') as f:
      for i in (yaml.safe_load_all(f)):
         if i['tag'] == 'gke':
            excludes = i['excludes']
            break

elif tags.has("aks"):
    html_baseurl = 'https://min.io/docs/minio/kubernetes/aks/'
    with open('url-excludes.yaml','r') as f:
      for i in (yaml.safe_load_all(f)):
         if i['tag'] == 'aks':
            excludes = i['excludes']
            break

exclude_patterns.extend(excludes)

# MyST Parser Customization
#myst_gfm_only = True
myst_heading_anchors = 2
myst_all_links_external=False
myst_url_schemes={'http': None, 'https': None, 'mailto': None, 'ftp': None}

# Copy-Button Customization

copybutton_selector = "div.copyable pre"

# sphinxcontrib-images customization

images_config = { 
   'override_image_directive' : True
}

# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'alabaster'

html_favicon = '_static/favicon.png'

html_sidebars = {
    '**' : [
        'navigation.html'
    ]
}

html_theme_options = {
    'fixed_sidebar' : 'true',
    'show_relbars': 'false'
}

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

html_css_files = ['css/main.min.css', 'custom.css']

html_js_files = [
    ('https://cdn.jsdelivr.net/npm/algoliasearch@4/dist/algoliasearch-lite.umd.js', {'defer': 'defer'}),
    ('https://cdn.jsdelivr.net/npm/instantsearch.js@4', {'defer': 'defer'}),
    ('js/main.js', {'defer': 'defer'}),
    ('js/instantSearch.js', {'defer': 'defer'}),
]

# Add https://www.min.io/robots.txt to html_extra_path list once available.
html_extra_path = [ 'extra']

# -- Project information -----------------------------------------------------

# We assume a single tag, since we control the builder

platform = list(tags.tags.keys())[0]

platform_fmt = ""

if platform == "k8s":
   platform_fmt = "Kubernetes"
elif platform == "macos":
   platform_fmt = "MacOS"
elif platform == "openshift":
   platform_fmt = "OpenShift"
elif platform == "eks":
   platform_fmt = "Elastic Kubernetes Service"
elif platform == "gke":
   platform_fmt = "Google Kubernetes Engine"
elif platform == "aks":
   platform_fmt = "Azure Kubernetes Service"
else:
   platform_fmt = platform.capitalize()

project = 'MinIO Documentation for ' + platform_fmt
copyright = '2020-Present, MinIO, Inc. '
author = 'MinIO Documentation Team'
html_title = 'MinIO Object Storage for ' + platform_fmt
html_short_title = 'MinIO Object Storage for ' + platform_fmt

html_permalinks_icon = ''

html_context = {
    'doc_platform': platform.lower()
}

# -- Options for Sphinx Tabs -------------------------------------------------

sphinx_tabs_disable_css_loading = True

# -- Intersphinx --

# k8s is temporary until integrating the references here

intersphinx_mapping = {
    'linux'      : ('https://min.io/docs/minio/linux/', None),
    'kubernetes' : ('https://min.io/docs/minio/kubernetes/upstream/',None) 
}

rst_prolog = """

.. |platform| replace:: %s

.. |podman| replace:: `Podman <https://podman.io/>`__

.. |kes-tag| replace:: `KESLATEST <https://github.com/minio/kes/releases/tag/KESLATEST>`__
.. |kes-stable| replace:: KESLATEST
.. |minio-tag| replace:: `MINIOLATEST <https://github.com/minio/minio/releases/tag/MINIOLATEST>`__
.. |minio-latest| replace:: MINIOLATEST
.. |minio-rpm| replace:: RPMURL
.. |minio-deb| replace:: DEBURL
.. |minio-rpmarm64| replace:: RPMARM64URL
.. |minio-debarm64| replace:: DEBARM64URL
.. |subnet| replace:: `MinIO SUBNET <https://min.io/pricing?jmp=docs>`__
.. |subnet-short| replace:: `SUBNET <https://min.io/pricing?jmp=docs>`__
.. |SNSD| replace:: :abbr:`SNSD (Single-Node Single-Drive)`
.. |SNMD| replace:: :abbr:`SNMD (Single-Node Multi-Drive)`
.. |MNMD| replace:: :abbr:`MNMD (Multi-Node Multi-Drive)`
.. |operator-version-stable| replace:: OPERATOR

.. |cpp-sdk-version| replace:: CPPVERSION
.. |dotnet-sdk-version| replace:: DOTNETVERSION
.. |go-sdk-version| replace:: GOVERSION
.. |haskell-sdk-version| replace:: HASKELLVERSION
.. |java-jar-url| replace:: JAVAURL
.. |java-sdk-version| replace:: JAVAVERSION
.. |javascript-sdk-version| replace:: JAVASCRIPTVERSION
.. |python-sdk-version| replace:: PYTHONVERSION
.. |rust-sdk-version| replace:: RUSTVERSION


""" % platform_fmt
