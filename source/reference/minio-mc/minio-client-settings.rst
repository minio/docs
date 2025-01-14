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

The temporary alias uses the :aws-docs:`AWS s3v4 API <AmazonS3/latest/API/sig-v4-authenticating-requests.html>`.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_HOST_<ALIAS>

         Replace ``<ALIAS>`` at the end of the environment variable with the ``alias`` to set the host for.

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

      Use :mc:`mc alias set` to configure an :ref:`alias <alias>`.

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

STS Service
~~~~~~~~~~~

.. versionadded:: mc RELEASE.2023-11-06T04-19-23Z

Use this setting to add an STS endpoint to use for `mc` commands.

.. versionchanged:: mc RELEASE.2023-12-02T02-03-28Z 

Supports adding multiple environment variables by alias.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_STS_ENDPOINT_<alias>

      .. code-block:: shell

         export MC_STS_ENDPOINT_myalias=https://sts.minio-operator.svc.cluster.local:4223/sts/ns-1 

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

Web Token Identity
~~~~~~~~~~~~~~~~~~

.. versionadded:: mc RELEASE.2023-11-06T04-19-23Z

Use this setting to add a web token identity to use for `mc` commands.

.. versionchanged:: mc RELEASE.2023-12-02T02-03-28Z 

Supports adding multiple environment variables by alias.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_WEB_IDENTITY_TOKEN_<alias>

      .. code-block:: shell

         export MC_WEB_IDENTITY_TOKEN_FILE_myalias=/var/run/secrets/kubernetes.io/serviceaccount/token

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

Configuration Directory
~~~~~~~~~~~~~~~~~~~~~~~

Specify the path to the configuration folder the MinIO Client should use.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_CONFIG_DIR

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

Progress Bar
~~~~~~~~~~~~

Disable the MinIO Client progress bar.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_QUIET

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

Pager
~~~~~

.. versionadded:: mc RELEASE.2024-04-29T09-56-05Z

Disable the pager functionality of the MinIO Client in the CLI.
When used, output prints to raw ``STDOUT`` instead.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_DISABLE_PAGER

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

Color Theme
~~~~~~~~~~~

Disable the color theme used for MinIO Client output.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_NO_COLOR

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option


JSON
~~~~

Enable formatting the output as JSON lines.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_JSON

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

Debug
~~~~~

Enable the debug output.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_DEBUG

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

Disable SSL
~~~~~~~~~~~

Disable SSL certificate verification.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_INSECURE

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

Limit Download Bandwidth
~~~~~~~~~~~~~~~~~~~~~~~~

Limit the download bandwidth the MinIO Client uses for certain commands.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_LIMIT_DOWNLOAD

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

If not specified, the MinIO Client uses all available bandwidth.

Limit client-side download rates to no more than the specified rate in KiB/s, MiB/s, or GiB/s. This affects only the download from the local device running the MinIO Client. Valid units include:

- B for bytes
- K for kilobytes
- M for megabytes
- G for gigabytes
- Ki for kibibytes
- Mi for mibibytes
- Gi for gibibytes

For example, to limit download rates to no more than 1 GiB/s, use the following on a Linux system:

.. code-block:: shell
   :class: copyable

   export MC_LIMIT_DOWNLOAD=1G

Refer to your operating system instructions for equivalent commands on non-Linux systems.

Limit Upload Bandwidth
~~~~~~~~~~~~~~~~~~~~~~

Limit the upload bandwidth the MinIO Client uses for certain commands.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_LIMIT_UPLOAD

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

If not specified, the MinIO Client uses all available bandwidth.

Limit client-side upload rates to no more than the specified rate in KiB/s, MiB/s, or GiB/s. This affects only the upload from the local device running the MinIO Client. Valid units include:

- B for bytes
- K for kilobytes
- M for megabytes
- G for gigabytes
- Ki for kibibytes
- Mi for mibibytes
- Gi for gibibytes

For example, to limit upload rates to no more than 1 GiB/s, use the following on a Linux system:

.. code-block:: shell
   :class: copyable

   export MC_LIMIT_UPLOAD=1G

Refer to your operating system instructions for equivalent commands on non-Linux systems.

SSE-KMS Encryption
~~~~~~~~~~~~~~~~~~

Encrypt and decrypt options using :ref:`SSE-KMS <minio-sse-data-encryption>` with server managed keys.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_ENC_KMS

         Specify the key with the :envvar:`MC_ENC_KMS` environment variable.

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option

SSE-S3 Encryption
~~~~~~~~~~~~~~~~~

Encrypt and decrypt options using :ref:`SSE-KMS <minio-sse-data-encryption>` with server managed keys.

.. tab-set::

   .. tab-item:: Environment Variable
      :selected:

      .. envvar:: MC_ENC_S3

         Specify the key to use for performing SSE-S3 encryption.
         The specified value must match the encryption key set in :envvar:`MINIO_KMS_KES_KEY_NAME`.

   .. tab-item:: Configuration Setting

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-settings-no-config-option
         :end-before: end-minio-settings-no-config-option
