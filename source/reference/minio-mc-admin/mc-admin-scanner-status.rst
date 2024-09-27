===========================
``mc admin scanner status``
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin scanner info
.. mc:: mc admin scanner status

Description
-----------

.. start-mc-admin-scanner-status-desc

The :mc-cmd:`mc admin scanner status` command displays a real-time summary of :ref:`scanner <minio-concepts-scanner>` information for a MinIO Server.

.. end-mc-admin-scanner-status-desc

This command has an alias of ``mc admin scanner info``.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example returns information about the current state of the scanner process.

      .. code-block:: shell
         :class: copyable

         mc admin scanner status myminio

      The command returns results similar to the following:

      .. code-block:: shell
         
         Overall Statistics                               	
         ------------------                                                  	
         Last full scan time:   0d0h15m; Estimated 2879.79/month             	
         Current cycle:         (between cycles)                             	
         Active drives: 0                                                    	
                                                                             	
         Last Minute Statistics                                              	
         ----------------------                                              	
         Objects Scanned:       3 objects; Avg: 67.611µs; Rate: 4320/day     	
         Versions Scanned:      3 versions; Avg: 2.506µs; Rate: 4320/day     	
         Versions Heal Checked: 0 versions; Avg: 0ms                         	
         Read Metadata:         3 objects; Avg: 40.817µs, Size: 395 bytes/obj	
         ILM checks:            3 versions; Avg: 714ns                       	
         Check Replication:     3 versions; Avg: 892ns                       	
         Verify Deleted:        0 folders; Avg: 0ms                          	
         Yield:                 18ms total; Avg: 6ms/obj     

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc admin scanner status ALIAS
                                [--bucket <string>]     \
                                [--interval <value>]   \
                                [--max-paths <value>]  \
                                [-n <integer>]         \
                                [--nodes <string>] 

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment for which to display :ref:`scanner <minio-concepts-scanner>` API operations.

.. mc-cmd:: --bucket
   :optional:

   Filter scanner statistics to the specified bucket.

.. mc-cmd:: --interval
   :optional:

   The number of seconds to wait between status request refreshes.
   If not specified, the status refreshes every 3 seconds.

.. mc-cmd:: --max-paths
   :optional:

   The maximum number of active paths to show.
   Use ``-1`` for an unlimited number of paths.
   If not specified, the results return for an unlimited number of active paths.

.. mc-cmd:: -n
   :optional:

   The number of status requests to return before automatically exiting.
   Use ``0`` to return an unlimited number of status results.

   If not specified, the results continuously refresh at the specified interval until manually exited.

.. mc-cmd:: --nodes
   :optional:

   Returns scanner status information for the specified node(s).
   Specify multiple nodes as a comma-separated list.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

