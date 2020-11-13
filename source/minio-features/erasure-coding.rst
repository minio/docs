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
loss of multiple drives or nodes in the cluster.Erasure Coding provides
object-level healing with less overhead than adjacent technologies such as
RAID or replication. 

Erasure Coding splits objects into data and parity blocks, where parity blocks
support reconstruction of missing or corrupted data blocks. MinIO distributes
both data and parity blocks across :mc:`minio server` nodes and drives in an
:ref:`Erasure Set <minio-ec-erasure-set>`. Depending on the configured parity,
number of nodes, and number of drives per node in the Erasure Set, MinIO can
tolerate the loss of up to half (``N/2``) of drives and still retrieve stored
objects.

For example, consider the following small-scale MinIO deployment consisting of a
single :ref:`Server Set <minio-intro-server-set>` with 4 :mc:`minio server`
nodes. Each node in the deployment has 4 locally attached ``1Ti`` drives for
a total of 16 drives:

<DIAGRAM>

MinIO creates :ref:`Erasure Sets <minio-ec-erasure-set>` by dividing the total
number of drives in the deployment into sets consisting of between 4 and 16
drives each. In the example deployment, the largest possible Erasure Set size
that evenly divides into the total number of drives is ``16``:

<DIAGRAM>

MinIO uses a Reed-Solomon algorithm to split objects into data and parity blocks
based on the size of the Erasure Set. MinIO then uniformly distributes the
data and parity blocks across the Erasure Set drives such that each drive
in the set contains no more than one block per object. MinIO uses
the ``EC:N`` notation to refer to the number of parity blocks (``N``) in the
Erasure Set.

<DIAGRAM>

The number of parity blocks in a deployment controls the deployment's relative
data redundancy. Higher levels of parity allow for higher tolerance of drive
loss at the cost of total available storage. For example, using EC:4 in our
example deployment results in 12 data blocks and 4 parity blocks. The parity
blocks take up some portion of space in the deployment, reducing total storage.
*However*, the parity blocks allow MinIO to reconstruct the object with only 
8 data blocks, increasing resilience to data corruption or loss.

The following table lists the outcome of varying EC levels on the example
deployment:

.. list-table:: Outcome of Parity Settings on a 16 Drive MinIO Cluster
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
  :ref:`minio-ec-parity`

- For more information on Erasure Code Object Healing, see
  :ref:`minio-ec-object-healing`.

.. _minio-ec-erasure-set:

Erasure Sets
------------

An *Erasure Set* is a set of drives in a MinIO deployment that support
Erasure Coding. MinIO evenly distributes object data and parity blocks among
the drives in the Erasure Set. 

MinIO calculates the number and size of *Erasure Sets* by dividing the total
number of drives in the :ref:`Server Set <minio-intro-server-set>` into sets
consisting of between 4 and 16 drives each. MinIO considers two factors when
selecting the Erasure Set size:

- The Greatest Common Divisor (GCD) of the total drives.

- The number of :mc:`minio server` nodes in the Server Set.

For an even number of nodes, MinIO uses the GCD to calculate the Erasure Set
size and ensure the minimum number of Erasure Sets possible. For an odd number
of nodes, MinIO selects a common denominator that results in an odd number of
Erasure Sets to facilitate more uniform distribution of erasure set drives
among nodes in the Server Set.

For example, consider a Server Set consisting of 4 nodes with 8 drives each
for a total of 32 drives. The GCD of 16 produces 2 Erasure Sets of 16 drives 
each with uniform distribution of erasure set drives across all 4 nodes.

Now consider a Server Set consisting of 5 nodes with 8 drives each for a total
of 40 drives. Using the GCD, MinIO would create 4 erasure sets with 10 drives
each. However, this distribution would result in uneven distribution with
one node contributing more drives to the Erasure Sets than the others. 
MinIO instead creates 5 erasure sets with 8 drives each to ensure uniform
distribution of Erasure Set drives per Nodes.

MinIO generally recommends maintaining an even number of nodes in a Server Set
to facilitate simplified human calculation of the number and size of
Erasure Sets in the Server Set.

.. _minio-ec-parity:

Erasure Code Parity (``EC:N``)
------------------------------

