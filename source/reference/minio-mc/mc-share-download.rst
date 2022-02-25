=====================
``mc share download``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc share download

.. |command| replace:: :mc-cmd:`mc share download`
.. |versionid| replace:: :mc-cmd:`~mc share download version-id`
.. |alias| replace:: :mc-cmd:`~mc share download ALIAS`

Syntax
------

.. start-mc-share-download-desc

The :mc:`mc share download` command generates a temporary presigned URL with
integrated access credentials for downloading objects from a MinIO bucket. The
temporary URL expires after a configurable time limit.

.. end-mc-share-download-desc

- Applications can perform a ``GET`` to retrieve the object from the URL. 
- Users can open the URL in a browser to download the object.

For more information on shareable object URLs, see the Amazon S3 
documentation on :aws-docs:`Pre-Signed URLs 
<AmazonS3/latest/dev/ShareObjectPreSignedURL.html>`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command generates a new presigned download URL for the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc share download --recursive myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] share upload             \
                          [--expire "string"]      \
                          [--recursive]            \
                          [--version-id "string"]  \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The :ref:`alias <alias>` of a MinIO deplyment and the full path to
   the object for which to generate a download URL. For example:

   .. code-block:: shell

      mc share download play/mybucket/object.txt

   You can specify multiple objects on the same or different MinIO deployments.
   For example:

   .. code-block:: shell

      mc share download play/mybucket/object.txt play/mybucket/otherobject.txt

   If specifying the path to a bucket or bucket prefix, you **must** also
   specify the :mc-cmd:`~mc share download --recursive` argument. For
   example:

   .. code-block:: shell

      mc share download --recursive play/mybucket/

      mc share download --recursive play/mybucket/myprefix/

.. mc-cmd:: --expire, E
   

   *Optional* Set the expiration time limit for all generated URLs.
   
   Specify a string with format ``##h##m##s`` format. For example:
   ``12h34m56s`` for an expiry of 12 hours, 34 minutes, and 56 seconds
   after URL generation.

   Defaults to ``168h`` or 168 hours (7 days).

.. mc-cmd:: --recursive, r
   
   
   *Optional* Recursively generate URLs for all objects in a 
   :mc-cmd:`mc share download ALIAS` bucket or bucket prefix. 
      
   Required if any ``ALIAS`` specifies a path to a bucket or bucket prefix.

.. mc-cmd:: version-id, vid
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Generate a URL to Download Object(s)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Get Specific Object

      Use :mc-cmd:`mc share download` to generate a URL that supports
      ``GET`` requests for an object:

      .. code-block:: shell
         :class: copyable

         mc share download --expire DURATION ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc share download ALIAS>` with the 
        :ref:`alias <alias>` of the MinIO deployment.

      - Replace :mc-cmd:`PATH <mc share download ALIAS>` with the path to the
        object on the MinIO deployment.

      - Replace :mc-cmd:`DURATION <mc share download --expire>` with the duration
        after which the URL expires. For example, to set a 30 day expiry, 
        specify ``30d``.

   .. tab-item:: Get Object(s) in a Bucket

      Use :mc-cmd:`mc share download` with the 
      :mc-cmd:`~mc share download --recursive` option to generate a URL for
      each object in a bucket. Each URL supports ``GET`` requests for its
      associated object:

      .. code-block:: shell
         :class: copyable

         mc share download --recursive --expire DURATION ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc share download ALIAS>` with the 
        :ref:`alias <alias>` of the MinIO deployment.

      - Replace :mc-cmd:`PATH <mc share download ALIAS>` with the path to the
        bucket or bucket prefix on the MinIO deployment.

      - Replace :mc-cmd:`DURATION <mc share download --expire>` with the duration
        after which the URL expires. For example, to set a 30 day expiry, 
        specify ``30d``.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
