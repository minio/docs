.. _minio-mc-idp-ldap-accesskey-info:

==============================
``mc idp ldap accesskey info``
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


.. mc:: mc idp ldap accesskey info


Description
-----------

.. start-mc-idp-ldap-accesskey-info-desc

The :mc:`mc idp ldap accesskey-info` outputs information about the specified access key(s).

.. end-mc-idp-ldap-accesskey-info-desc

.. tab-set::

   .. tab-item:: EXAMPLE

         The following example outputs details for the access key ``mykey`` from the ``minio`` deployment:

      .. code-block:: shell
         :class: copyable

         mc idp ldap accesskey info minio/ mykey

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap accesskey info      \
                                             ALIAS     \
                                             KEY       \
                                             [KEY2] ...


      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment configured for AD/LDAP integration.
      - Replace ``KEY`` with the access key to delete.
        You can list more than one access key by separating each key with a space.
        
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

         mc idp ldap accesskey ls minio

.. mc-cmd:: KEY
   :required:

   The configured access key to output information about.

   You can list more than one access key by separating each key with a space.


Example
~~~~~~~

Output information about the access keys ``mykey`` and ``mykey2`` from the ``minio`` deployment.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey info minio/ mykey mykey2

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
