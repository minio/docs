=======================
``mc license register``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support register
.. mc:: mc license register


Description
-----------

.. start-mc-license-register-desc

The :mc-cmd:`mc license register` command connects your deployment with your |SUBNET| account.

.. end-mc-license-register-desc

After registration, you can upload deployment health reports directly to SUBNET using the :mc-cmd:`mc support diag` command.


Examples
--------

Register a Deployment Using the Deployment's Name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Register the MinIO deployment at alias ``minio1`` on SUBNET, using ``minio1`` as the deployment name:

.. code-block:: shell
   :class: copyable

   mc license register minio1

If not already registered, a prompt asks for SUBNET credentials for the deployment.

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

.. code-block:: shell
   :class: copyable

   mc license register minio3 --airgap

#. Run the command to return a registration link with token
#. Go to the copied registration link in a web browser and sign in to SUBNET, if necessary
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

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.

.. mc-cmd:: --name
   :optional:

   Specify a name other than the alias to associate to the MinIO deployment in SUBNET.

   Use ``--name <value>`` replacing ``<value>`` with the name you want to use for the deployment on SUBNET.
   
.. mc-cmd:: --airgap
   :optional:

   Use in environments without network access to SUBNET (for example, airgapped, firewalled, or similar configuration).

   For instructions, see the :ref:`airgap example <minio-license-register-airgap>`.

   If the deployment is airgapped, but the local device where you are using the :ref:`minio client <minio-client>` has network access, you do not need to use the ``--airgap`` flag.


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