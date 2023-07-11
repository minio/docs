.. _minio-hardware-checklist:

==================
Hardware Checklist
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Use the following checklist when planning the hardware configuration for a production, distributed MinIO deployment.

Considerations
--------------

When selecting hardware for your MinIO implementation, take into account the following factors:

- Expected amount of data in tebibytes to store at launch
- Expected growth in size of data for at least the next two years
- Number of objects by average object size
- Average retention time of data in years
- Number of sites to be deployed
- Number of expected buckets

.. _deploy-minio-distributed-recommendations:

Production Hardware Recommendations
-----------------------------------

The following checklist follows MinIO's `Recommended Configuration <https://min.io/product/reference-hardware?ref-docs>`__ for production deployments.
The provided guidance is intended as a baseline and cannot replace |subnet| Performance Diagnostics, Architecture Reviews, and direct-to-engineering support.

.. admonition:: MinIO does not provide hosted services or hardware sales
   :class: important

   See our `Reference Hardware <https://min.io/product/reference-hardware#hardware?ref-docs>`__ page for a curated selection of servers and storage components from our hardware partners.

.. list-table::
   :widths: auto
   :width: 100%

   * - :octicon:`circle`
     - Sufficient CPU cores to achieve performance goals for hashing (for example, for healing) and encryption
       
       MinIO recommends Single Socket Intel® Xeon® Scalable Gold CPUs (minimum 16 cores per socket).

   * - :octicon:`circle`
     - Sufficient RAM to achieve performance goals based on the number of drives and anticipated concurrent requests (see the :ref:`formula and reference table <minio-hardware-checklist-memory>`).

       MinIO recommends a minimum of 128GB of memory per node for best performance.

   * - :octicon:`circle`
     - .. cond:: k8s

          MinIO requires a *minimum* of 4 worker nodes per MinIO Tenant.

          MinIO strongly recommends allocating worker nodes dedicated to servicing the MinIO Tenant.
          Colocating multiple high-performance services on the same nodes can result in resource contention and reduced overall performance.

       .. cond:: linux or container or macos or windows

          MinIO recommends a *minimum* of 4 host servers per distributed deployment.

          MinIO strongly recommends hardware dedicated to servicing the MinIO Tenant.
          Colocating multiple high-performance services on the same servers can result in resource contention and reduced overall performance.

   * - :octicon:`circle`
     - .. cond:: k8s

          MinIO recommends a minimum of 4 Persistent Volumes per MinIO Server pod.
          For better performance and storage efficiency, use 8 or more PV per server.

       .. cond:: linux or container or macos or windows

          MinIO recommends a minimum of 4 locally attached drives per MinIO Server.
          For better performance and storage efficiency, use 8 or more drives per server.

       Use the same type of drive (NVMe, SSD, or HDD) with the same capacity across all nodes in the deployment.

   * - :octicon:`circle`
     - | 25GbE Network as a baseline 
       | 100GbE Network for high performance

.. important:: 

   The following areas have the greatest impact on MinIO performance, listed in order of importance:

   .. list-table:: 
      :stub-columns: 1
      :widths: auto
      :width: 100%

      * - Network Infrastructure
        - Insufficient or limited throughput constrains performance
      
      * - Storage Controller
        - Old firmware, limited throughput, or failing hardware constrains performance and affects reliability

      * - Storage (Drive)
        - Old firmware, or slow/aging/failing hardware constrains performance and affects reliability

   Prioritize securing the necessary components for each of these areas before focusing on other hardware resources, such as compute-related constraints.

The minimum recommendations above reflect MinIO's experience with assisting enterprise customers in deploying on a variety of IT infrastructures while maintaining the desired SLA/SLO. 
While MinIO may run on less than the minimum recommended topology, any potential cost savings come at the risk of decreased reliability, performance, or overall functionality.

Networking
~~~~~~~~~~

MinIO recommends high speed networking to support the maximum possible throughput of the attached storage (aggregated drives, storage controllers, and PCIe busses). The following table provides a general guideline for the maximum storage throughput supported by a given physical or virtual network interface.
This table assumes all network infrastructure components, such as routers, switches, and physical cabling, also supports the NIC bandwidth.

.. list-table::
   :widths: auto
   :width: 100%

   * - NIC Bandwidth (Gbps)
     - Estimated Aggregated Storage Throughput (GBps)

   * - 10GbE
     - 1.25GBps

   * - 25GbE
     - 3.125GBps

   * - 50GbE
     - 6.25GBps

   * - 100GbE
     - 12.5GBps

Networking has the greatest impact on MinIO performance, where low per-host bandwidth artificially constrains the potential performance of the storage.
The following examples of network throughput constraints assume spinning disks with ~100MB/S sustained I/O

