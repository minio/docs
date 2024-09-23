.. _minio-mc-idp-ldap-accesskey-disable:

=================================
``mc idp ldap accesskey disable``
=================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


.. mc:: mc idp ldap accesskey disable


Description
-----------

.. start-mc-idp-ldap-accesskey-disable-desc

:mc:`mc idp ldap accesskey disable` disables the specified access key on the local server.

.. end-mc-idp-ldap-accesskey-disable-desc

.. tab-set::

   .. tab-item:: EXAMPLE

         The following example disables the access key ``mykey`` from the ``minio`` deployment:

      .. code-block:: shell
         :class: copyable

         mc idp ldap accesskey disable minio mykey

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap accesskey disable  \
                                          ALIAS       \
                                          KEY


      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment configured for AD/LDAP integration.
      - Replace ``KEY`` with the access key to disable.
        
      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment configured for AD/LDAP.

   For example:

   .. code-block:: none

         mc idp ldap accesskey disable minio

.. mc-cmd:: KEY
   :required:

   The configured access key to disable.

Example
~~~~~~~

Disable the access key ``mykey`` from the ``minio`` deployment.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey disable minio/ mykey

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
