.. versionadded:: MinIO RELEASE.2023-04-20T17-56-55Z

Overview
--------

Starting with :minio-release:`MinIO Server RELEASE.2023-04-20T17-56-55Z <RELEASE.2023-04-20T17-56-55Z>`, you can use the File Transfer Protocol (FTP) or SSH File Transfer Protocol (SFTP) to interact with the objects on a MinIO deployment.

You must specifically enable FTP or SFTP when starting the server.
Enabling either server type does not affect other MinIO features.

This page uses the abbreviation FTP throughout, but you can use any of the supported FTP protocols described below.

Supported Protocols
~~~~~~~~~~~~~~~~~~~

When enabled, MinIO supports FTP access over the following protocols:

- SSH File Transfer Protocol (SFTP)

  SFTP is defined by the Internet Engineering Task Force (IETF) as an extension of SSH 2.0.
  SFTP allows file transfer over SSH for use with :ref:`Transport Layer Security (TLS) <minio-tls>` and virtual private network (VPN) applications.

  Your FTP client must support SFTP.

- File Transfer Protocol over SSL/TLS (FTPS)
  
  FTPS allows for encrypted FTP communication with TLS certificates over the standard FTP communication channel.
  FTPS should not be confused with SFTP, as FTPS does not communicate over a Secure Shell (SSH).

  Your FTP client must support FTPS.

- File Transfer Protocol (FTP)
  
  Unencrypted file transfer.

  MinIO does **not** recommend using unencrypted FTP for file transfer.

.. admonition:: MinIO Operator Tenants only support SFTP
   :class: note

   MinIO Tenants deployed with Operator only support SFTP.
   For details, see `File Transfer Protocol for Tenants <https://min.io/docs/minio/kubernetes/upstream/developers/file-transfer-protocol.html?ref=docs>`__.


Supported Commands
~~~~~~~~~~~~~~~~~~

When enabled, MinIO supports the following FTP operations:

- ``get``
- ``put``
- ``ls``
- ``mkdir``
- ``rmdir``
- ``delete``

MinIO does not support either ``append`` or ``rename`` operations.

Considerations
--------------

Versioning
~~~~~~~~~~

SFTP clients can only operate on the :ref:`latest version <minio-bucket-versioning>` of an object.
Specifically:

- For read operations, MinIO only returns the latest version of the requested object(s) to the FTP client.
- For write operations, MinIO applies normal versioning behavior and creates a new object version at the specified namespace.
  ``delete`` and ``rmdir`` operations create ``DeleteMarker`` objects.


Authentication and Access
~~~~~~~~~~~~~~~~~~~~~~~~~

FTP access requires the same authentication as any other S3 client.
MinIO supports the following authentication providers:

- :ref:`MinIO IDP <minio-internal-idp>` users and their service accounts
- :ref:`Active Directory/LDAP <minio-external-identity-management-ad-ldap>` users and their service accounts
- :ref:`OpenID/OIDC <minio-external-identity-management-openid>` service accounts

:ref:`STS <minio-security-token-service>` credentials **cannot** access buckets or objects over FTP.

Authenticated users can access buckets and objects based on the :ref:`policies <minio-policy>` assigned to the user or parent user account.

The FTP protocol does not require any of the ``admin:*`` :ref:`permissions <minio-policy-mc-admin-actions>`.
The FTP protocols do not support any of the MinIO admin actions.

Prerequisites
-------------

- MinIO RELEASE.2023-04-20T17-56-55Z or later.
- Enable an FTP or SFTP port for the server.
- A port to use for the FTP commands and a range of ports to allow the FTP server to request to use for the data transfer.

Procedure
---------

1. Start MinIO with an FTP and/or SFTP port enabled.

   .. code-block:: shell
      :class: copyable

      minio server http://server{1...4}/disk{1...4}        \
      --ftp="address=:8021"                                \
      --ftp="passive-port-range=30000-40000"               \
      --sftp="address=:8022"                               \
      --sftp="ssh-private-key=/home/miniouser/.ssh/id_rsa" \
      ...
    
   See the :mc-cmd:`minio server --ftp` and :mc-cmd:`minio server --sftp` for details on using these flags to start the MinIO service.
   To connect to the an FTP port with TLS (FTPS), pass the ``tls-private-key`` and ``tls-public-cert`` keys and values, as well, unless using the MinIO default TLS keys.

   The output of the command should return a response that resembles the following:

   .. code-block:: shell

      MinIO FTP Server listening on :8021
      MinIO SFTP Server listening on :8022

2. Use your preferred FTP client to connect to the MinIO deployment.
   You must connect as a user whose :ref:`policies <minio-policy>` allow access to the desired buckets and objects.

   The specifics of connecting to the MinIO deployment depend on your FTP client.
   Refer to the documentation for your client.

   To connect over TLS or through SSH, you must use a client that supports the desired protocol.

Examples
--------

The following examples use the `FTP CLI client <https://linux.die.net/man/1/ftp>`__ on a Linux system.


Connect to MinIO Using FTP
~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example connects to a server using ``minio`` credentials to list contents in a bucket named ``runner``

.. code-block:: shell

   > ftp localhost -P 8021
   Connected to localhost.
   220 Welcome to MinIO FTP Server
   Name (localhost:user): minio
   331 User name ok, password required
   Password:
   230 Password ok, continue
   Remote system type is UNIX.
   Using binary mode to transfer files.
   ftp> ls runner/
   229 Entering Extended Passive Mode (|||39155|)
   150 Opening ASCII mode data connection for file list
   drwxrwxrwx 1 nobody nobody            0 Jan  1 00:00 chunkdocs/
   drwxrwxrwx 1 nobody nobody            0 Jan  1 00:00 testdir/
   ...

Start MinIO with FTP over TLS (FTPS) Enabled
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example starts MinIO with FTPS enabled.

.. code-block:: shell
   :class: copyable

   minio server http://server{1...4}/disk{1...4} \
   --ftp="address=:8021"                         \
   --ftp="passive-port-range=30000-40000"        \
   --ftp="tls-private-key=path/to/private.key"   \
   --ftp="tls-public-cert=path/to/public.crt"    \
   ...

.. note:: 

   Omit ``tls-private-key`` and ``tls-public-cert`` to use the MinIO default TLS keys for FTPS.
   For more information, see the :ref:`TLS on MinIO documentation <minio-tls>`.

Download an Object over FTP
~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example lists items in a bucket, then downloads the contents of the bucket.

.. code-block:: console

   > ftp localhost -P 8021
   Connected to localhost.
   220 Welcome to MinIO FTP Server
   Name (localhost:user): minio
   331 User name ok, password required
   Password:
   230 Password ok, continue
   Remote system type is UNIX.
   Using binary mode to transfer files.ftp> ls runner/chunkdocs/metadata
   229 Entering Extended Passive Mode (|||44269|)
   150 Opening ASCII mode data connection for file list
   -rwxrwxrwx 1 nobody nobody           45 Apr  1 06:13 chunkdocs/metadata
   226 Closing data connection, sent 75 bytes
   ftp> get
   (remote-file) runner/chunkdocs/metadata
   (local-file) test
   local: test remote: runner/chunkdocs/metadata
   229 Entering Extended Passive Mode (|||37785|)
   150 Data transfer starting 45 bytes
   	45        3.58 KiB/s
   226 Closing data connection, sent 45 bytes
   45 bytes received in 00:00 (3.55 KiB/s)
   ...

Connect to MinIO Using SFTP
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example connects to an SFTP server, lists the contents of a bucket named ``runner``, and downloads an object.

.. code-block:: console

   > sftp -P 8022 minio@localhost
   minio@localhost's password:
   Connected to localhost.
   sftp> ls runner/
   chunkdocs  testdir
   sftp> get runner/chunkdocs/metadata metadata
   Fetching /runner/chunkdocs/metadata to metadata
   metadata                               100%  226    16.6KB/s   00:00

Force use of service account or ldap for authentication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To force authentication to SFTP using LDAP or service account credentials, append a suffix to the username.
Valid suffixes are either ``=ldap`` or ``=svc``.

.. code-block:: console

   > sftp -P 8022 my-ldap-user=ldap@[minio@localhost]:/bucket


.. code-block:: console

   > sftp -P 8022 my-ldap-user=svc@[minio@localhost]:/bucket


- Replace ``my-ldap-user`` with the username to use.
- Replace ``[minio@localhost]`` with the address of the MinIO server.
