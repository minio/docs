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
Objects are compressed before they are written to disk and uncompressed when read, making the compression process transparent to client applications and services.

Depending on the type of data, compression may also increase overall throughput.
Write throughput for compressible data is generally 500MB per second or greater per available CPU.
Decompression is typically at least 1 GB per second.

Data compression is a global option, configured settings apply to all buckets in a deployment.
You can control which objects are compressed by specifying the desired file extensions and media types.

.. admonition:: Existing objects are not modified
   :class: note

   Enabling, disabling, or updating a deployment's compression settings does not modify existing objects.
   New objects are compressed according to the settings in effect at the time they are created.


Incompressible Data
~~~~~~~~~~~~~~~~~~~

Some types of objects cannot be effectively compressed, such as video or already compressed data.
MinIO does not compress common incompressible file types, even if they are specified in the compression configuration.

Objects of these types are never compressed:

File extensions

- ``gz``, ``bz2``, ``rar``, ``zip``, ``7z``, ``xz``, ``mp4``, ``mkv``, ``mov``

Media types
- ``video/*``, ``audio/*``, ``application/zip``, ``application/x-gzip``, ``application/x-bz2``, ``application/x-compress``, ``application/x-xz``

	
Data Compression and Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports encrypting compressed objects but recommends against encryption for most deployments.
An important concern is a 3rd party may be able to learn details of an object's contents by comparing the uncompressed and compressed file sizes.

Before enabling encryption for compressed objects, carefully consider the security needs of your environment.
|subnet| users can `log in <https://subnet.min.io/?ref=docs>`__ and engage with our engineering and security teams to review encryption options.


Tutorials
---------

Enable Data Compression
~~~~~~~~~~~~~~~~~~~~~~~

To enable data compression, use :mc-cmd:`mc admin config set` to set the :mc-conf:`compression` key :mc-conf:`~compression.enable` option to ``on``.

The following enables compression for new objects of the default types:

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

By default, MinIO compresses the following extensions and types:

* File extensions: ``.txt``, ``.log``, ``.csv``, ``.json``, ``.tar``, ``.xml``, ``.bin``
* Media types: ``text/*``, ``application/json``, ``application/xml``, ``binary/octet-stream``

.. admonition:: Default excluded extensions and types are never compressed
   :class: note

   Some objects cannot be efficiently compressed.
   MinIO will not attempt to compress these objects, even if they are specified in :mc-conf:`~compression.extensions` or :mc-conf:`~compression.mime_types` arguments.

The sections below describe how to configure compression for the desired file extensions and media types.

Compress All Compressible Objects
+++++++++++++++++++++++++++++++++

To compress all objects except the default excluded ones, use :mc-cmd:`mc admin config set` to set the :mc-conf:`compression` key :mc-conf:`~compression.extensions` and :mc-conf:`~compression.mime_types` options to empty lists.

The following compresses all objects, except the default incompressible objects:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression extensions= mime_types=

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

  
Compress Objects by File Extension
++++++++++++++++++++++++++++++++++

To compress objects with certain file extensions, use :mc-cmd:`mc admin config set` to set the :mc-conf:`compression` key :mc-conf:`~compression.extensions` option to a list of the desired file extensions.

The following command compresses files with the extensions ``.bin`` and ``.txt``:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression extensions=".bin, .txt"

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

The new list of file extensions replaces the previous list.
To add or remove an extension, repeat the :mc-conf:`~compression.extensions` command with the complete list of extensions to compress.

The following command adds ``.pdf`` to the list of file extensions from the previous example:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression extensions=".bin, .txt, .pdf"

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.


Compress Objects by Media Type
++++++++++++++++++++++++++++++

To compress objects of certain types, use :mc-cmd:`mc admin config set` to set the :mc-conf:`compression` key :mc-conf:`~compression.mime_types` option to a list of the desired types.

The following example compresses files of types ``application/json`` and ``image/png``:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression mime_types="application/json, image/png"

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

The new list of media types replaces the previous list.
To add or remove a type, repeat the :mc-conf:`~compression.mime_types` command with the complete list of types to compress.

You can use ``*`` to specify all subtypes of a single media type.
The following command adds all text subtypes to the list from the previous example:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression mime_types="application/json, image/png, text/*"

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.
