=============
``mc policy``
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

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

Syntax
------

:mc:`~mc policy` has the following syntax:

.. code-block:: shell

   mc policy COMMAND [ARGUMENTS]

:mc:`~mc policy` supports the following commands:

.. mc-cmd:: set

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

      The full path to the bucket, folder, orobject to which the command applies
      the specified :mc-cmd:`~mc policy set-json FILE` S3 policy document.
      Specify the :mc:`alias <mc alias>` of a configured S3 service as the
      prefix to the ``TARGET`` path. For example:

      .. code-block:: shell
               
         mc set public play/mybucket

.. mc-cmd:: get

   Prints the current anonymous policy for the specified bucket, folder,
   or object on the console.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc policy get TARGET
      
   Specify the :mc:`alias <mc alias>` of a configured S3 service
   as the prefix to the ``TARGET`` bucket path. For example:

   .. code-block:: shell
      :class: copyable
      
      mc get play/mybucket

.. mc-cmd:: get-json

   Returns the current anonymous policy for the specified bucket, folder,
   or object in ``JSON`` format.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc policy get-json TARGET
      
   Specify the :mc:`alias <mc alias>` of a configured S3 service
   as the prefix to the ``TARGET`` bucket path. For example:

   .. code-block:: shell
      :class: copyable
      
      mc policy get-json play/mybucket

.. mc-cmd:: list

   Prints the anonymous policy for the specified bucket and any folders
   or objects with a different anonymous policy from the bucket.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc policy list TARGET

   Specify the :mc:`alias <mc alias>` of a configured S3 service
   as the prefix to the ``TARGET`` bucket path. For example:

   .. code-block:: shell
      :class: copyable

      mc policy list play/mybucket
         

Examples
--------

Get Current Anonymous Policy for Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc policy get play/mybucket

To retrieve the :s3-docs`IAM JSON policy document <using-iam-policies>`, use the 
:mc-cmd:`mc policy get-json` mc:

.. code-block:: shell
   :class: copyable

   mc policy get-json play/mybucket

Set Anonymous Policy for Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc policy set upload play/mybucket

See :mc-cmd:`mc policy set` for the list of supported built-in policies.

To set the anonymous policy for the specified bucket using
an :s3-docs:`IAM JSON file <using-iam-policies>`, use the 
:mc-cmd:`mc policy set-json` mc:

.. code-block:: shell
   :class: copyable

   mc policy set-json ~/policies/s3-upload.json play/mybucket

Remove Anonymous Policy for Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc policy set none play/mybucket
