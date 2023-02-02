=========================
``mc license unregister``
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc license unregister


Description
-----------

.. start-mc-license-unregister-desc

The :mc-cmd:`mc license unregister` command disconnects your deployment from your |SUBNET| account.

.. end-mc-license-unregister-desc

.. important::

   After unregistering, you can no longer use the :mc:`mc support` commands.


Examples
--------

Unregister a Deployment Using the Deployment's Name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Remove the registration of the MinIO deployment at alias ``minio1`` from SUBNET.

.. code-block:: shell
   :class: copyable

   mc license unregister minio1

Syntax
------
      
The command has the following syntax:

.. code-block:: shell

   mc [GLOBALFLAGS] license unregister ALIAS       \
                                       [--airgap]

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.

.. mc-cmd:: --airgap
   :optional:

   .. versionadded:: RELEASE.2023-01-28T20-29-38Z

   Removes registration info from the deployment without also unregistering from SUBNET.
   Use in environments without direct access to the Internet.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
