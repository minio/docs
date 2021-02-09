=============
``mc policy``
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc policy

Description
-----------

.. start-mc-policy-desc

The :mc:`mc policy` command supports setting or removing anonymous
policies to a bucket and its contents using AWS S3 
:s3-docs:`JSON policies <using-iam-policies>`. Buckets with anonymous 
policies allow public access where clients can perform any action
granted by the policy without.

.. end-mc-policy-desc

You can set or remove policies on individual folders or objects inside of a
bucket for more granular control over anonymous access to a bucket's
contents.

Examples
--------

Get Current Anonymous Policy for Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc policy get` to retrieve the current anonymous policy for a 
bucket:

.. code-block:: shell
   :class: copyable

   mc policy get ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc policy get TARGET>` with the 
  :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc policy get TARGET>` with the destination bucket.

Use :mc-cmd:`mc policy get-json` to retrieve the 
:s3-docs:`IAM JSON policy document <using-iam-policies>` of a bucket:

.. code-block:: shell
   :class: copyable

   mc policy get-json ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc policy get-json TARGET>` with the 
  :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc policy get-json TARGET>` with the destination
  bucket.

Set Anonymous Policy for Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc policy set` to set the anonymous policy for a 
bucket:

.. code-block:: shell
   :class: copyable

   mc policy set POLICY ALIAS/PATH

- Replace :mc-cmd:`POLICY <mc policy set PERMISSION>` with a supported
  :mc-cmd:`permission <mc policy set PERMISSION>`.

- Replace :mc-cmd:`ALIAS <mc policy set TARGET>` with the 
  :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc policy set TARGET>` with the destination bucket.

Use :mc-cmd:`mc policy set-json` to use a
:s3-docs:`IAM JSON policy document <using-iam-policies>` to set the anonymous
policy for a bucket:

.. code-block:: shell
   :class: copyable

   mc policy set-json POLICY ALIAS/PATH

- Replace :mc-cmd:`POLICY <mc policy set-json FILE>` with the JSON-formatted
  IAM policy document to use for setting the anonymous policy.

- Replace :mc-cmd:`ALIAS <mc policy set-json TARGET>` with the 
  :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc policy set-json TARGET>` with the destination
  bucket.

Remove Anonymous Policy for Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc policy set` to clear the anonymous policy for a 
bucket:

.. code-block:: shell
   :class: copyable

   mc policy set none ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc policy set TARGET>` with the 
  :mc-cmd:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc policy set TARGET>` with the destination bucket.

Syntax
------

:mc:`~mc policy` has the following syntax:

.. code-block:: shell

   mc policy COMMAND [ARGUMENTS]

:mc:`~mc policy` supports the following commands:

.. mc-cmd:: set
   :fullpath:

   Adds one of the following built-in policies to the specified 
   bucket. The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc policy set PERMISSION TARGET
      
   The command requires the following arguments:
   
   .. mc-cmd:: PERMISSION
      
      Name of the policy to assign to the specified ``TARGET``
            
      :mc-cmd:`mc policy set PERMISSION` supports the following built-in 
      policies:

      - ``none`` - Disable anonymous access to the ``TARGET``.
      - ``download`` - Enable download-only access to the ``TARGET``.
      - ``upload`` - Enable upload-only access to the ``TARGET``.
      - ``public`` - Enable download and upload access to the ``TARGET``.

   .. mc-cmd:: TARGET
      
      The full path to the bucket, folder, or object to which the command 
      applies the specified :mc-cmd:`~mc policy set PERMISSION`. Specify the
      :mc:`alias <mc alias>` of a configured S3 service as the
      prefix to the ``TARGET`` path. For example:

      .. code-block:: shell
               
         mc set public play/mybucket

.. mc-cmd:: set-json
   :fullpath:

   Adds an AWS S3 :s3-docs:`JSON policy <using-iam-policies>` to the 
   specified bucket. The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc policy set-json FILE TARGET
      
   The command requires the following arguments:

   .. mc-cmd:: FILE

      The full path to the S3 policy ``.json`` file which the
      command applies to the specified :mc-cmd:`~mc policy set-json TARGET`

   .. mc-cmd:: TARGET

      The full path to the bucket, folder, or object to which the command applies
      the specified :mc-cmd:`~mc policy set-json FILE` S3 policy document.
      Specify the :mc:`alias <mc alias>` of a configured S3 service as the
      prefix to the ``TARGET`` path. For example:

      .. code-block:: shell
               
         mc set public play/mybucket

.. mc-cmd:: get
   :fullpath:

   Prints the current anonymous policy for the specified bucket, folder,
   or object on the console.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc policy get TARGET
      
   The command requires the following arguments:

   .. mc-cmd:: TARGET

      The full path to the bucket, folder, or object for which the command
      returns the current anonymous policy. Specify the :mc:`alias <mc alias>`
      of a configured S3 service as the prefix to the ``TARGET`` path. For
      example:

      .. code-block:: shell
               
         mc set public play/mybucket

.. mc-cmd:: get-json
   :fullpath:

   Returns the current anonymous policy for the specified bucket, folder,
   or object in ``JSON`` format.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc policy get-json TARGET

   The command requires the following arguments:
      
   .. mc-cmd:: TARGET

      The full path to the bucket, folder, or object for which the command
      returns the current anonymous policy JSON document. Specify the :mc:`alias
      <mc alias>` of a configured S3 service as the prefix to the ``TARGET``
      path. For example:

      .. code-block:: shell
               
         mc set public play/mybucket

.. mc-cmd:: list
   :fullpath:

   Prints the anonymous policy for the specified bucket and any folders
   or objects with a different anonymous policy from the bucket.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc policy list TARGET

   The command requires the following arguments:
      
   .. mc-cmd:: TARGET

      The full path to the bucket, folder, or object for which the command
      returns the current anonymous policy JSON document. Specify the :mc:`alias
      <mc alias>` of a configured S3 service as the prefix to the ``TARGET``
      path. For example:

      .. code-block:: shell
               
         mc set public play/mybucket
         


