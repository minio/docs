.. _minio-site-replication-overview:


=========================
Site Replication Overview
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Site replication allows multiple, independent MinIO sites or clusters to be configured as replicas.
When configured this way, we refer to the replica sites as either peer sites or sites.

The sites or clusters must be using the same external Identify Provider (IDP).


What replicates across all sites?
---------------------------------

Enabling site replication on a siet of sites, the following changes apply to the other sites:

- Creation and deletion of buckets and objects
- Creation and deletion of IAM users, groups, policies, and policy mappings to users or groups
- Creation of Security Token Service (STS) credentials
- Creation and deletion of service accounts (except those owned by the ``root`` user)
- Changes to bucket features, such as
  
  - :ref:`Policies <minio-policy>`
  - Tags (for example, see :mc-cmd:`mc tag set`)
  - :ref:`Object-Lock <minio-object-locking>` configurations (including retention and legal hold configurations)
  - :ref:`Encryption configuration <minio-encryption-overview>`

Site replication enables bucket versioning for all new and existing buckets on all replicated sites.


What does not replicate across sites?
-------------------------------------

The following bucket features do not replicate across sites set up for site repication:

- Notification configurations
- Lifecycle management (ILM) configurations

This allows users who access different sites to define separate notification or ILM settings.


Prerequisites
-------------

- Only *one* site can have data at the time of setup.

  After configuring site replication, the data replicates to the other sites.
  Subsequent objects written to any site then replicate to all sites.
- All sites must have the same deployment credentials (for example, ``MINIO_ROOT_USER``, ``MINIO_ROOT_PASSWORD``)
- Once configured, a site cannot be removed
- All sites must use the same external IDP(s), if any
- For :ref:`SSE-S3 <minio-encryption-sse-s3>` or :ref:`SSE-KMS <minio-encryption-sse-kms>` encryption via KMS, all sites must have access to a central KMS deployment. 
  This can be achieved via a central KES server or multiple KES servers (say one per site) connected via a central KMS (Vault) server.


Configure Site Replication
--------------------------

#. Configure an alias for each site

   For example, for three MinIO sites, you might create aliases ``minio1``, ``minio2``, and ``minio3``.
   
   Use :mc-cmd:`mc alias set`

   .. code-block:: shell

      mc alias set minio1 https://minio1.example.com:9000 adminuser adminpassword
      mc alias set minio2 https://minio2.example.com:9000 adminuser adminpassword
      mc alias set minio3 https://minio3.example.com:9000 adminuser adminpassword

   or define environment variables

   .. code-block:: shell
   
      export MC_HOST_minio1=https://adminuser:adminpassword@minio1.example.com
      export MC_HOST_minio2=https://adminuser:adminpassword@minio2.example.com
      export MC_HOST_minio3=https://adminuser:adminpassword@minio3.example.com

#. Add site replication configuration

   .. code-block:: shell
   
      mc admin replicate add minio1 minio2 minio3

#. Query the site replication configuration to verify

   .. code-block:: shell
   
      mc admin repicate info minio1