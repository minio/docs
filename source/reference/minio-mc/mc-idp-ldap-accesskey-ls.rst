.. _minio-mc-idp-ldap-accesskey-ls:

============================
``mc idp ldap accesskey ls``
============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


.. mc:: mc idp ldap accesskey list
.. mc:: mc idp ldap accesskey ls


Description
-----------

.. start-mc-idp-ldap-accesskey-ls-desc

The :mc:`mc idp ldap accesskey ls` displays a list of LDAP access key pairs.

.. end-mc-idp-ldap-accesskey-ls-desc

:mc:`mc idp ldap accesskey ls` is also known as :mc:`mc idp ldap accesskey list`.

.. include:: /includes/common-minio-ad-ldap-params.rst
   :start-after: start-minio-ad-ldap-accesskey-creation
   :end-before: end-minio-ad-ldap-accesskey-creation

.. tab-set::

   .. tab-item:: EXAMPLE

         The following example returns a list of access keys associated with the authenticated user on the ``minio`` :ref:`alias <alias>`:

      .. code-block:: shell
         :class: copyable

         mc idp ldap accesskey ls minio/

      If the authenticated user is the ``admin``, the example command returns a list of all users and their associated access keys.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap accesskey ls              \
                                          ALIAS              \
                                          [--permanent-only] \
                                          [--temp-only]      \
                                          [--users-only]     \
                                          [DN] ...


      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment configured for AD/LDAP integration.
      - Replace ``DN`` with the string of a user's `distinguished name <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ldap/distinguished-names>`__.
        You may list multiple distinguished names by separating each with a space.

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

.. mc-cmd:: --permanent-only
   :optional:

   Output only permanent access keys.

   Mutually exclusive with :mc-cmd:`~mc idp ldap accesskey ls --temp-only`.

.. mc-cmd:: --temp-only
   :optional:

   Output only temporary access keys.

   Mutually exclusive with :mc-cmd:`~mc idp ldap accesskey ls --permanent-only`.

.. mc-cmd:: --users-only
   :optional:

   Output only the user distinguished names.

Examples
~~~~~~~~

List All Access Keys
++++++++++++++++++++

To return a list of all access keys, you must first authenticate as the ``admin`` user.
Once authenticated, the following command returns all AD/LDAP access keys on the ``minio`` deployment.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey ls minio

.. note::

   If not authenticated as an admin, the command returns a list of access keys for the authenticated user only.

List User Distinguished Names
+++++++++++++++++++++++++++++

To return a list of DNs for a deployment, you must first authenticate as the ``admin`` user.
Once authenticated, the following command outputs the AD/LDAP distinguished names on the ``minio`` deployment.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey ls minio --users-only

List Temporary Access Keys
++++++++++++++++++++++++++

To return a list of all temporary access keys for a deployment, you must first authenticate as the ``admin`` user.
Once authenticated, the following command outputs a list of distinguished names with their associated temporary access keys.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey ls minio --temp-only

List a User's Access Keys
+++++++++++++++++++++++++

The following command returns the AD/LDAP access keys for the user ``bobfisher`` on the ``minio`` deployment.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey list minio/ uid=bobfisher,dc=min,dc=io

List Access Keys for Multiple Users
+++++++++++++++++++++++++++++++++++

The following command returns the AD/LDAP access keys for the users ``bobfisher`` and ``cody3`` on the ``minio`` deployment.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey list minio/ uid=bobfisher,dc=min,dc=io uid=cody3,dc=min,dc=io

List Access Keys for Authenticated User
+++++++++++++++++++++++++++++++++++++++

The following command returns the AD/LDAP access keys for the currently authenticated user on the ``minio`` deployment.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey list minio/ 

.. note:: 

   If the authenticated user is the ``admin``, the command returns a list of all users and access keys on the deployment.

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
