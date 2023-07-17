.. _minio-data-compression:

================
Data Compression
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


Overview
--------

MinIO Server supports compressing objects to reduce disk usage.
Objects are compressed on PUT before writing to disk, and uncompressed on GET before they are sent to the client. This makes the compression process transparent to client applications and services.

Depending on the type of data, compression may also increase overall throughput.
Write throughput for a production deployment is generally 500MB per second or greater per available CPU core in the system.
Decompression is approximately 1 GB per second or greater for each CPU core.

For best results, review MinIO's :ref:`recommended hardware configuration <deploy-minio-distributed-recommendations>` or use |subnet| to work directly with engineers for analyzing compression performance.

.. _minio-data-compression-default-types:

Default File Types
~~~~~~~~~~~~~~~~~~

Data compression is a global option, the configured settings apply to all buckets in a deployment.
Enabling data compression compresses the following types of data by default:

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-data-compression-default-desc
   :end-before: end-minio-data-compression-default-desc

You can control which objects are compressed by specifying the desired file extensions and `media (MIME) types <https://en.wikipedia.org/wiki/Media_type>`__.

.. admonition:: Existing objects are not modified
   :class: note

   Enabling, disabling, or updating a deployment's compression settings does not modify existing objects.
   New objects are compressed according to the settings in effect at the time they are created.

.. _minio-data-compression-excluded-types:

Excluded File Types
~~~~~~~~~~~~~~~~~~~

Some data cannot be effectively compressed, such as video or already compressed data.
MinIO does not compress common incompressible file types, even if they are specified in the compression configuration.

Objects of these types are never compressed:

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-data-compression-default-excluded-desc
   :end-before: end-minio-data-compression-default-excluded-desc


Data Compression and Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports encrypting compressed objects but recommends against combining compression and encryption without a prior risk assessment.
Before enabling encryption for compressed objects, carefully consider the security needs of your environment.

See `Transparent Data Compression on MinIO <https://blog.min.io/transparent-data-compression/>`__ for more about combining compression and encryption.
|subnet| users can `log in <https://subnet.min.io/?ref=docs>`__ and engage with our engineering and security teams to review encryption options.


Tutorials
---------

Enable Data Compression
~~~~~~~~~~~~~~~~~~~~~~~

To enable data compression, use :mc-cmd:`mc admin config set` to set the :mc-conf:`compression` key :mc-conf:`~compression.enable` option to ``on``.

The following enables compression for new objects of the :ref:`default types <minio-data-compression-default-types>`:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression enable=on

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

Existing uncompressed objects are not modified.
To configure which extensions and types to compress, see :ref:`minio-data-compression-configure-objects`.

To view the current compression settings:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression


Disable Data Compression
~~~~~~~~~~~~~~~~~~~~~~~~

To disable data compression, use :mc-cmd:`mc admin config set` to set the :mc-conf:`compression` key :mc-conf:`~compression.enable` option to ``off``:

The following disables data compression for new objects:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression enable=off

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

Existing compressed objects are not modified.

.. _minio-data-compression-configure-objects:

Configure Which Objects to Compress
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Configure the objects to compress by specifying the desired file extensions and media types in :mc-conf:`~compression.extensions` or :mc-conf:`~compression.mime_types` arguments.

The default data compression configuration compresses the following types of data:

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-data-compression-default-desc
   :end-before: end-minio-data-compression-default-desc

.. admonition:: Default excluded extensions and types are never compressed
   :class: note

   Some objects cannot be efficiently compressed.
   MinIO will not attempt to compress these objects, even if they are specified in :mc-conf:`~compression.extensions` or :mc-conf:`~compression.mime_types` arguments.
   See :ref:`minio-data-compression-excluded-types` for a list of excluded types.

The sections below describe how to configure compression for the desired file extensions and media types.

Compress All Compressible Objects
+++++++++++++++++++++++++++++++++

To compress all objects except the :ref:`default excluded types <minio-data-compression-excluded-types>`, use :mc-cmd:`mc admin config set` to set the :mc-conf:`compression` key :mc-conf:`~compression.extensions` and :mc-conf:`~compression.mime_types` options to empty lists:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression extensions= mime_types=

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

  
Compress Objects by File Extension
++++++++++++++++++++++++++++++++++

To compress objects with certain file extensions, use :mc-cmd:`mc admin config set` to set the desired file extensions in an :mc-conf:`~compression.extensions` argument.

The following command compresses files with the extensions ``.bin`` and ``.txt``:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression extensions=".bin, .txt"

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

The new list of file extensions replaces the previous list.
To add or remove an extension, repeat the :mc-conf:`~compression.extensions` command with the complete list of extensions to compress.

The following adds ``.pdf`` to the list of file extensions from the previous example:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression extensions=".bin, .txt, .pdf"

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.


Compress Objects by Media Type
++++++++++++++++++++++++++++++

To compress objects of certain media types, use :mc-cmd:`mc admin config set` to set the :mc-conf:`compression` key :mc-conf:`~compression.mime_types` option to a list of the desired types.

The following example compresses files of types ``application/json`` and ``image/bmp``:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression mime_types="application/json, image/bmp"

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

The new list of media types replaces the previous list.
To add or remove a type, repeat the :mc-conf:`~compression.mime_types` command with the complete list of types to compress.

You can use ``*`` to specify all subtypes of a single media type.
The following command adds all ``text`` subtypes to the list from the previous example:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression mime_types="application/json, image/bmp, text/*"

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.
