.. _minio-mc-admin-replicate:

======================
``mc admin replicate``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin replicate

.. versionchanged:: RELEASE.2023-01-11T03-14-16Z

   - ``mc admin replicate edit`` renamed to :mc-cmd:`mc admin replicate update`
   - ``mc admin replicate remove`` renamed to :mc-cmd:`mc admin replicate rm`

Description
-----------

.. start-mc-admin-replicate-desc

The :mc-cmd:`mc admin replicate` command creates and manages :ref:`site replication <minio-site-replication-overview>` for a set of MinIO peer sites.

Site replication mimics an active-active bucket replication, but for multiple MinIO deployments.
Wherever a change occurs to IAM settings, buckets, or objects across the set of sites, the change replicates across all sites in the site replication group.

.. end-mc-admin-replicate-desc

Where :ref:`bucket replication <minio-bucket-replication>` manages the mirroring of particular buckets or objects from one location to another within a deployment or across deployments, site replication continuously mirrors an entire MinIO site to other sites.

:mc-cmd:`mc admin replicate` only supports site replication for :ref:`distributed deployments <deploy-minio-distributed>` when configuring site replication.

Only one deployment can have any data when initiating a new site replication configuration.

Site replication enforces :ref:`bucket versioning <minio-bucket-versioning>` on all buckets, including existing buckets and any buckets added after initiating site replication.
Site replication fully synchronizes versioned objects, compared to :mc:`mc mirror` which operates only on the latest version of an object

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only


The :mc-cmd:`mc admin replicate` command has the following subcommands:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Subcommand
     - Description

   * - :mc-cmd:`mc admin replicate add`
     - Create a new site replication configuration or expand an existing configuration.

   * - :mc-cmd:`mc admin replicate info`
     - Returns information about site replication configuration.

   * - :mc-cmd:`mc admin replicate resync`
     - Resynchronizes content from one site to a second site if the second site has lost data.

   * - :mc-cmd:`mc admin replicate rm`
     - Removes an entire site replication configuration or one or more peer sites from participating in site replication.

   * - :mc-cmd:`mc admin replicate status`
     - Displays the status for :ref:`replicable data <minio-site-replication-what-replicates>` across participating sites.

   * - :mc-cmd:`mc admin replicate update`
     - Modify the endpoint of the specified peer site in the site replication configuration.

Syntax
------

.. mc-cmd:: add
   :fullpath:

   Create or expand a site replication configuration.
   The configuration uses asynchronous site replication by default, as MinIO recommends.

   To enable synchronous site replication, create the replication using this command *first*.
   Then use :mc-cmd:`mc admin replicate update --mode sync <mc admin replicate update --mode>` to update the configuration.

   .. tab-set::

      .. tab-item:: EXAMPLES

         Consider a multi-site MinIO topology with three separate MinIO deployments using the following :ref:`aliases <alias>`: ``minio1``, ``minio2``, and ``minio3``. 
         All three sites have complete bidirectional network access and low latency between sites.

         .. code-block:: shell
            :class: copyable

            mc admin replicate add minio1 minio2 minio3

         The following command expands an existing site replication that includes peer site ``minio1`` to an additional peer site, ``minio5``.
         ``minio5`` contains no data.

         .. code-block:: shell
            :class: copyable

            mc admin replicate add minio1 minio5

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell
            :class: copyable

            mc [GLOBALFLAGS] admin replicate add      \
                                        ALIAS1        \
                                        ALIAS2        \
                                        [ALIAS3 ...]

   .. mc-cmd:: ALIAS
      :required:

      The :ref:`alias <alias>` of a MinIO deployment to include in site replication.

      At least two MinIO deployment aliases are required to create a site replication. 
      Only the first alias can have buckets or objects.
      The first site can also be empty.

      To expand an existing site replication to one more new replication sites, the first :ref:`alias <alias>` must be a peer site in the site replication set to expand.
      Then include one or more additional :ref:`aliases <alias>` to add to the existing site replication.
      The deployments to add must be empty.

