=====================
``mc license update``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc license update

.. important:: 

   ``mc license register`` requires :ref:`MinIO Client <minio-client>` version ``RELEASE.2023-11-20T16-30-59Z``.

   For best functionality and compatibility, use a MinIO Client version released closely to your MinIO Server version. 
   For example, a MinIO Client released the same day or later than your MinIO Server version.

   You can install a version of the MinIO Client that is more recent than the MinIO Server version. 
   However, if the MinIO Client version skews too far from the MinIO Server version, you may see increased warnings or errors as a result of the differences.
   For example, while core S3 APIs around copying (:mc:`mc cp`) may remain unchanged, some features or flags may only be available or stable if the client and server versions are aligned.

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
