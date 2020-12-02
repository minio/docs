.. _minio-erasure-coding:

==============
Erasure Coding
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

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

The number of parity blocks determines the Tenant's ability to continue
servicing read and write requests in the event of drive or pod failure. 
Specifically:

- For read operations, the MinIO Tenant can tolerate the loss of up to
  ``N`` drives.

- For write operations, the MinIO Tenant can tolerate the loss of up to
  ``N-1`` drives.

Since parity blocks require storage space, higher levels of parity 
provide increased tolerance to drive or pod failure at the cost of
total usable storage capacity.

The following table lists the outcome of varying EC levels on a MinIO Tenant
with 4 pods and 4 1Ti drives per node. MinIO creates a single Erasure Set 
consisting of 16 drives for this Tenant.

.. list-table:: Outcome of Parity Settings on a 16 Drive MinIO Tenant
   :header-rows: 1
   :widths: 20 20 20 20 20
   :width: 100%

   * - Parity
     - Total Storage
     - Storage Ratio
     - Minimum Drives for Read Operations
     - Minimum Drives for Write Operations

   * - ``EC: 4`` (Default)
     - 12 Tebibytes
     - 0.750
     - 12
     - 13

   * - ``EC: 6``
     - 10 Tebibytes
     - 0.625
     - 10
     - 16

   * - ``EC: 8``
     - 8 Tebibytes
     - 0.500
     - 8
     - 9

- For more information on Erasure Sets, see :ref:`minio-ec-erasure-set`.

- For more information on selecting Erasure Code Parity, see
  :ref:`minio-ec-parity`.

.. _minio-ec-erasure-set:

Erasure Sets
------------

An *Erasure Set* is a set of drives in a MinIO Tenant that support
Erasure Coding. MinIO evenly distributes object data and parity blocks among
the drives in the Erasure Set. 

IMAGE

When creating a MinIO Tenant Pool, MinIO divides the total number of drives in
the Pool into sets consisting of between 4 and 16 drives each. MinIO considers
two factors when selecting the Erasure Set size:

- The Greatest Common Divisor (GCD) of the total drives.

- The number of ``minio`` pods in the Pool.

For Pools with an even number of pods, MinIO uses the ``GCD`` to calculate the
Erasure Set size and ensure the minimum number of Erasure Sets possible. For
Pools with an odd number of pods, MinIO selects a common denominator that
results in an odd number of Erasure Sets to facilitate more uniform distribution
of erasure set drives among pods in the Pool.

For example, consider a Pool consisting of 4 pods with 8 drives each
for a total of 32 drives. The GCD of 16 produces 2 Erasure Sets of 16 drives 
each with uniform distribution of erasure set drives across all 4 pods.

Now consider a Pool consisting of 5 pods with 8 drives each for a total
of 40 drives. Using the GCD, MinIO would create 4 erasure sets with 10 drives
each. However, this distribution would result in uneven distribution with
one node contributing more drives to the Erasure Sets than the others. 
MinIO instead creates 5 erasure sets with 8 drives each to ensure uniform
distribution of Erasure Set drives per Nodes.

MinIO generally recommends maintaining an even number of pods in a Pool
to facilitate simplified human calculation of the number and size of
Erasure Sets in the Pool. You can review the number of instances per Pool
from the :guilabel:`MinIO` section under the :guilabel:`Configure` tab of
the Cluster:

IMAGE

