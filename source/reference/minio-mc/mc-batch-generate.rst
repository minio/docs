.. _minio-mc-batch-generate:

=====================
``mc batch generate``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc batch generate

.. versionchanged:: MinIO RELEASE.2022-10-08T20-11-00Z or later

Syntax
------

.. start-mc-batch-generate-desc

The :mc:`mc batch generate` command creates a basic YAML-formatted template file for the specified job type.

.. end-mc-batch-generate-desc

After MinIO creates the file, open it in your preferred text editor tool to further customize.
You can define one job task definition per batch file.

See :ref:`job types <minio-batch-job-types>` for the supported jobs you can generate.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command creates a basic YAML file for a replicate job on the ``mybucket`` bucket of the ``myminio`` alias.

      .. code-block:: shell
         :class: copyable

         mc batch generate myminio replicate

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] batch generate \
                                ALIAS   \
                                JOBTYPE

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:
   
   The :ref:`alias <alias>` used to generate the YAML template file.
   The specified ``alias`` does not restrict the deployment(s) where you can use the generated file.
   
   For example:

   .. code-block:: none

      mc batch generate myminio replicate

.. mc-cmd:: JOBTYPE
   :required:
   
   The type of job to generate a YAML document for.
   
   Supports the following values:
   
   - :ref:`minio-mc-batch-generate-replicate-job`
   - :ref:`minio-mc-batch-generate-keyrotate-job`
   - :ref:`minio-mc-batch-generate-expire-job` (Added ``mc.RELEASE.2023-12-02T11-24-10Z``)

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Generate a ``yaml`` File for a Replicate Job Type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command generates a YAML blueprint for a replicate type batch job and names the file ``replicate`` with the ``.yaml`` extension:

.. code-block:: shell
   :class: copyable

   mc batch generate alias replicate > replicate.yaml

- Replace ``alias`` with the :mc:`alias <mc alias>` to use to generate the yaml file.

- Replace ``replicate`` with the type of job to generate a yaml file for.
 
  :mc:``mc batch`` supports the ``replicate`` and ``keyrotate`` job types. 


S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

.. _minio-batch-job-types:

Job Types
---------

:mc:`mc batch` currently supports the following job task types:

- :ref:`minio-mc-batch-generate-replicate-job`
  
  Replicate objects between two MinIO deployments.
  Provides similar functionality to :ref:`bucket replication <minio-bucket-replication>` as a batch job rather than continual scanning function.

- :ref:`minio-mc-batch-generate-keyrotate-job`

  .. versionadded:: MinIO RELEASE.2023-04-07T05-28-58Z 
  
  Rotate the sse-s3 or sse-kms keys for objects at rest on a MinIO deployment.

- :ref:`minio-mc-batch-generate-expire-job`

  .. versionadded:: MinIO RELEASE.2023-12-02T10-51-33Z

  Expire objects based using similar semantics as :ref:`minio-lifecycle-management-create-expiry-rule`.

.. _minio-mc-batch-generate-replicate-job:

``replicate``
~~~~~~~~~~~~~

You can use the following example configuration as the starting point for building your own custom replication batch job:

.. literalinclude:: /includes/code/replicate.yaml
   :language: yaml

See :ref:`minio-batch-framework-replicate-job-ref` for more complete documentation on each key.

.. _minio-mc-batch-generate-keyrotate-job:

``keyrotate``
~~~~~~~~~~~~~

You can use the following example configuration as the starting point for building your own custom key rotation batch job:

.. literalinclude:: /includes/code/keyrotate.yaml
   :language: yaml

See :ref:`minio-batch-framework-keyrotate-job-ref` for more complete documentation on each key.

.. _minio-mc-batch-generate-expire-job:

``expire``
~~~~~~~~~~

You can use the following example configuration as a starting point for building your own custom expiration batch job:

.. literalinclude:: /includes/code/keyrotate.yaml
   :language: yaml

See :ref:`minio-batch-framework-expire-job-ref` for more complete documentation on each key.