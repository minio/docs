.. _minio-mc-replicate-rm:

===================
``mc replicate rm``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc replicate remove
.. mc:: mc replicate rm

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z 

   ``mc replicate rm`` replaces the ``mc admin bucket remote rm`` command.
   Removing the replication automatically removes the underlying remote target.

Syntax
------

.. start-mc-replicate-rm-desc

The :mc:`mc replicate rm` command removes a 
:ref:`replication rule <minio-bucket-replication-serverside>` from a 
MinIO bucket.

.. end-mc-replicate-rm-desc

The :mc:`mc replicate remove` command has equivalent functionality to :mc:`mc replicate rm`.

.. code-block:: shell

   mc [GLOBALFLAGS] replicate rm FLAGS [FLAGS] ALIAS

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes the replication rule with specified
      id from the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc replicate rm --id "c76um9h4b0t1ijr36mug" myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] replicate rm     \
                          --id "string"    \
                          [--all --force]  \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* the :ref:`alias <alias>` of the MinIO deployment and full path to
   the bucket or bucket prefix from which to remove the replication rule. For
   example:

   .. code-block:: none

      mc replicate rm --id "ID" myminio/mybucket


.. mc-cmd:: --id
   

   *Required* Specify the unique ID for a configured replication rule.

   You can omit this option if specifying :mc-cmd:`~mc replicate rm --all`

.. mc-cmd:: --all
   

   *Optional* Removes all replication rules on the specified bucket. Requires
   specifying the :mc-cmd:`~mc replicate rm --force` flag.

.. mc-cmd:: --force
   

   *Optional* Required if specifying :mc-cmd:`~mc replicate rm --all` .


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Remove a Replication Rule from a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc replicate rm` to remote a bucket replication rule:

.. code-block:: shell
   :class: copyable

   mc replicate rm --id "ID" ALIAS/PATH

- Replace :mc-cmd:`ID <mc replicate rm --id>` with the unique ID of the
  replication rule to remove. Use :mc:`mc replicate ls` to list all
  replication rules for the bucket.

- Replace :mc-cmd:`ALIAS <mc replicate rm ALIAS>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate rm ALIAS>` with the path to the 
  bucket or bucket prefix.

Remove All Replication Rules from a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc replicate rm` to list bucket replication rules:

.. code-block:: shell
   :class: copyable

   mc replicate rm --all --force ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc replicate rm ALIAS>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate rm ALIAS>` with the path to the 
  bucket or bucket prefix.

Behavior
--------

Removing Replication Rules Does Not Affect Replicated Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Removing one or all replication rule for a bucket does *not* 
remove any objects already replicated under those rule(s).

Use The command or :mc:`mc rb` commands to remove replicated
objects on the remote target. You can identify replicated objects using
the ``X-Amz-Replication-Status`` metadata field where the value is
``REPLICA``. Buckets which contain objects from multiple replication sources
may require additional care and filtering to determine the source prior
to removal.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
