.. _minio-concepts-healing:

==============
Object Healing
==============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

What is healing?
----------------

Healing is MinIO's ability to restore an object that has been damaged, corrupted, or partially lost.
The loss can come from random corruptions in the form of 
- :ref:`bit rot <minio-ec-bitrot>`
- the loss of one or more drives due to failure or outages
- the corruption or loss of one or more shards of an object for other reasons

Healing and Erasure Coding
--------------------------

The ability of MinIO to restore a damaged object relates directly to the following:

- total number of drives in the :ref:`erasure set <minio-erasure-coding>` where the object exists
- :ref:`parity setting <minio-ec-parity>` for the erasure set

  Parity refers to the number of extra shards MinIO create when writing the object.
  For example, an erasure set may have eight total drives and use three drives during a write for parity.
  In that scenario, MinIO splits the object into five parts written to five of the drives.
  MinIO uses the remaining three drives in the erasure set for parity shards.

  When MinIO needs to provide the object, it looks for the data shards for the object.
  If any of the data shards are missing or damaged, MinIO uses the parity shards to restore the object.
  For this scenario, up to three of data shard parts can be lost or damaged and MinIO can still successfully restore and serve the object. 
- number of drives available with intact parts of the object

  The number of drives available with intact data or parity shards of the object must meet or exceed the number of drives used for data shards in the erasure set.
  In the scenario above, five drives with intact shards must be online and available for MinIO to successfully serve the object.

When does MinIO heal an object?
-------------------------------

MinIO has a robust system for healing objects.

Healing during ``GET`` requests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO automatically checks the consistency of an object's data shards each time you request an object with a ``GET`` operation.

If all data shards are found intact, MinIO takes no further action on the object and serves the object from the data shards.

If MinIO finds missing or damaged data shards, MinIO utilizes the available parity shards to heal the object before serving it as part of the ``GET`` operation.
There **must** be a parity shard available for each lost or damaged data shard.

Healing with the object scanner
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO utilizes an :ref:`object scanner <minio-concepts-scanner>` to perform a number of tasks related to objects.
One of these tasks checks the integrity of objects and, if found damaged or corrupted, heals them.

On each scanning pass, MinIO selects one out of every 1,024 objects to check.
MinIO chooses the objects based on a hash of the object name.

If any object is found to have lost data shards, MinIO heals the object from available parity shards.
By default, MinIO does *not* check for :term:`bit rot` corruption using the scanner, as it can be an expensive operation to perform while bit rot is a low risk across multiple disks.

Healing by manual request
~~~~~~~~~~~~~~~~~~~~~~~~~

Administrators can use :mc:`mc admin heal` to initiate a full system healing.
The procedure is very resource intensive and not typically needed.

Consult with MinIO Engineers before manually starting a healing process on a deployment.

Healing metrics
---------------

MinIO provides several `healing metrics <https://min.io/docs/minio/linux/operations/monitoring/metrics-and-alerts.html#healing-metrics>`__ to monitor the status of healing processes on a deployment.

Refer to the :ref:`minio-metrics-and-alerts` for more information on available endpoints and configuration.

.. _minio-concepts-healing-colors:

Healing Output Color Key
------------------------

Originally, the healing mechanism output a table that used a Green-Yellow-Red-Gray color key to attempt to differentiate the status of objects in healing.
These colors have been deprecated in favor of more detailed :ref:`healing metrics available at the cluster level <minio-metrics-and-alerts-available-metrics>`.

The following table describes the intent of each of the deprecated color keys.

.. list-table::
   :widths: 25 75
   :width: 100%

   * - **Green**
     - *Healthy*, the object has all data and parity shards available as required to serve the object
 
   * - **Yellow** 
     - *Healing*, the object is still in the process of healing, and there are sufficient data or parity shards available to complete the healing

   * - **Red** 
     - *Unhealthy*, the object has lost one or more shards and requires healing

   * - **Grey** 
     -  *Unrecoverable*, the object has lost too many data and/or parity shards and cannot be healed or recovered

