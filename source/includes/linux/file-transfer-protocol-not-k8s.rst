1. Start MinIO with an FTP and/or SFTP port enabled.

   .. tab-set::

      .. tab-item:: FTPS
         :sync: ftps

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

      .. tab-item:: SFTP/FTP
         :sync: sftp

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

3. Connect to MinIO

   .. tab-set::

      .. tab-item:: SFTP/FTP
         :sync: sftp


         The following example connects to an SFTP server, and lists the contents of a bucket named ``runner``.

         .. code-block:: console

            > sftp -P 8022 minio@localhost
            minio@localhost's password:
            Connected to localhost.
            sftp> ls runner/
            chunkdocs  testdir


      .. tab-item:: FTPS
         :sync: ftps

         The following uses the Linux uses the `FTP CLI client <https://linux.die.net/man/1/ftp>`__ to connect to the MinIO server using ``minio`` credentials to list contents in a bucket named ``runner``

         .. code-block:: shell

<<<<<<< HEAD
.. code-block:: console
   :class: copyable

   ssh-keygen -s ~/.ssh/ca_user_key -I miniouser -n miniouser -V +1h -z 1 miniouser1.pub

-  ``-s`` specifies the path to the certificate authority public key to use for generating this key.
   The specified public key must have a ``principals`` list that includes this user.
- ``-I`` specifies the key identity for the public key.
- ``-n`` creates the ``user principals`` list for which this key is valid. 
  You must include the user for which this key is valid, and the user must match the username in MinIO.
- ``-V`` limits the duration for which the generated key is valid. 
  In this example, the key is valid for one hour.
  Adjust the duration for your requirements.
- ``-z`` adds a serial number to the key to distinguish this generated public key from other keys signed by the same certificate authority public key.

MinIO requires specifying the Certificate Authority used to sign the certificates for SFTP access.
Start or restart the MinIO Server and specify the path to the trusted certificate authority's public key using an ``--sftp="trusted-user-ca-key=PATH"`` flag:

  .. code-block:: console
     :class: copyable 

     minio server {path-to-server} --sftp="trusted-user-ca-key=/path/to/.ssh/ca_user_key.pub" {...other flags}

When connecting to the MinIO Server with SFTP, the client verifies the MinIO Server's certificate.
The client then passes its own certificate to the MinIO Server.
The MinIO Server verifies the key created above by comparing its value to the the known public key from the certificate authority provided at server startup.

Once the MinIO Server verifies the client's certificate, the user can connect to the MinIO server over SFTP:

.. code-block:: bash
   :class: copyable:
   
   sftp -P <SFTP port> <server IP>


Procedure
+++++++++

The following procedure generates two key-value pairs, signs one with the other, then uses the resulting signed key to log in to the SFTP server.

1. Generate a key-value pair for the MinIO Server
   
   .. code-block:: bash
      :class: copyable

      ssh-keygen -f ./ca_user_key

2. Generate a key-value pair for the user

   .. code-block:: bash
      :class: copyable

      ssh-keygen -f ./minioadmin

   Replace ``minioadmin`` with the user accessing the MinIO Server by SFTP.

3. Sign the user key-value pair key with the MinIO Server key-value pair key

   .. code-block:: bash
      :class: copyable

      ssh-keygen -s ca_user_key -I minioadmin -n minioadmin -V +30d -z 1 minioadmin.pub

   Move the ``minioadmin.pub`` key to the same directory as ``minioadmin`` key-value pair, such as ``~/.ssh/meaningful-directory``.

4. Start or restart the MinIO Server passing the generated public keys

   .. code-block:: bash
      :class: copyable

      minio server --sftp="address=:8022" --sftp="ssh-private-key=/path/to/ca_user_key" --sftp="trusted-user-ca-key=/path/to/ca_user_key.pub"

5. Connect to the MinIO Server by sftp

   .. code-block:: bash
      :class: copyable

      sftp -i ./minioadmin -oPort=8022 minioadmin@localhost


Require service account or LDAP for authentication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To force authentication to SFTP using LDAP or service account credentials, append a suffix to the username.
Valid suffixes are either ``=ldap`` or ``=svc``.

.. code-block:: console

   > sftp -P 8022 my-ldap-user=ldap@[minio@localhost]:/bucket
=======
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
>>>>>>> 8da23e1 (Attempting to reduce docs to single platform)


4. Download an Object

   .. tab-set:: 

      .. tab-item:: SFTP/FTP
         :sync: sftp

         This example lists items in a bucket, then downloads the contents of the bucket.

         .. code-block:: console

            > sftp -P 8022 minio@localhost
            minio@localhost's password:
            Connected to localhost.
            sftp> ls runner/
            chunkdocs  testdir
            sftp> get runner/chunkdocs/metadata metadata
            Fetching /runner/chunkdocs/metadata to metadata
            metadata                               100%  226    16.6KB/s   00:00
            sftp> 

      .. tab-item:: FTPS
         :sync: ftps

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
