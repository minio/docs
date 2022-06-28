========
Glossary
========

.. glossary::
   :sorted:

   bucket
   buckets
     A grouping of :term:`objects`.

   Console
   MinIO Console
     Graphical User Interface (GUI) used to interact with a MinIO deployment or :term:`tenant`.

   decommission
     Process of removing a pool of drives from a :term:`distributed` deployment.
     When initiated, the objects on the decommission pool drain by moving to other pools on the deployment.
     The process is not reversible.
   
   deployment
     A specific instance of MinIO containing a set of :term:`buckets` and :term:`objects`.

   erasure coding
     A technology that splits :term:`objects` into multiple shards and writes the shards to separate multiple disks.
     Depending on the :term:`topology` used, erasure coding allows for loss of drives or nodes within a MinIO deployment without losing read or write access.

   lifecycle management
   ILM
     Rules to determine when :term:`objects` should move or expire.

   locking
     A rule that prevents removal or deletion of an object until an authorized agent removes the rule or it expires.

   multi-node multi-drive
   MNMD
   distributed
     A system :term:`topology` that uses more than one server and more than one drive per server to host a MinIO instance.
     MinIO recommends Kubernetes for distributed deployments.

   object
   objects
     An item of data MinIO interacts with using an S3-compatible API.
     Objects can be grouped into :term:`buckets`.

   Operator
   Operator Console
     The Graphical User Interface (GUI) to deploy and manage the MinIO :term:`tenants` in a distributed deployment environment.
   
   replication
     The duplication of a :ref:`bucket <minio-bucket-replication>` or entire :ref:`site <minio-site-replication-overview>` to another location.
   
   service account
     A MinIO deployment or tenant account with limited account typically used with API calls.

   single-node multi-drive
   SNMD
     A system :term:`topology` that deploys MinIO on one compute resource with more than one attached volume.

   single-node single-drive
   SNSD
   filesystem
     A system :term:`topology` that deploys MinIo on a single compute resource with a single drive.
     This adds S3-type functionality to an otherwise standard filesystem mode. 
   
   SUBNET
     MinIO's Subscription Network tracks support tickets and providers 24 hour direct-to-engineer access for subscribed accounts.

   tenant
     In a :term:`distributed` mode, a specific MinIO deployment.
     One instance of the MinIO Operator may have multiple tenants.

   topology
     The hardware configuration used for a deployment.
     MinIO works with three topologies:
     
     - :term:`multi-node multi-drive`
     - :term:`single-node multi-drive`
     - :term:`signle-node signle-drive`

   versioning
     The retention of multiple iterations of an object as it changes over time.