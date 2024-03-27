======================
``mc support inspect``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support inspect

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Description
-----------

.. start-mc-support-inspect-desc

The :mc:`mc support inspect` command collects the data and metadata associated to objects at the specified path.

.. end-mc-support-inspect-desc

MinIO assembles this data from each backend drive storing an :ref:`erasure shard <minio-erasure-coding>` for each specified object.
The command produces an encrypted zip file that includes all matching files with their respective *host+drive+path*.

If this information is required to diagnose a |SUBNET| issue, MinIO Engineering will provide the appropriate command.
The resulting report is intended for use by MinIO Engineering via SUBNET and may contain internal or private data points associated to the object.
Exercise caution before sending a report to a third party or posting the report in a public forum.

.. versionchanged:: RELEASE.2023-01-11T03-14-16Z

   The file uploads to MinIO for use by the engineering team in support efforts.
   The file saves the the current working directory in the event the file does not successfully upload (such as in an airgapped environment).

.. versionchanged:: RELEASE.2022-12-12T19-27-27Z
   
   When writing the zip archive, MinIO also encrypts the zip index of file names included in the archive.

.. important::
   
   :mc:`mc support inspect` requires a MinIO deployment server from October 2021 or later. 

Wildcards
---------

The command supports wildcard ``*`` pattern matching for prefixes or objects when using the Bash shell.
For non-Bash shells, a message displays indicating that wildcard patterns are only supported in Bash.

.. code-block:: shell
   :class: copyable

   mc support inspect ALIAS/bucket/path/**/xl.meta
   
This command collects all ``xl.meta`` associated to objects at ``ALIAS/bucket/path/``.


Examples
--------

Download Metadata for an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can download the metadata for an object.
Metadata stores in an ``xl.meta`` binary file.

The following command downloads the ``xl.meta`` from ``mybucket/myobject`` on the ``minio1`` deployment.

The file downloads from all drives as a zip archive file.

.. code-block:: shell
   :class: copyable

   mc support inspect minio1/mybucket/myobject/xl.meta

The contents of the ``xl.meta`` file are not human readable.
You can convert the contents of an ``xl.meta`` file to JSON format.


Download All Objects at a Prefix Recursively
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command downloads all objects recursively found at a prefix.

.. caution::

   This can be an expensive operation.
   Proceed with caution.

.. code-block:: shell
   :class: copyable

   mc support inspect minio1/mybucket/myobject/**


Syntax
------
      
The command has the following syntax:

.. code-block:: shell

   mc [GLOBALFLAGS] support inspect       \
                            [--legacy]   \
                            TARGET

Parameters
~~~~~~~~~~

.. mc-cmd:: --legacy
   :optional:

   Use the older method of exporting inspection data, which does not encrypt data by default.
   
.. mc-cmd:: TARGET
   :required:

   The path to the location or object to inspect.
   The path should include the `alias <alias>` of the MinIO deployment and, if needed, the prefix and/or object name.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
