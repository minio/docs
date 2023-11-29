.. start-linux-hardware-checklist

.. list-table::
   :header-rows: 1
   :widths: 5 45 25 25
   :width: 100%

   * - 
     - Description
     - Minimum
     - Recommended

   * - :octicon:`circle`
     - Dedicated Baremetal or Virtual Hosts ("hosts").

     - 4 dedicated hosts
     - 8+ dedicated hosts

   * - :octicon:`circle`
     - :ref:`Dedicated locally-attached drives for each host <minio-hardware-checklist-storage>`.

     - 4 drives per MinIO Server
     - 8+ drives per MinIO Server

   * - :octicon:`circle`
     - :ref:`High speed network infrastructure <minio-hardware-checklist-network>`.
     - 25GbE
     - 100GbE

   * - :octicon:`circle`
     - Server-grade CPUs with support for modern SIMD instructions (AVX-512), such as Intel® Xeon® Scalable or better.
     - 8 CPU/socket or vCPU per host
     - 16+ CPU/socket or vCPU per host

   * - :octicon:`circle`
     - :ref:`Available memory to meet and exceed per-server usage <minio-hardware-checklist-memory>` by a reasonable buffer.
     - 32GB of available memory per host
     - 128GB+ of available memory per host

.. end-linux-hardware-checklist

.. start-k8s-hardware-checklist

.. list-table::
   :header-rows: 1
   :widths: 5 55 20 20
   :width: 100%

   * - 
     - Description
     - Minimum
     - Recommended

   * - :octicon:`circle`
     - Kubernetes worker nodes to exclusively service the MinIO Tenant.

     - 4 workers per Tenant
     - 8+ workers per Tenant

   * - :octicon:`circle`
     - :ref:`Dedicated Persistent Volumes for the MinIO Tenant <minio-hardware-checklist-storage>`.

     - 4 PV per MinIO Server pod
     - 8+ PV per MinIO Server pod

   * - :octicon:`circle`
     - :ref:`High speed network infrastructure <minio-hardware-checklist-network>`.
     - 25GbE
     - 100GbE
       

   * - :octicon:`circle`
     - Server-grade CPUs with support for modern SIMD instructions (AVX-512), such as Intel® Xeon® Scalable or better.
     - 4 vCPU per MinIO Pod
     - 8+ vCPU per MinIO Pod

   * - :octicon:`circle`
     - :ref:`Available memory to meet and exceed per-server usage <minio-hardware-checklist-memory>` by a reasonable buffer.
     - 32GB of available memory per worker node
     - 128GB+ of available memory per worker node

.. end-k8s-hardware-checklist