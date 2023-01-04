.. _minio-mc-ilm-tier-check:

=====================
``mc ilm tier check``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm tier check

Description
-----------

.. start-mc-ilm-tier-check-desc

The :mc:`mc ilm tier check` command displays the configuration for remote tier on a deployment. 

.. end-mc-ilm-tier-check-desc

Syntax
------

The command has the following syntax:

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example displays the configuration for an existing remote tier called ``WARM-TIER`` on the ``myminio`` deployment.
      
      .. code-block:: shell
         :class: copyable

          mc ilm tier check myminio WARM-TIER                    


   .. tab-item:: SYNTAX
   
      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc ilm tier add TARGET TIER_NAME 

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

The command accepts the following arguments:

.. mc-cmd:: TARGET
   :required:

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on which the desired tier exists.
      
.. mc-cmd:: TIER_NAME
   :required:

   The name of an existing remote tier to display. 

   You **must** specify the tier in all-caps, e.g. ``WARM_TIER``.
   

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Example
-------

Display the Configuration for an Existing Tier
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example displays the configuration of the tier ``WARM-TIER`` on the ``myminio`` deployment.

.. code-block:: shell
   :class: copyable

   mc ilm tier check myminio WARM-TIER 

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

Required Permissions
--------------------

For permissions required to review a tier, refer to the :ref:`required permissions <minio-mc-ilm-tier-permissions>` on the parent command.