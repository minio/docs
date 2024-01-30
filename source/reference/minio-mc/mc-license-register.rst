=======================
``mc license register``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support register
.. mc:: mc license register

.. important:: 

   ``mc license register`` requires :ref:`MinIO Client <minio-client>` version ``RELEASE.2023-11-20T16-30-59Z`` or later.

   For best functionality and compatibility, use a MinIO Client version released closely to your MinIO Server version. 
   For example, a MinIO Client released the same day or later than your MinIO Server version.

   You can install a version of the MinIO Client that is more recent than the MinIO Server version. 
   However, if the MinIO Client version skews too far from the MinIO Server version, you may see increased warnings or errors as a result of the differences.
   For example, while core S3 APIs around copying (:mc:`mc cp`) may remain unchanged, some features or flags may only be available or stable if the client and server versions are aligned.
   
   If for any reason you cannot upgrade your MinIO Client to the required version or later for the purpose of registering to SUBNET, register using the :ref:`MinIO Console <minio-docs-subnet>` instead.

Description
-----------

.. start-mc-license-register-desc

The :mc-cmd:`mc license register` command connects your deployment with your |SUBNET| account.

.. end-mc-license-register-desc

After registration, you can upload deployment health reports directly to SUBNET using the :mc-cmd:`mc support diag` command.

.. tab-set::

   .. tab-item:: EXAMPLE

         The following example registers the ``minio`` :ref:`alias <alias>` with |SUBNET|:

      .. code-block:: shell
         :class: copyable

         mc license register minio

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] license register ALIAS                      \
                                  [--airgap]                          \
                                  [--api-key <string>]                \
                                  [--license <path to license file>]  \
                                  [--name <value>]

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.

  
.. mc-cmd:: --airgap
   :optional:

   Use in environments without network access to SUBNET (for example, airgapped, firewalled, or similar configuration).

   For instructions, see the :ref:`airgap example <minio-license-register-airgap>`.

   If the deployment is airgapped, but the local device where you are using the :ref:`minio client <minio-client>` has network access, you do not need to use the ``--airgap`` flag.

.. mc-cmd:: --api-key

   API of the account on SUBNET.

   Corresponds with the ``MC_SUBNET_API_KEY`` environment variable.

   To find the API key:

   #. Log in to |SUBNET|
   #. Go to the :guilabel:`Deployments` tab
   #. Select the :guilabel:`API Key` button near the top of the page on the right side of the account statistics information box
   #. Select copy button to the right of the key field to copy the key value to your clipboard

.. mc-cmd:: --license
   :optional:

   Path to the license file to use for registering the deployment.
   
   You must first :ref:`download the license file <minio-subnet-license-file-download>` for the account.

.. mc-cmd:: --name
   :optional:

   Specify a name other than the alias to associate to the MinIO deployment in SUBNET.

   Use ``--name <value>`` replacing ``<value>`` with the name you want to use for the deployment on SUBNET.

Examples
--------

Register a Deployment Using the Deployment's Name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Register the MinIO deployment at alias ``minio1`` on SUBNET, using ``minio1`` as the deployment name:

.. code-block:: shell
   :class: copyable

   mc license register minio1

If not already registered, a prompt asks for SUBNET credentials for the deployment.

Register a Deployment Using the Account's License File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Register a new MinIO deployment at alias ``minio5`` on SUBNET, using the license file downloaded for the account:

.. code-block:: shell
   :class: copyable

   mc license register minio5 /path/to/minio.license

If not already downloaded, you can :ref:`download the license file <minio-subnet-license-file-download>` from SUBNET.

Register a Deployment with a Different Deployment Name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Register a MinIO deployment at alias ``minio2`` on SUBNET, using ``second-deployment`` as the name:

.. code-block:: shell
   :class: copyable

   mc license register minio2 --name second-deployment

.. _minio-license-register-airgap:

Register a Deployment Without Direct Internet Access
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Register a MinIO deployment at alias ``minio3`` on SUBNET that does not have direct Internet access due to a firewall, airgap, or the like.

.. versionchanged:: mc RELEASE.2022-07-29T19-17-16Z

   The airgap registration process works with MinIO Client version ``RELEASE.2022-07-29T19-17-16Z`` or later.
   Earlier versions of the MinIO Client cannot register an airgapped deployment.

.. code-block:: shell
   :class: copyable

   mc license register minio3 --airgap

#. Run the command to return a registration link with token
#. Open the copied registration link in a web browser and sign in to SUBNET
#. Select the :guilabel:`?` button to the right of the :guilabel:`License` number for the deployment
#. In the popup, select the download link and save the key to a path you have access to
#. In the command line, run the following command
   
   .. code-block:: shell
      :class: copyable

      mc license update minio3 <path-to-file>

   Replace ``<path-to-file>`` with the path to the file you downloaded from SUBNET.

Syntax
------
      
The command has the following syntax:

.. code-block:: shell

   mc [GLOBALFLAGS] license register       \
                            ALIAS          \
                            [--name value] \
                            [--airgap]




Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Behavior
--------

Automatic License Updates
~~~~~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: RELEASE.2023-01-18T04-36-38Z

Once registered for |SUBNET|, MinIO automatically checks for and updates the license every month.

In airgapped or other environments where the server does not have direct access to the internet, use :mc-cmd:`mc license update` with the path to the file to update the registration.