.. _minio-environment-variables:
.. _minio-server-environment-variables:
.. _minio-server-configuration-settings:

========
Settings
========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The :mc:`minio server` process stores its configuration in the storage backend :mc-cmd:`directory <minio server DIRECTORIES>`. 

.. _minio-server-configuration-options:

MinIO Settings
--------------

MinIO settings define runtime behavior of the MinIO :mc:`server <minio server>` process:

You can define many MinIO Server settings in one of two ways:

1. Set :ref:`environment variables <minio-environment-variables>` in the host system prior to launching or restarting the server process.
2. Modify configuration options using the :mc:`mc admin config` command or the :guilabel:`Administrator > Settings` page of the :ref:`MinIO Console <minio-console>`.

.. important::

   Settings defined by an environment variable override similar settings defined as configurations with :mc:`mc admin config` or the MinIO Console.

Additional environment variables include those to configure:

- :ref:`MinIO Console <minio-server-envvar-console>`
- :ref:`Notification targets <minio-server-envvar-notifications>` for use with :ref:`MinIO Bucket Notifications <minio-bucket-notifications>`
- :ref:`Identity and access management solutions <minio-server-envvar-iam>`
- :ref:`Metrics and logs <minio-server-envvar-metrics-logging>`
- :ref:`Key Encryption Service (KES) <minio-server-envvar-kes>`
- :ref:`Object Lamba functions <minio-server-envvar-object-lambda-webhook>`

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-server/settings/core
   /reference/minio-server/settings/root-credentials 
   /reference/minio-server/settings/storage-class
   /reference/minio-server/settings/console 
   /reference/minio-server/settings/metrics-and-logging 
   /reference/minio-server/settings/notifications 
   /reference/minio-server/settings/iam 
   /reference/minio-server/settings/kes 
   /reference/minio-server/settings/object-lambda
   /reference/minio-server/settings/deprecated