============================
Core Administration Concepts
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The following core concepts are fundamental to the administration of MinIO deployments, including but not limited to object retention, encryption, and access management.

What Is Object Storage?
-----------------------

.. _objects:

An :ref:`object <objects>` is binary data, sometimes referred to as a Binary Large OBject (BLOB). 
Blobs can be images, audio files, spreadsheets, or even binary executable code. 
Object Storage platforms like MinIO provide dedicated tools and capabilities for storing, retrieving, and searching for blobs. 

.. _buckets:

MinIO Object Storage uses :ref:`buckets <buckets>` to organize objects. 
A bucket is similar to a folder or directory in a filesystem, where each bucket can hold an arbitrary number of objects. 
MinIO buckets provide the same functionality as AWS S3 buckets. 

For example, consider an application that hosts a web blog. 
The application needs to store a variety of blobs, including rich multimedia like videos and images. 

MinIO supports multiple levels of nested directories through the feature of ``prefixing``  to support even the most dynamic object storage workloads.


How does MinIO determine access to objects?
-------------------------------------------

MinIO requires the client perform both authentication and authorization for each new operation.
:ref:`Identity and access management (IAM) <minio-authentication-and-identity-management>` is therefore a critical component of a MinIO configuration.

*Authentication* verifies the identity of a connecting client. 
MinIO requires clients to authenticate using :s3-api:`AWS Signature Version 4 protocol <sig-v4-authenticating-requests.html>` with support for the deprecated Signature Version 2 protocol. 
Specifically, clients must present a valid access key and secret key to access any S3 or MinIO administrative API, such as ``PUT``, ``GET``, and ``DELETE`` operations. 

MinIO then checks that authenticated users or clients have *authorization* to perform actions or use resources on the deployment. 
MinIO uses :ref:`Policy-Based Access Control (PBAC) <minio-policy>`, where each policy describes one or more rules that outline the permissions of a user or group of users. 
MinIO supports S3-specific :ref:`actions <minio-policy-actions>` and :ref:`conditions <minio-policy-conditions>` when creating policies. 

By default, MinIO *denies* access to actions or resources not explicitly referenced in a user's assigned or inherited policies.

MinIO provides an access management feature as part of the software.
Alternatively, you can configure MinIO to authenticate with one of several external IAM providers using either :ref:`Active Directory/LDAP <minio-external-identity-management-ad-ldap>` or :ref:`OpenID/OIDC <minio-external-identity-management-openid>`.


How does MinIO secure data?
---------------------------

MinIO supports methods that encode objects while on drive (encryption-at-rest) and during transition from one location to another (encryption-in-transit, or "in flight").
When enabled, MinIO utilizes :ref:`server-side encryption <minio-encryption-overview>` to write objects in an encrypted state.
To retrieve and read an encrypted object, the user must have appropriate access privileges and also provide the object's decryption key.

MinIO supports **Transport Layer Security** (TLS) versions 1.2 and 1.3 encrypting objects.
TLS replaces the previously used Secure Socket Layer (SSL) method that has since been deprecated.
The TLS standard, maintained by the Internet Engineering Task Force (IETF), provides the standards used by internet communications to support encryption, authentication, and data integrity.

The process of authenticating a user and verifying access to objects is known as the `TLS Handshake`.
Once authenticated, TLS provides the cipher to encrypt and then decrypt the transfer of information from the server to the requesting client.

MinIO supports several methods of :ref:`Server-Side Encryption <minio-encryption-overview>`.

.. _minio-admin-concepts-organize-objects:

Can I organize objects in a folder structure within buckets?
------------------------------------------------------------

MinIO utilizes a :term:`prefix` method for each object that mimics a folder structure from traditional file systems.
Prefixing involves prepending the name of an object with a fixed string.

With prefixes, you do not manually create folders and subfolders.
Instead, MinIO looks for the ``/`` character in the prefix of an object's name.
Each ``/`` indicates a new folder or subfolder.

Using the object's name and prefix, MinIO automatically generates a series of folders and subfolders for stored objects.
When you use the same prefix string on multiple objects, MinIO identifies those as similar or grouped objects.

