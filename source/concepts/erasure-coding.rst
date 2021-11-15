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
loss of multiple drives or nodes in the cluster. Erasure Coding provides
object-level healing with less overhead than adjacent technologies such as
RAID or replication. 

MinIO splits each new object into data and parity blocks, where parity blocks
support reconstruction of missing or corrupted data blocks. MinIO writes these
blocks to a single :ref:`erasure set <minio-ec-erasure-set>` in the deployment.
Since erasure set drives are striped across the deployment, a given node 
typically contains only a portion of data or parity blocks for each object.
MinIO can therefore tolerate the loss of multiple drives or nodes in the
deployment depending on the configured parity and deployment topology.

.. image:: /images/erasure-code.jpg
   :width: 600px
   :alt: MinIO Erasure Coding example
   :align: center

At maximum parity, MinIO can tolerate the loss of up to half the drives per
erasure set (``N/2-1``) and still perform read and write operations. MinIO
defaults to 4 parity blocks per object with tolerance for the loss of 4 drives
per erasure set. For more complete information on selecting erasure code parity,
see :ref:`minio-ec-parity`.

Erasure coding requires a minimum of 4 drives is only available with 
:ref:`distributed <minio-installation-comparison>` MinIO deployments. Erasure
coding is a core requirement for the following MinIO features:

- :ref:`Object Versioning <minio-bucket-versioning>`
- :ref:`Server-Side Replication <minio-bucket-replication>`
- :ref:`Write-Once Read-Many Locking <minio-bucket-locking>`

Use the MinIO `Erasure Code Calculator 
<https://min.io/product/erasure-code-calculator?ref=docs>`__ when planning and
designing your MinIO deployment to explore the effect of erasure code settings
on your intended topology.

.. _minio-ec-erasure-set:

Erasure Sets
------------

An *Erasure Set* is a set of drives in a MinIO deployment that support Erasure
Coding. MinIO evenly distributes object data and parity blocks among the drives
in the Erasure Set. MinIO randomly and uniformly distributes the data and parity
blocks across drives in the erasure set with *no overlap*. Each unique object
has no more than one data or parity block per drive in the set.

MinIO calculates the number and size of *Erasure Sets* by dividing the total
number of drives in the :ref:`Server Pool <minio-intro-server-pool>` into sets
consisting of between 4 and 16 drives each. MinIO considers two factors when
selecting the Erasure Set size:

- The Greatest Common Divisor (GCD) of the total drives.

- The number of :mc:`minio server` nodes in the Server Pool.

For an even number of nodes, MinIO uses the GCD to calculate the Erasure Set
size and ensure the minimum number of Erasure Sets possible. For an odd number
of nodes, MinIO selects a common denominator that results in an odd number of
Erasure Sets to facilitate more uniform distribution of erasure set drives
among nodes in the Server Pool.

For example, consider a Server Pool consisting of 4 nodes with 8 drives each
for a total of 32 drives. The GCD of 16 produces 2 Erasure Sets of 16 drives 
each with uniform distribution of erasure set drives across all 4 nodes.

Now consider a Server Pool consisting of 5 nodes with 8 drives each for a total
of 40 drives. Using the GCD, MinIO would create 4 erasure sets with 10 drives
each. However, this distribution would result in uneven distribution with
one node contributing more drives to the Erasure Sets than the others. 
MinIO instead creates 5 erasure sets with 8 drives each to ensure uniform
distribution of Erasure Set drives per Nodes.

MinIO generally recommends maintaining an even number of nodes in a Server Pool
to facilitate simplified human calculation of the number and size of
Erasure Sets in the Server Pool.

.. _minio-ec-parity:

Erasure Code Parity (``EC:N``)
------------------------------

MinIO uses a Reed-Solomon algorithm to split objects into data and parity blocks
based on the :ref:`Erasure Set <minio-ec-erasure-set>` size in the deployment.
For a given erasure set of size ``M``, MinIO splits objects into ``N`` parity
blocks and ``M-N`` data blocks. 

MinIO uses the ``EC:N`` notation to refer to the number of parity blocks (``N``)
in the deployment. MinIO defaults to ``EC:4`` or 4 parity blocks per object.
MinIO uses the same ``EC:N`` value for all erasure sets and
:ref:`server pools <minio-intro-server-pool>` in the deployment.

MinIO can tolerate the loss of up to ``N`` drives per erasure set and 
continue performing read and write operations ("quorum"). If ``N`` is equal
to exactly 1/2 the drives in the erasure set, MinIO write quorum requires
``N+1`` drives to avoid data inconsistency ("split-brain").

Setting the parity for a deployment is a balance between availability
and total usable storage. Higher parity values increase resiliency to drive
or node failure at the cost of usable storage, while lower parity provides
maximum storage with reduced tolerance for drive/node failures. 
Use the MinIO `Erasure Code Calculator 
<https://min.io/product/erasure-code-calculator?ref=docs>`__ to explore the
effect of parity on your planned cluster deployment.

The following table lists the outcome of varying erasure code parity levels on
a MinIO deployment consisting of 1 node and 16 1TB drives:

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
     - 12

   * - ``EC: 6``
     - 10 Tebibytes
     - 0.625
     - 10
     - 10

   * - ``EC: 8``
     - 8 Tebibytes
     - 0.500
     - 8
     - 9

.. _minio-ec-storage-class:

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

   Starting with :minio-git:`RELEASE.2021-01-30T00-20-58Z 
   <minio/releases/tag/RELEASE.2021-01-30T00-20-58Z>`, MinIO defaults 
   ``STANDARD`` storage class based on the number of volumes in the Erasure Set:

   .. list-table::
      :header-rows: 1
      :widths: 30 70
      :width: 100%

      * - Erasure Set Size
        - Default Parity (EC:N)

      * - 5 or Fewer 
        - EC:2

      * - 6 - 7
        - EC:3

      * - 8 or more 
        - EC:4

   The maximum value is half of the total drives in the
   :ref:`Erasure Set <minio-ec-erasure-set>`.

   The minimum value is ``2``.

   ``STANDARD`` parity *must* be greater than or equal to
   ``REDUCED_REDUNDANCY``. If ``REDUCED_REDUNDANCY`` is unset, ``STANDARD``
   parity *must* be greater than 2

``REDUCED_REDUNDANCY``
   The ``REDUCED_REDUNDANCY`` storage class allows creating objects with
   lower parity than ``STANDARD``. 

   You can configure the ``REDUCED_REDUNDANCY`` storage class parity using
   either:

   - The :envvar:`MINIO_STORAGE_CLASS_RRS` environment variable, *or*
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


.. _minio-ec-bitrot-protection:

BitRot Protection
-----------------

.. TODO- ReWrite w/ more detail.

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
