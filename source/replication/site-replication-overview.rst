.. _minio-site-replication-overview:

=========================
Site replication overview
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Site replication configures multiple independent MinIO sites or clusters as replicas.
When configured this way, refer to the replica sites as either "peer sites" or "sites".

Site replication assumes the use of an external identity provider (IDP).
All configured deployments must use the same external IDP.


What replicates across all sites?
---------------------------------

When enabling site replication on a set of sites, the following changes apply to the other sites:

- Creation and deletion of buckets and objects, including

  - Configuration
  - Policy changes and deletions
  - Tags
  - Locks
  - Encryption settings

- Creation and deletion of IAM users, groups, policies, and policy mappings to users or groups (for LDAP users or groups)
- Creation of Security Token Service (STS) credentials for session tokens verifiable from the local ``root`` credentials
- Creation and deletion of service accounts (except those owned by the ``root`` user)
- Changes to bucket features, such as
  
  - :ref:`Policies <minio-policy>`
  - Tags (for example, see :mc-cmd:`mc tag set`)
  - :ref:`Object-Lock <minio-object-locking>` configurations (including retention and legal hold configurations)
  - :ref:`Encryption configuration <minio-encryption-overview>`

Site replication enables bucket versioning for all new and existing buckets on all replicated sites.


What doesn't replicate across sites?
-------------------------------------

The following bucket features don't replicate across sites set up for site replication:

- Notification configurations
- Lifecycle management (ILM) configurations

This allows users who access different sites to define separate notification or ILM settings.


Order of operations
-------------------

After enabling site replication, identity and access management (IAM) settings sync in the following order:

#. Policies
#. User accounts (for local users)
   
   Note: Sites that use OIDC and LDAP don't sync, and they may not have local users.

#. Groups 
   
   For MinIO IDP and LDAP managed groups

#. Service accounts

   Only static accounts with valid claims.
   Service accounts for ``root`` don't sync.

#. Policy mapping for synced user accounts

#. Policy mapping for `Short Token Service (STS) users <https://docs.min.io/docs/minio-sts-quickstart-guide.html>`

Site healing
------------

With site replication enabled, bucket metadata and IAM entries can heal from whichever peer site has the most updated entry.


Prerequisites
-------------

- Only *one* site can have data at the time of setup.
  The other sites must be empty of buckets and objects.

  After configuring site replication, the data replicates to the other sites.
  Objects written to any site after setting up replication then replicate to all sites.

- All sites must have the same deployment credentials (for example, ``MINIO_ROOT_USER``, ``MINIO_ROOT_PASSWORD``)
- All sites must use the same external IDP(s), if any
- For :ref:`SSE-S3 <minio-encryption-sse-s3>` or :ref:`SSE-KMS <minio-encryption-sse-kms>` encryption via KMS, all sites must have access to a central KMS deployment. 
  This can be achieved via a central KES server or multiple KES servers (say one per site) connected via a central KMS (Vault) server.


Configure site replication
--------------------------

.. tab-set::

   .. tab-item:: Console

      #. Deploy three or more separate MinIO sites, using the same Identity Provider for each site

         Only one site can have any buckets or objects on it.
         The other sites must be empty.

      #. In a browser, access the Console for one of the sites

         For example, ``https://<addressforsite>:9000``
         
         If one of the sites has content, log in to the Console for that site.

      #. Select **Settings**, then **Site Replication**

         .. image:: /images/minio-console/console-settings-site-replication.png
            :width: 400px
            :alt: MinIO Console menu with the Settings heading expanded to show Site Repilication
            :align: center
      
      #. Select :guilabel:`Add Sites +``

         .. image:: /images/minio-console/console-settings-site-replication-add.png
            :width: 600px
            :alt: MinIO Console's Add Sites for Replication screen
            :align: center

      #. Make the following entries:

         :Access Key: `(required)` The user name to use for signing in to each site. Should be the same across all sites.

         :Secret Key: `(required)` The password for the user name to use for signing in to each site. Should be the same across all sites.

         :Site Name: An alias to use for the site name.

         :Endpoint: `(required)` The URL or IP address and port to use to access the site.

         To add additional sites beyond two, select the ``+`` button to the side of one of the Site entries.
         To remove a site previously added, select the ``-`` button to the side of the site.

      #. Click **Save**

   .. tab-item:: Command line

      #. Deploy three or more separate MinIO sites, using the same external IDP

         Only one site can have any buckets or objects on it.
         The other sites must be empty.

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


