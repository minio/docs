.. _minio-lifecycle-management-create-expiry-rule:

===========================
Automatic Object Expiration
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Each procedure on this page creates a new object lifecycle management rule that
expires objects on a MinIO bucket. This procedure supports use cases like
removing "old" objects after a certain time period or calendar date.

.. todo: diagram

Requirements
------------

Install and Configure ``mc``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses :mc:`mc` for performing operations on the MinIO cluster.
Install :mc:`mc` on a machine with network access to both source and destination
clusters. See the ``mc`` :ref:`Installation Quickstart <mc-install>` for
instructions on downloading and installing ``mc``.

Use the :mc:`mc alias` command to create an alias for the source MinIO cluster
and the destination S3-compatible service. Alias creation requires specifying an
access key for a user on the source and destination clusters. The specified
users must have :ref:`permissions
<minio-lifecycle-management-create-expiry-rule-permissions>` for configuring
and applying expiry operations.

.. _minio-lifecycle-management-create-expiry-rule-permissions:

Required Permissions
~~~~~~~~~~~~~~~~~~~~

MinIO requires the following permissions scoped to the bucket or buckets 
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

Expire Objects after Calendar Date
----------------------------------

Use :mc-cmd:`mc ilm add` with :mc-cmd-option:`~mc ilm add expiry-date` to
expire bucket contents after a specific date.

.. code-block:: shell
   :class: copyable

   mc ilm add ALIAS/PATH --expiry-date "DATE"

- Replace :mc-cmd:`ALIAS <mc ilm add TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm add TARGET>` with the path to the bucket on the
  S3-compatible host.

- Replace :mc-cmd:`DATE <mc ilm add expiry-date>` with the calendar date after
  which to expire the object. For example, specify "2021-01-01" to expire
  objects after January 1st, 2021.

Expire Objects after Number of Days
-----------------------------------

Use :mc-cmd:`mc ilm add` with :mc-cmd-option:`~mc ilm add expiry-days` to
expire bucket contents a number of days after object creation:

.. code-block:: shell
   :class: copyable

   mc ilm add ALIAS/PATH --expiry-days "DAYS" 

- Replace :mc-cmd:`ALIAS <mc ilm add TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm add TARGET>` with the path to the bucket on the
  S3-compatible host.

- Replace :mc-cmd:`DATE <mc ilm add expiry-date>` with the number of days after
  which to expire the object. For example, specify ``30d`` to expire the
  object 30 days after creation.

Expire Versioned Objects
------------------------

Use :mc-cmd:`mc ilm add` to expiring noncurrent object versions and object
delete markers: 

- To expire noncurrent object versions after a specific duration in days,
  include :mc-cmd-option:`~mc ilm add noncurrentversion-expiration-days`.

- To expire delete markers for objects with no remaining versions, 
  include :mc-cmd-option:`~mc ilm add expired-object-delete-marker`.

.. code-block:: shell
   :class: copyable

   mc ilm add ALIAS/PATH \ 
      --noncurrentversion-expiration-days NONCURRENT_DAYS \
      --expired-object-delete-marker

- Replace :mc-cmd:`ALIAS <mc ilm add TARGET>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm add TARGET>` with the path to the bucket on the
  S3-compatible host.

- Replace :mc-cmd:`NONCURRENT_DAYS 
  <mc ilm add noncurrentversion-expiration-days>` with the number of days after
  which to expire noncurrent object versions. For example, specify ``30d`` to
  expire a version after it has been noncurrent for at least 30 days.

