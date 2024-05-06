====================
``mc admin console``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin console

.. important::

   This command has been replaced by :mc:`mc admin logs` in `mc RELEASE.2022-12-02T23-48-47Z <https://github.com/minio/mc/releases/tag/RELEASE.2022-12-02T23-48-47Z>`__.

   The command was previously replaced by ``mc support logs show`` in `mc RELEASE.2022-06-26T18-51-48Z <https://github.com/minio/mc/tree/RELEASE.2022-06-26T18-51-48Z>`__.

Description
-----------

The :mc:`mc admin console` command returns server log entries for each
MinIO server in the deployment.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only


Syntax
------

:mc:`mc admin console` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin console [FLAGS] TARGET NODENAME

:mc:`mc admin console` supports the following:

.. mc-cmd:: TARGET

   The :mc:`alias <mc alias>` of a configured MinIO deployment from which
   the command retrieves server logs.

.. mc-cmd:: NODENAME

   The specific MinIO server node from which the command retrieves server logs.

.. mc-cmd:: --limit, l
   

   The number of most recent log entries to show. Defaults to ``10``.

.. mc-cmd:: --type, t
   

   The type of errog logs to return. Specify one or more of the following
   options as a comma-seperated ``,`` list:

   - ``minio``
   - ``application``
   - ``all`` (Default)

