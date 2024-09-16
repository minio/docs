.. _minio-mc-admin-cluster-iam-export:

===============================
``mc admin cluster iam export``
===============================

.. default-domain:: minio

.. mc:: mc admin cluster iam export

Description
-----------

.. versionadded:: RELEASE.2022-06-26T18-51-48Z

.. start-mc-admin-cluster-iam-export-desc

The :mc:`mc admin cluster iam export` command exports :ref:`IAM <minio-authentication-and-identity-management>` metadata for use with the :mc:`mc admin cluster iam import` command.

.. end-mc-admin-cluster-iam-export-desc

The command saves the output as ``ALIAS-iam-metadata.zip``, where ``ALIAS`` is the :mc:`alias <mc admin cluster iam export ALIAS>` of the MinIO deployment.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command exports all IAM metadata for the ``myminio`` deployment.
  
      .. code-block:: shell  
         :class: copyable 
  
         mc admin cluster iam export myminio

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 
  
         mc [GLOBALFLAGS] admin cluster iam export ALIAS  \
                          [--output, -o <string>]
                                             
      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Starting with :mc-release:`RELEASE.2023-05-04T18-10-16Z`, :mc:`mc admin cluster iam export` adds support for aliases ending with a trailing forward slash ``ALIAS/``.
Prior to this release, the command would fail when provided a trailing forward slash.

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment to export IAM metadata for.


.. mc-cmd:: --output, --o
   :optional:

   Specify a custom file and path to use when exporting the IAM data.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Download all IAM metadata for a cluster to a ZIP file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command downloads all IAM metadata for the cluster at alias ``myminio``, then stores the metadata to a ZIP file.

.. code-block:: shell

   mc admin cluster iam export myminio

The ZIP file is named ``<alias>-iam-info.zip`` where ``<alias>`` is the alias of the cluster.
For the above example, the file is named ``myminio-iam-info.zip``.

The file is placed in the current active directory path.

Download all IAM metadata for a cluster and specify the name and path of the ZIP file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command downloads all IAM metadata for the cluster at alias ``myminio``, then stores the metadata to a ZIP file at ``/tmp/myminio-iam.zip``.

.. code-block:: shell

   mc admin cluster iam export myminio --output /tmp/myminio-iam.zip