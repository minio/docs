.. _minio-mc-alias-list:

=================
``mc alias list``
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc alias list

Syntax
------

.. start-mc-alias-list-desc

The :mc:`mc alias list` command lists all aliases in the local 
:program:`mc` configuration. 

.. end-mc-alias-list-desc

The command output includes the configured access key and secret key associated
to each alias.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command lists all :ref:`aliases <alias>` configured
      on the local host machine:

      .. code-block:: shell
         :class: copyable

         mc alias list

   .. tab-item:: SYNTAX

      The :mc-cmd:`mc alias list` command has the following syntax:

      .. code-block:: shell

         mc [GLOBALFLAGS] alias list [ALIAS]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Optional* The name of a specific alias to display.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

List All Configured Aliases
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Example

      The following :mc-cmd:`mc alias list` command lists all configured aliases
      in the local :program:`mc` configuration. 

      .. code-block:: shell
         :class: copyable

         mc alias list

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable

         mc alias list

List a Specific Alias
~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Example

      The following :mc-cmd:`mc alias list` command lists the details of a 
      specific alias in the local :program:`mc` configuration.

      .. code-block:: shell
         :class: copyable

         mc alias list myminio

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable

         mc alias list ALIAS 

      - Replace ``ALIAS`` with the the name of the alias to return.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility