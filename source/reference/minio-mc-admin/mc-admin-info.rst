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

.. versionadded:: mc RELEASE.2024-05-03T11-21-07Z

   The command output includes information about the :ref:`erasure code <minio-ec-erasure-set>` setting for the cluster.
   This displays in the output in the format ``EC:#``.

The output of the command resembles the following:

.. code-block::

   ●  play.min.io
      Uptime: 2 hours 
      Version: 2024-05-10T08:24:14Z
      Network: 1/1 OK 
      Drives: 4/4 OK 
      Pool: 1
   
   Pools:
      1st, Erasure sets: 1, Drives per erasure set: 4
   
   0 B Used, 3 Buckets, 0 Objects
   4 drives online, 0 drives offline, EC:1
   

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

   mc admin info TARGET      \
                 [--offline]

Specify the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment as the ``TARGET``.

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:
   
   The :ref:`alias <alias>` about which you want to display information.

.. mc-cmd:: --offline
   :optional:

   Show only offline drives or nodes.