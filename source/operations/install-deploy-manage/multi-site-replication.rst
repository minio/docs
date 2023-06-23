.. _minio-site-replication-overview:

=========================
Site Replication Overview
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Site replication configures multiple independent MinIO deployments as a cluster of replicas called peer sites.

   .. figure:: /images/architecture/architecture-load-balancer-multi-site.svg
      :figwidth: 100%
      :alt: Diagram of a site replication deployment with two sites

      A site replication deployment with two peer sites.
      A load balancer manages routing operations to either of the two sites
      Data written to one site automatically replicates to the other peer site.

Site replication assumes the use of either the included MinIO identity provider (IDP) *or* an external IDP.
All configured deployments must use the same IDP.
Deployments using an external IDP must use the same configuration across sites.

For more information on site replication architecture and deployment concepts, see :ref:`Deployment Architecture: Replicated MinIO Deployments <minio-deployment-architecture-replicated>`.


Overview
--------

.. _minio-site-replication-what-replicates:

What Replicates Across All Sites
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-mc-admin-replicate-what-replicates
   :end-before: end-mc-admin-replicate-what-replicates

What Does Not Replicate Across Sites
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-mc-admin-replicate-what-does-not-replicate
   :end-before: end-mc-admin-replicate-what-does-not-replicate


Initial Site Replication Process
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After enabling site replication, identity and access management (IAM) settings sync in the following order:

.. tab-set::

   .. tab-item:: MinIO IDP

      #. Policies
      #. User accounts (for local users)
      #. Groups
      #. Access Keys
         
         Access Keys for ``root`` do not sync.

      #. Policy mapping for synced user accounts
      #. Policy mapping for :ref:`Security Token Service (STS) users <minio-security-token-service>`

   .. tab-item:: OIDC

      #. Policies
      #. Access Keys associated to OIDC accounts with a valid :ref:`MinIO Policy <minio-policy>`. ``root`` access keys do not sync.
      #. Policy mapping for synced user accounts
      #. Policy mapping for :ref:`Security Token Service (STS) users <minio-security-token-service>`

   .. tab-item:: LDAP

      #. Policies
      #. Groups
      #. Access Keys associated to LDAP accounts with a valid :ref:`MinIO Policy <minio-policy>`. ``root`` access keys do not sync.
      #. Policy mapping for synced user accounts
      #. Policy mapping for :ref:`Security Token Service (STS) users <minio-security-token-service>`

After the initial synchronization of data across peer sites, MinIO continually replicates and synchronizes :ref:`replicable data <minio-site-replication-what-replicates>` among all sites as they occur on any site.

Site Healing
~~~~~~~~~~~~

Any MinIO deployment in the site replication configuration can resynchronize damaged :ref:`replica-eligible data <minio-site-replication-what-replicates>` from the peer with the most updated ("latest") version of that data.

.. versionchanged:: RELEASE.2022-08-11T04-37-28Z

   Failed or pending replications requeue automatically when performing any ``GET`` or ``HEAD`` API method. 
   For example, using :mc:`mc stat`, :mc:`mc cat`, or :mc:`mc ls` commands after a site comes back online prompts healing to requeue.

.. versionchanged:: RELEASE.2022-12-02T23-48-47Z

   If one site loses data for any reason, resynchronize the data from another healthy site with :mc-cmd:`mc admin replicate resync`.
   This launches an active process that resynchronizes the data without waiting for the passive MinIO scanner to recognize the missing data.

Synchronous vs Asynchronous Replication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-replication-sync-vs-async
   :end-before: end-replication-sync-vs-async

MinIO strongly recommends using the default asynchronous site replication.
To configure synchronous site replication use :mc-cmd:`mc admin replicate update` with the :mc-cmd:`~mc admin replicate update --sync` option.

Proxy to Other Sites
~~~~~~~~~~~~~~~~~~~~

MinIO peer sites can proxy ``GET/HEAD`` requests for an object to other peers to check if it exists.
This allows a site that is healing or lagging behind other peers to still return an object persisted to other sites.

For example:

