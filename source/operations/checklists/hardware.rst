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

Hardware Requirements
---------------------

The following checklist provides a minimum hardware specification for production MinIO deployments. 
While MinIO can run on commodity or "budget" hardware, we strongly recommend using this table as guidance for best results in production environments.

.. note:: 

   See our `Reference Hardware <https://min.io/product/reference-hardware?ref-docs>`__ page for a curated selection of servers and storage components from our hardware partners.

   MinIO does not provide hosted services or hardware sales.

.. list-table::
   :widths: auto
   :width: 100%

   * - :octicon:`circle`
     - | Sufficient CPU cores to achieve performance goals for hashing (for example, for healing) and encryption
       | MinIO recommends Dual Intel® Xeon® Scalable Gold CPUs (minimum 8 cores per socket) or any CPU with AVX512 instructions

   * - :octicon:`circle`
     - | Sufficient RAM to achieve performance goals based on the number of drives and anticipated concurrent requests (see the :ref:`formula and reference table <minio-requests-per-node>`)
       | Refer to the information on :ref:`memory allocation <minio-k8s-production-considerations-memory>` for recommended RAM amounts 

   * - :octicon:`circle`
     - | Four nodes or servers
       | For containers or Kubernetes in virtualized environments, MinIO requires four distinct physical nodes.

   * - :octicon:`circle`
     - | SATA/SAS drives for capacity and NVMe SSDs for high-performance
       | MinIO recommends a minimum of 8 drives per server

   * - :octicon:`circle`
     - | 25GbE network for capacity 
       | 100GbE Network interface cards for high performance

.. important:: 

   The following areas have the greatest impact on MinIO performance, listed in order of importance:

   - Network infrastructure (insufficient or limited throughput)
   - Storage controller (old firmware; limited throughput)
   - Storage (old firmware; slow, aged, or failing drives)

   Prioritize upgrading these areas before focusing on compute-related performance constraints.
   
   For example:

   The following examples of network throughput constraints assume spinning disks with ~100MB/S sustained I/O

   - 1GbE network link can support up to 125MB/s, or one spinning disk
   - 10GbE network can support approximately 1.25GB/s, potentially supporting 10-12 spinning disk
   - 25GbE network can support approximately 3.125GB/s, potentially supporting ~30 disks

   The recommended minimum MinIO cluster of 4 nodes with 4 drives each (16 total disks) requires a 25GbE network to support the total potential aggregate throughput.
   For best performance, have a minimum of eight drives per node.

   MinIO takes full advantage of the modern hardware improvements such as AVX-512 SIMD acceleration, 100GbE networking, and NVMe SSDs, when available.

Recommended Hardware Tests
--------------------------

MinIO Diagnostics
~~~~~~~~~~~~~~~~~

Run the built in health diagnostic tool.
If you have access to :ref:`SUBNET <minio-docs-subnet>`, you can upload the results there.

.. code-block:: shell
   :class: copyable

   mc support diag ALIAS --airgap

Replace ALIAS with the :mc-cmd:`~mc alias` defined for the deployment.

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

If you cannot run the :mc:`mc support diagnostics` or the results show unexpected results, you can use the operating system's default tools.

Test each drive independently on all servers to ensure they are identical in performance.
Use the results of these OS-level tools to verify the capabilities of your storage hardware.
Record the results for later reference.

#. Test the drive's performance during write operations

   This tests checks a drive's ability to write new data (uncached) to disk by creating a specified number of blocks at up to a certain number of bytes at a time to mimic how a drive would function with writing uncached data. 
   This allows you to see the actual drive performance with consistent file I/O.
   
   .. code-block::
      :class: copyable

      dd if=/dev/zero of=/mnt/driveN/testfile bs=128k count=80000 oflag=direct conv=fdatasync > dd-write-drive1.txt

   Replace ``driveN`` with the path for the disk you are testing.

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

   Replace ``driveN`` with the path for the disk you are testing.

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
     - Number of threads (:math:`numberOfDisks * 16`)
   * - ``-F <>``  
     - list of files (the above command tests with 16 files per disk)  
