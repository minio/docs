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

# The current working dir seems to be /source, so we have to pop up a level
sys.path.append(os.path.abspath('../sphinxext'))


# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

# We assume a single tag, since we control the builder

platform = list(tags.tags.keys())[0]

if (platform =="k8s"):
    platform = "Kubernetes"

project = 'MinIO Documentation for ' + platform
copyright = '2020-Present, MinIO, Inc. '
author = 'MinIO Documentation Team'

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
    'kube-docs'       : ('https://kubernetes.io/docs/%s', ''),
    'minio-git'       : ('https://github.com/minio/%s',''),
    'github'          : ('https://github.com/%s',''),
    'kube-api'        : ('https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.19/%s',''),
    'aws-docs'        : ('https://docs.aws.amazon.com/%s',''),
    's3-docs'         : ('https://docs.aws.amazon.com/AmazonS3/latest/userguide/%s',''),
    's3-api'          : ('https://docs.aws.amazon.com/AmazonS3/latest/API/%s',''),
    'iam-docs'        : ('https://docs.aws.amazon.com/IAM/latest/UserGuide/%s',''),
    'minio-release'   : ('https://github.com/minio/minio/releases/tag/%s',''),
    'mc-release'      : ('https://github.com/minio/mc/releases/tag/%s',''),
    'prometheus-docs' : ('https://prometheus.io/docs/%s',''),
    'podman-docs'     : ('https://docs.podman.io/en/latest/%s',''),
    'podman-git'      : ('https://github.com/containers/podman/%s',''),
    'docker-docs'     : ('https://docs.docker.com/%s', ''),

}

