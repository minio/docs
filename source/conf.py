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

project = 'MinIO Documentation'
copyright = '2020, MinIO'
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
    'sphinx_tabs.tabs',
    'recommonmark',
    'sphinx_markdown_tables',
]

# -- External Links

# Add roots for short external link references in the documentation. 
# Helpful for sites we tend to make lots of references to.

extlinks = {
    'kube-docs' : ('https://kubernetes.io/docs/%s', ''),
    'minio-git' : ('https://github.com/minio/%s',''),
    'github'    : ('https://github.com/%s',''),
    'kube-api'  : ('https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/%s',''),
    'aws-docs'  : ('https://docs.aws.amazon.com/%s',''),
    's3-docs'   : ('https://docs.aws.amazon.com/AmazonS3/latest/dev/%s',''),
    's3-api'    : ('https://docs.aws.amazon.com/AmazonS3/latest/API/%s',''),
    'iam-docs'  : ('https://docs.aws.amazon.com/IAM/latest/UserGuide/%s',''),
    'release'   : ('https://github.com/minio/mc/releases/tag/%s',''),
    'legacy'    : ('https://docs.min.io/docs/%s',''),
}

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['includes/*.rst']

# Copy-Button Customization

copybutton_selector = "div.copyable pre"

# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'alabaster'

html_favicon = '_static/favicon.png'

html_sidebars = {
    '**' : [
        'searchbox.html',
        'navigation.html',
    ]
}

html_theme_options = {
    'fixed_sidebar' : 'true',
    'show_relbars': 'true',
}

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

html_css_files = ['css-style.css']

html_js_files = ['js/main.js']

html_title = 'MinIO Documentation'

# rst_epilog contains common replacements for all pages

rst_epilog = """

.. |minio-operator-release| replace:: ``minio/k8s-operator:v3.0.27``

.. |minio-server-release| replace::   ``minio/minio:RELEASE.2020-10-03T02-19-42Z``

"""