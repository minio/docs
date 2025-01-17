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

The :mc-cmd:`mc support callhome` command allows the enabling or disabling of diagnostic information from a deployment to |SUBNET|.

.. end-mc-support-callhome-desc

All ``mc support`` commands require an active SUBNET subscription.

When enabled, MinIO sends diagnostic information to SUBNET.

MinIO disables this functionality by default, regardless of registration status.
You must explicitly enable the ``callhome`` function to begin information upload.

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

   .. note::

      The ``--logs`` and ``--diag`` flags are no longer supported in SUBNET and will be removed in a future release.

.. mc-cmd:: disable
   :fullpath:

   Stop sending a deployment's diagnostics, logs, or both to SUBNET.

   .. code-block:: shell
               
      mc support callhome disable  \
                          ALIAS    \
                          [--logs] \
                          [--diag]

   .. note::

      The ``--logs`` and ``--diag`` flags are no longer supported in SUBNET and will be removed in a future release.

.. mc-cmd:: status
   :fullpath:

   Output whether a deployment currently sends diagnostics, logs, or both to SUBNET.

   .. code-block:: shell
               
      mc support callhome status   \
                          ALIAS    \
                          [--logs] \
                          [--diag]

   .. note::

      The ``--logs`` and ``--diag`` flags are no longer supported in SUBNET and will be removed in a future release.
            
Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.

.. mc-cmd:: --logs
   :optional:

   .. note::

      This option is no longer supported in SUBNET and will be removed in a future release.

   Send or stop sending log information to SUBNET in real time.

.. mc-cmd:: --diag
   :optional:

   .. note::

      This option is no longer supported in SUBNET and will be removed in a future release.

   Send or stop sending deployment diagnostic information to SUBNET every 24 hours.

If you do not pass either ``--logs`` or ``--diag``, the command applies to both logs and diagnostics.

Examples
--------

Enable ``callhome`` reporting
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enable sending diagnostic information to SUBNET for a deployment registered to SUBNET with an :ref:`alias <alias>` of ``minio1``.

.. code-block:: shell
   :class: copyable
 
   mc support callhome enable minio1

Disable ``callhome`` reporting
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Disable sending diagnostic information to SUBNET for a deployment registered to SUBNET with an :ref:`alias <alias>` of ``minio1``.

.. code-block:: shell
   :class: copyable

   mc support callhome disable minio1


Display Current ``callhome`` settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Display whether a deployment with the alias ``minio1`` sends information to SUBNET.

.. code-block:: shell
   :class: copyable
 
   mc support callhome status minio1

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

