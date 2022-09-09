======================
``mc support inspect``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support inspect

Description
-----------

The :mc:`mc support inspect` command collects the data and metadata associated to objects at the specified path.
MinIO assembles this data from each backend drive storing an :ref:`erasure shard <minio-erasure-coding>` for each specified object.

The command produces a zip file that includes all matching files with their respective *host+drive+path*. 

You can export the contents to a JSON output for further analysis.

The resulting report is intended for use by MinIO Engineering via |SUBNET| and may contain internal or private data points associated to the object.
Exercise caution before sending a report to a third party or posting the report in a public forum.

.. important::
   
   :mc:`mc support inspect` requires a MinIO deployment server from October 2021 or later. 

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Wildcards
---------

The command suports wildcard ``*`` pattern matching for prefixes or objects. 

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

The folloing command downloads the ``xl.meta`` from ``mybucket/myobject`` on the ``minio1`` deployment.

The file downloads from all drives as a zip archive file.

.. code-block:: shell
   :class: copyable

   mc support inspect minio1/mybucket/myobject/xl.meta

The contents of the ``xl.meta`` file are not human readable.
You can convert the contents of an ``xl.meta`` file to JSON format.

Download All Parts of an Object as an Encrypted Zip
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command downloads all of the constituent parts of an object with the following details:

- MinIO deployment alias: ``minio1``
- Bucket: ``mybucket``
- Object: ``myobject``

The file downloads as an encrypted zip file.

.. code-block:: shell
   :class: copyable

   mc support inspect --encrypt minio1/mybucket/myobject*/*/part.*

You can decrypt the resulting zip file with the :ref:`decryption tool <minio-support-decryption>`

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
                            [--encrypt]   \
                            [--export]    \
                            ALIAS

Parameters
~~~~~~~~~~

.. mc-cmd:: --encrypt
   :optional:

   Encrypt contents with a one-time key for confidential data.
   
.. mc-cmd:: --export
   :optional:

   Export inspect data as JSON or data JSON from ``xl.meta``.

   Use ``--export <value>``, replacing ``<value>`` with either ``json`` or ``djson`` as the output type.

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
