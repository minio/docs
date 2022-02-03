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

project = 'MinIO Baremetal Documentation'
copyright = '2020-Present, MinIO, Inc. '
author = 'Ravind Kumar'

# The full version, including alpha/beta/rc tags
release = '0.1'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.extlinks',
    'minio',
    'sphinx_copybutton',
    'sphinx_markdown_tables',
    'sphinx-prompt',
    'sphinx_substitution_extensions',
    'sphinx_togglebutton',
    'sphinxcontrib.images',
    'myst_parser',
    'sphinx_design',
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
    'legacy'          : ('https://docs.min.io/docs/%s',''),
    'docs-k8s'        : ('https://docs.min.io/minio/k8s/%s',''),
    'prometheus-docs' : ('https://prometheus.io/docs/%s',''),
    'podman-docs'     : ('https://docs.podman.io/en/latest/%s',''),
    'podman-git'      : ('https://github.com/containers/podman/%s','')

}

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['includes/*.rst', 'includes/imports/*', '*-template.rst']

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
        'searchbox.html',
        'navigation.html'
    ]
}

html_theme_options = {
    'fixed_sidebar' : 'true',
    'show_relbars': 'false'
}

html_short_title = "MinIO Object Storage for Baremetal Infrastructure"

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

html_css_files = ['css/main.min.css', 'custom.css']

html_js_files = ['js/main.js']

html_extra_path = [ 'extra']

html_permalinks_icon = "<img class='anchor' src=https://docs.min.io/minio/baremetal/_static/img/anchor-link.svg />"

html_title = 'MinIO Baremetal Documentation'

# -- Options for Sphinx Tabs -------------------------------------------------

sphinx_tabs_disable_css_loading = True

rst_prolog = """

.. |podman| replace:: `Podman <https://podman.io/>`__
.. |kes-stable| replace:: 0.16.1

.. |minio-tag| replace:: `RELEASE.2022-02-01T18-00-14Z <https://github.com/minio/minio/releases/tag/RELEASE.2022-02-01T18-00-14Z>`__
.. |minio-latest| replace:: RELEASE.2022-02-01T18-00-14Z
.. |minio-rpm| replace:: https://dl.min.io/server/minio/release/linux-amd64/minio-20220201180014.0.0.x86_64.rpm
.. |minio-deb| replace:: https://dl.min.io/server/minio/release/linux-amd64/minio_20220201180014.0.0_amd64.deb
.. |subnet| replace:: `MinIO SUBNET <https://min.io/pricing?jmp=docs>`

"""