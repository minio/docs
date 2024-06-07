============
MinIO Server
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: minio

MinIO Server
------------

The :mc:`minio server` command starts the MinIO server process:

.. code-block:: shell
   :class: copyable

   minio server /mnt/disk{1...4}

For examples of deploying :mc:`minio server` on a bare metal environment, see :ref:`minio-installation`.

For examples of deploying :mc:`minio server` on a Kubernetes environment, see :ref:`Deploying a MinIO Tenant <minio-k8s-deploy-minio-tenant>`.


.. _minio-server-parameters:

Syntax
~~~~~~

.. mc:: minio server

Starts the ``minio`` server process.

The command has the following syntax:

.. code-block:: shell
   :class: copyable

   minio server [FLAGS] HOSTNAME/DIRECTORIES [HOSTNAME/DIRECTORIES..]

The command accepts the following arguments:

.. mc-cmd:: HOSTNAME

   The hostname of a :mc:`minio server` process.

   For standalone deployments, this field is *optional*. 
   You can start a standalone :mc:`~minio server` process with only the :mc-cmd:`~minio server DIRECTORIES` argument.

   For distributed deployments, specify the hostname of each :mc:`minio server` in the deployment. 
   The group of :mc:`minio server` processes represent a single :ref:`Server Pool <minio-intro-server-pool>`.

   :mc-cmd:`~minio server HOSTNAME` supports MinIO expansion notation ``{x...y}`` to denote a sequential series of hostnames. 
   MinIO *requires* sequential hostnames to identify each :mc:`minio server` process in the set.

   For example, ``https://minio{1...4}.example.net`` expands to:

   - ``https://minio1.example.net``
   - ``https://minio2.example.net``
   - ``https://minio3.example.net``
   - ``https://minio4.example.net``

   You must run the :mc:`minio server` command with the *same* combination of :mc-cmd:`~minio server HOSTNAME` and :mc-cmd:`~minio server DIRECTORIES` on   each host in the Server Pool.

   Each additional ``HOSTNAME/DIRECTORIES`` pair denotes an additional Server Set for the purpose of horizontal expansion of the MinIO deployment. 
   For more information on Server Pools, see :ref:`Server Pool <minio-intro-server-pool>`.

.. mc-cmd:: DIRECTORIES
   :required:

   The directories or drives the :mc:`minio server` process uses as the storage backend.

   :mc-cmd:`~minio server DIRECTORIES` supports MinIO expansion notation ``{x...y}`` to denote a sequential series of folders or drives. 
   For example, ``/mnt/disk{1...4}`` expands to:

   - ``/mnt/disk1``
   - ``/mnt/disk2``
   - ``/mnt/disk3``
   - ``/mnt/disk4``

   The :mc-cmd:`~minio server DIRECTORIES` path(s) *must* be empty when first starting the :mc:`minio <minio server>` process.

   The :mc:`minio server` process requires *at least* 4 drives or directories to enable :ref:`erasure coding <minio-erasure-coding>`.

   .. important::

      MinIO recommends locally-attached drives, where the :mc-cmd:`~minio server DIRECTORIES` path points to each drive on the host machine. 
      MinIO recommends *against* using network-attached storage, as network latency reduces performance of those drives compared to locally-attached storage.

      For development or evaluation, you can specify multiple logical directories or partitions on a single physical volume to enable erasure coding on the deployment.

      For production environments, MinIO does **not recommend** using multiple logical directories or partitions on a single physical disk. 
      While MinIO supports those configurations, the potential cost savings come at the risk of decreased reliability.


