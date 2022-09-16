===================
``mc share list``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc share list

Syntax
-----------

.. start-mc-share-upload-desc

The :mc:`mc share list` command displays any unexpired presigned URLs generated
by :mc:`mc share upload` or :mc:`mc share download`

.. end-mc-share-upload-desc

Applications can perform a ``PUT`` to retrieve the object from the URL. 

For more information on shareable object URLs, see the Amazon S3 
documentation on :aws-docs:`Pre-Signed URLs 
<AmazonS3/latest/dev/ShareObjectPreSignedURL.html>`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command lists all upload and download presigned URLs
      respectively for the ``mydata`` bucket on the ``myminio`` MinIO
      deployment:

      .. code-block:: shell
         :class: copyable

         mc share list upload myminio/mydata
         mc share list download myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] share list           \
                          [download | upload]  \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: download

   *Required* Lists all unexpired presigned download (``GET``) URLs.

   Mutually exclusive with :mc:`mc share list upload`

.. mc-cmd:: upload

   *Required* Lists all unexpired presigned upload (``PUT``) URLs.

   Mutually exclusive with :mc:`mc share list download`

.. mc-cmd:: ALIAS

   *Required* The :ref:`alias <alias>` of a MinIO deplyment and the full path to
   the object for which to list unexpired presigned URLs. 



Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

List Generated Download and Upload URLs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: List Active Download Presigned URLs

      Use :mc:`mc share list download` to generate a URL
      that supports ``POST`` requests for uploading a file to a specific object
      location on an S3-compatible host:

      .. code-block:: shell
         :class: copyable

         mc share list download ALIAS

      - Replace :mc-cmd:`ALIAS <mc share list ALIAS>` with the 
        :ref:`alias <alias>` of the MinIO deployment.

   .. tab-item:: List Active Upload Presigned URLs

      Use :mc:`mc share list upload` to generate a URL that
      supports ``POST`` requests for uploading a file to a specific object
      location on an S3-compatible host:

      .. code-block:: shell
         :class: copyable

         mc share list upload ALIAS

      - Replace :mc-cmd:`ALIAS <mc share upload ALIAS>` with the 
        :ref:`alias <alias>` of the MinIO deployment.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
