.. _minio-mc-ilm-export:

=================
``mc ilm export``
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm export

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z

   ``mc ilm export`` replaced by :mc-cmd:`mc ilm rule export`.


Syntax
------

.. start-mc-ilm-export-desc

The :mc:`mc ilm export` command exports the object lifecycle management
configuration for a MinIO bucket.

.. end-mc-ilm-export-desc

The :mc:`mc ilm export` command outputs to ``STDOUT`` by default. You can
output the contents to a ``.json`` file for archival or ingestion using
:mc:`mc ilm import`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command exports the lifecycle management configuration
      of the ``mydata`` bucket on the ``myminio`` deployment to the
      ``mydata-lifecycle-config.json`` file:

      .. code-block:: shell
         :class: copyable

         mc ilm export myminio/mydata > mydata-lifecycle-config.json

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] ilm export ALIAS > STDOUT

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   
   *Required* The :ref:`alias <alias>` and full path to the bucket on the MinIO
   deployment for which to export object lifecycle management rules. For
   example:

   .. code-block:: none

      mc ilm export myminio/mydata > bucket-lifecycle.json

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Export the Bucket Lifecycle Management Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Example

      The following command exports the bucket lifecycle management
      configuration to the ``bucket-lifecycle.json`` file:

      .. code-block:: shell
         :class: copyable

         mc ilm export myminio/mybucket > bucket-lifecycle.json

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable

         mc ilm export ALIAS > file.json

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO 
        deployment and the bucket for which to export object lifecycle
        management rules:

        ``myminio/mydata``

      - Replace ``file.json`` with the name of the file to which to export the
        lifecycle management rules.


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
