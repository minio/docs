========================
MinIO Server (``minio``)
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: minio

The :mc:`minio` command line executable starts either the MinIO Object Storage
process *or* the MinIO Gateway process. 

MinIO Server
------------

The :mc:`minio server` command starts the MinIO server process:

.. code-block:: shell
   :class: copyable

   minio server /mnt/disk{1...4}

For examples of deploying :mc:`minio server` on a bare metal environment, 
see :ref:`minio-baremetal`.

For examples of deploying :mc:`minio server` on a Kubernetes environment,
see :ref:`minio-kubernetes`.

Configuration Settings
~~~~~~~~~~~~~~~~~~~~~~

The :mc:`minio server` process stores its configuration in the storage
backend :mc-cmd:`directory <minio server DIRECTORIES>`. You can modify
configuration options using the
:mc-cmd:`mc admin config` command.

Syntax
~~~~~~~

.. mc:: minio server

Starts the ``minio`` server process.

The command has the following syntax:

.. code-block:: shell
   :class: copyable

   minio server [FLAGS] HOSTNAME/DIRECTORIES [HOSTNAME/DIRECTORIES..]

The command accepts the following arguments:

.. mc-cmd:: HOSTNAME

   The hostname of a :mc:`minio server` process.

   For standalone deployments, this field is *optional*. You can start a 
   standalone :mc:`minio <minio server>` process with only the
   :mc-cmd:`~minio server DIRECTORIES` argument.

   For distributed deployments, specify the hostname of each 
   :mc:`minio <minio server>` in the deployment. 

   :mc-cmd:`~minio server HOSTNAME` supports MinIO expansion notation
   ``{x...y}`` to denote a sequential series of hostnames. For example,
   ``https://minio{1...4}.example.net`` expands to:

   - ``https://minio1.example.net``
   - ``https://minio2.example.net``
   - ``https://minio3.example.net``
   - ``https://minio4.example.net``
   
   The set of :mc:`minio server` processes in :mc-cmd:`~minio server HOSTNAME`
   define a single :ref:`zone <minio-zones>`. MinIO *requires* sequential
   hostnames to identify each :mc:`minio server` process in the zone. 
   
   Each additional ``HOSTNAME/DIRECTORIES`` pair denotes an additional zone for
   the purpose of horizontal expansion of the MinIO deployment. For more
   information on zones, see :ref:`minio-zones`.

.. mc-cmd:: DIRECTORIES

   The directories or disks the :mc:`minio server` process uses as the 
   storage backend. 

   :mc-cmd:`~minio server DIRECTORIES` supports MinIO expansion notation
   ``{x...y}`` to denote a sequential series of folders or disks. For example,
   ``/mnt/disk{1...4}`` expands to:

   - ``/mnt/disk1``
   - ``/mnt/disk2``
   - ``/mnt/disk3``
   - ``/mnt/disk4``

   The :mc-cmd:`~minio server DIRECTORIES` path(s) *must* be empty when first
   starting the :mc:`minio <minio server>` process.

   The :mc:`minio server` process requires *at least* 4 disks or directories
   to enable :ref:`erasure coding <minio-erasure-coding>`.

   .. important::

      MinIO recommends locally-attached disks, where the
      :mc-cmd:`~minio server DIRECTORIES` path points to each disk on the
      host machine. 

      For development or evaluation, you can specify multiple logical
      directories or partitions on a single physical volume to enable erasure
      coding on the deployment.
      
      For production environments, MinIO does **not recommend** using multiple
      logical directories or partitions on a single physical disk. While MinIO
      supports those configurations, the potential cost savings come at the risk
      of decreased reliability.
      

.. mc-cmd:: address
   :option:

   *Optional* Binds the :mc:`minio <minio server>` server process to a
   specific network address and port number. Specify the address and port as
   ``ADDRESS:PORT``, where ``ADDRESS`` is an IP address or hostname and
   ``PORT`` is a valid and open port on the host system.

   To change the port number for all IP addresses or hostnames configured
   on the host machine, specify ``:PORT`` where ``PORT`` is a valid
   and open port on the host.

   If omitted, :mc:`minio <minio server>` binds to port ``9000`` on all
   configured IP addresses or hostnames on the host machine.

.. mc-cmd:: certs-dir, -S
   :option:

   *Optional* Specifies the path to the folder containing certificates the
   :mc:`minio` process uses for configuring TLS/SSL connectivity.

   Omit to use the default directory paths:

   - Linux/OSX: ``${HOME}/.minio/certs`` 
   - Windows: ``%%USERPROFILE%%\.minio\certs``.

   See :ref:`minio-TLS` for more information on TLS/SSL connectivity.

.. mc-cmd:: quiet
   :option:

   *Optional* Disables startup information.

.. mc-cmd:: anonymous
   :option:

   *Optional* Hides sensitive information from logging.

