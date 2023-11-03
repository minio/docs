.. _minio-server-envvar-mc:

=====================
MinIO Client Settings
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page covers settings for the :ref:`MinIO Client <minio-client>`. 

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-defined
   :end-before: end-minio-settings-defined

Settings
--------

Host Credentials
~~~~~~~~~~~~~~~~

Use this setting to add a temporary alias to use for `mc` commands.
For example, for use with scripting.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_HOST_<ALIAS>

         Replace ``<ALIAS>`` at the end of the environment variable with the ``alias`` to set the host for.

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

      Use :mc:`mc alias set` to configure an ALIAS.

Examples
++++++++

**Static Credentials**

.. tab-set::

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable
      
         export MC_HOST_<alias>=https://<Access Key>:<Secret Key>@<YOUR-S3-ENDPOINT>

   .. tab-item:: Example

      .. code-block:: shell
         :class: copyable

         export MC_HOST_myalias=https://Q3AM3UQ867SPQQA43P2F:zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG@play.min.io


**Security Token Service (STS) Credentials**

.. tab-set::

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable
         
         export MC_HOST_<alias>=https://<Access Key>:<Secret Key>:<Session Token>@<YOUR-S3-ENDPOINT>

   .. tab-item:: Example

      .. code-block:: shell
         :class: copyable

         export MC_HOST_myalias=https://Q3AM3UQ867SPQQA43P2F:zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG:eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3NLZXkiOiJOVUlCT1JaWVRWMkhHMkJNUlNYUiIsImF1ZCI6IlBvRWdYUDZ1Vk80NUlzRU5SbmdEWGo1QXU1WWEiLCJhenAiOiJQb0VnWFA2dVZPNDVJc0VOUm5nRFhqNUF1NVlhIiwiZXhwIjoxNTM0ODk2NjI5LCJpYXQiOjE1MzQ4OTMwMjksImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0Ojk0NDMvb2F1dGgyL3Rva2VuIiwianRpIjoiNjY2OTZjZTctN2U1Ny00ZjU5LWI0MWQtM2E1YTMzZGZiNjA4In0.eJONnVaSVHypiXKEARSMnSKgr-2mlC2Sr4fEGJitLcJF_at3LeNdTHv0_oHsv6ZZA3zueVGgFlVXMlREgr9LXA@play.min.io