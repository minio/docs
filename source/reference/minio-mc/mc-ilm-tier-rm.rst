.. _minio-mc-ilm-tier-rm:

==================
``mc ilm tier rm``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm tier rm

Description
-----------

.. start-mc-ilm-tier-rm-desc

The :mc:`mc ilm tier rm` command removes an remote tier that has not been used to transition any objects. 

.. end-mc-ilm-tier-rm-desc

.. note:: 

   Once a tier has transitioned objects, it cannot be removed.

Required Permissions
~~~~~~~~~~~~~~~~~~~~

MinIO requires the following permissions scoped to to the bucket or buckets 
for which you are creating lifecycle management rules.

- :policy-action:`s3:PutLifecycleConfiguration`
- :policy-action:`s3:GetLifecycleConfiguration`

MinIO also requires the following administrative permissions on the cluster
in which you are creating remote tiers for object transition lifecycle
management rules:

- :policy-action:`admin:SetTier`
- :policy-action:`admin:ListTier`

For example, the following policy provides permission for configuring object
transition lifecycle management rules on any bucket in the cluster:.

.. literalinclude:: /extra/examples/LifecycleManagementAdmin.json
   :language: json
   :class: copyable

Syntax
------

The command has the following syntax:

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example removes an existing remote tier called ``WARM-TIER`` on the ``myminio`` deployment.
      No objects have transitioned to the ``WARM-TIER`` tier.
      
      .. code-block:: shell
         :class: copyable

          mc ilm tier rm myminio WARM-TIER


   .. tab-item:: SYNTAX
   
      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc ilm tier info TARGET TIER_NAME 

Parameters
~~~~~~~~~~

The command accepts the following arguments:

.. mc-cmd:: TARGET
   :required:

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on which the desired tier exists.
      
.. mc-cmd:: TIER_NAME
   :required:

   The name of an existing remote tier to remove. 

   You **must** specify the tier in all-caps, e.g. ``WARM_TIER``.

   No object can have transitioned to the tier.
   

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

For permissions required to remove a tier, refer to the :ref:`required permissions <minio-mc-ilm-tier-permissions>` on the parent command.