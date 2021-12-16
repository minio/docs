=============
``mc update``
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc update

Syntax
------

.. start-mc-update-desc

The :mc:`mc update` command automatically updates the :program:`mc` binary to
the latest stable version.

.. end-mc-update-desc

Running this command is equivalent to manually downloading the latest 
stable binary and using it to replace the existing ``mc`` installation on the
host machine.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command updates the :program:`mc` binary on the local host:

      .. code-block:: shell
         :class: copyable

         mc update

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] update

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Use :mc:`mc update` after updating the :program:`minio` server binary to
ensure consistent behavior and compatibility.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-json-globals
   :end-before: end-minio-mc-json-globals
