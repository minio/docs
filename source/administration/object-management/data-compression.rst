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


- Streaming data compression, transparent to the client

  - MinIO supports streaming data compression. Objects are compressed before they are written to disk, and uncompressed when read. Compression and decompression are transparent to the client, requests function as expected.

- Global setting: enable for all buckets and objects

  - Enabling/disabling affects newly created objects, not existing ones

- Default included/excluded file types

  - MinIO never tries to compress certain types of files
  - This data can't be made significantly smaller

    - ``gz``, ``bz2``, ``rar``, ``zip``, ``7z``, ``xz``, ``mp4``, ``mkv``, ``mov``
    - ``video/*``, ``audio/*``, ``application/zip``, ``application/x-gzip``, ``application/x-bz2``, ``application/x-compress``, ``application/x-xz``

Enabling and disabling data compression

- With mc

  - mc admin config get myminio compression
  - mc admin config set myminio compression enable="on"
  - mc admin config set myminio compression extensions="foo" mime_types="bar"
  - mc admin config set myminio compression allow_encryption=on

- With environment variables

  - MINIO_COMPRESSION_ENABLE
  - MINIO_COMPRESSION_EXTENSIONS
  - MINIO_COMPRESSION_MIME_TYPES
  - MINIO_COMPRESSION_ALLOW_ENCRYPTION

	
Data Compression and Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Rarely required and not recommended
- Encrypting a compressed object leaks information about its contents
- Compressing an encrypted object is not effective
- Link to blog post?


Tutorials
---------

Enable Data Compression
~~~~~~~~~~~~~~~~~~~~~~~

To enable data compression, use :mc-cmd:`mc admin config set` to toggle the :mc-conf:`compression` key :mc-conf:`~compression.enable` option to ``on``:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression enable=on

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

This example enables compression for new objects of the default file extensions and media types.
Existing uncompressed objects are not modified.

To configure a different set extensions and types, see [link].


Disable Data Compression
~~~~~~~~~~~~~~~~~~~~~~~~

To disable data compression, use :mc-cmd:`mc admin config set` to toggle the :mc-conf:`compression` key :mc-conf:`~compression.enable` option to ``off``:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression enable=off

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

  New objects are stored uncompressed.
  Existing compressed objects are not modified.


Configure the Objects to Compress
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Configure which objects to compress by specifying the desired file extensions or media types in :mc-conf:`~compression.extensions` or :mc-conf:`~compression.mime_types` arguments.

.. admonition:: Default excluded extensions and types are never compressed
   :class: note

   Some objects cannot be efficiently compressed due to the randomness of their contents.
   MinIO will not attempt to compress these objects, even if they are specified in :mc-conf:`~compression.extensions` or :mc-conf:`~compression.mime_types` arguments.
   See [something] for a list of common uncompressible file extensions and media types.

Compress All Compressible Objects
+++++++++++++++++++++++++++++++++

To compress all objects except the default excluded ones, use :mc-cmd:`mc admin config set` to set the :mc-conf:`compression` key :mc-conf:`~compression.extensions` and :mc-conf:`~compression.mime_types` options to empty lists.

The following command compresses all objects, except the default uncompressible objects:

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

   mc admin config set ALIAS compression extensions=".bin,.txt"

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

The new list of file extensions replaces the previous list.
To add or remove an extension, repeat the :mc-conf:`~compression.extensions` command with the complete list of extensions to compress.

The following command adds ``.pdf`` to the list of file extensions from the previous example:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression extensions=".bin,.txt,.pdf"

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.


Compress Objects by Media Type
++++++++++++++++++++++++++++++

To compress objects of certain types, use :mc-cmd:`mc admin config set` to set the :mc-conf:`compression` key :mc-conf:`~compression.mime_types` option to a list of the desired types.

The following example compresses files of types ``application/json`` and ``image/png``:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression mime_types="application/json,image/png"

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.

The new list of media types replaces the previous list.
To add or remove a type, repeat the :mc-conf:`~compression.mime_types` command with the complete list of types to compress.

You can use ``*`` to specify all subtypes of a single media type.
The following command adds all text subtypes to the list from the previous example:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS compression mime_types="application/json,image/png,text/*"

- Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured MinIO deployment.