- 1GbE network link can support up to 125MB/s, or one spinning disk
- 10GbE network can support approximately 1.25GB/s, potentially supporting 10-12 spinning disk
- 25GbE network can support approximately 3.125GB/s, potentially supporting ~30 spinning disks

.. _minio-hardware-checklist-memory:

Memory
~~~~~~

Memory primarily constrains the number of concurrent simultaneous connections per node.

You can calculate the maximum number of concurrent requests per node with this formula:

   :math:`totalRam / ramPerRequest`

To calculate the amount of RAM used for each request, use this formula:

   :math:`((2MiB + 128KiB) * driveCount) + (2 * 10MiB) + (2 * 1 MiB)`

   10MiB is the default erasure block size v1.
   1 MiB is the default erasure block size v2.

The following table lists the maximum concurrent requests on a node based on the number of host drives and the *free* system RAM:

.. list-table::
   :header-rows: 1
   :width: 100%

   * - Number of Drives
     - 32 GiB of RAM
     - 64 GiB of RAM
     - 128 GiB of RAM
     - 256 GiB of RAM
     - 512 GiB of RAM

   * - 4 Drives
     - 1,074 
     - 2,149 
     - 4,297 
     - 8,595 
     - 17,190 

   * - 8 Drives
     - 840 
     - 1,680 
     - 3,361 
     - 6,722 
     - 13,443 

   * - 16 Drives
     - 585 
     - 1,170 
     - 2.341 
     - 4,681 
     - 9,362 

The following table provides general guidelines for allocating memory for use by MinIO based on the total amount of local storage on the node:

.. list-table::
   :header-rows: 1
   :width: 100%
   :widths: 40 60

   * - Total Host Storage
     - Recommended Host Memory

   * - Up to 1 Tebibyte (Ti)
     - 8GiB

   * - Up to 10 Tebibyte (Ti)
     - 16GiB

   * - Up to 100 Tebibyte (Ti)
     - 32GiB
   
   * - Up to 1 Pebibyte (Pi)
     - 64GiB

   * - More than 1 Pebibyte (Pi)
     - 128GiB

Storage
~~~~~~~

MinIO recommends selecting the type of drive based on your performance objectives.
The following table highlights the general use case for each drive type based on cost and performance:

NVMe/SSD - Hot Tier
HDD - Warm

.. list-table::
   :header-rows: 1
   :widths: auto
   :width: 100%

   * - Type
     - Cost
     - Performance
     - Tier

   * - NVMe
     - High
     - High
     - Hot

   * - SSD
     - Balanced
     - Balanced
     - Hot/Warm

   * - HDD
     - Low
     - Low
     - Cold/Archival

Use the same type of drive (NVME, SSD, HDD) with the same capacity across all nodes in a MinIO deployment.
MinIO does not distinguish drive types when using the underlying storage and does not benefit from mixed storage types.

Use the same capacity of drive across all nodes in the MinIO :ref:`server pool <minio-intro-server-pool>`. 
MinIO limits the maximum usable size per drive to the smallest size in the deployment.
For example, if a deployment has 15 10TB drives and 1 1TB drive, MinIO limits the per-drive capacity to 1TB.

Recommended Hardware Tests
--------------------------

MinIO Diagnostics
~~~~~~~~~~~~~~~~~

Run the built in health diagnostic tool.
If you have access to :ref:`SUBNET <minio-docs-subnet>`, you can upload the results there.

.. code-block:: shell
   :class: copyable

   mc support diag ALIAS --airgap

Replace ALIAS with the :mc:`~mc alias` defined for the deployment.

MinIO Support Diagnostic Tools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For deployments registered with MinIO |subnet-short|, you can run the built-in support diagnostic tools.

Run the three :mc:`mc support perf` tests.
   
These server-side tests validate network, drive, and object throughput.
Run all three tests with default options.

#. Network test

   Run a network throughput test on a cluster with alias ``minio1``.

   .. code-block:: shell
      :class: copyable

      mc support perf net minio1

#. Drive test

   Run drive read/write performance measurements on all drive on all nodes for a cluster with alias ``minio1``.
   The command uses the default blocksize of 4MiB.

   .. code-block:: shell
      :class: copyable
 
      mc support perf drive minio1

#. Object test

   Measure the performance of S3 read/write of an object on the alias ``minio1``.
   MinIO autotunes concurrency to obtain maximum throughput and IOPS (Input/Output Per Second).

   .. code-block:: shell
      :class: copyable
 
      mc support perf object minio1

Operating System Diagnostic Tools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you cannot run the :mc:`mc support diag` or the results show unexpected results, you can use the operating system's default tools.

