=======================
``mc support register``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support register

Description
-----------

The :mc-cmd:`mc support register` command connects your deployment with your |SUBNET| account.

After registration, upload deployment health reports directly to SUBNET using :mc-cmd:`mc support diagnostics` command.


Examples
--------

Register a Deployment Using the Cluster's Name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Register the MinIO deployment at alias ``minio1`` on SUBNET, using ``minio1`` as the cluster name:

.. code-block:: shell
   :class: copyable

   mc support register minio1

Register a Deployment with a Different Cluster Name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Register a MinIO deployment at alias ``minio2`` on SUBNET, using ``second-cluster`` as the name:

.. code-block:: shell
   :class: copyable

   mc support register minio2 --name second-cluster

.. _minio-support-register-airgap:

Register a Deployment Without Direct Internet Access
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Register a MinIO deployment at alias ``minio3`` on SUBNET that does not have direct Internet access due to a firewall, airgap, or the like.

.. code-block:: shell
   :class: copyable

   mc support register minio3 --airgap

#. Run the command to return a registration token
#. Copy the registration token
#. In a web browser, go to https://subnet.min.io and log in with your |SUBNET| credentials
#. Select the  :guilabel:`Register` button
#. Select :guilabel:`No` for the question :guilabel:`"Is the cluster connected to the internet?"`
#. Paste the copied token into the box for :guilabel:`Register using MinIO Client Utility`
#. Select :guilabel:`Register`
#. Copy the API token that displays
#. Back in the terminal, paste or enter the API token to complete the registration process


Syntax
------
      
The command has the following syntax:

.. code-block:: shell

   mc [GLOBALFLAGS] support register       \
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

   Specify a name other than the alias to associate to the MinIO cluster in SUBNET.

   Use ``--name <value>`` replacing ``<value>`` with the name you want to use for the cluster on SUBNET.
   
.. mc-cmd:: --airgap
   :optional:

   Use in environments without network access to SUBNET (for example, airgapped, firewalled, or similar configuration).

   For instructions, see the :ref:`airgap example <minio-support-register-airgap>`.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
