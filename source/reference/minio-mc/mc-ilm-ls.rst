.. _minio-mc-ilm-ls:

=============
``mc ilm ls``
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm ls

Syntax
------

.. start-mc-ilm-ls-desc

The :mc:`mc ilm ls` command lists all configured object lifecycle management 
rules on a MinIO bucket.

.. end-mc-ilm-ls-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command lists all lifecycle management rules for the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc ilm ls myminio/mydata

   .. tab-item:: SYNTAX

      The :mc-cmd:`mc ilm ls` command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] ilm ls                        \
                          [--expiry | --transition]     \

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   
   *Required* The :ref:`alias <alias>` and full path to the bucket on the MinIO
   deployment for which to list the object lifecycle management rules. For
   example:

   .. code-block:: none

      mc ilm ls myminio/mydata


.. mc-cmd:: --expiry
   

   *Optional* :mc-cmd:`mc ilm ls` returns only fields related to lifecycle rule
   expiration.

   Mutually exclusive with :mc-cmd:`~mc ilm ls --transition`.

.. mc-cmd:: --transition
   

   *Optional* :mc-cmd:`mc ilm ls` returns only fields related to lifecycle rule
   transition.

   Mutually exclusive with :mc-cmd:`~mc ilm ls --expiry`.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

List Bucket Lifecycle Management Rules
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc ilm ls` to list a bucket's lifecycle management rules:

.. code-block:: shell
   :class: copyable

   mc ilm ls ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc ilm ls ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm ls ALIAS>` with the path to the bucket on the
  S3-compatible host.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
