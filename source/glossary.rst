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

   audit logs
     Granular descriptions of each operation on a MinIO deployment.
     :ref:`Audit logs <minio-logging>` support security standards and regulations which require detailed tracking of operations.
     
     See also: :term:`server logs`.

   bit rot 
     Data corruption that occurrs without the user’s knowledge. 
     
     MinIO combats bit rot with :term:`hashing` and :term:`erasure coding`.

   bit rot healing
     Objects corrupted due to bit rot automatically restore to a healed state at time of read.
     MinIO captures and heals corrupted objects on the fly with its :term:`hashing` implementation.

   bucket
   buckets
     A grouping of :term:`objects` and associated configurations.

   cluster
     A group of drives and one or more MinIO server processes pooled into a single storage resource.
     
     See also: :term:`tenant`.

   cluster registration
     Cluster registration links a MinIO deployment to a :term:`SUBNET` :ref:`subscription <minio-docs-subnet>`.
     An organization may have more than one MinIO clusters registered to the same SUBNET subscription.

   Console
   MinIO Console
     Graphical User Interface (GUI) for interacting with a MinIO deployment or :term:`tenant`.

   data
     One of the two types of blocks MinIO writes when doing :term:`erasure coding`.
     Data blocks contain the contents of a file.

     :term:`Parity` blocks support data reconstruction should data blocks become corrupt or go missing.

   decommission
     Process of removing a pool of drives from a :term:`distributed` deployment.
     When initiated, the objects on the decommission pool drain by moving to other pools on the deployment.
     
     The process is not reversible.
   
   deployment
     A specific instance of MinIO containing a set of :term:`buckets` and :term:`objects`.

   disk encryption
     The conversion of all of the contents written to a disk to values that cannot be easily deciphered by an unauthorized entity.
     Disk encryption can be used in conjunction with other encryption technologies to create a robust data security system.

   encryption at rest
     A method of encryption that stores an object in an encrypted state.
     The object remains encrypted while not moving from one location to another.

     Objects can be encrypted by the the server using one of key management methods:
     :term:`SSE-KMS`, :term:`SSE-S3`, or :term:`SSE-C`.

   encryption in transit
     A method of encryption that protects an object when moving it from one location to another, such as during a GET request.
     The object may or may not be encrypted on the origin or destination storage devices.
   
   erasure coding
     A technology that splits :term:`objects` into multiple shards and writes the shards to multiple, separate disks.
     
     Depending on the :term:`topology` used, erasure coding allows for loss of drives or nodes within a MinIO deployment without losing read or write access.

   erasure set
     A group of drives within MinIO that support :term:`erasure coding`. 
     MinIO divides the number of drives in a deployment's server pool into groups of 4 to 16 drives that make up each *erasure set*.
     When writing objects, :term:`data` and :term:`parity` blocks write randomly to the drives in the erasure set.

   hashing
     The use of an algorithm to create a unique, fixed-length string (a `value`) to identify a piece of data.
   
   healing
     Restoration of data from partial loss due to bit rot, drive failure, or site failure.

   health diagnostics
     A suite of MinIO :ref:`API endpoints <minio-healthcheck-api>` available to check whether a server is
     
     - online 
     - available for writing data
     - available for reading data
     - available for maintenance without affecting the cluster's read and write operations

   host bus adapter
   HBA 
     A circuit board or integrated circuit adapter that connects a host system to a storage device.
     The :abbr:`HBA (host bus adapter)` handles processing to reduce load on the host system's processor.

   IAM integration
     MinIO only allows access to data for authenticated users.
     MinIO provides a built-in identity management solution to create authorized credentials.
     Optionally, MinIO users can authenticate with credentials from a 3rd party identify provider (IDP), including either OpenID or LDAP providers.

   JBOD 
     Initialism for "Just A Bunch of Disks".
     JBOD is a storage device enclosure that holds many hard drives.
     These drives can combine into one logical drive unit.
     
     See also: :term:`RAID`

   lifecycle management
   ILM
     Rules to determine when :term:`objects` should move or expire.

   locking
     A rule that prevents removal or deletion of an object until an authorized agent removes the rule or it expires.

   monitoring
     The act of reviewing the status, activity, and availability of a MinIO cluster, deployment, tenant, or server.
     MinIO provides the following tools: 

     - `Prometheus <https://prometheus.io/>`__ compatible metrics and alerts
     - :term:`Audit logs`
     - :term:`server logs`
     - :ref:`Healthcheck API endpoints <minio-healthcheck-api>`
     - :ref:`Bucket notifications <minio-bucket-notifications>`

   multi-node multi-drive
   MNMD
   distributed
     A system :term:`topology` that uses more than one server and more than one drive per server to host a MinIO instance.
     MinIO recommends Kubernetes for distributed deployments.

   network encryption
     A method of securing data during transit from one location to another, such as server-server or client-server.
     MinIO supports :ref:`Transport Layer Security (TLS) <minio-tls>`, version 1.2 and later, for both incoming and outgoing traffic.

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
   mirror
     The replication of a :ref:`bucket <minio-bucket-replication>` or entire :ref:`site <minio-site-replication-overview>` to another location.

   scanner 
   MinIO Scanner
     One of several low-priority processes MinIO runs to check:
     
     - lifecycle management rules requiring object transition
     - bucket or site replication status
     - object :term:`bit rot` and healing

   self signed certificates
     A self-signed certificate is one created by, issued by, and signed by the company or developer responsible for the content the certificate secures.
     Self-signed certificates are not issued by or signed by a publicly trusted, third-party Certificate Authority (CA).
     These types of certificates do not expire or require periodic review, and they cannot be revoked.

   server logs
     Records the ``minio server`` operations logged to the system console.
     :ref:`Server logs <minio-logging>` support general monitoring and troubleshooting of operations.

     For more detailed logging information, see :term:`audit logs`.

   server pool
     A set of ``minio server`` nodes which combine their drives and resources to support object storage and retrieval requests.

   service account
     A MinIO deployment or tenant user account with limited account typically used with API calls.

   single-node multi-drive
   SNMD
     A system :term:`topology` that deploys MinIO on one compute resource with more than one attached volume.

   single-node single-drive
   SNSD
   filesystem
     A system :term:`topology` that deploys MinIO on a single compute resource with a single drive.
     This adds S3-type functionality to an otherwise standard filesystem. 

   SSE-C
     A method of :term:`encryption at rest` that encrypts an object at the time of writing with an encryption key included with the write request.
     To retrieve the object, you must provide the same encryption key provided when originally writing the object.
     Additionally, you must self-manage the encryption key(s) used.

     See also: :term:`SSE-KMS`, :term:`SSE-S3`, :term:`encryption at rest`, :term:`network encryption`.

   SSE-KMS
     A method of :term:`encryption at rest` that encrypts each object at the time of writing with separate keys managed by a service provider.
     Use keys at either the bucket level (default) or at the object level.
     MinIO recommends the SSE-KMS method for key management of encryption.

     See also: :term:`SSE-S3`, :term:`SSE-C`, :term:`encryption at rest`, :term:`network encryption`.

   SSE-S3
     A method of :term:`encryption at rest` that encrypts each object at the time of writing with a single key for all objects on a deployment.
     A deployment uses a single external key to decrypt any object throughout the deployment.

     See also: :term:`SSE-KMS`, :term:`SSE-C`, :term:`encryption at rest`, :term:`network encryption`.
   
   SUBNET
     `MinIO's Subscription Network <|SUBNET|>`__ tracks support tickets and provides 24 hour direct-to-engineer access for subscribed accounts.

   tenant
   tenants
     In a :term:`distributed` mode, a specific MinIO deployment.
     One instance of the MinIO Operator may have multiple tenants.

   topology
     The hardware configuration used for a deployment.
     MinIO works with three topologies:
     
     - :term:`multi-node multi-drive`
     - :term:`single-node multi-drive`
     - :term:`single-node single-drive`

   versioning
     The retention of multiple iterations of an :term:`object` as it changes over time.
  
   webhook
     A :ref:`webhook <minio-bucket-notifications-publish-webhook>` is a method for altering the behavior of a web page or web application with a custom callback.
     The format is typically :abbr:`JSON (JavaScript Object Notation)` sent as an HTTP POST request.

   WORM
     Write Once Read Many (WORM) is a data retention methodology that functions as part of object locking.
     Many requests can retrieve can view a WORM-locked object (``read many``), but no write requests can change the object (``write once``).
