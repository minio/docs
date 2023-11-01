.. _minio-mc-admin-config:

===================
``mc admin config``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin config

Description
-----------

.. start-mc-admin-config-desc

The :mc:`mc admin config` command manages configuration settings for the
:mc:`minio` server.

.. end-mc-admin-bucket-remote-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Examples
--------

Syntax
------

.. mc-cmd:: set
   :fullpath:

   Sets a :ref:`configuration key <minio-server-configuration-settings>` on the MinIO deployment.
   Configurations defined by environment variables override configurations defined by this command.

   For distributed deployments, use to modify existing endpoints.

   Endpoints using the http protocol can be either the hostname or IP address, and they may use either ``http`` or ``https``.

.. mc-cmd:: get
   :fullpath:

   Gets a :ref:`configuration key <minio-server-configuration-settings>` on the MinIO deployment created using `mc admin config set`.

.. mc-cmd:: export
   :fullpath:

   Exports any configuration settings created using `mc admin config set`.

.. mc-cmd:: history
   :fullpath:

   Lists the history of changes made to configuration keys by `mc admin config`.

   Configurations defined by environment variables do not show.

.. mc-cmd:: import
   :fullpath:

   Imports configuration settings exported using `mc admin config export`.

.. mc-cmd:: reset
   :fullpath:

   Resets config to defaults.
   Configurations defined in environment variables are not affected.

.. mc-cmd:: restore
   :fullpath:

   Roll back changes to configuration keys to a previous point in history.

   Does not affect configurations defined by environment variables.

Configuration Settings
----------------------

For a list of available configuration settings, see :ref:`minio-server-configuration-settings`.