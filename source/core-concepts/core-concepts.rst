=============
Core Concepts
=============

.. default-domain:: minio

Erasure Coding
--------------

MinIO Erasure Coding is a data redundancy and availability feature that allows
MinIO deployments to automatically reconstruct objects on-the-fly despite the
loss of multiple drives or pods in the cluster. Erasure Coding provides
object-level healing with less overhead than adjacent technologies such as
RAID or replication. 

Erasure Coding uses a system of data blocks, parity blocks, and drives grouped
into **Erasure Sets**. Each object written to the MinIO Tenant is split
into data and parity blocks, where parity blocks support reconstruction of
missing or corrupted data block. For a given Erasure Code parity level
(``EC:N``), ``N`` drives in the Erasure Set contain parity blocks while the
remaining drives contain data blocks.

Since parity blocks require storage space, higher levels of parity 
provide increased tolerance to drive or pod failure at the cost of
total usable storage capacity.

For more complete documentation on erasure coding, see 
:ref:`minio-erasure-coding`.

Bucket Versioning
-----------------

MinIO supports keeping multiple "versions" of an object in a single bucket.
Write operations which would normally overwrite an existing object instead
result in the creation of a new versioned object. MinIO versioning protects from
unintended overwrites and deletions while providing support for "undoing" a
write operation. Bucket versioning also supports retention and archive policies.

<Diagram>

MinIO generates a unique immutable ID for each object. If a ``PUT`` request
contains an object name which duplicates an existing object, MinIO does *not*
overwrite the "older" object. Instead, MinIO retains all object versions while
considering the most recently written "version" of the object as "latest".
Applications retrieve the latest object version by default, but *may* retrieve
any other version in the history of that object.

Bitrot Protection
-----------------

ToDo

Bucket WORM Locking
-------------------

ToDo

Replication and Lifecycle Management
------------------------------------

ToDo

.. TODO: Table w/ high-level summary.

   Eventually needs to include:

   - Identity and Access Management
   - Encryption
   - Bucket Versioning
   - Bucket WORM Locking
   - Bucket Notifications
   - Replication and Lifecycle Management
   - Log Search

.. toctree::
   :titlesonly:
   :hidden:

   /core-concepts/erasure-coding
   /core-concepts/bucket-versioning