MinIO uses a Reed-Solomon algorithm to split objects into data and parity blocks
based on the size of the Erasure Set. MinIO uses parity blocks to automatically
heal damaged or missing data blocks when reconstructing an object. MinIO uses
the ``EC:N`` notation to refer to the number of parity blocks (``N``) in the
Erasure Set.

MinIO uses a hash of an object's name to determine into which Erasure Set to
store that object. MinIO always uses that erasure set for objects with a
matching name. For example, MinIO stores all :ref:`versions
<minio-bucket-versioning>` of an object in the same Erasure Set.

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
a ``EC:N`` parity setting to apply to objects created with that class. 

MinIO storage classes are *distinct* from Amazon Web Services :s3-docs:`storage
classes <storage-class-intro.html>`. MinIO storage classes define 
*parity settings per object*, while AWS storage classes define 
*storage tiers per object*. 

MinIO provides the following two storage classes:

``STANDARD``
   The ``STANDARD`` storage class is the default class for all objects. 

   You can configure the ``STANDARD`` storage class parity using either:

   - The :envvar:`MINIO_STORAGE_CLASS_STANDARD` environment variable, *or*
   - The :mc:`mc admin config` command to modify the ``storage_class.standard``
     configuration setting.

   Starting with <RELEASE>, MinIO defaults ``STANDARD`` storage class to
   ``EC:4``.

   The maximum value is half of the total drives in the
   :ref:`Erasure Set <minio-ec-erasure-set>`.

   ``STANDARD`` parity *must* be greater than or equal to
   ``REDUCED_REDUNDANCY``. If ``REDUCED_REDUNDANCY`` is unset, ``STANDARD``
   parity *must* be greater than 2

``REDUCED_REDUNDANCY``
   The ``REDUCED_REDUNDANCY`` storage class allows creating objects with
   lower parity than ``STANDARD``. 

   You can configure the ``REDUCED_REDUNDANCY`` storage class parity using
   either:

   - The :envvar:`MINIO_STORAGE_CLASS_REDUCED` environment variable, *or*
   - The :mc:`mc admin config` command to modify the 
     ``storage_class.rrs`` configuration setting.

   The default value is ``EC:2``.

   ``REDUCED_REDUNDANCY`` parity *must* be less than or equal to ``STANDARD``.
   If ``STANDARD`` is unset, ``REDUCED_REDUNDANCY`` must be less than half of
   the total drives in the :ref:`Erasure Set <minio-ec-erasure-set>`.

   ``REDUCED_REDUNDANCY`` is not supported for MinIO deployments with
   4 or fewer drives.

MinIO references the ``x-amz-storage-class`` header in request metadata for
determining which storage class to assign an object. The specific syntax
or method for setting headers depends on your preferred method for
interfacing with the MinIO server.

- For the :mc:`mc` command line tool, certain commands include a specific
  option for setting the storage class. For example, the :mc:`mc cp` command
  has the :mc-cmd-option:`~mc cp storage-class` option for specifying the
  storage class to assign to the object being copied.

- For MinIO SDKs, the ``S3Client`` object has specific methods for setting
  request headers. For example, the ``minio-go`` SDK ``S3Client.PutObject``
  method takes a ``PutObjectOptions`` data structure as a parameter.
  The ``PutObjectOptions`` data structure includes the ``StorageClass``
  option for specifying the storage class to assign to the object being
  created.


.. _minio-ec-object-healing:

Object Healing
--------------

TODO

.. _minio-ec-bitrot-protection:

BitRot Protection
-----------------

TODO- ReWrite w/ more detail.

Silent data corruption or bitrot is a serious problem faced by disk drives
resulting in data getting corrupted without the user’s knowledge. The reasons
are manifold (ageing drives, current spikes, bugs in disk firmware, phantom
writes, misdirected reads/writes, driver errors, accidental overwrites) but the
result is the same - compromised data.

MinIO’s optimized implementation of the HighwayHash algorithm ensures that it
will never read corrupted data - it captures and heals corrupted objects on the
fly. Integrity is ensured from end to end by computing a hash on READ and
verifying it on WRITE from the application, across the network and to the
memory/drive. The implementation is designed for speed and can achieve hashing
speeds over 10 GB/sec on a single core on Intel CPUs.