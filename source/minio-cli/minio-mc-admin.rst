==========================
MinIO Admin (``mc admin``)
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc admin

The MinIO Client :mc-cmd:`mc` command line tool provides the :mc-cmd:`mc admin`
command for performing administrative tasks on your MinIO deployments.

While :mc-cmd:`mc` supports any S3-compatible service, 
:mc-cmd:`mc admin` *only* supports MinIO deployments.

:mc-cmd:`mc admin` has the following syntax:

.. code-block:: shell

   mc admin [FLAGS] COMMAND [ARGUMENTS]

Command Quick reference
-----------------------

The following table lists :mc-cmd:`mc admin` commands:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Command
     - Description

   * - :mc:`mc admin bucket remote`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-bucket-remote.rst
          :start-after: start-mc-admin-bucket-remote-desc
          :end-before: end-mc-admin-bucket-remote-desc

   * - :mc:`mc admin bucket quota`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-bucket-quota.rst
          :start-after: start-mc-admin-bucket-quota-desc
          :end-before: end-mc-admin-bucket-quota-desc

   * - :mc:`mc admin group`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-group.rst
          :start-after: start-mc-admin-group-desc
          :end-before: end-mc-admin-group-desc

   * - :mc:`mc admin heal`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-heal.rst
          :start-after: start-mc-admin-heal-desc
          :end-before: end-mc-admin-heal-desc

   * - :mc:`mc admin info`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-info.rst
          :start-after: start-mc-admin-info-desc
          :end-before: end-mc-admin-info-desc

   * - :mc:`mc admin kms key`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-kms-key.rst
          :start-after: start-mc-admin-kms-key-desc
          :end-before: end-mc-admin-kms-key-desc

   * - :mc:`mc admin obd`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-obd.rst
          :start-after: start-mc-admin-obd-desc
          :end-before: end-mc-admin-obd-desc

   * - :mc:`mc admin policy`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-policy.rst
          :start-after: start-mc-admin-policy-desc
          :end-before: end-mc-admin-policy-desc

   * - :mc:`mc admin profile`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-profile.rst
          :start-after: start-mc-admin-profile-desc
          :end-before: end-mc-admin-profile-desc

   * - :mc:`mc admin prometheus`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-prometheus.rst
          :start-after: start-mc-admin-prometheus-desc
          :end-before: end-mc-admin-prometheus-desc

   * - :mc:`mc admin service`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-service.rst
          :start-after: start-mc-admin-service-desc
          :end-before: end-mc-admin-service-desc

   * - :mc:`mc admin top`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-top.rst
          :start-after: start-mc-admin-top-desc
          :end-before: end-mc-admin-top-desc

   * - :mc:`mc admin trace`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-trace.rst
          :start-after: start-mc-admin-trace-desc
          :end-before: end-mc-admin-trace-desc

   * - :mc:`mc admin update`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-update.rst
          :start-after: start-mc-admin-update-desc
          :end-before: end-mc-admin-update-desc

   * - :mc:`mc admin user`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-user.rst
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

Use the :mc-cmd:`mc alias set` command to add the
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

:mc-cmd:`mc admin` supports the same global options as 
:mc-cmd:`mc`. See :ref:`minio-mc-global-options`.

.. toctree::
   :titlesonly:
   :hidden:
   :glob:

   /minio-cli/minio-mc-admin/*
