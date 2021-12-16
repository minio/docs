.. _minio-mc-alias-remove:

===================
``mc alias remove``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc alias remove

Syntax
------

.. start-mc-alias-remove-desc

The :mc:`mc alias remove` removes an existing alias from the local
:program:`mc` configuration.

.. end-mc-alias-remove-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes the ``myminio`` :ref:`alias <alias>` for a
      MinIO deployment from the host machine:

      .. code-block:: shell
         :class: copyable

         mc alias remove myminio

   .. tab-item:: SYNTAX

      The :mc-cmd:`mc alias remove` command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] alias remove ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The alias to remove from the local :program:`mc` configuration.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Remove an Alias from the ``mc`` Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc alias remove` to remove an existing alias from the
:program:`mc` configuration:

.. tab-set::

   .. tab-item:: Example

      The following command removes the ``myminio`` alias.

      .. code-block:: shell
         :class: copyable

         mc alias remove myminio

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable

         mc alias remove ALIAS

      Replace ``ALIAS`` with the the name of the alias to remove.

Behavior
~~~~~~~~

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility