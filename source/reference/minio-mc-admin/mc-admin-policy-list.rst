========================
``mc admin policy list``
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin policy list

Syntax
------

.. start-mc-admin-policy-list-desc

Lists all policies on the target MinIO deployment.

.. end-mc-admin-policy-list-desc


.. tab-set::

   .. tab-item:: EXAMPLE

      The following command displays a list of the policies currently current on the :term:`alias` ``play``.

      .. code-block:: shell
         :class: copyable

         mc admin policy list play

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc admin policy list TARGET

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

The :mc-cmd:`mc admin policy list` command accepts the following arguments:

.. mc-cmd:: TARGET
   
   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from which the command lists the available policies.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

List the policies that exist on the deployment at alias ``myminio``.

.. code-block:: shell
   :class: copyable

   mc admin policy list myminio

Output
~~~~~~

The command returns output that resembles the following:

.. code-block:: shell

   readwrite
   writeonly