==============
MinIO Security
==============

.. default-domain:: minio

MinIO provides support for the following security features:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Feature
     - Description

   * - Server-Side Object Encryption
     - Encrypt objects using a secret key provided by the S3 client
       or a supported Key Management System (KMS). Only clients with access
       to the secret key can decrypt the object. 
   
   * - Transport Layer Security (TLS) Encryption
     - Enable TLS encryption of all network traffic. Several MinIO 
       security features, such as Server-Side Object Encryption, require
       TLS encryption to ensure end-to-end security of data.

   * - Policy Based Access Control (RBAC)
     - MinIO uses :aws-docs:`IAM-compatible policy documents 
       <IAM/latest/UserGuide/access_policies>` for controlling user privileges.
       You can also assign privileges to a group, where all members of the
       group inherit the group privileges. MinIO provides built-in
       policies for the most common access patterns.
   
   * - Security Token Service (STS)
     - MinIO Security Token Service (STS) is an endpoint service that allows
       clients to request temporary credentials for accessing MinIO resources.
       MinIO STS supports multiple forms of identity federation, including
       OpenID identity providers and Active Directory/LDAP services.


.. toctree::
   :titlesonly:
   :hidden:

   /security/minio-authentication-authorization
   /security/minio-security-TLS-encryption
   /security/minio-security-server-side-encryption
   /security/minio-security-security-token-service 
