===================
``mc admin update``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc admin update

Description
-----------

.. start-mc-admin-update-desc

The :mc-cmd:`mc admin update` command updates all MinIO servers in the deployment. 
The command also supports using a private mirror server for environments where the deployment does not have public internet access.

.. end-mc-admin-update-desc

After running the command, a prompt displays to confirm the update.
Type ``y`` and ``[ENTER]`` to confirm and proceed with the update.
You may need to use ``sudo`` if your user does not have write permissions for the path where ``mc`` is installed.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only


Considerations
--------------

Updates are Non-Disruptive
~~~~~~~~~~~~~~~~~~~~~~~~~~

:mc-cmd:`mc admin update` updates the binary and restarts all MinIO servers in the deployment simultaneously. 
MinIO operations are atomic and strictly consistent and as such the restart process is non-disruptive to applications.

MinIO strongly recommends only performing simultaneous upgrade-and-restart procedures. 
Do not perform "rolling" (that is, one node at a time) upgrade procedures.

Examples
--------

Use :mc-cmd:`mc admin update` to update each :mc:`minio` server process in the MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin update ALIAS

Replace :mc-cmd:`ALIAS <mc admin update ALIAS>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

After running the command, answer yes to the prompt to confirm and process the update.

Syntax
------

:mc-cmd:`mc admin update` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin update ALIAS         \
                   [MIRROR_URL]  \
                   [--yes]             

:mc-cmd:`mc admin update` supports the following arguments:

.. mc-cmd:: ALIAS

   The :mc-cmd:`alias <mc alias>` of the MinIO deployment to update. 

   If the specified ``ALIAS`` corresponds to a distributed MinIO deployment, :mc-cmd:`mc admin update` updates *all* MinIO servers in the deployment at the same time. 

   Use :mc:`mc alias list` to review the configured aliases and their corresponding MinIO deployment endpoints.

.. mc-cmd:: MIRROR_URL
   
   The mirror URL of the ``minio`` server binary to use for updating MinIO servers in the :mc-cmd:`~mc admin update ALIAS` deployment.

.. mc-cmd:: --yes, -y
   :optional:

   Pass this flag to confirm the update and bypass the confirmation prompt.

Behavior
--------

Binary Compression 
~~~~~~~~~~~~~~~~~~

Starting with :minio-release:`RELEASE.2024-01-28T22-35-53Z`, :mc-cmd:`mc admin update` compresses the binary before sending to all nodes in the deployment.

This feature does not apply to :ref:`systemctl managed deployments <minio-upgrade-systemctl>`.