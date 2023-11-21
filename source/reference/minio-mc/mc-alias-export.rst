.. _minio-mc-alias-export:

===================
``mc alias export``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc alias export

.. versionadded:: mc.RELEASE.2023-11-15T22-45-58Z

Syntax
------

.. start-mc-alias-export-desc

The :mc:`mc alias export` command exports an alias configuration from the existing :ref:`configuration <mc-configuration>`.

.. end-mc-alias-export-desc

The command outputs the result to ``STDOUT`` where you can either capture the output as a file *or* perform further modifications to the output as necessary.

Use the :mc:`mc alias import` command to import the resulting JSON configuration.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command exports an alias configuration from the existing host and outputs it to a file:

      .. code-block:: shell
         :class: copyable

         mc alias export play > play.json

      The command outputs the file to Standard Out (``STDOUT``).
      You can alternatively pipe the output to a utility of your choice for further operations.


   .. tab-item:: SYNTAX

      The :mc:`mc alias export` command has the following syntax:

      .. code-block:: shell

         mc [GLOBALFLAGS] alias export ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The name of the alias to export.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Behavior
--------

JSON Format
~~~~~~~~~~~

The command outputs a JSON object with the following schema:

.. code-block:: json

   {
      "url" : "https://hostname:port",
      "accessKey": "<STRING>",
      "secretKey": "<STRING>",
      "api": "s3v4",
      "path": "auto"
   }

You can use the :mc:`mc alias import` to import the JSON document.

Examples
--------

Export and Transform an Alias
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example exports the alias for the `play.min.io <https://play.min.io>`__ sandbox.
It then transforms the configuration using the `jq <https://jqlang.github.io/jq/>`__ utility and creates a new alias from the modified configuration:

.. code-block:: shell
   :class: copyable

   mc alias export play | jq '.accessKey = "minioadmin" | .secretKey = "minioadmin"' | mc alias import play-custom

Back Up An Alias Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command exports an alias configuration to a JSON file.
You can then back up that file using your preferred process.

.. code-block:: shell
   :class: copyable

   mc alias export play > play-backup.json

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

