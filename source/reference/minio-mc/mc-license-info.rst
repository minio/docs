===================
``mc license info``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc license info

Description
-----------

The :mc-cmd:`mc license info` command displays information about the MinIO deployment's license status.
Specifically, whether the deployment uses the AGPLv3 Open Source license of the `MinIO Commercial License <https://min.io/product/subnet?ref=docs>`__.

You must register your deployment with MinIO |SUBNET| to activate your commercial license.

For example, the command returns the following information for an unregistered deployment:

.. code-block:: shell

   You are using GNU AFFERO GENERAL PUBLIC LICENSE Version 3 (https://www.gnu.org/licenses/agpl-3.0.txt)

   If you are building proprietary applications, you may want to choose the commercial license 
   included as part of the Standard and Enterprise subscription plans. (https://min.io/signup?ref=mc)

   Applications must otherwise comply with all the GNU AGPLv3 License & Trademark obligations.

Use :mc-cmd:`mc license register` to associate your deployment with your SUBNET account.
If you are not already signed up for SUBNET, see the `Registration <https://min.io/pricing?ref=docs>`__ page.

Examples
--------

Display the Current License for a Deployment with Alias ``minio1``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc license info minio1

If a deployment uses an expired MinIO Commercial License, the command outputs an error message.

Syntax
------
      
The command has the following syntax:

.. code-block:: shell

   mc [GLOBALFLAGS] license info       \
                            ALIAS      \
                            [--airgap]

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.
   
.. mc-cmd:: --airgap
   :optional:

   Use in environments where the client machine running the :ref:`minio client <minio-client>` does not have network access to SUBNET (for example, airgapped, firewalled, or similar configuration) to display instructions for how to register the deployment with SUBNET.
   
   If the deployment is airgapped, but the local device has network access, you do not need to use the ``--airgap`` flag.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