.. mc-cmd:: update
   :fullpath:

   Modifies the endpoint used for an existing peer site participating in site replication.

   .. versionchanged:: RELEASE.2023-01-11T03-14-16Z

      ``mc admin replicate edit`` renamed to ``mc admin replicate update``.

   .. tab-set::

      .. tab-item:: EXAMPLE

         .. code-block:: shell
            :class: copyable

            mc admin replicate update                                                   \
                               minio2                                                 \
                               --deployment-id c1758167-4426-454f-9aae-5c3dfdf6df64   \
                               --endpoint https://minio2:9000

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell

            mc [GLOBALFLAGS] admin replicate update                     \
                                        ALIAS                           \
                                        --deployment-id [deploymentID]  \
                                        --endpoint [newEndpoint]        \
                                        --mode ["sync" | "async"]
    
   .. mc-cmd:: ALIAS
      :required:

      The :ref:`alias <alias>` of the MinIO deployment.

   .. mc-cmd:: --deployment-id
      :required:

      The unique id of the deployment to change.

      The deployment ID can be found by running :mc-cmd:`mc admin replicate info ALIAS`

   .. mc-cmd:: --endpoint
      :required:
      
      The new endpoint or URL to associate with the peer site.

   .. mc-cmd:: --mode
      :optional:

      Specify whether MinIO performs replication operations to the peer synchronously or asynchronously.
      Available values are ``sync`` and ``async``.
      
      Defaults to ``async``.

   .. mc-cmd:: --sync
      :optional:

      .. important::

         The ``--sync`` flag has been deprecated as of ``RELEASE.2023-07-07T05-25-51Z``.
         Use :mc-cmd:`~mc admin replicate update --mode` instead.

      Enable or disable synchronous site replication.
      Available values are ``enable`` and ``disable``.
      If not defined, MInIO uses asynchronous site replication.

.. mc-cmd:: rm, remove
   :fullpath:

   .. versionchanged:: RELEASE.2023-01-11T03-14-16Z

      The ``mc admin replicate remove`` subcommand renamed to ``mc admin replicate rm``.

   Removes one or more sites from a site replication configuration.

   Remember, if you intend to re-add the site to a site replication configuration in the future, it must be empty of :ref:`replicable data <minio-site-replication-what-replicates>`.

   .. tab-set::
      
      .. tab-item:: EXAMPLES
         
         Remove site replication for all connected sites for an existing site replication configuration that includes `minio2`.
         This deletes the site replication configuration for all participating sites.
         
         .. code-block:: shell
            :class: copyable

            mc admin replicate rm      \
                               minio2  \
                               --all   \
                               --force

         Remove the sites with alias names ``minio5`` and ``minio6`` from an existing site replication configuration that includes `minio2`

         .. code-block:: shell
            :class: copyable

            mc admin replicate rm      \
                               minio2  \
                               minio5  \
                               minio6  \
                               --force
        
      .. tab-item:: SYNTAX
         
         The command has the following syntax:

         .. code-block:: shell
            
            mc [GLOBALFLAGS] admin rm          \
                                   TARGET      \
                                   ALIAS1      \
                                   [ALIAS2...] \
                                   --all       \
                                   --force

   .. mc-cmd:: TARGET
      :required:

      The :ref:`alias <alias>` of an active MinIO deployment participating in the site replication to target.
      Do not use an alias of a deployment to be removed, unless removing all sites from site replication.

   .. mc-cmd:: ALIAS
      :optional:

      The :ref:`alias <alias>` of an active MinIO deployment to remove from a site replication configuration.
      May be repeated to remove additional sites.

   .. mc-cmd:: --all
      :optional:

      Include this flag to remove all sites configured for site replication and end the site replication configuration.

   .. mc-cmd:: --force
      :required:

      This flag forces the removal of the specified peer site(s) from the site replication configuration.
      

.. mc-cmd:: info
   :fullpath:

   Returns information about the sites in the site replication configuration.
   
   .. tab-set::
      
      .. tab-item:: EXAMPLE
         
         .. code-block:: shell
            :class: copyable

            mc admin replicate info minio1

      .. tab-item:: SYNTAX
         
         .. code-block:: shell
            
            mc [GLOBALFLAGS] admin replicate info ALIAS

   .. mc-cmd:: ALIAS
      :required:

      The :ref:`alias <alias>` of an active MinIO deployment in the site replication configuration.


