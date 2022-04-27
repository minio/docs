=========================
``mc admin replicate``
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin replicate

Description
-----------

.. start-mc-admin-replicate-desc

The :mc:`mc admin replicate` command creates and manages :ref:`site replication <minio-site-replication-overview>` for a set of MinIO peer sites.

Where :ref:`bucket replication <minio-bucket-replication>` manages the mirroring of particular buckets or objects from one location to another within a deployment or across deployments, site replication continuously mirrors an entire MinIO site to other sites.

Site replication mimics an active-active bucket replication, but for multiple MinIO sites.
Wherever a change occurs to IAM settings, buckets, or objects across the set of sites, the change replicates across all sites in the site replication group.

.. end-mc-admin-replicate-desc

:mc:`mc admin replicate` only supports site replication for distributed deployments across multiple sites.

Site replication requires that bucket versioning be enabled.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Syntax
------

.. code-block:: shell
   
   mc admin replicate COMMAND SUBCOMMAND <TARGET(s)> [FLAGS | -h] [ARGUMENTS...]


Subcommands
-----------

The :mc:`mc admin replicate` command has the following subcommands:

.. mc-cmd:: add

   Adds one or more sites for replication.
 
.. mc-cmd:: edit

   Edits the endpoint of a site participating in cluster replication

   Flags include:
       
   - ``--deployment-id <value>`` 
    
     Specify the deployment ID of the site to edit
   
   - ``--endpoint <value>`` 
    
     Specify the new endpoint to use for the edited site

.. mc-cmd:: remove

   Removes one or more sites from site replication.

.. mc-cmd:: info
   
   Returns information about site replication.

.. mc-cmd:: status

   Displays site replication status
      
   Flags include:

   - ``--all`` 
    
     Display all available site replication status information

   - ``--buckets`` 
     
     Display the status of buckets only

   - ``--policies`` 
     
     Display the status of policies only

   - ``--users`` 
   
     Display the status of users only

   - ``--groups`` 
    
     Display the status of groups only

   - ``--bucket <value>`` 
    
     Display the status of a specific bucket

   - ``--policy <value>`` 
 
     Display the status of a specific policy
   
   - ``--user <value>`` 
     
     Display the status of a particular user

   - ``--group <value>`` 
     
     Display the status of a particular group


Examples
~~~~~~~~

- Create site replication across four deployments called ``minio1``, ``minio2``, ``minio3``, and ``minio4``.
 
  Or, add ``minio4`` to an existing site replication with the other three sites
  
  .. code-block:: shell
    
     mc admin replicate add minio1 minio2 minio3 minio4

- Retrieve site replication information for the site ``minio1``
  
  .. code-block:: shell
     
     mc admin replicate info minio1

- Change the endpoint used for a specific site

  .. code-block:: shell
    
     mc admin replicate edit --deployment-id c1758167-4426-454f-9aae-5c3dfdf6df64 --endpoint https://minio2:9000

- Retrieve the status information for an ``images`` bucket on the site ``minio1``
 
  .. code-block:: shell
    
     mc admin replicate status minio1 --bucket images

- Display status information for all policies for the site ``minio1``
 
  .. code-block:: shell
     
     mc admin replicate status minio1 --policies


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals