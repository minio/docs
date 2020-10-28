============
``mc share``
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc share

Description
-----------

.. start-mc-share-desc

The :mc:`mc share` command generates temporary URLs with integrated
access credentials for uploading or downloading objects to an S3-compatible
host. The temporary URL expires after a configurable time limit.

.. end-mc-share-desc

For more information on shareable object URLs, see the Amazon S3 
documentation on :aws-docs:`Pre-Signed URLs 
<AmazonS3/latest/dev/ShareObjectPreSignedURL.html>`.

Examples
--------

Generate a CURL GET Command
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tabs::

   .. tab:: Get Specific Object

      Use :mc-cmd:`mc share download` to generate a URL that supports
      ``GET`` requests for an object:

      .. code-block:: shell
         :class: copyable

         mc share download --expire DURATION ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc share download TARGET>` with the 
        :mc:`alias <mc alias>` of the S3-compatible host.

      - Replace :mc-cmd:`PATH <mc share download TARGET>` with the path to the
        object on the S3-compatible host.

      - Replace :mc-cmd:`DURATION <mc share download expire>` with the duration
        after which the URL expires. For example, to set a 30 day expiry, 
        specify ``30d``.

   .. tab:: Get Object(s) in a Bucket

      Use :mc-cmd:`mc share download` with the 
      :mc-cmd-option:`~mc share download recursive` option to generate a URL for
      each object in a bucket. Each URL supports ``GET`` requests for its
      associated object:

      .. code-block:: shell
         :class: copyable

         mc share download --recursive --expire DURATION ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc share download TARGET>` with the 
        :mc:`alias <mc alias>` of the S3-compatible host.

      - Replace :mc-cmd:`PATH <mc share download TARGET>` with the path to the
        bucket or bucket prefix on the S3-compatible host.

      - Replace :mc-cmd:`DURATION <mc share download expire>` with the duration
        after which the URL expires. For example, to set a 30 day expiry, 
        specify ``30d``.

Generate a CURL POST Command
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tabs::

   .. tab:: Upload to Object

      Use :mc-cmd:`mc share upload` to generate a URL that supports
      ``POST`` requests for uploading a file to a specific object location
      on an S3-compatible host:

      .. code-block:: shell
         :class: copyable

         mc share upload --expire DURATION ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc share upload TARGET>` with the 
        :mc:`alias <mc alias>` of the S3-compatible host.

      - Replace :mc-cmd:`PATH <mc share upload TARGET>` with the path to the
        object on the S3-compatible host.

      - Replace :mc-cmd:`DURATION <mc share upload expire>` with the duration
        after which the URL expires. For example, to set a 30 day expiry, 
        specify ``30d``.

   .. tab:: Upload File(s) to Bucket

      Use :mc-cmd:`mc share upload` with the 
      :mc-cmd-option:`~mc share upload recursive` option to generate a URL that
      supports ``POST`` requests for uploading files to a bucket on an
      S3-compatible host:

      .. code-block:: shell
         :class: copyable

         mc share upload --recursive --expire DURATION ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc share upload TARGET>` with the 
        :mc:`alias <mc alias>` of the S3-compatible host.

      - Replace :mc-cmd:`PATH <mc share upload TARGET>` with the path to the
        bucket or bucket prefix on the S3-compatible host.

      - Replace :mc-cmd:`DURATION <mc share upload expire>` with the duration
        after which the URL expires. For example, to set a 30 day expiry, 
        specify ``30d``.

      The command returns a CURL command for uploading an object to the
      specified bucket prefix. 

      - Replace the ``<FILE>`` string in the returned CURL command with the path
        to the file to upload. 
      
      - Replace the ``<NAME>`` string in the returned CURL command with the name
        of the file in the bucket.

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
            -F bucket=rkbucket -F key=mydata/${file} -F file=@${file}

         done

      Defer to the documented best practices for your preferred scripting language
      for iterating through files in a directory.



Syntax
------

.. |command| replace:: :mc-cmd:`mc share download`
.. |versionid| replace:: :mc-cmd-option:`~mc share download version-id`
.. |alias| replace:: :mc-cmd-option:`~mc share download TARGET`

.. mc-cmd:: download
   :fullpath:

   Generates a URL for using an HTTP GET request to retrieve the
   object(s).

   :mc-cmd:`~mc share download` has the following syntax:

   .. code-block:: shell

      mc share download [FLAGS] TARGET [TARGET ...]

   :mc-cmd:`~mc share download` supports the following arguments:

   .. mc-cmd:: TARGET

      The full path to the object for which :mc:`mc share download` generates a 
      URL.

      If any ``TARGET`` specifies a path to a bucket, :mc:`mc share` *must*
      include the :mc-cmd-option:`mc share download recursive` argument.

   .. mc-cmd:: recursive, r
      :option:
      
      Recursively generate URLs for all objects in a 
      :mc-cmd:`mc share download TARGET` bucket or bucket prefix. 
         
      Required if any ``TARGET`` specifies a path to a bucket or bucket prefix.

   .. mc-cmd:: version-id, vid
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-version-id-desc
         :end-before: end-version-id-desc

   .. mc-cmd:: expire, E
      :option:

      Set the expiration time limit for all generated URLs.
      
      Specify a string with format ``##h##m##s`` format. For example:
      ``12h34m56s`` for an expiry of 12 hours, 34 minutes, and 56 seconds
      after URL generation.

      Defaults to ``168h`` or 168 hours (7 days).


.. mc-cmd:: upload

   Generates a ``CURL`` command for uploading object(s) using ``HTTP POST``.

   :mc-cmd:`~mc share upload` has the following syntax:

   .. code-block:: shell

      mc share upload [FLAGS] TARGET [TARGET ...]

   :mc-cmd:`~mc share upload` supports the following arguments:

   .. mc-cmd:: TARGET

      The full path to the object for which :mc:`mc share upload` generates a
      URL. 
      
      If the ``TARGET`` specifies a single object, :mc-cmd:`mc share upload`
      names the uploaded object based on the name specified to ``TARGET``.

      If the ``TARGET`` specifies a path to a bucket or bucket prefix,
      :mc-cmd:`mc share upload` *must* include the
      :mc-cmd-option:`~mc share upload recursive` argument. 

   .. mc-cmd:: recursive, r
      :option:
      
      Modifies the CURL URL to support uploading objects to a bucket or bucket
      prefix. Required if any ``TARGET`` specifies a path to a bucket or bucket
      prefix. The modified CURL output resembles the following:

      .. code-block:: shell

         curl ... -F key=TARGET/<NAME> -F file=@<FILE>

      Replace ``<FILE>`` with the path to the file to upload.

      Replace ``<NAME>`` with the file once uploaded.
         

   .. mc-cmd:: expire, E
      :option:

      Set the expiration time limit for all generated URLs.
      
      Specify a string with format ``##h##m##s`` format. For example:
      ``12h34m56s`` for an expiry of 12 hours, 34 minutes, and 56 seconds
      after URL generation.

      Defaults to ``168h`` or 168 hours (7 days).


.. mc-cmd:: list

   List all unexpired upload or download URLs generated by 
   :mc-cmd:`mc share download` and :mc-cmd:`mc share upload`.

   :mc-cmd:`~mc share list` has the following syntax:

   .. code-block:: shell

      mc share list SUBCOMMAND

   :mc-cmd:`~mc share download` supports the following subcommands:

   .. mc-cmd:: upload
   
      List all unexpired URLs generated by :mc-cmd:`mc share upload`.

   .. mc-cmd:: download
   
      List all unexpired URLs generated by :mc-cmd:`mc share download`.