Expand site replication
-----------------------

If necessary or desired, you can add more sites to an existing site replication.

The site to add must already be deployed, and it must be empty (no buckets or objects).

.. tab-set::

   .. tab-item:: Console

      #. Deploy a new, empty MinIO site

      #. In a browser, access the Console for one of the exisitng replicated sites

         For example, ``https://<addressforsite>:9000``

      #. Select **Settings**, then **Site Replication**

         .. image:: /images/minio-console/console-site-replication-list-of-sites.png
            :width: 600px
            :alt: MinIO Console Site Replication with three sites listed
            :align: center
      
      #. Select :guilabel:`Add Sites +`

         .. image:: /images/minio-console/console-settings-site-replication-add.png
            :width: 600px
            :alt: MinIO Console's Add Sites for Replication screen
            :align: center

      #. Make the following entries:

         :Access Key: `(required)` The user name to use for signing in to each site. Should be the same across all sites.

         :Secret Key: `(required)` The password for the user name to use for signing in to each site. Should be the same across all sites.

         :Site Name: An alias to use for the site name.

         :Endpoint: `(required)` The URL or IP address and port to use to access the site.

         To add additional sites beyond two, select the ``+`` button to the side of the last Site entry.

      #. Click :guilabel:`Save`

   .. tab-item:: Command line

      #. Deploy three or more separate MinIO sites, using the same external IDP

         Only one site can have any buckets or objects on it.
         The other sites must be empty.

      #. Configure an alias for each site

         To check the existing aliases, use :mc-cmd:`mc alias list`.
      
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

         List all existing replicated sites first, then list the new site(s) to add.
         In this example, ``minio1``, ``minio2``, and ``minio3`` are already configured for replication.
         The command adds minio4 and minio5 as new sites to add to the replication.
         ``minio4`` and ``minio5`` must be empty.
      
         .. code-block:: shell
         
            mc admin replicate add minio1 minio2 minio3 minio4 minio5
      
      #. Query the site replication configuration to verify
      
         .. code-block:: shell
         
            mc admin replicate info minio1

Modify a site's endpoint
------------------------

From time to time a replicated site's address may change.
When this occurs, update the site's endpoint in the site replication's configuration.

.. tab-set::

   .. tab-item:: Console

      #. In a browser, access the Console for one of the replicated sites

         For example, ``https://<addressforsite>:9000``

      #. Select **Settings**, then **Site Replication**
      
      #. Select the pencil **Edit** icon to the side of the site to update

         .. image:: /images/minio-console/console-site-replication-edit-button.png
            :width: 600px
            :alt: MinIO Console's List of Replicated Sites screen with the edit buttons highlighted
            :align: center

      #. Make the following entries:

         :New Endpoint: `(required)` The new endpoint address and port to use.

         .. image:: /images/minio-console/console-settings-site-replication-edit-endpoint.png
            :width: 600px
            :alt: Example of the MinIO Console's Edit Replication Endpoint screen
            :align: center

      #. Click **Update**

   .. tab-item:: Command line

      #. Obtain the site's Deployment ID with :mc-cmd:`mc admin replicate info`

         .. code-block:: shell

            mc admin replicate info <ALIAS>
         
      
      #. Update the site's endpoint with :mc-cmd:`mc admin replicate edit`
      
         .. code-block:: shell

            mc admin replicate edit ALIAS --deployment-id [DEPLOYMENT-ID] --endpoint [NEW-ENDPOINT]

         Replace [DEPLOYMENT-ID] with the deployment ID of the site to update.
         
         Replace [NEW-ENDPOINT] with the new endpoint for the site.