.. mc-cmd:: status
   :fullpath:

   Displays the status of the sites, buckets, users, groups, or policies for a site replication configuration.

   .. tab-set::
      
      .. tab-item:: EXAMPLES

         Display the overall replication status for a site replication configuration that includes the site ``minio1``.
         
         .. code-block:: shell
            
            mc admin replicate status minio1
        
         Display the replication status of buckets across sites for a site replication configuration that includes the site ``minio1``.

         .. code-block:: shell
            
            mc admin replicate status     \
                               minio1     \
                               --buckets

         Display the site replication status of a bucket called ``images`` across sites for a site replication configuration that contains the site ``minio1``.

         .. code-block:: shell

            mc admin replicate status           \
                                minio1          \
                                --bucket images

         Display the site replication status for the setting for a user, ``janedoe``, across sites for a site replication configuration that contains the site ``minio1``.

         .. code-block:: shell

            mc admin replicate status         \
                               minio1         \
                               --user janedoe

         The output of any of hte above examples resembles the following:

         .. code-block:: shell

            Bucket replication status:
            ●  30/30 Buckets in sync
            
            Policy replication status:
            ●  5/5 Policies in sync
            
            User replication status:
            ●  3/3 Users in sync
            
            Group replication status:
            No Groups present
            
            Object replication status:
            Replication status since 1 day 
            Summary:
            Replicated:    0 objects (0 B)
            Queued:        ● 0 objects, (0 B) (avg: 0 objects, 0 B; max: 0 objects, 0 B)
            Received:      0 objects (0 B)

      .. tab-item:: SYNTAX
         
         .. code-block:: shell
            
            mc [GLOBALFLAGS] admin replicate status     \
                               TARGET                   \
                               [--all]                  \
                               [--buckets]              \
                               [--bucket nameOfBucket]  \
                               [--groups]               \
                               [--group nameOfGroup]    \
                               [--policies]             \
                               [--policy nameOfPolicy]  \
                               [--users]                \
                               [--user accessKey]

   .. mc-cmd:: TARGET
      :required:
     
      The :ref:`alias <alias>` of an active MinIO deployment in the site replication configuration.
  
   .. mc-cmd:: --all
      :optional:

      Display all available site replication status information.

   .. mc-cmd:: --buckets
      :optional:
    
      Display the replication status of all buckets.

   .. mc-cmd:: --bucket
      :optional:
     
      Display the replication status of a specific bucket by including the bucket name after the flag.

   .. mc-cmd:: --groups
      :optional:

      Display the replication status of all groups.

   .. mc-cmd:: --group
      :optional:

      Display the replication status of a specific group by including the group name after the flag.

   .. mc-cmd:: --policies
      :optional:

      Display the replication status of all policies.

   .. mc-cmd:: --policy
      :optional:

      Display the replication status of a specific policy by including the policy name after the flag.

   .. mc-cmd:: --users
      :optional:
 
      Display the replication status of all users.
  
   .. mc-cmd:: --user
      :optional:

      Display the replication status of a specific user by including the user name after the flag.

.. mc-cmd:: resync
   :fullpath:

   Resynchronizes data from one site in the replication configuration to a second site in the replication configuration in the event of lost data.

   .. tab-set::
      
      .. tab-item:: EXAMPLES
         
         The following command starts a resynchronization process to restore ``minio2`` from ``minio1``

         .. code-block:: shell
            :class: copyable

            mc admin replicate resync start minio1 minio2

         The following command shows the status of a resynchronization currently in progress.

         .. code-block:: shell
            :class: copyable

            mc admin replicate resync status minio1 minio2

         The following command stops a resynchronization that is in progress.

         .. code-block:: shell
            :class: copyable

            mc admin replicate resync cancel minio1 minio2

      .. tab-item:: SYNTAX
         
         .. code-block:: shell
            
            mc [GLOBALFLAGS] admin replicate resync start|status|cancel ALIAS1 ALIAS2   

         - Replace ``ALIAS1`` with the alias for the site that has the data to restore.
         - Replace ``ALIAS2`` with the alias for the site that needs resynched data.

   .. mc-cmd:: start

      Launches a new resynchronization process from one site with data to a second site that needs synchronization.

   .. mc-cmd:: status

      Shows the status of an existing resynchronization process between two sites configured for site replication.

   .. mc-cmd:: cancel

      Ends a resynchronization process currently in progress between two sites configured for site replication.

   .. mc-cmd:: alias1

      The :ref:`alias <alias>` of an active MinIO deployment in the site replication configuration with the data you want to resync to another site.

   .. mc-cmd:: alias2

      The :ref:`alias <alias>` of an active MinIO deployment in the site replication configuration that needs data resynced from another site.
   

Global Flags
------------

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
