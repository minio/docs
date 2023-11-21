.. _minio-mc-alias-import:

===================
``mc alias import``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc alias import

Syntax
------

.. start-mc-alias-import-desc

The :mc:`mc alias import` command imports an alias configuration from a JSON document.

.. end-mc-alias-import-desc

You can use :mc:`mc alias export` to create the necessary JSON for import.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command imports an alias configuration from a JSON document:

      .. code-block:: shell
         :class: copyable

         mc alias import newalias ./credentials.json

      Use :mc:`mc alias list newalias <mc alias list>` to confirm the import succeeded.

   .. tab-item:: SYNTAX

      The :mc:`mc alias import` command has the following syntax:

      .. code-block:: shell

         mc [GLOBALFLAGS] alias import ALIAS PATH|STDIN

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The name of the alias to assign to the imported configuration.

.. mc-cmd:: PATH
   :required:

   The full path to the JSON object representing the alias configuration to import.

   Mutually exclusive with the :mc-cmd:`~mc alias import STDIN` parameter.

.. mc-cmd:: STDIN
   :required:

   Directs the command to use the Standard Input (STDIN) as the source of the JSON object for import.

   Mutually exclusive with the :mc-cmd:`~mc alias import PATH` parameter.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Behavior
--------

JSON Format
~~~~~~~~~~~

The JSON object **must** have the following format:

.. code-block:: json

   {
      "url" : "https://hostname:port",
      "accessKey": "<STRING>",
      "secretKey": "<STRING>",
      "api": "s3v4",
      "path": "auto"
   }

You can use the :mc:`mc alias export` command to export an existing alias from the local host configuration.
Alternatively, you can manually extract the necessary JSOn fields from the :mc:`mc` :ref:`configuration file <mc-configuration>`.

Examples
--------

Import an Alias Using Standard Input
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example imports a custom alias for the `play.min.io <https://play.min.io>`__ sandbox.
You can modify this example to use user credentials you have already created or validated as existing on the sandbox:

.. code-block:: shell
   :class: copyable

   echo '
   {
    "url": "https://play.min.io",
    "accessKey": "minioadmin",
    "secretKey": "minioadmin",
    "api": "s3v4",
    "path": "auto"
   }' | mc alias import play-minioadmin

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