Test each drive independently on all servers to ensure they are identical in performance.
Use the results of these OS-level tools to verify the capabilities of your storage hardware.
Record the results for later reference.

#. Test the drive's performance during write operations

   This tests checks a drive's ability to write new data (uncached) to the drive by creating a specified number of blocks at up to a certain number of bytes at a time to mimic how a drive would function with writing uncached data. 
   This allows you to see the actual drive performance with consistent file I/O.
   
   .. code-block::
      :class: copyable

      dd if=/dev/zero of=/mnt/driveN/testfile bs=128k count=80000 oflag=direct conv=fdatasync > dd-write-drive1.txt

   Replace ``driveN`` with the path for the drive you are testing.

   .. list-table::
      :widths: auto
      :width: 100%

      * - ``dd``
        - The command to copy and paste data.
      * - ``if=/dev/zero``
        - Read from ``/dev/zero``, an system-generated endless stream of 0 bytes used to create a file of a specified size
      * - ``of=/mnt/driveN/testfile``
        - Write to ``/mnt/driveN/testfile``
      * - ``bs=128k``
        - Write up to 128,000 bytes at a time
      * - ``count=80000``
        - Write up to 80000 blocks of data
      * - ``oflag=direct``
        - Use direct I/O to write to avoid data from caching
      * - ``conv=fdatasync``
        - Physically write output file data before finishing
      * - ``> dd-write-drive1.txt``
        - Write the contents of the operation's output to ``dd-write-drive1.txt`` in the current working directory

   The operation returns the number of files written, total size written in bytes, the total length of time for the operation (in seconds), and the speed of the writing in some order of bytes per second.

#. Test the drive's performance during read operations

   .. code-block::
      :class: copyable

      dd if=/mnt/driveN/testfile of=/dev/null bs=128k iflag=direct > dd-read-drive1.txt

   Replace ``driveN`` with the path for the drive you are testing.

   .. list-table::
      :widths: auto
      :width: 100%

      * - ``dd``
        - The command to copy and paste data
      * - ``if=/mnt/driveN/testfile``
        - Read from ``/mnt/driveN/testfile``; replace with the path to the file to use for testing the drive's read performance
      * - ``of=/dev/null``
        - Write to ``/dev/null``, a virtual file that does not persist after the operation completes
      * - ``bs=128k``
        - Write up to 128,000 bytes at a time
      * - ``count=80000``
        - Write up to 80000 blocks of data
      * - ``iflag=direct``
        - Use direct I/O to read and avoid data from caching
      * - ``> dd-read-drive1.txt``
        - Write the contents of the operation's output to ``dd-read-drive1.txt`` in the current working directory

   Use a sufficiently sized file that mimics the primary use case for your deployment to get accurate read test results.
   
   The following guidelines may help during performance testing:

   - Small files: < 128KB
   - Normal files: 128KB – 1GB
   - Large files: > 1GB

   You can use the ``head`` command to create a file to use.
   The following command example creates a 10 Gigabyte file called ``testfile``.

   .. code-block:: shell
      :class: copyable

      head -c 10G </dev/urandom > testfile

   The operation returns the number of files read, total size read in bytes, the total length of time for the operation (in seconds), and the speed of the reading in bytes per second.

Third Party Diagnostic Tools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

IO Controller test
   
Use `IOzone <http://iozone.org/>`__ to test the input/output controller and all drives in combination.
Document the performance numbers for each server in your deployment.

.. code-block:: shell
   :class: copyable

   iozone -s 1g -r 4m -i 0 -i 1 -i 2 -I -t 160 -F /mnt/sdb1/tmpfile.{1..16} /mnt/sdc1/tmpfile.{1..16} /mnt/sdd1/tmpfile.{1..16} /mnt/sde1/tmpfile.{1..16} /mnt/sdf1/tmpfile.{1..16} /mnt/sdg1/tmpfile.{1..16} /mnt/sdh1/tmpfile.{1..16} /mnt/sdi1/tmpfile.{1..16} /mnt/sdj1/tmpfile.{1..16} /mnt/sdk1/tmpfile.{1..16} > iozone.txt

.. list-table::
   :widths: auto
   :width: 100%

   * - ``-s 1g``
     - Size of 1G per file
   * - ``-r`` 
     - 4m  4MB block size
   * - ``-i #``   
     - 0=write/rewrite, 1=read/re-read, 2=random-read/write
   * - ``-I``     
     - Direct-IO modern
   * - ``-t N``   
     - Number of threads (:math:`numberOfDrives * 16`)
   * - ``-F <>``  
     - list of files (the above command tests with 16 files per drive)  
