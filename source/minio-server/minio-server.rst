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
   standalone :mc:`~minio server` process with only the
   :mc-cmd:`~minio server DIRECTORIES` argument.

   For distributed deployments, specify the hostname of each :mc:`minio server`
   in the deployment. The group of :mc:`minio server` processes represent a
   single :ref:`Server Set <minio-intro-server-set>`.

   :mc-cmd:`~minio server HOSTNAME` supports MinIO expansion notation
   ``{x...y}`` to denote a sequential series of hostnames. MinIO *requires*
   sequential hostnames to identify each :mc:`minio server` process in the set.
   
   For example,
   ``https://minio{1...4}.example.net`` expands to:

   - ``https://minio1.example.net``
   - ``https://minio2.example.net``
   - ``https://minio3.example.net``
   - ``https://minio4.example.net``

   You must run the :mc:`minio server` command with the *same* combination of
   :mc-cmd:`~minio server HOSTNAME` and :mc-cmd:`~minio server DIRECTORIES` on
   each host in the Server Set.
   
   Each additional ``HOSTNAME/DIRECTORIES`` pair denotes an additional Server
   Set for the purpose of horizontal expansion of the MinIO deployment. For more
   information on Server Sets, see :ref:`Server Set <minio-intro-server-set>`.

.. mc-cmd:: DIRECTORIES

   The directories or drives the :mc:`minio server` process uses as the 
   storage backend. 

   :mc-cmd:`~minio server DIRECTORIES` supports MinIO expansion notation
   ``{x...y}`` to denote a sequential series of folders or drives. For example,
   ``/mnt/disk{1...4}`` expands to:

   - ``/mnt/disk1``
   - ``/mnt/disk2``
   - ``/mnt/disk3``
   - ``/mnt/disk4``

   The :mc-cmd:`~minio server DIRECTORIES` path(s) *must* be empty when first
   starting the :mc:`minio <minio server>` process.

   The :mc:`minio server` process requires *at least* 4 drives or directories
   to enable :ref:`erasure coding <minio-erasure-coding>`.

   .. important::

      MinIO recommends locally-attached drives, where the
      :mc-cmd:`~minio server DIRECTORIES` path points to each disk on the
      host machine. MinIO recommends *against* using network-attached
      storage, as network latency reduces performance of those drives
      compared to locally-attached storage.

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

   The access key for the :ref:`root <minio-users-root>` user. 

   .. warning::

      If :envvar:`MINIO_ACCESS_KEY` is unset, 
      :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments. 
      MinIO strongly recommends specifying a unique, long, and random
      :envvar:`MINIO_ACCESS_KEY` value for all environments.

.. envvar:: MINIO_SECRET_KEY

   The secret key for the :ref:`root <minio-users-root>` user.

   .. warning::

      If :envvar:`MINIO_SECRET_KEY` is unset,
      :mc:`minio` defaults to ``minioadmin``.

      **NEVER** use the default credentials in production environments.
      MinIO strongly recommends specifying a unique, long, and random
      :envvar:`MINIO_ACCESS_KEY` value for all environments.

.. envvar:: MINIO_ACCESS_KEY_OLD

   Used for rotating the :ref:`root <minio-users-root>` user access
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

   Used for rotating the :ref:`root <minio-users-root>` user secret
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
   :envvar:`MINIO_SECRET_KEY_OLD`.

Storage Class
~~~~~~~~~~~~~

These environment variables configure the :ref:`parity <minio-ec-parity>`
to use for objects written to the MinIO cluster. 

MinIO Storage Classes are distinct from AWS Storage Classes, where the latter
refers to the specific storage tier on which to store a given object. 

.. envvar:: MINIO_STORAGE_CLASS_STANDARD

   The number of :ref:`parity blocks <minio-ec-parity>` to create for 
   objects with the standard (default) storage class. MinIO uses the
   ``EC:N`` notation to refer to the number of parity blocks (``N``).
   This environment variable only applies to deployments with 
   :ref:`Erasure Coding <minio-erasure-coding>` enabled. 

   Defaults to ``4``. 

.. envvar:: MINIO_STORAGE_CLASS_REDUCED

   The number of :ref:`parity blocks <minio-ec-parity>` to create for objects
   with the reduced redundancy storage class. MinIO uses the ``EC:N``
   notation to refer to the number of parity blocks (``N``). This environment
   variable only applies to deployments with :ref:`Erasure Coding
   <minio-erasure-coding>` enabled. 

   Defaults to ``2``.

.. envvar:: MINIO_STORAGE_CLASS_COMMENT

   Adds a comment to the storage class settings.