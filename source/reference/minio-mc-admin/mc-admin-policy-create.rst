==========================
``mc admin policy create``
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin policy create

Syntax
------

.. start-mc-admin-policy-create-desc

Creates a new policy on the target MinIO deployment. 

.. end-mc-admin-policy-create-desc

MinIO deployments include the following :ref:`built-in policies <minio-policy-built-in>` by default:

- :userpolicy:`readonly` 
- :userpolicy:`readwrite`
- :userpolicy:`diagnostics`
- :userpolicy:`writeonly`

.. tab-set::

   .. tab-item:: EXAMPLE


      Consider the following JSON policy document saved at a file called ``/tmp/listmybuckets.json``:
      
      .. code-block:: javascript
         :class: copyable
      
         {
            "Version": "2012-10-17",
            "Statement": [
               {
                  "Effect": "Allow",
                  "Action": [
                     "s3:ListAllMyBuckets"
                  ],
                  "Resource": [
                     "arn:aws:s3:::*"
                  ]
               }
            ]
         }

      The following command creates a new policy called ``listmybuckets`` on the :term:`alias` ``myminio`` using the policy found at the file ``/tmp/listmybuckets.json``.

      .. code-block:: shell
         :class: copyable

         mc admin policy create myminio listmybuckets /tmp/listmybuckets.json  

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc admin policy create     \
                         TARGET     \
                         POLICYNAME \
                         POLICYPATH


      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

The :mc-cmd:`mc admin policy create` command accepts the following arguments:

.. mc-cmd:: TARGET

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on which to add the new policy.

.. mc-cmd:: POLICYNAME

   The name of the policy to add. 
      
   Specifying the name of an existing policy overwrites that policy on the :mc-cmd:`~mc admin policy create TARGET` MinIO deployment.

.. mc-cmd:: POLICYPATH

   The file path of the policy to add. 
   The file *must* be a JSON-formatted file with :iam-docs:`IAM-compatible syntax <reference_policies.html>` and no more than 2048 characters.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Create a new policy called ``writeonly`` from the JSON file at ``/tmp/writeonly.json`` on the deployment at the alias ``myminio``.

.. code-block:: shell
   :class: copyable

   mc admin policy create myminio writeonly /tmp/writeonly.json
