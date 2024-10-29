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

Use the :mc:`mc alias set` command to create an alias for the source MinIO cluster
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

Expire Objects after Number of Days
-----------------------------------

Use :mc:`mc ilm rule add` with :mc-cmd:`~mc ilm rule add --expire-days` to
expire bucket contents a number of days after object creation:

.. code-block:: shell
   :class: copyable

   mc ilm rule add ALIAS/PATH --expire-days "DAYS" 

- Replace :mc-cmd:`ALIAS <mc ilm rule add ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm rule add ALIAS>` with the path to the bucket on the
  S3-compatible host.

- Replace :mc-cmd:`DAYS <mc ilm rule add --expire-days>` with the number of days after
  which to expire the object. For example, specify ``30`` to expire the
  object 30 days after creation.

Expire Versioned Objects
------------------------

Use :mc:`mc ilm rule add` to expiring noncurrent object versions and object
delete markers: 

- To expire noncurrent object versions after a specific duration in days,
  include :mc-cmd:`~mc ilm rule add --noncurrent-expire-days`.

- To expire delete markers for objects with no remaining versions, 
  include :mc-cmd:`~mc ilm rule add --expire-delete-marker`.

.. code-block:: shell
   :class: copyable

   mc ilm rule add ALIAS/PATH \ 
      --noncurrent-expire-days NONCURRENT_DAYS \
      --expire-delete-marker

- To expire all versions of an object with no delete marker, include :mc-cmd:`~mc ilm rule add --expire-all-object-versions`.

  .. code-block:: shell
     :class: copyable
  
     mc ilm rule add ALIAS/PATH \ 
        --expire-all-object-versions

- Replace :mc-cmd:`ALIAS <mc ilm rule add ALIAS>` with the 
  :mc:`alias <mc alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc ilm rule add ALIAS>` with the path to the bucket on the
  S3-compatible host.

- Replace :mc-cmd:`NONCURRENT_DAYS 
  <mc ilm rule add --noncurrent-expire-days>` with the number of days after
  which to expire noncurrent object versions. For example, specify ``30d`` to
  expire a version after it has been noncurrent for at least 30 days.

Expire All Versions of a Deleted Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Starting with :mc-release:`MinIO Server RELEASE.2024-05-01T01-11-10Z`, MinIO supports deleting all versions of an object that has a delete marker as its latest version.
MinIO only supports this function with JSON.

To add this function, first export the rule to modify with :mc:`mc ilm rule export`.
Modify the exported rule with additional ``JSON`` that resembles the following:

.. code-block:: text
   :class: copyable

   <DelMarkerObjectExpiration>
       <Days> 10 </Days>
   </DelMarkerObjectExpiration>   

This example ``JSON`` expires all versions of the deleted object after 10 days.
Modify the value in the ``<Days>`` element to the number of days you want to wait after deleting or expiring the object.