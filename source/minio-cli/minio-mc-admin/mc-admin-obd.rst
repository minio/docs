================
``mc admin obd``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin obd

Description
-----------

.. start-mc-admin-obd-desc

The :mc:`mc admin obd` command generates detailed diagnostics for the
target MinIO deployment as a ``GZIP`` compressed ``JSON`` file. MinIO Support
may request the output of :mc:`mc admin obd` as part of troubleshooting
and diagnostics.

.. end-mc-admin-obd-desc

:mc:`mc admin odb` names the file using the following pattern:

.. code-block:: none

   alias-health_YYYYMMDDHHMMSS.json.gzip

The ``alias`` is the :mc-cmd:`~mc admin obd TARGET` MinIO deployment from which
:mc:`mc admin odb` returned the diagnostics.

The :mc:`mc admin odb` output may contain sensitive information about your
environment. Exercise all possible precautions, such as redacting sensitive
fields, prior to sharing the data on any public forum. 

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Syntax
------

:mc-cmd:`mc admin obd` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin obd [FLAGS] TARGET

:mc-cmd:`mc admin obd` supports the following arguments:

.. mc-cmd:: TARGET

   *Required*

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from which
   the command retrieves the diagnostic data.

.. mc-cmd:: deadline
   :option:

   The maximum duration the command can run. Specify a string as 
   ``##h##m##s``. Defaults to ``1h0m0s``. 

