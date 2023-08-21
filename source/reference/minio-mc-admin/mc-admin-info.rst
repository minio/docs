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
For distributed MinIO deployments, :mc-cmd:`mc admin info` displays information
for each MinIO server in the deployment.

.. end-mc-admin-info-desc

  
The output of the command resembles the following:

.. code-block::

   ●  play.min.io
      Uptime: 14 hours 
      Version: 2023-08-17T16:37:55Z
      Network: 1/1 OK 
      Drives: 4/4 OK 
      Pool: 1

   Pools:
      1st, Erasure sets: 1, Drives per erasure set: 4

   4.3 GiB Used, 499 Buckets, 3,547 Objects, 554 Versions, 67 Delete Markers
   4 drives online, 0 drives offline

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

Specify the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment as the ``TARGET``.