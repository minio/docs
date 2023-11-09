.. _minio-mc-idp-ldap-accesskey-rm:

============================
``mc idp ldap accesskey rm``
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


.. mc:: mc idp ldap accesskey rm
.. mc:: mc idp ldap accesskey remove


Description
-----------

.. start-mc-idp-ldap-accesskey-rm-desc

The :mc:`mc idp ldap accesskey rm` deletes the specified access key from the local server.

.. end-mc-idp-ldap-accesskey-rm-desc

:mc:`mc idp ldap accesskey rm` is also known as :mc:`mc idp ldap accesskey remove`.

.. tab-set::

   .. tab-item:: EXAMPLE

         The following example deletes the access key ``mykey`` from the ``minio`` deployment:

      .. code-block:: shell
         :class: copyable

         mc idp ldap accesskey rm minio/ mykey

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap accesskey rm              \
                                          ALIAS              \
                                          KEY


      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment configured for AD/LDAP integration.
      - Replace ``KEY`` with the access key to delete.
        
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

   The configured access key to delete.

Example
~~~~~~~

Delete the access key ``mykey`` from the ``minio`` deployment.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey rm minio/ mykey

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
