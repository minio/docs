==========================
``mc admin policy remove``
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin policy remove

Syntax
------

.. start-mc-admin-policy-remove-desc

Removes an IAM policy from the target MinIO deployment. 

.. end-mc-admin-policy-remove-desc


.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes the policy names ``writeonly`` from the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc admin policy remove myminio writeonly

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc admin policy remove TARGET POLICYNAME 

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

The :mc-cmd:`mc admin policy create` command accepts the following arguments:

.. mc-cmd:: TARGET

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from which to remove the policy.

.. mc-cmd:: POLICYNAME

   The name of the policy to remove. 
      
Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Remove a policy called ``listbuckets``.

.. code-block:: shell
   :class: copyable

   mc admin policy remove myminio listbuckets