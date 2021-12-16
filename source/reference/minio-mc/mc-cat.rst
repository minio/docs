.. _minio-mc-cat:

==========
``mc cat``
==========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc cat

.. Replacement substitutions

.. |command| replace:: :mc-cmd:`mc cat`
.. |rewind| replace:: :mc-cmd-option:`~mc cat rewind`
.. |versionid| replace:: :mc-cmd-option:`~mc cat version-id`
.. |alias| replace:: :mc-cmd-option:`~mc cat ALIAS`

Syntax
------

.. start-mc-cat-desc

The :mc:`mc cat` command concatenates the contents of a file or
object to another file or object. You can also use the command to
display the contents of the specified file or object to ``STDOUT``. 
:mc:`~mc cat` has similar functionality to ``cat``. 

.. end-mc-cat-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command concatenates the contents of an object on a 
      MinIO deployment to ``STDOUT``:

      .. code-block:: shell
         :class: copyable

         mc cat play/mybucket/myobject.txt

   .. tab-item:: SYNTAX

      The command command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] cat             \
                          [--rewind]      \
                          [--version-id]  \
                          [--encrypt-key] \
                          PATH

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


You can also use :mc:`mc cat` against a local filesystem to produce similar
results to the ``cat`` commandline tool:

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The :ref:`alias <alias>` of a MinIO or other S3-compatible
   service. 

.. mc-cmd:: PATH

   *Required* The full path to an object on the specified alias.

.. mc-cmd:: rewind
   :option:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: version-id, vid
   :option:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

.. mc-cmd:: encrypt-key
   :option:

   Encrypt or decrypt objects using server-side encryption with
   client-specified keys. Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting 
      object(s).

   Enclose the entire list of key-value pairs passed to 
   :mc-cmd-option:`~mc cat encrypt-key` in double quotes ``"``.

   :mc-cmd-option:`~mc cat encrypt-key` can use the ``MC_ENCRYPT_KEY``
   environment variable for retrieving a list of encryption key-value pairs
   as an alternative to specifying them on the command line.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

View an S3 Object
~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cat` to return the object:

.. code-block:: shell
   :class: copyable

   mc cat ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc cat ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc cat ALIAS>` with the path to the object on the
  S3-compatible host.

View an S3 Object at a Point-In-Time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd-option:`mc cat rewind` to return the object at a specific
point-in-time in the past:

.. code-block:: shell
   :class: copyable

   mc cat ALIAS/PATH --rewind DURATION

- Replace :mc-cmd:`ALIAS <mc cat ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc cat ALIAS>` with the path to the object on the
  S3-compatible host.

- Replace :mc-cmd:`DURATION <mc cat rewind>` with the point-in-time in the past
  at which the command returns the object. For example, specify ``30d`` to
  return the version of the object 30 days prior to the current date.

.. include:: /includes/facts-versioning.rst
   :start-after: start-versioning-admonition
   :end-before: end-versioning-admonition

View an S3 Object with Specific Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd-option:`mc cat version-id` to return a specific version of the 
object:

.. code-block:: shell

   mc cat ALIAS/PATH --version-id VERSION

- Replace :mc-cmd:`ALIAS <mc cat ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc cat ALIAS>` with the path to the object on the
  S3-compatible host.

- Replace :mc-cmd:`VERSION <mc cat version-id>` with the specific version of the
  object to return.

.. include:: /includes/facts-versioning.rst
   :start-after: start-versioning-admonition
   :end-before: end-versioning-admonition

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
