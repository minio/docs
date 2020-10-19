==================
``mc admin trace``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin trace

Description
-----------

.. start-mc-admin-trace-desc

The :mc-cmd:`mc admin trace` command displays the results of an
`HTTP TRACE <https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/TRACE>`__
request against each MinIO server in a deployment.

.. end-mc-admin-trace-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Example
-------

Use :mc:`mc admin trace` to perform an HTTP trace of each MinIO server in
the deployment:

.. code-block:: shell
   :class: copyable

   mc admin trace ALIAS

- Replace :mc-cmd:`ALIAS <mc admin trace TARGET>` with the 
  :mc-cmd:`alias <mc alias>` of the MinIO deployment.

Syntax
------

:mc-cmd:`mc admin trace` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin trace [FLAGS] TARGET

:mc-cmd:`mc admin trace` supports the following argument:

.. mc-cmd:: TARGET

   Specify the :mc-cmd:`alias <mc-alias>` of a configured MinIO deployment
   against which the command issues ``HTTP TRACE`` requests.

.. mc-cmd:: all, a
   :option:

   Returns all traffic on the MinIO deployment, including internode traffic
   between MinIO servers.

.. mc-cmd:: verbose
   :option:

   Returns verbose ``HTTP TRACE`` output.

.. mc-cmd:: errors, e
   :option:

   Returns failed ``HTTP TRACE`` requests only.
