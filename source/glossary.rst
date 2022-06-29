========
Glossary
========

.. glossary::
   :sorted:

   active-active
     A method of :term:`replication` that provides bidirectional mirroring of data.
     With active-active configuration, changing the data at at any storage location also changes the data at the other storage location(s).
     See also: :term:`active-passive`.

   active-passive
     A method of :term:`replication` that provides one-way mirroring of data.
     With the active-passive configuration, changing data at the originating location also changes the data at the destination.
     However, changing data at the destination does not affect the data on the origin.
     See also: :term:`active-active`.

   bitrot 
     Data corruption that occurrs without the user’s knowledge. 
     Some common reasons for bitrot include:
     
     - ageing drives
     - current spikes
     - bugs in disk firmware
     - phantom writes
     - misdirected reads/writes
     - driver errors
     - accidental overwrites
     
     MinIO combats bitrot with :term:`hashing` and :term:`erasure coding`.

   bitrot healing
     Objects corrupted due to bitrot automatically restore to a healed state at time of read.
     MinIO captures and heals corrupted objects on the fly with its :term:`hashing` implementation.

   bucket
   buckets
     A grouping of :term:`objects` and associated configurations.

   Console
   MinIO Console
     Graphical User Interface (GUI) used to interact with a MinIO deployment or :term:`tenant`.

   data
     One of the two types of blocks MinIO writes when doing :term:`erasure coding`.
     Data blocks contain the contents of a file.
     :term:`parity` blocks support data reconstruction should data blocks become corrupt or go missing.


   decommission
     Process of removing a pool of drives from a :term:`distributed` deployment.
     When initiated, the objects on the decommission pool drain by moving to other pools on the deployment.
     The process is not reversible.
   
   deployment
     A specific instance of MinIO containing a set of :term:`buckets` and :term:`objects`.

   encryption at rest
     A method of encryption that stores an object in an encrypted state.
     The object remains encrypted while not moving from one location to another.

   encryption in transit
     A method of encryption that encrypts an object when moving it from one location to another, such as during a GET request.
     The object may or may not be encrypted on the origin or destination storage devices.
   
   erasure coding
     A technology that splits :term:`objects` into multiple shards and writes the shards to separate multiple disks.
     Depending on the :term:`topology` used, erasure coding allows for loss of drives or nodes within a MinIO deployment without losing read or write access.

   erasure set
     A group of drives within MinIO that support :term:`erasure coding`. 
     MinIO divides the number of drives in a deployment's server pool into groups of 4 to 16 drives that make up each _erasure set_.
     When writing objects, :term:`data` and :term:`parity` blocks write randomly to the drives in the erasure set.

   JBOD 
     Initialism for "Just A Bunch of Disks".
     JBOD is a storage device enclosure that holds many hard drives.
     These drives can combine into one logical drive unit.
     See also: :term:`RAID`

   lifecycle management
   Data Lifecycle Management
   Object Lifecycle Management
   Information Lifecycle Management
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

   parity
     The portion of blocks written for an object by MinIO to support data reconstruction due to missing or corrupt data blocks.
     The number of parity blocks indicates the number of drives in the :term:`erasure set` that a deployment can lose while still retaining read and write operations.

   prefix
     Prefixes organize the :term:`objects` in a :term:`bucket` by assigning the same string of characters to objects that should share a similar hierarchy or structure.
     Use a delimiter character, typically a `/` to add layers to the hierarchy.
     While prefixed objects may resemble a directory structure in some file systems, prefixes are not directories.

   RAID
     Initialism for "Redundant Array of Independent Disks".
     The technology merges multiple separate physical disks into a single storage unit or array.
     Some RAID levels provide data redundancy or fault tolerance by duplicating data, striping data, or mirroring data across physical disks.
     See also: :term:`JBOD`.

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
     The retention of multiple iterations of an :term:`object` as it changes over time.
  

..

  To define:
  
   audit Logs
   cluster registration 
   disk encryption
   hashing
   HBA 
   health diagnostics
   IAM integration
   monitoring
   network encryption
   scanner | MinIO Scanner
   self signed certificates
   server pool
   SSE-C 
   SSE-KMS
   SSE-S3 
   webhook