.. mc-cmd:: json
   :option:

   *Optional* Outputs server logs and startup information in ``JSON``
   format.

MinIO Gateway
-------------

Syntax
~~~~~~

.. mc:: minio gateway

Starts the MinIO Gateway process. 

The command has the following syntax:

.. code-block:: shell
   :class: copyable

   minio gateway [FLAGS] SUBCOMMAND [ARGUMENTS]

:mc:`minio gateway` supports the following flags:

.. mc-cmd:: address
   :option:

   *Optional* Binds the MinIO Gateway to a specific network address and port
   number. Specify the address and port as ``ADDRESS:PORT``, where ``ADDRESS``
   is an IP address or hostname and ``PORT`` is a valid and open port on the
   host system.

   To change the port number for all IP addresses or hostnames configured
   on the host machine, specify ``:PORT`` where ``PORT`` is a valid
   and open port on the host.

.. mc-cmd:: certs-dir, -S
   :option:

   *Optional* Specifies the path to the folder containing certificates the
   MinIO Gateway process uses for configuring TLS/SSL connectivity.

   Omit to use the default directory paths:

   - Linux/OSX: ``${HOME}/.minio/certs`` 
   - Windows: ``%%USERPROFILE%%\.minio\certs``.

   See :ref:`minio-TLS` for more information on TLS/SSL connectivity.

.. mc-cmd:: quiet
   :option:

   *Optional* Disables startup information.

.. mc-cmd:: anonymous
   :option:

   *Optional* Hides sensitive information from logging.

.. mc-cmd:: json
   :option:

   *Optional* Outputs server logs and startup information in ``JSON``
   format.

:mc:`minio gateway` supports the following subcommands:

.. mc-cmd:: nas
   :fullpath:

   Creates a MinIO Gateway process configured for Network-Attached Storage
   (NAS).

.. mc-cmd:: azure
   :fullpath:

   Creates a MinIO Gateway process configured for Microsoft Azure Blob Storage.

.. mc-cmd:: s3
   :fullpath:

   Creates a MinIO Gateway process configured for Amazon Simple Storage Service
   (S3).

.. mc-cmd:: hdfs
   :fullpath:

   Creates a MinIO Gateway process configured for Hadoop Distributed File
   System (HDFS).

.. mc-cmd:: gcs
   :fullpath:

   Creates a MinIO Gateway process configured for Google Cloud Storage.

Environment Variables
---------------------

The :mc:`minio server` and :mc:`minio gateway` processes can use the following
environment variables when creating its configuration settings:

Root Credentials
~~~~~~~~~~~~~~~~

.. envvar:: MINIO_ACCESS_KEY

   The access key for the :ref:`root <minio-auth-authz-root>` user. 

   .. warning::

      If :envvar:`MINIO_ACCESS_KEY` is unset, 
      :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments. 
      MinIO strongly recommends specifying a unique, long, and random
      :envvar:`MINIO_ACCESS_KEY` value for all environments.

.. envvar:: MINIO_SECRET_KEY

   The secret key for the :ref:`root <minio-auth-authz-root>` user.

   .. warning::

      If :envvar:`MINIO_SECRET_KEY` is unset,
      :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments.
      MinIO strongly recommends specifying a unique, long, and random
      :envvar:`MINIO_ACCESS_KEY` value for all environments.

.. envvar:: MINIO_ACCESS_KEY_OLD

   Used for rotating the :ref:`root <minio-auth-authz-root>` user access
   key.

   Restart the :mc:`minio server` process with *all* of the following
   environment variables to rotate the root credentials:

   - :envvar:`MINIO_ACCESS_KEY_OLD` set to the old access key.
   - :envvar:`MINIO_ACCESS_KEY` set to the new access key.
   - :envvar:`MINIO_SECRET_KEY_OLD` set to the old secret key.
   - :envvar:`MINIO_SECRET_KEY` set to the new secret key.

   The :mc:`minio server` process automatically detects and re-encrypts 
   the server configuration with the new credentials. After the process
   restarts successfully, you can restart it without 
   :envvar:`MINIO_ACCESS_KEY_OLD`.

.. envvar:: MINIO_SECRET_KEY_OLD

   Used for rotating the :ref:`root <minio-auth-authz-root>` user secret
   key.

   Restart the :mc:`minio server` process with *all* of the following
   environment variables to rotate the root credentials:

   - :envvar:`MINIO_ACCESS_KEY_OLD` set to the old access key.
   - :envvar:`MINIO_ACCESS_KEY` set to the new access key.
   - :envvar:`MINIO_SECRET_KEY_OLD` set to the old secret key.
   - :envvar:`MINIO_SECRET_KEY` set to the new secret key.

   The :mc:`minio server` process automatically detects and re-encrypts 
   the server configuration with the new credentials. After the process
   restarts successfully, you can restart it without 
   :envvar:`SECRET_KEY_OLD`.
