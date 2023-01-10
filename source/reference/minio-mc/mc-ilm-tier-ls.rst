.. _minio-mc-ilm-tier-ls:

==================
``mc ilm tier ls``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm tier ls

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z

   :mc:`mc ilm tier ls` replaces ``mc admin tier ls``.

Description
-----------

.. start-mc-ilm-tier-ls-desc

The :mc:`mc ilm tier ls` command shows the remote tiers configured on a deployment. 

.. end-mc-ilm-tier-ls-desc

Syntax
------

The command has the following syntax:

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example outputs a list of the existing remote tiers on the ``myminio`` deployment.
      
      .. code-block:: shell
         :class: copyable

          mc ilm tier ls myminio


   .. tab-item:: SYNTAX
   
      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc ilm tier ls TARGET TIER_NAME 

Parameters
~~~~~~~~~~

The command accepts the following argument:

.. mc-cmd:: TARGET
   :required:

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on which the desired tier exists.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

Required Permissions
--------------------

For permissions required for reviewing a tier, refer to the :ref:`required permissions <minio-mc-ilm-tier-permissions>` on the parent command.
