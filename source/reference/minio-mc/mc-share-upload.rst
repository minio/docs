===================
``mc share upload``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc share upload

Syntax
-----------

.. start-mc-share-upload-desc

The :mc:`mc share upload` command generates a temporary presigned URL with
integrated access credentials for uploading objects to a MinIO bucket. The
temporary URL expires after a configurable time limit.

.. end-mc-share-upload-desc

Applications can perform a ``PUT`` to upload an object using the URL. 

For more information on shareable object URLs, see the Amazon S3 
documentation on :aws-docs:`Pre-Signed URLs 
<AmazonS3/latest/dev/ShareObjectPreSignedURL.html>`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command generates a new presigned upload URL for the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc share upload --recursive myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] share upload         \
                          [--expire "string"]  \
                          [--recursive]        \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The :ref:`alias <alias>` of a MinIO deplyment and the full path to
   the object for which to generate an upload URL. For example:

   .. code-block:: shell

      mc share upload play/mybucket/object.txt

   You can specify multiple objects on the same or different MinIO deployments.
   For example:

   .. code-block:: shell

      mc share upload play/mybucket/object.txt play/mybucket/otherobject.txt

   If specifying the path to a bucket or bucket prefix, you **must** also
   specify the :mc-cmd:`~mc share upload --recursive` argument. For
   example:

   .. code-block:: shell

      mc share upload --recursive play/mybucket/

      mc share upload --recursive play/mybucket/myprefix/

.. mc-cmd:: --expire, E
   

   *Optional* Set the expiration time limit for all generated URLs.
   
   Specify a string with format ``##h##m##s`` format. For example:
   ``12h34m56s`` for an expiry of 12 hours, 34 minutes, and 56 seconds
   after URL generation.

   Defaults to ``168h`` or 168 hours (7 days).

.. mc-cmd:: --recursive, r
   
   
   *Optional* Modifies the CURL URL to support uploading objects to a bucket or
   bucket prefix. Required if any ``ALIAS`` specifies a path to a bucket or
   bucket prefix. The modified CURL output resembles the following:

   .. code-block:: shell

      curl ... -F key=<NAME> -F file=@<FILE>

   Replace ``<FILE>`` with the path to the file to upload.

   Replace ``<NAME>`` with the object name once uploaded.  
   This may include :term:`prefixes <prefix>`.
      
Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Generate a URL to Upload Object(s)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Upload Single Object

      Use :mc:`mc share upload` to generate a URL that supports
      ``POST`` requests for uploading a file to a specific object location
      on a MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc share upload --expire DURATION ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc share upload ALIAS>` with the 
        :ref:`alias <alias>` of the MinIO deployment.

      - Replace :mc-cmd:`PATH <mc share upload ALIAS>` with the path to the
        object on the MinIO deployment.

      - Replace :mc-cmd:`DURATION <mc share upload --expire>` with the duration
        after which the URL expires. For example, to set a 30 day expiry, 
        specify ``30d``.

   .. tab-item:: Upload Multiple Objects

      Use :mc:`mc share upload` with the
      :mc-cmd:`~mc share upload --recursive` and
      :mc-cmd:`~mc share upload --expire` options to generate a temporary URL
      that supports ``POST`` requests for uploading files to a bucket on a MinIO
      deployment:

      .. code-block:: shell
         :class: copyable

         mc share upload --recursive --expire DURATION ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc share upload ALIAS>` with the 
        :ref:`alias <alias>` of the MinIO deployment.

      - Replace :mc-cmd:`PATH <mc share upload ALIAS>` with the path to the
        bucket or bucket prefix on the MinIO deployment.

      - Replace :mc-cmd:`DURATION <mc share upload --expire>` with the duration
        after which the URL expires. For example, to set a 30 day expiry, 
        specify ``30d``.

      The command returns a CURL command for uploading an object to the
      specified bucket prefix. 

      - Replace the ``<FILE>`` string in the returned CURL command with the path
        to the file to upload. 
      
      - Replace the ``<NAME>`` string in the returned CURL command with the name
        of the object in the bucket.  
        This may include :term:`prefixes <prefix>`.

      You can use a shell script loop to recursively upload the contents of a
      filesystem directory to the S3-compatible service:

      .. code-block:: shell

         #!/bin/sh

         for file in ~/Documents/photos/
         do
            curl https://play.min.io/mybucket/ \
            -F policy=AAAAA -F x-amz-algorithm=AWS4-HMAC-SHA256 \
            -F x-amz-credential=AAAA/us-east-1/s3/aws4_request \
            -F x-amz-date=20200812T202556Z \
            -F x-amz-signature=AAAA \
            -F bucket=mybucket -F key=photos/${file} -F file=@${file}

         done

      This example will upload each file in the directory ``~/Documents/photos/`` to
      the ``mybucket`` bucket under the prefix ``photos``.  Defer to the documented 
      best practices for your preferred scripting language for iterating through 
      files in a directory.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