1. A client issues ``GET("data/invoices/january.xls")`` to ``Site1``
2. ``Site1`` cannot locate the object
3. ``Site1`` proxies the request to ``Site2``
4. ``Site2`` returns the latest version of the requested object
5. ``Site1`` returns the proxied object to the client

For ``GET/HEAD`` requests that do *not* include a unique version ID, the proxy request returns the *latest* version of that object on the peer site.
This may result in retrieval of a non-current version of an object, such as if the responding peer site is also experiencing replication lag.

MinIO does not proxy ``LIST``, ``DELETE``, and ``PUT`` operations.

Prerequisites
-------------

One Site with Data at Setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Only *one* site can have data at the time of setup.
The other sites must be empty of buckets and objects.

After configuring site replication, any data on the first deployment replicates to the other sites.

All Sites Must Use the Same IDP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

All sites must use the same :ref:`Identity Provider <minio-authentication-and-identity-management>`.
Site replication supports the included MinIO IDP, OIDC, or LDAP.

All Sites Must use the Same MinIO Server Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

All sites must have a matching and consistent MinIO Server version. 
Configuring replication between sites with mismatched MinIO Server versions may result in unexpected or undesired replication behavior.

You should also ensure the :mc:`mc` version used to configure replication closely matches the server version.

Access to the Same Encryption Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For :ref:`SSE-S3 <minio-encryption-sse-s3>` or :ref:`SSE-KMS <minio-encryption-sse-kms>` encryption via Key Management Service (KMS), all sites must have access to a central KMS deployment. 

You can achieve this with a central KES server or multiple KES servers (say one per site) connected via a central supported :ref:`key vault server <minio-sse>`.

Replication Requires Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Site replication *requires* :ref:`minio-bucket-versioning` and enables it for all created buckets automatically.
You cannot disable versioning in site replication deployments

If you exclude a prefix or folder from versioning within a bucket, MinIO cannot replicate objects within that folder or prefix.

Load Balancers Installed on Each Multi-Node Site
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-mc-admin-replicate-load-balancing
   :end-before: end-mc-admin-replicate-load-balancing

Switch to Site Replication from Bucket Replication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:ref:`Bucket replication <minio-bucket-replication>` and multi-site replication are mutually exclusive.
You cannot use both replication methods on the same deployments.

If you previously set up bucket replication and wish to now use site replication, you must first delete all of the bucket replication rules on the deployment that has data when initializing site replication.
Use :mc:`mc replicate rm` on the command line or the MinIO Console to remove bucket replication rules.

Only one site can have data when setting up site replication.
All other sites must be empty.

Tutorials
---------

.. _minio-configure-site-replication:

Configure Site Replication
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Console
      :sync: gui

      #. :ref:`Deploy <deploy-minio-distributed>` two or more separate MinIO sites, using the same Identity Provider for each site

         Only one site can have any buckets or objects on it.
         The other site(s) must be empty.

      #. In a browser, access the Console for the site with data (if any)

         For example, ``https://<addressforsite>:9000``
         
         Replace ``<addressforsite>`` with the hostname or IP address of the load balancer, reverse proxy, or similar control plane that manages connections to the MinIO deployment.

      #. Select **Settings**, then **Site Replication**

         .. image:: /images/minio-console/console-settings-site-replication.png
            :width: 400px
            :alt: MinIO Console menu with the Settings heading expanded to show Site Replication
            :align: center
      
      #. Select :guilabel:`Add Sites +`

         .. image:: /images/minio-console/console-settings-site-replication-add.png
            :width: 600px
            :alt: MinIO Console's Add Sites for Replication screen
            :align: center

      #. Complete the requested information:

         This Site:

           - :Site Name: A name or other identifying text to associate to the site.
           - :Endpoint: `(required)` The hostname or IP of the load balancer managing connections to the site.
           - :Access Key: `(required)` The user name for ``root`` to use for signing in to the site.
           - :Secret Key: `(required)` The password for ``root`` to use for signing in to the site.

         Peer Sites:

           - :Site Name: A name or other identifying text to associate to the site.
           - :Endpoint: `(required)` The hostname or IP of the load balancer managing connections to the site.
           - :Access Key: `(required)` The user name for ``root`` for the peer site to use for signing in to the site.
           - :Secret Key: `(required)` The password for ``root`` for the peer site to use for signing in to the site.

         .. include:: /includes/common-replication.rst
            :start-after: start-mc-admin-replicate-load-balancing
            :end-before: end-mc-admin-replicate-load-balancing

         To add additional sites beyond two, select the ``+`` button to the side of one of the Site entries.
         To remove a site previously added, select the ``-`` button to the side of the site.

         Site replication adds a :mc:`~mc admin user svcacct` under the ``root`` user of each site to perform replication activities.

      #. Select **Save**
   
      #. Select :guilabel:`Replication Status` button to verify replication has completed across peer sites.

         Any :ref:`replicable data <minio-site-replication-what-replicates>` that exists should show as successfully synced.

         For more on reviewing site replication, see the :ref:`Site Replication Status tutorial <minio-site-replication-status-tutorial>`.


   .. tab-item:: Command Line
      :sync: cli

      The following steps create a new site replication configuration for three :ref:`distributed deployments <deploy-minio-distributed>`.
      One of the sites contains :ref:`replicable data <minio-site-replication-what-replicates>`.

      The three sites use aliases, ``minio1``, ``minio2``, and ``minio3``, and only ``minio1`` contains any data.

      #. :ref:`Deploy <deploy-minio-distributed>` three or more separate MinIO sites, using the same :ref:`IDP <minio-authentication-and-identity-management>`

         Start with empty sites *or* have no more than one site with any :ref:`replicable data <minio-site-replication-what-replicates>`.

      #. Configure an alias for each site

         .. include:: /includes/common-replication.rst
            :start-after: start-mc-admin-replicate-load-balancing
            :end-before: end-mc-admin-replicate-load-balancing
      
         For example, for three MinIO sites, you might create aliases ``minio1``, ``minio2``, and ``minio3``.
         
         Use :mc:`mc alias set` to define the hostname or IP of the load balancer managing connections to the site.
      
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

         If all sites are empty, the order of the aliases does not matter.
         If one of the sites contains any :ref:`replicable data <minio-site-replication-what-replicates>`, you must list it first.

         No more than one site can contain any replicable data.
      
      #. Query the site replication configuration to verify
      
         .. code-block:: shell
         
            mc admin replicate info minio1

         You can use the alias for any peer site in the site replication configuration.

      #. Query the site replication status to confirm any initial data has replicated to all peer sites.
      
         .. code-block:: shell

            mc admin replicate status minio1

         You can use the alias for any of the peer sites in the site replication configuration.
         The output should say that all :ref:`replicable data <minio-site-replication-what-replicates>` is in sync.

         The output could resemble the following:

         .. code-block:: shell

            Bucket replication status:
            ●  1/1 Buckets in sync

            Policy replication status:
            ●  5/5 Policies in sync

            User replication status:
            No Users present

            Group replication status:
            No Groups present

         For more on reviewing site replication, see the :ref:`Site Replication Status tutorial <minio-site-replication-status-tutorial>`.


.. _minio-expand-site-replication:

Expand Site Replication
~~~~~~~~~~~~~~~~~~~~~~~

You can add more sites to an existing site replication configuration.

The new site must meet the following requirements:

- Site is fully deployed and accessible by hostname or IP
- Shares the IDP configuration as all other sites in the configuration
- Uses the same root user credentials as other configured sites
- Contains no bucket or object data

