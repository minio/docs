=====================
``mc license update``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc license update

.. important:: 

   This command is no longer maintained in the Open Source MinIO Server or MinIO Client product and has been removed completely as of MinIO Client ``RELEASE.2024-07-03T20-17-25Z``.

   For questions about licensing the MinIO Server, contact sales@min.io.

.. note::

   ``mc license update`` requires :ref:`MinIO Client <minio-client>` version ``RELEASE.2023-11-20T16-30-59Z``.
   While not strictly required, best practice keeps the :ref:`MinIO Client version <mc-client-versioning>` in alignment with the MinIO Server version.
   
   If for any reason you cannot upgrade your MinIO Client to the required version or later for the purpose of registering to SUBNET, register using the :ref:`MinIO Console <minio-docs-subnet>` instead.

Description
-----------

.. start-mc-license-update-desc

Use the :mc-cmd:`mc license update` command to replace a license key for a deployment.

.. end-mc-license-update-desc

.. versionchanged:: RELEASE.2023-01-18T04-36-38Z

   For deployments registered for |SUBNET|, MinIO automatically checks for and updates the license every month.

If not passed with the command, MinIO checks the license file on SUBNET and automatically updates it.

Examples
--------

Update the License Key for a Deployment with Alias ``minio1``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc license update minio1 license.key

Syntax
------
      
The command has the following syntax:

.. code-block:: shell

   mc [GLOBALFLAGS] license update                   \
                            ALIAS                    \
                            [LICENSE-FILE-WITH-PATH] \
                            [--airgap]

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.

.. mc-cmd:: LICENSE-FILE-WITH-PATH
   :optional:

   The path (relative to the current working directory) and file name of the key to use to update the deployment's license.

   See the :ref:`troubleshooting page <minio-subnet-license-file-download>` for instructions on downloading the license file.
   
.. mc-cmd:: --airgap
   :optional:

   Use in environments without network access to SUBNET (for example, airgapped, firewalled, or similar configuration).

   If the deployment is airgapped, but the local device where you are using the :ref:`minio client <minio-client>` has network access, you do not need to use the ``--airgap`` flag.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
