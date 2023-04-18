========================
``mc admin policy info``
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin policy info

Syntax
------

.. start-mc-admin-policy-info-desc

Returns the specified policy in JSON format if it exists on the target MinIO deployment. 

.. end-mc-admin-policy-info-desc


.. tab-set::

   .. tab-item:: EXAMPLE

      The following command displays the contents of the ``writeonly`` policy on the :term:`alias` ``myminio``.

      .. code-block:: shell
         :class: copyable

          mc admin policy info myminio writeonly  

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc admin policy info TARGET POLICYNAME
                              [--policy-file, -f <path>]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

The :mc-cmd:`mc admin policy info` command accepts the following arguments:

.. mc-cmd:: TARGET
   :required:

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from which to display the specified policy.

.. mc-cmd:: POLICYNAME
   :required:

   The name of the policy whose details you want to display. 

.. mc-cmd:: --policy-file
   :optional:

   Specifly the path of a file to write the contents of the specified policy JSON.
   If the path already exists, the command overwrites the existing file with the contents of the specified file.
      
Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Display the contents of the ``writeonly`` policy on the :term:`alias` ``myminio``.

.. code-block:: shell
   :class: copyable

   mc admin policy info myminio writeonly

Show information on a given policy and write the policy JSON content to /tmp/policy.json.

.. code-block:: shell
   :class: copyable

   mc admin policy info myminio writeonly --policy-file /tmp/policy.json

Output
~~~~~~

The command returns output that resembles the following:

.. code-block:: json

   {
      "Version": "2012-10-17",
      "Statement": [
         {
            "Effect": "Allow",
            "Action": [
               "s3:PutObject"
            ],
            "Resource": [
               "arn:aws:s3:::*"
            ]
         }
      ]
   }