.. mc-cmd:: --address
   :optional:

   Binds the :mc:`minio <minio server>` server process to a specific network address and port number. 
   Specify the address and port as ``ADDRESS:PORT``, where ``ADDRESS`` is an IP address or hostname and ``PORT`` is a valid and open port on the host system.

   To change the port number for all IP addresses or hostnames configured on the host machine, specify ``:PORT`` where ``PORT`` is a valid and open port on the host.

   .. versionchanged:: RELEASE.2023-01-02T09-40-09Z
   
      You can configure your hosts file to have MinIO only listen on specific IPs.
      For example, if the machine's `/etc/hosts` file contains the following:

      .. code-block:: shell

         127.0.1.1       minioip
         127.0.1.2       minioip

      A command like the following would listen for API calls on port ``9000`` on both configured IP addresses.

      .. code-block:: shell

         minio server --address "minioip:9000" ~/miniodirectory

   If omitted, :mc:`minio <minio server>` binds to port ``9000`` on all configured IP addresses or hostnames on the host machine.

.. mc-cmd:: --console-address
   :optional:

   Specifies a static port for the embedded MinIO Console.

   Omit to direct MinIO to generate a dynamic port at server startup. 
   The MinIO server outputs the port to the system log.

.. mc-cmd:: --ftp
   :optional:
   
   Enable and configure a File Transfer Protocol (``FTP``) or File Transfer Protocol over SSL/TLS (``FTPS``) server.
   Use this flag multiple times to specify an address port, a passive port range of addresses, or a TLS certificate and key as key-value pairs.

   Valid keys:

   - ``address``, which takes a single port to use for the server, typically ``8021``
   
   - *(Optional)* ``passive-port-range``, which restricts the range of potential ports the server can use to transfer data, such as when tight firewall rules limit the port the FTP server can request for the connection
   
   - *(Optional)* ``tls-private-key``, which takes the path to the user's private key for accessing the MinIO deployment by TLS
     
     Use with ``tls-public-cert``.
   
   - *(Optional)* ``tls-public-cert``, which takes the path to the certificate for accessing the MinIO deployment by TLS
     
     Use with ``tls-private-key``.

   For MinIO deployments with TLS enabled, omit ``tls-private-key`` and ``tls-public-key`` to direct MinIO to use the default TLS keys for the MinIO deployment. 
   See :ref:`minio-tls` for more information.
   You only need to specify a certificate and private key to a different set of TLS certificate and key than the MinIO default (for example, to use a different domain).

   For example:

   .. code-block:: shell
      :class: copyable

      minio server http://server{1...4}/disk{1...4} \
      --ftp="address=:8021"                         \
      --ftp="passive-port-range=30000-40000"        \
      --ftp="tls-private-key=path/to/private.key"   \
      --ftp="tls-public-cert=path/to/public.crt"    \
      ...

.. mc-cmd:: --sftp
   :optional:

   Enable and configure a SSH File Transfer Protocol (``SFTP``) server.
   Use multiple times to specify each desired key-value pair.

   The following table lists valid keys.

   .. list-table::
      :header-rows: 1
      :widths: 30 30 40
      :width: 100%
   
      * - Key
        - Description
        - Valid values
   
      * - ``address``
        - Port to use for connecting to SFTP.
        - Any valid port number, typically ``8022``.
   
      * - ``ssh-private-key``
        - Path to the user's private key file.
        - Absolute path or relative path from current location to the key file to use.
 
      * - ``pub-key-algos``
        - Comma-separated list of the public key algorithms to support.
        - 
          .. code-block:: text

             ssh-ed25519
             sk-ssh-ed25519@openssh.com
             sk-ecdsa-sha2-nistp256@openssh.com
             ecdsa-sha2-nistp256
             ecdsa-sha2-nistp384
             ecdsa-sha2-nistp521
             rsa-sha2-256
             rsa-sha2-512
             ssh-rsa
             ssh-dss

      * - ``kex-algos``
        - Comma-separated list in priority order of the key-exchange algorithms to support.
        - 
          .. code-block:: text
          
             curve25519-sha256
             curve25519-sha256@libssh.org
             ecdh-sha2-nistp256
             ecdh-sha2-nistp384
             ecdh-sha2-nistp521
             diffie-hellman-group14-sha256
             diffie-hellman-group16-sha512
             diffie-hellman-group14-sha1
             diffie-hellman-group1-sha1

      * - ``cipher-algos``
        - Comma-separated list of cipher algorithms to support
        - 
          .. code-block:: text

            aes128-ctr
            aes192-ctr
            aes256-ctr
            aes128-gcm@openssh.com
            aes256-gcm@openssh.com
            chacha20-poly1305@openssh.com
            arcfour256
            arcfour128
            arcfour
            aes128-cbc
            3des-cbc

      * - ``mac-algos``
        - Comma-separated list in preference order of MAC algorithms to support. 
          Based on `RFC 4253 section 6.4 <https://www.rfc-editor.org/rfc/rfc4253>`__ with the exception of ``hmac-md5`` variants, which are end of life.
        - 
          .. code-block:: text

             hmac-sha2-256-etm@openssh.com
             hmac-sha2-512-etm@openssh.com
             hmac-sha2-256
             hmac-sha2-512
             hmac-sha1
             hmac-sha1-96


   For example:

   .. code-block:: shell
      :class: copyable

      minio server http://server{1...4}/disk{1...4}                                 \
      --sftp="address=:8022" --sftp="ssh-private-key=/home/miniouser/.ssh/id_rsa"   \
      --sftp="kex-algos=diffie-hellman-group14-sha256,curve25519-sha256@libssh.org" \
      ...

