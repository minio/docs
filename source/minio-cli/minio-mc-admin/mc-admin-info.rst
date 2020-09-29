=================
``mc admin info``
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc admin info

Description
-----------

.. start-mc-admin-info-desc

The :mc-cmd:`mc admin info` command displays information on a MinIO server.
For distributed MinIO deployments, :mc:`mc admin info` displays information
for each MinIO server in the deployment.

.. end-mc-admin-info-desc

Examples
--------

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc admin info play

Syntax
------

:mc-cmd:`mc admin info` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin info TARGET

Specify the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment as the
``TARGET``. :mc-cmd:`~mc admin service restart` restarts *all* MinIO servers in
the deployment.