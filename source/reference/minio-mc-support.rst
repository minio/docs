==============================
MinIO Support (``mc support``)
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support

The MinIO Client :mc-cmd:`mc support` command line tool provides commands related to the MinIO subscription network, SUBNET, and the ability to performance analysis on performance and diagnostic information.

While :mc-cmd:`mc` supports any S3-compatible service, :mc-cmd:`mc support` *only* supports MinIO deployments.

:mc-cmd:`mc support` has the following syntax:

.. code-block:: shell

   mc support COMMAND [COMMAND FLAGS | -h] [ARGUMENTS...]


Command Quick reference
-----------------------

The following table lists :mc-cmd:`mc admin` commands:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Command
     - Description

   * - :mc:`mc support register`
     - .. include:: /reference/minio-mc-support/mc-support-register.rst
          :start-after: start-mc-support-register-desc
          :end-before: end-mc-support-register-desc

   * - :mc:`mc support callhome`
     - .. include:: /reference/minio-mc-support/mc-support-callhome.rst
          :start-after: start-mc-support-callhome-desc
          :end-before: end-mc-support-callhome-desc

   * - :mc:`mc support diagnostics`
     - .. include:: /reference/minio-mc-support/mc-support-diagnostics.rst
          :start-after: start-mc-support-diagnostics-desc
          :end-before: end-mc-support-diagnotics-desc

   * - :mc:`mc support perf`
     - .. include:: /reference/minio-mc-support/mc-support-perf.rst
          :start-after: start-mc-support-perf-desc
          :end-before: end-mc-support-perf-desc

   * - :mc:`mc support inspect`
     - .. include:: /reference/minio-mc-support/mc-support-inspect.rst
          :start-after: start-mc-support-inspect-desc
          :end-before: end-mc-support-inspect-desc

   * - :mc:`mc support profile`
     - .. include:: /reference/minio-mc-support/mc-support-profile.rst
          :start-after: start-mc-support-profile-desc
          :end-before: end-mc-support-profile-desc


.. _mc-support-install:

Installation
------------

.. include:: /includes/minio-mc-installation.rst

Quickstart
----------

Ensure that the host machine has :mc:`mc` :ref:`installed <mc-support-install>` before starting this procedure.

.. important::

   The following example temporarily disables the bash history to mitigate the
   risk of authentication credentials leaking in plain text. This is a basic
   security measure and does not mitigate all possible attack vectors. Defer to
   security best practices for your operating system for inputting sensitive
   information on the command line.

Use the :mc-cmd:`mc alias set` command to add the MinIO deployment
to the :mc-cmd:`mc` :ref:`configuration <mc-configuration>`.

.. code-block:: shell
   :class: copyable

   bash +o history
   mc alias set ALIAS HOSTNAME ACCESS_KEY SECRET_KEY
   bash -o history

- Replace ``ALIAS`` with a name to associate to the MinIO deployment. 
  :mc-cmd:`mc` commands typically require ``ALIAS`` as an argument for
  identifying which MinIO deployment to execute against.

- Replace ``HOSTNAME`` with the URL endpoint or IP address of the MinIO deployment.

- Replace ``ACCESS_KEY`` and ``SECRET_KEY`` with the access and secret 
  keys for a user on the MinIO deployment. 

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

:mc-cmd:`mc support` supports the same global options as 
:mc-cmd:`mc`. See :ref:`minio-mc-global-options`.

.. toctree::
   :titlesonly:
   :hidden:
   :glob:

   /reference/minio-mc-support/*