.. tab-set::

   .. tab-item:: Console
      :sync: gui

      #. Deploy a new, empty MinIO site

      #. In a browser, access the Console for one of the existing replicated sites

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

         :Endpoint: `(required)` The hostname or IP of the load balancer managing connections to the site.
         
         .. include:: /includes/common-replication.rst
            :start-after: start-mc-admin-replicate-load-balancing
            :end-before: end-mc-admin-replicate-load-balancing

         To add additional sites beyond two, select the ``+`` button to the side of the last Site entry.

      #. Select :guilabel:`Save`

   .. tab-item:: Command Line
      :sync: cli

      #. Deploy the new MinIO peer site(s) following the stated requirements.


      #. Configure an alias for the new site

         .. include:: /includes/common-replication.rst
            :start-after: start-mc-admin-replicate-load-balancing
            :end-before: end-mc-admin-replicate-load-balancing

         To check the existing aliases, use :mc:`mc alias list`.
      
         Use :mc:`mc alias set` to define the hostname or IP of the load balancer managing connections to the new site(s).
      
         .. code-block:: shell
      
            mc alias set minio4 https://minio4.example.com:9000 adminuser adminpassword
      
         or define environment variables
      
         .. code-block:: shell
         
            export MC_HOST_minio4=https://adminuser:adminpassword@minio4.example.com
      
      #. Add site replication configuration

         Use the :mc-cmd:`mc admin replicate add` command to expand the site replication configuration with the new peer site.
         Specify the alias of any existing healthy peer site as the first parameter and the alias of the new site as the second parameter.

         For example, the following command adds the new peer site ``minio4`` to an existing site replication configuration on ``minio1``.
      
         .. code-block:: shell
         
            mc admin replicate add minio1 minio4
      
      #. Query the site replication configuration to verify
      
         .. code-block:: shell
         
            mc admin replicate info minio1

Modify a Site's Endpoint
~~~~~~~~~~~~~~~~~~~~~~~~

If a peer site changes its hostname, you can modify the replication configuration to reflect the new hostname.

.. tab-set::

   .. tab-item:: Console
      :sync: gui

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

         .. include:: /includes/common-replication.rst
            :start-after: start-mc-admin-replicate-load-balancing
            :end-before: end-mc-admin-replicate-load-balancing

         .. image:: /images/minio-console/console-settings-site-replication-edit-endpoint.png
            :width: 600px
            :alt: Example of the MinIO Console's Edit Replication Endpoint screen
            :align: center

      #. Select **Update**

   .. tab-item:: Command Line
      :sync: cli

      #. Obtain the site's Deployment ID with :mc-cmd:`mc admin replicate info`

         .. code-block:: shell

            mc admin replicate info <ALIAS>
         
      
      #. Update the site's endpoint with :mc-cmd:`mc admin replicate update`
      
         .. code-block:: shell

            mc admin replicate update ALIAS --deployment-id [DEPLOYMENT-ID] --endpoint [NEW-ENDPOINT]

         Replace [DEPLOYMENT-ID] with the deployment ID of the site to update.
         
         Replace [NEW-ENDPOINT] with the new endpoint for the site.

         .. include:: /includes/common-replication.rst
            :start-after: start-mc-admin-replicate-load-balancing
            :end-before: end-mc-admin-replicate-load-balancing

Remove a Site from Replication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can remove a site from replication at any time.
You can re-add the site at a later date, but you must first completely wipe bucket and object data from the site.

.. tab-set::

   .. tab-item:: Console
      :sync: gui

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

   .. tab-item:: Command Line
      :sync: cli

      Use :mc-cmd:`mc admin replicate rm`

      .. code-block:: shell

         mc admin replicate rm ALIAS PEER_TO_REMOVE --force

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of any peer site in the replication configuration.

      - Replace ``PEER_TO_REMOVE`` with the alias of the peer site to remove.

      All healthy peers in the site replication configuration update to remove the specified peer automatically.

      MinIO requires the ``--force`` flag to remove the peer from the site replication configuration.

.. _minio-site-replication-status-tutorial:

Review Replication Status
~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO provides information on replication across the sites for users, groups, policies, or buckets.

The summary information includes the number of **Synced** and **Failed** items for each category.

.. tab-set::

   .. tab-item:: Console
      :sync: gui

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
      
      #. `(Optional)` Update the information by selecting :guilabel:`Refresh`

   .. tab-item:: Command Line
      :sync: cli

      Use :mc-cmd:`mc admin replicate status`

      .. code-block:: shell

         mc admin replicate status <ALIAS> --<flag> <value>

      For example:

      - ``mc admin replicate status minio3 --bucket images``

        Displays the replication status for the ``images`` bucket on the ``minio3`` site.
        
        The output resembles the following:

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

        The output resembles the following:

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
       
