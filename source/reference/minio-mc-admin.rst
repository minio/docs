==================
MinIO Admin Client
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc admin

The MinIO Client :mc-cmd:`mc` command line tool provides The command
command for performing administrative tasks on your MinIO deployments.

While :mc-cmd:`mc` supports any S3-compatible service, 
:mc:`mc admin` *only* supports MinIO deployments.

:mc:`mc admin` has the following syntax:

.. code-block:: shell

   mc admin [FLAGS] COMMAND [ARGUMENTS]

Command Quick reference
-----------------------

The following table lists :mc:`mc admin` commands:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Command
     - Description

   * - :mc-cmd:`mc admin bucket remote`
     - .. include:: /reference/minio-mc-admin/mc-admin-bucket-remote.rst
          :start-after: start-mc-admin-bucket-remote-desc
          :end-before: end-mc-admin-bucket-remote-desc

   * - :mc-cmd:`mc admin console`
     - .. include:: /reference/minio-mc-admin/mc-admin-console.rst
          :start-after: start-mc-admin-console-desc
          :end-before: end-mc-admin-console-desc

   * - :mc-cmd:`mc admin decommission`
     - .. include:: /reference/minio-mc-admin/mc-admin-decommission.rst
          :start-after: start-mc-admin-decommission-desc
          :end-before: end-mc-admin-decommission-desc

   * - :mc:`mc admin group`
     - .. include:: /reference/minio-mc-admin/mc-admin-group.rst
          :start-after: start-mc-admin-group-desc
          :end-before: end-mc-admin-group-desc

   * - :mc-cmd:`mc admin heal`
     - .. include:: /reference/minio-mc-admin/mc-admin-heal.rst
          :start-after: start-mc-admin-heal-desc
          :end-before: end-mc-admin-heal-desc

   * - :mc-cmd:`mc admin idp ldap`
     - .. include:: /reference/minio-mc-admin/mc-admin-idp-ldap.rst
          :start-after: start-mc-admin-idp-ldap-desc
          :end-before: end-mc-admin-idp-ldap-desc
  
   * - :mc-cmd:`mc admin idp openid`
     - .. include:: /reference/minio-mc-admin/mc-admin-idp-openid.rst
          :start-after: start-mc-admin-idp-openid-desc
          :end-before: end-mc-admin-idp-openid-desc

   * - :mc-cmd:`mc admin info`
     - .. include:: /reference/minio-mc-admin/mc-admin-info.rst
          :start-after: start-mc-admin-info-desc
          :end-before: end-mc-admin-info-desc

   * - :mc-cmd:`mc admin kms key`
     - .. include:: /reference/minio-mc-admin/mc-admin-kms-key.rst
          :start-after: start-mc-admin-kms-key-desc
          :end-before: end-mc-admin-kms-key-desc

   * - :mc-cmd:`mc admin logs`
     - .. include:: /reference/minio-mc-admin/mc-admin-logs.rst
          :start-after: start-mc-admin-logs-desc
          :end-before: end-mc-admin-logs-desc

   * - :mc-cmd:`mc admin obd`
     - .. include:: /reference/minio-mc-admin/mc-admin-obd.rst
          :start-after: start-mc-admin-obd-desc
          :end-before: end-mc-admin-obd-desc

   * - :mc:`mc admin policy`
     - .. include:: /reference/minio-mc-admin/mc-admin-policy.rst
          :start-after: start-mc-admin-policy-desc
          :end-before: end-mc-admin-policy-desc

   * - :mc-cmd:`mc admin profile`
     - .. include:: /reference/minio-mc-admin/mc-admin-profile.rst
          :start-after: start-mc-admin-profile-desc
          :end-before: end-mc-admin-profile-desc

   * - :mc-cmd:`mc admin prometheus`
     - .. include:: /reference/minio-mc-admin/mc-admin-prometheus.rst
          :start-after: start-mc-admin-prometheus-desc
          :end-before: end-mc-admin-prometheus-desc

   * - :mc-cmd:`mc admin rebalance`
     - .. include:: /reference/minio-mc-admin/mc-admin-rebalance.rst
          :start-after: start-mc-admin-rebalance-desc
          :end-before: end-mc-admin-rebalance-desc

   * - :mc-cmd:`mc admin replicate`
     - .. include:: /reference/minio-mc-admin/mc-admin-replicate.rst
          :start-after: start-mc-admin-replicate-desc
          :end-before: end-mc-admin-replicate-desc

   * - :mc-cmd:`mc admin service`
     - .. include:: /reference/minio-mc-admin/mc-admin-service.rst
          :start-after: start-mc-admin-service-desc
          :end-before: end-mc-admin-service-desc

   * - :mc-cmd:`mc admin top`
     - .. include:: /reference/minio-mc-admin/mc-admin-top.rst
          :start-after: start-mc-admin-top-desc
          :end-before: end-mc-admin-top-desc

   * - :mc-cmd:`mc admin trace`
     - .. include:: /reference/minio-mc-admin/mc-admin-trace.rst
          :start-after: start-mc-admin-trace-desc
          :end-before: end-mc-admin-trace-desc

   * - :mc-cmd:`mc admin update`
     - .. include:: /reference/minio-mc-admin/mc-admin-update.rst
          :start-after: start-mc-admin-update-desc
          :end-before: end-mc-admin-update-desc

   * - :mc:`mc admin user`
     - .. include:: /reference/minio-mc-admin/mc-admin-user.rst
          :start-after: start-mc-admin-user-desc
          :end-before: end-mc-admin-user-desc