For example, an object named ``/articles/john.doe/2022-01-02-MinIO-Object-Storage.md`` winds up in the ``articles`` bucket in a folder labeled ``john.doe``.

A MinIO object store might resemble the following structure, with three buckets.
MinIO automatically generates two folders in the ``articles`` bucket based on the prefixes for those objects.

.. code-block:: text

   / #root
   /images/
      2022-01-02-MinIO-Diagram.png
      2022-01-03-MinIO-Advanced-Deployment.png
      MinIO-Logo.png
   /videos/
      2022-01-04-MinIO-Interview.mp4
   /articles/
      /john.doe/
         2022-01-02-MinIO-Object-Storage.md
         2022-01-02-MinIO-Object-Storage-comments.json
      /jane.doe/
         2022-01-03-MinIO-Advanced-Deployment.png
         2022-01-02-MinIO-Advanced-Deployment-comments.json
         2022-01-04-MinIO-Interview.md

MinIO itself does not limit the number of objects that any specific prefix can contain.
However, hardware and network conditions may show performance impacts with large prefixes.

- Deployments with modest or budget-focused hardware should architect their workloads to target 10,000 objects per prefix as a baseline. 
  Increase this target based on benchmarking and monitoring of real world workloads up to what the hardware can meaningfully handle. 
- Deployments with high-performance or enterprise-grade :ref:`hardware <deploy-minio-distributed-recommendations>` can typically handle prefixes with millions of objects or more.

|SUBNET| Enterprise accounts can utilize yearly architecture reviews as part of the deployment and maintenance strategy to ensure long-term performance and success of your MinIO-dependent projects.

For a deeper discussion on the benefits of limiting prefix contents, see the article on :s3-docs:`optimizing S3 performance <optimizing-performance.html>`.

How can I backup and restore objects on MinIO?
----------------------------------------------

MinIO provides two types of replication to copy an object, its versions, and its metadata from one location to another.
You can configure replication at either the :ref:`bucket level <minio-bucket-replication>` or at the :ref:`site level <minio-site-replication-overview>`.

- Bucket level replication can function as either one-way, active-passive replication (such as for archival purposes) or as two-way, active-active replication to keep two buckets in sync with each other.
- Site level replication functions as two-way, active-active replication to keep multiple data locations (such as different geographic data centers) in sync with one another.

Besides replication, MinIO provides a mirroring service.
:mc:`mc mirror` copies only the actual object to any other S3 compatible data store, including other MinIO stores.
However, versions and metadata do not back up with the :mc:`mc mirror` command.


What tools does MinIO provide to manage objects based on speed and frequency of access?
---------------------------------------------------------------------------------------

:ref:`Tiering rules <minio-lifecycle-management-tiering>` allow frequently accessed objects to store on hot or warm storage, which is typically more expensive but provides better performance.

Less frequently accessed objects can move to cold storage.
Cold storage often exchanges slower performance for a cheaper price.


How does MinIO protect objects from accidental overwrite or deletion?
---------------------------------------------------------------------

Locking
~~~~~~~

Locks, a Write Once Read Many (WORM) mechanism, prevent the deletion or modification of an object.
When locked, MinIO retains the objects indefinitely until someone removes the lock or the lock expires.

MinIO provides:

- :ref:`legal holds <minio-object-locking-legalhold>` locks for indefinite retention by all users
- :ref:`compliance holds <minio-object-locking-compliance>` for time-based restrictions for all users
- :ref:`governing locks <minio-object-locking-governance>` for time-based rules for non-privileged users

Versioning
~~~~~~~~~~

By default, objects written with the same name (including prefix) overwrite an existing object of the same name.
MinIO provides a configuration option to create buckets with versioning enabled.
:ref:`Versioning <minio-bucket-versioning>` provides access to various iterations of a uniquely named object as it changes over time. 
When enabled, MinIO writes mutated objects to a different version than the original, allowing access to both the original object and the newer, changed object.

Additional configurations on the MinIO bucket determine how long to retain older versions of each object in the bucket.

.. include:: /includes/common-admonitions.rst
   :start-after: start-exclusive-drive-access
   :end-before: end-exclusive-drive-access