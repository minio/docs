=======================
``mc support callhome``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support logs disable
.. mc:: mc support logs enable
.. mc:: mc support logs status
   
.. mc:: mc support callhome

Description
-----------

.. start-mc-support-callhome-desc

The :mc-cmd:`mc support callhome` command allows the enabling or disabling of reports from a deployment to |SUBNET|.

.. end-mc-support-callhome-desc

All ``mc support`` commands require an active SUBNET subscription.

When enabled, MinIO can send logs to SUBNET in real time, diagnostics every 24 hours, or both.

MinIO disables this functionality by default, regardless of registration status.
You must explicitly enable the ``callhome`` function to begin real time log upload.

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Syntax
------

.. mc-cmd:: enable
   :fullpath:

   Begin sending a deployment's diagnostics, logs, or both to SUBNET.

   .. code-block:: shell
               
      mc support callhome enable    \
                          ALIAS     \
                          [--logs]  \
                          [--diag]

.. mc-cmd:: disable
   :fullpath:

   Stop sending a deployment's diagnostics, logs, or both to SUBNET.

   .. code-block:: shell
               
      mc support callhome disable  \
                          ALIAS    \
                          [--logs] \
                          [--diag]

.. mc-cmd:: status
   :fullpath:

   Output whether a deployment currently sends diagnostics, logs, or both to SUBNET.

   .. code-block:: shell
               
      mc support callhome status   \
                          ALIAS    \
                          [--logs] \
                          [--diag]
            
Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.

.. mc-cmd:: --logs
   :optional:

   Send or stop sending log information to SUBNET in real time.

.. mc-cmd:: --diag
   :optional:

   Send or stop sending deployment diagnostic information to SUBNET every 24 hours.

If you do not pass either ``--logs`` or ``--diag``, the command applies to both logs and diagnostics.

Examples
--------

Enable ``callhome`` Reporting
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable the sending of data for deployment with the alias ``minio1``.
When enabled for a deployment registered to SUBNET, MinIO sends logs and diagnostics to SUBNET.

.. code-block:: shell
   :class: copyable
 
   mc support callhome enable minio1

Enable ``callhome`` Reporting for Logs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable logs callhome for a deployment with the alias ``minio1``.
When enabled for a deployment registered to SUBNET, MinIO sends logs to SUBNET in real time.

.. code-block:: shell
   :class: copyable
 
   mc support callhome enable minio1 --logs

Disable ``callhome`` Logs
~~~~~~~~~~~~~~~~~~~~~~~~~

Disable sending real time information to SUBNET for a deployment registered to SUBNET with an :ref:`alias <alias>` of ``minio1``.

.. code-block:: shell
   :class: copyable

   mc support callhome disable minio1


Display Current ``callhome`` Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Display whether a deployment with the alias ``minio1`` sends diagnostics or logs to SUBNET.

.. code-block:: shell
   :class: copyable
 
   mc support callhome status minio1

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

