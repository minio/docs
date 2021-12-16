=========
``mc rb``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc rb

Syntax
------

.. start-mc-rb-desc

The :mc:`mc rb` command removes one or more buckets on MinIO *or*
another S3-compatible service.

To remove only the contents of a bucket, use :mc:`mc rm` instead.

.. end-mc-rb-desc

.. important::

   :mc:`mc rb` *permanently deletes bucket(s)* on the target deployment,
   including any and all :ref:`object versions <minio-bucket-versioning>`
   and bucket configurations such as 
   :ref:`lifecycle management <minio-lifecycle-management>` or
   :ref:`replication <minio-bucket-replication-serverside>`.

You can also use :mc:`mc rb` against the local filesystem to produce
similar results to the ``rm --rf`` commandline tool.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes the ``mydata`` bucket on the 
      ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc rb --force myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] rb             \
                          --force        \
                          [--dangerous]  \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The :ref:`alias <alias>` of a MinIO or other S3-compatible
   service and the full path to the bucket to remove. For example:

   .. code-block:: none

      mc rb --force myminio/mydata

   Omit the bucket path to perform a site-wide removal of buckets on the MinIO
   deployment. This operation *requires* specifying 
   :mc-cmd-option:`~mc rb dangerous` to explicitly acknowledge the permanent
   removal of *all* data on the deployment. For example:

   .. code-block:: none

      mc rb --force --dangerous myminio

   For removing a directory and its contents on a local filesystem, specify
   the full path to that directory. The 
   :mc-cmd-option:`~mc rb force` flag is ignored if specified. For example:

   .. code-block:: none

      mc rb ~/data/myolddata


.. mc-cmd:: force
   :option:

   *Required* Safety flag to confirm removal of the bucket contents.

.. mc-cmd:: dangerous
   :option:

   *Optional* Directs :mc:`mc rb` to perform a site-wide removal of all
   buckets on each specified :mc-cmd:`~mc rb ALIAS` (e.g. ``myminio/``).

   If any ``ALIAS`` specifies a filesystem directory, this option
   results in the removal of all subdirectories and files at that directory
   path similar to ``rm --rf``.

   .. warning::

      Running :mc-cmd-option:`mc rb dangerous` is irreversible. Exercise all
      possible due diligence in ensuring the command applies to only the 
      desired ``ALIAS`` targets prior to execution.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Example
-------

Remove a Bucket
~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc rb --force ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc rb ALIAS>` with the :mc-cmd:`alias <mc alias>` of
  a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc rb ALIAS>` with the path to the bucket to remove.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