suppress_warnings = [
    'toc.excluded',
    'myst.header',
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

if tags.has("linux"):
    html_baseurl = 'https://min.io/docs/minio/linux/'
    excludes = [
        'operations/install-deploy-manage/deploy-minio-tenant.rst',
        'operations/install-deploy-manage/modify-minio-tenant.rst',
        'operations/install-deploy-manage/expand-minio-tenant.rst',
        'operations/install-deploy-manage/upgrade-minio-tenant.rst',
        'operations/install-deploy-manage/upgrade-minio-operator.rst',
        'operations/install-deploy-manage/delete-minio-tenant.rst',
        'operations/install-deploy-manage/minio-operator-console.rst',
        'operations/deploy-manage-tenants.rst',
        'reference/kubectl-minio-plugin.rst',
        'reference/kubectl-minio-plugin/kubectl-minio-delete.rst',
        'reference/kubectl-minio-plugin/kubectl-minio-init.rst',
        'reference/kubectl-minio-plugin/kubectl-minio-proxy.rst',
        'reference/kubectl-minio-plugin/kubectl-minio-tenant-create.rst',
        'reference/kubectl-minio-plugin/kubectl-minio-tenant-delete.rst',
        'reference/kubectl-minio-plugin/kubectl-minio-tenant-expand.rst',
        'reference/kubectl-minio-plugin/kubectl-minio-tenant-info.rst',
        'reference/kubectl-minio-plugin/kubectl-minio-tenant-list.rst',
        'reference/kubectl-minio-plugin/kubectl-minio-tenant-report.rst',
        'reference/kubectl-minio-plugin/kubectl-minio-tenant-upgrade.rst',
        'reference/kubectl-minio-plugin/kubectl-minio-tenant.rst',
        'reference/kubectl-minio-plugin/kubectl-minio-version.rst',
    ]
elif tags.has("macos"):
    html_baseurl = 'https://min.io/docs/minio/macos/'
    excludes = [
        'operations/install-deploy-manage/deploy-minio-tenant.rst',
        'operations/install-deploy-manage/modify-minio-tenant.rst',
        'operations/install-deploy-manage/expand-minio-tenant.rst',
        'operations/install-deploy-manage/upgrade-minio-tenant.rst',
        'operations/install-deploy-manage/upgrade-minio-operator.rst',
        'operations/install-deploy-manage/delete-minio-tenant.rst',
        'operations/install-deploy-manage/minio-operator-console.rst',
        'operations/deploy-manage-tenants.rst',
        'reference/kubectl-minio-plugin*',
        'reference/minio-server*',
        'reference/minio-mc*',
        'developers/*',
        'integrations/*'
    ]
elif tags.has("windows"):
    # html_baseurl is used for generating the sitemap.xml for each platform. These are combined in a sitemapindex.xml.
    html_baseurl = 'https://min.io/docs/minio/windows/'
    excludes = [
        'operations/install-deploy-manage/deploy-minio-tenant.rst',
        'operations/install-deploy-manage/modify-minio-tenant.rst',
        'operations/install-deploy-manage/expand-minio-tenant.rst',
        'operations/install-deploy-manage/upgrade-minio-tenant.rst',
        'operations/install-deploy-manage/upgrade-minio-operator.rst',
        'operations/install-deploy-manage/delete-minio-tenant.rst',
        'operations/install-deploy-manage/minio-operator-console.rst',
        'operations/deploy-manage-tenants.rst',
        'reference/kubectl-minio-plugin*',
        'reference/minio-server*',
        'reference/minio-mc*',
        'developers/*',
        'integrations/*'
    ]
elif tags.has("container"):
    html_baseurl = 'https://min.io/docs/minio/container/'
    excludes = [
        'operations/install-deploy-manage/deploy-minio-tenant.rst',
        'operations/install-deploy-manage/modify-minio-tenant.rst',
        'operations/install-deploy-manage/expand-minio-tenant.rst',
        'operations/install-deploy-manage/upgrade-minio-tenant.rst',
        'operations/install-deploy-manage/upgrade-minio-operator.rst',
        'operations/install-deploy-manage/delete-minio-tenant.rst',
        'operations/install-deploy-manage/minio-operator-console.rst',
        'operations/install-deploy-manage/deploy-minio-multi-node-multi-drive.rst',
        'operations/install-deploy-manage/multi-site-replication.rst',
        'operations/deploy-manage-tenants.rst',
        'reference/kubectl-minio-plugin*',
        'reference/minio-server*',
        'reference/minio-mc*',
        'developers/*',
        'integrations/*'
    ]
elif tags.has("k8s"):
    html_baseurl = 'https://min.io/docs/minio/kubernetes/upstream/'
    excludes = [
        'operations/install-deploy-manage/deploy-minio-single-node-single-drive.rst',
        'operations/install-deploy-manage/deploy-minio-single-node-multi-drive.rst',
        'operations/install-deploy-manage/deploy-minio-multi-node-multi-drive.rst',
        'operations/install-deploy-manage/upgrade-minio-deployment.rst',
        'operations/install-deploy-manage/expand-minio-deployment.rst',
        'operations/install-deploy-manage/decommission-server-pool.rst',
        'operations/manage-existing-deployments.rst',
        'reference/minio-server*',
        'reference/minio-mc*',
        'developers/*',
        'integrations/*'

    ]
else:
    excludes = []

exclude_patterns.extend(excludes)

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

html_short_title = "MinIO Object Storage for " + ("MacOS" if platform == "macos" else platform.capitalize())

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

html_css_files = ['css/main.min.css', 'custom.css']

html_js_files = [
    ('https://cdn.jsdelivr.net/npm/@docsearch/js@3', {'defer': 'defer'}),
    ('js/main.js', {'defer': 'defer'}),
]

# Add https://www.min.io/robots.txt to html_extra_path list once available.
html_extra_path = [ 'extra']

html_title = 'MinIO Object Storage for ' + ("MacOS" if platform == "macos" else platform.capitalize())

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

.. |podman| replace:: `Podman <https://podman.io/>`__

.. |kes-tag| replace:: `KESLATEST <https://github.com/minio/kes/releases/tag/KESLATEST>`__
.. |kes-stable| replace:: KESLATEST
.. |minio-tag| replace:: `MINIOLATEST <https://github.com/minio/minio/releases/tag/MINIOLATEST>`__
.. |minio-latest| replace:: MINIOLATEST
.. |minio-rpm| replace:: RPMURL
.. |minio-deb| replace:: DEBURL
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


"""