Remove a Site from replication
------------------------------

When decomissioning a peer site, you must remove it from the site replication configuration.

.. tab-set::

   .. tab-item:: Console

      #. In a browser, access the Console for one of the replicated sites

         For example, ``https://<addressforsite>:9000``

      #. Select **Settings**, then **Site Replication**
      
      #. Select the trash can Delete icon to the side of the site to update

         .. image:: /images/minio-console/console-site-replication-delete-button.png
            :width: 600px
            :alt: MinIO Console's List of Replicated Sites screen with the delete buttons highlighted
            :align: center

      #. Confirm the site deletion at the prompt by selecting **Delete**

         .. image:: /images/minio-console/console-settings-site-replication-confirm-delete.png
            :width: 600px
            :alt: Example of the MinIO Console's Edit Replication Endpoint screen
            :align: center

   .. tab-item:: Command line

      Use :mc-cmd:`mc admin replicate remove`

      .. code-block:: shell

         mc admin replicate remove <ALIAS> --all --force

      The ``-all`` flag removes the site as a peer from all participating sites.

      The ``--force`` flag is required to removes the site from the site replication configuration.

Review replication status
-------------------------

MinIO provides information on replication across the sites.
Information is available in a summary view or for specific, inlcuding users, groups, policies, or buckets.

The summary information includes the number of **Synced** and **Failed** items for each category.

.. tab-set::

   .. tab-item:: Console

      #. In a browser, access the Console for one of the replicated sites

         For example, ``https://<addressforsite>:9000``

      #. Select **Settings**, then **Site Replication**
      
      #. Select :guilabel:`Replication Status`

         .. image:: /images/minio-console/console-settings-site-replication-status-summary.png
            :width: 600px
            :alt: MinIO Console's Replication status from all Sites screen
            :align: center

      #. `(Optional)` View the replication status for a specific item
         
         Select the type of item to view in the :guilabel:`View Replication Status for a:` dropdown

         Specify the name of the specific Bucket, Group, Policy, or User to view

         .. image:: /images/minio-console/console-settings-site-replication-status-item.png
            :width: 600px
            :alt: Example of replication status for a particular bucket item
            :align: center
      
      #. `(Optional)` Update the information by clicking :guilabel:`Refresh`

   .. tab-item:: Command line

      Use :mc-cmd:`mc admin replicate status`

      .. code-block:: shell

         mc admin replicate status <ALIAS> --<flag> <value>

      For example:

      - ``mc admin replicate status minio3 --bucket images``

        Displays the replication status for the ``images`` bucket on the ``minio3`` site.
        
        Example output:

        .. code-block::
 
           ●  Bucket config replication summary for: images
 
           Bucket          | MINIO2          | MINIO3          | MINIO4         
           Tags            |                 |                 |                
           Policy          |                 |                 |                
           Quota           |                 |                 |                
           Retention       |                 |                 |                
           Encryption      |                 |                 |                
           Replication     | ✔               | ✔               | ✔        

      - ``mc admin replicate status minio3 --all``

        Displays the replication status summary for all replication sites of which ``minio3`` is part. 

        Example output:

        .. code-block::

           Bucket replication status:
           ●  1/1 Buckets in sync
          
           Policy replication status:
           ●  5/5 Policies in sync
          
           User replication status:
           ●  1/1 Users in sync
          
           Group replication status:
           ●  0/2 Groups in sync
          
           Group           | MINIO2          | MINIO3          | MINIO4         
           ittechs         | ✗  in-sync      |                 | ✗  in-sync    
           managers        | ✗  in-sync      |                 | ✗  in-sync    
       