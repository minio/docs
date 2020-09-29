=====================
Deployment Topologies
=====================

.. default-domain:: minio

MinIO supports three deployment topologies:

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Deployment Type
     - Description

   * - :ref:`Standalone <minio-deployment-standalone>`
     - A single MinIO server.

       Standalone deployments are ideal for local development and evaluation.

   * - :ref:`Distributed <minio-deployment-distributed>`
     - Multiple MinIO servers allow for horizontal scaling of storage while
       allowing applications to treat the deployment as a single MinIO 
       instance. 

       Distributed deployments are ideal for production environments. 

   * - :ref:`Active-Active <minio-deployment-active-active>`
     - Multiple distributed deployments with intra-deployment
       replication to synchronize :ref:`objects <objects>` across
       deployments.

       Active-Active Distributed deployments are ideal for production 
       environments with globally distributed applications, where applications
       prefer routing to the geographically-nearest MinIO instance. 

.. _minio-deployment-standalone:

Standalone Deployment
---------------------

TBD:
- Add a diagram of a standalone deployment
- List the drawbacks (if any)
- Link to deployment tutorials (kubernetes, bare-metal)

.. _minio-deployment-distributed:
.. _minio-zones:

Distributed Deployment
----------------------

TBD:
- Add a diagram of a distributed deployment
- List the drawbacks (if any)
- Link to deployment tutorials (kubernetes, bare-metal)
- Discuss horizontal expansion / zones

.. _minio-deployment-active-active:

Active-Active
-------------

TBD:
- Add a diagram of a distributed deployment
- List the drawbacks (if any)
- Link to deployment tutorials (kubernetes, bare-metal)