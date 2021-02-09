====================
``mc admin console``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin console

Description
-----------

.. start-mc-admin-console-desc

The :mc-cmd:`mc admin console` command returns server log entries for each
MinIO server in the deployment.

.. end-mc-admin-console-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only


Syntax
------

:mc-cmd:`mc admin console` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin console [FLAGS] TARGET NODENAME

:mc-cmd:`mc admin console` supports the following:

.. mc-cmd:: TARGET

   The :mc:`alias <mc alias>` of a configured MinIO deployment from which
   the command retrieves server logs.

.. mc-cmd:: NODENAME

   The specific MinIO server node from which the command retrieves server logs.

.. mc-cmd:: limit, l
   :option:

   The number of most recent log entries to show. Defaults to ``10``.

.. mc-cmd:: type, t
   :option:

   The type of errog logs to return. Specify one or more of the following
   options as a comma-seperated ``,`` list:

   - ``minio``
   - ``application``
   - ``all`` (Default)