.. mc-cmd:: --certs-dir, -S
   :optional:

   Specifies the path to the folder containing certificates the :mc:`minio` process uses for configuring TLS/SSL connectivity.
   
   The contents of the specified folder must follow that of the :ref:`default path structure <minio-tls-user-generated>`.
   For example, the path contents of ``--certs-dir /etc/minio`` should resemble the following:

   .. code-block:: shell

      /etc/minio
        private.key
        public.crt
        domain.tld/
          private.key
          public.crt
        CAs/
          full-chain-ca.crt

   Omit to use the default directory paths:

   - Linux/macOS: ``${HOME}/.minio/certs``
   - Windows: ``%%USERPROFILE%%\.minio\certs``.

   See :ref:`minio-TLS` for more information on TLS/SSL connectivity.

   .. important::

      :minio-release:`MinIO Server RELEASE.2023-12-09T18-17-51Z <RELEASE.2023-12-09T18-17-51Z>` removes the deprecated ``--config-dir | -C`` parameter.
      Deployments using this flag may start without TLS enabled.
      Replace those parameters with ``--certs-dir | -S`` and restart to re-enable TLS.

.. mc-cmd:: --quiet
   :optional:

   Disables startup information.

.. mc-cmd:: --anonymous
   :optional:

   Hides sensitive information from logging.

.. mc-cmd:: --json
   :optional:

   Outputs server logs and startup information in ``JSON`` format.

.. note::

   You can define any of the ``minio`` parameters above by setting them in the :envvar:`MINIO_OPTS` environment variable.
   This variable takes as its value a single string that contains any of the above parameters and their values that you want to set when starting the MinIO Server.

Settings
--------

You can perform other customizations to the MinIO Server process by defining additional :ref:`Configuration Values <minio-server-configuration-options>` or :ref:`Environment Variables <minio-server-environment-variables>`.

Many configuration values and environment variables define the same value.
If you set both a configuration value and the matching environment variable, MinIO uses the value from the environment variable.

   
.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-server/settings
   /reference/minio-server/settings/core
   /reference/minio-server/settings/root-credentials 
   /reference/minio-server/settings/storage-class
   /reference/minio-server/settings/console 
   /reference/minio-server/settings/metrics-and-logging 
   /reference/minio-server/settings/notifications 
   /reference/minio-server/settings/iam 
   /reference/minio-server/settings/ilm 
   /reference/minio-server/settings/kes 
   /reference/minio-server/settings/object-lambda
   /reference/minio-server/settings/deprecated