.. _mc-admin-install:

Installation
------------

.. include:: /includes/minio-mc-installation.rst

Quickstart
----------

Ensure that the host machine has :mc:`mc`
:ref:`installed <mc-admin-install>` prior to starting this procedure.

.. important::

   The following example temporarily disables the bash history to mitigate the
   risk of authentication credentials leaking in plain text. This is a basic
   security measure and does not mitigate all possible attack vectors. Defer to
   security best practices for your operating system for inputting sensitive
   information on the command line.

Use the :mc:`mc alias set` command to add the
deployment to the :program:`mc` configuration.

.. code-block:: shell
   :class: copyable

   bash +o history
   mc config host add <ALIAS> <ENDPOINT> ACCESS_KEY SECRET_KEY
   bash -o history

Replace each argument with the required values. Specifying only the 
``mc config host add`` command starts an input prompt for entering the
required values.

Use the :mc-cmd:`mc admin info` command to test the connection to
the newly added MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin info <ALIAS>

Global Options
--------------

:mc:`mc admin` supports the same global options as :mc-cmd:`mc`. 
See :ref:`minio-mc-global-options`.

.. toctree::
   :titlesonly:
   :hidden:
   :glob:

   /reference/minio-mc-admin/mc-admin-bucket-remote.rst
   /reference/minio-mc-admin/mc-admin-config
   /reference/minio-mc-admin/mc-admin-console
   /reference/minio-mc-admin/mc-admin-decommission
   /reference/minio-mc-admin/mc-admin-group
   /reference/minio-mc-admin/mc-admin-heal
   /reference/minio-mc-admin/mc-admin-idp-ldap
   /reference/minio-mc-admin/mc-admin-idp-ldap-policy
   /reference/minio-mc-admin/mc-admin-idp-openid
   /reference/minio-mc-admin/mc-admin-info
   /reference/minio-mc-admin/mc-admin-kms-key
   /reference/minio-mc-admin/mc-admin-logs
   /reference/minio-mc-admin/mc-admin-obd
   /reference/minio-mc-admin/mc-admin-policy
   /reference/minio-mc-admin/mc-admin-profile
   /reference/minio-mc-admin/mc-admin-prometheus
   /reference/minio-mc-admin/mc-admin-rebalance
   /reference/minio-mc-admin/mc-admin-replicate
   /reference/minio-mc-admin/mc-admin-service
   /reference/minio-mc-admin/mc-admin-top
   /reference/minio-mc-admin/mc-admin-trace
   /reference/minio-mc-admin/mc-admin-update
   /reference/minio-mc-admin/mc-admin-user
 