MinIO uses a hash of an object's name to determine into which :ref:`Erasure Set
<minio-ec-erasure-set>` to store that object. MinIO always uses that erasure set
for objects with a matching name. For example, MinIO stores all versions of an
object in the same Erasure Set.

<DIAGRAM: Object A routes to EC A, Object B routes to EC B, Object B v2 routes to EC B>

.. _minio-ec-parity:

Erasure Code Parity (``EC:N``)
------------------------------

MinIO uses a Reed-Solomon algorithm to split objects into data and parity blocks
based on the size of the Erasure Set. MinIO uses parity blocks to automatically
heal damaged or missing data blocks when reconstructing an object. MinIO uses
the ``EC:N`` notation to refer to the number of parity blocks (``N``) in the
Erasure Set.

After MinIO selects an object's Erasure Set, it divides the object based on the
number of drives in the set and the configured parity. MinIO creates:

- ``(Erasure Set Drives) - EC:N`` Data Blocks, *and*
- ``EC:N`` Parity Blocks.

MinIO randomly and uniformly distributes the data and parity blocks across
drives in the erasure set with *no overlap*. While a drive may contain both data
and parity blocks for multiple unique objects, a single unique object has no
more than one block per drive in the set. For versioned objects, MinIO selects
the same drives for both data and parity storage while maintaining zero overlap
on any single drive.

The specified parity for an object also dictates the minimum number of Erasure
Set drives ("Quorum") required for MinIO to either read or write that object:

Read Quorum
   The minimum number of Erasure Set drives required for MinIO to 
   serve read operations. MinIO can automatically reconstruct an object
   with corrupted or missing data blocks if enough drives are online to
   provide Read Quorum for that object.
  
   MinIO Read Quorum is ``DRIVES - (EC:N)``.

Write Quorum
  The minimum number of Erasure Set drives required for MinIO
  to serve write operations. MinIO requires enough available drives to
  eliminate the risk of split-brain scenarios. 
  
  MinIO Write Quorum is ``DRIVES - (EC:N-1)``.

Storage Classes
~~~~~~~~~~~~~~~

MinIO supports storage classes with Erasure Coding to allow applications to
specify per-object :ref:`parity <minio-ec-parity>`. Each storage class specifies
an ``EC:N`` parity setting to apply to objects created with that class. 

MinIO references the ``x-amz-storage-class`` header in request metadata for
determining which storage class to assign an object. The specific syntax or
method for setting headers depends on your preferred method for interfacing with
the MinIO Tenant. For example, the ``minio-go`` SDK ``S3Client.PutObject``
method takes a ``PutObjectOptions`` data structure as a parameter. The
``PutObjectOptions`` data structure includes the ``StorageClass`` option for
specifying the storage class to assign to the object being created.

MinIO storage classes are *distinct* from Amazon Web Services 
:s3-docs:`storage classes <storage-class-intro.html>`. MinIO storage classes
define *parity settings per object*, while AWS storage classes define *storage
tiers per object*. 

MinIO provides the following two storage classes:

``STANDARD``
   The ``STANDARD`` storage class defines the default parity for all objects. 
   MinIO sets the default value at Tenant creation based on the number of 
   drives per :ref:`Erasure Set <minio-ec-erasure-set>` as 
   ``EC:N/2``, where ``N`` is the number of drives in the Erasure Set.

   To modify the ``STANDARD`` storage class after Tenant creation,
   use the ``mc admin config`` command to modify
   ``storage_class.standard EC:N`` where ``N`` is the new parity value. 
   The change applies only to those objects created *after* updating the
   storage class value.

   - The maximum value is half of the total drives in the
     :ref:`Erasure Set <minio-ec-erasure-set>`.

   - ``STANDARD`` parity *must* be greater than or equal to
     ``REDUCED_REDUNDANCY``. 
     
   - If ``REDUCED_REDUNDANCY`` is unset, ``STANDARD``
     parity *must* be greater than 2

``REDUCED_REDUNDANCY``
   The ``REDUCED_REDUNDANCY`` storage class allows creating objects with
   lower parity than ``STANDARD``. MinIO sets the default value at 
   Tenant creation to ``EC:2``.

   To modify the ``REDUCED_REDUNDANCY`` storage class after Tenant creation,
   use the ``mc admin config set`` command to modify
   ``storage_class.rrs EC:N`` where ``N`` is the new parity value. 
   The change applies only to those objects created *after* updating the
   storage class value.

   - ``REDUCED_REDUNDANCY`` parity *must* be less than or equal to ``STANDARD``.
     If ``STANDARD`` is unset, ``REDUCED_REDUNDANCY`` must be less than half of
     the total drives in the :ref:`Erasure Set <minio-ec-erasure-set>`.

   - ``REDUCED_REDUNDANCY`` is not supported for MinIO Tenants with
     4 or fewer drives.


