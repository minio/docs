.. _minio-ftp:

=================================
File Transfer Protocol (FTP/SFTP)
=================================

.. default-domain:: minio

.. container:: extlinks-video

   - `File Transport Using FTP and SFTP with MinIO <https://www.youtube.com/watch?v=lNZyL8wD-lI>`__

.. contents:: Table of Contents
   :local:
   :depth: 2

.. tab-set::
   :class: parent

   .. tab-item:: Kubernetes
      :sync: k8s

      Starting with Operator 5.0.7 and :minio-release:`MinIO Server RELEASE.2023-04-20T17-56-55Z <RELEASE.2023-04-20T17-56-55Z>`, you can use the SSH File Transfer Protocol (SFTP) to interact with the objects on a MinIO Operator Tenant deployment.

      SFTP is defined by the Internet Engineering Task Force (IETF) as an extension of SSH 2.0.
      It allows file transfer over SSH for use with :ref:`Transport Layer Security (TLS) <minio-tls>` and virtual private network (VPN) applications.

      Enabling SFTP does not affect other MinIO features.

   .. tab-item:: Baremetal
      :sync: baremetal

      Starting with :minio-release:`MinIO Server RELEASE.2023-04-20T17-56-55Z <RELEASE.2023-04-20T17-56-55Z>`, you can use the File Transfer Protocol (FTP) to interact with the objects on a MinIO deployment.

      You must specifically enable FTP or SFTP when starting the server.
      Enabling either server type does not affect other MinIO features.

      This page uses the abbreviation FTP throughout, but you can use any of the supported FTP protocols described below.

Supported Protocols
-------------------

.. tab-set::
   :class: hidden

   .. tab-item:: Kubernetes
      :sync: k8s

      The MinIO Operator only supports configuring SSH File Transfer Protocol (SFTP).

   .. tab-item:: Baremetal
      :sync: baremetal

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

Supported Commands
------------------

When enabled, MinIO supports the following SFTP operations:

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

- For read operations, MinIO only returns the latest version of the requested object(s) to the SFTP client.
- For write operations, MinIO applies normal versioning behavior and creates a new object version at the specified namespace.
  ``rm`` and ``rmdir`` operations create ``DeleteMarker`` objects.

Authentication and Access
~~~~~~~~~~~~~~~~~~~~~~~~~

SFTP access requires the same authentication as any other S3 client.
MinIO supports the following authentication providers:

- :ref:`MinIO IDP <minio-internal-idp>` users and their service accounts
- :ref:`Active Directory/LDAP <minio-external-identity-management-ad-ldap>` users and their service accounts
- :ref:`OpenID/OIDC <minio-external-identity-management-openid>` service accounts

:ref:`STS <minio-security-token-service>` credentials **cannot** access buckets or objects over SFTP.

Authenticated users can access buckets and objects based on the :ref:`policies <minio-policy>` assigned to the user or parent user account.

The SFTP protocol does not require any of the ``admin:*`` :ref:`permissions <minio-policy-mc-admin-actions>`.
You may not perform other MinIO admin actions with SFTP.

Prerequisites
-------------

.. tab-set::
   :class: hidden

   .. tab-item:: Kubernetes
      :sync: k8s

      - MinIO Operator v5.0.7 or later.
      - Enable an SFTP port (8022) for the server.
      - A port to use for the SFTP commands and a range of ports to allow the SFTP server to request to use for the data transfer.

   .. tab-item:: Baremetal
      :sync: baremetal

      - MinIO RELEASE.2023-04-20T17-56-55Z or later.
      - Enable an FTP or SFTP port for the server.
      - A port to use for the FTP commands and a range of ports to allow the FTP server to request to use for the data transfer.

Procedure
---------

.. tab-set::
   :class: hidden

   .. tab-item:: Kubernetes
      :sync: k8s

      .. include:: /includes/k8s/file-transfer-protocol-k8s.rst

   .. tab-item:: Baremetal
      :sync: baremetal

      .. include:: /includes/linux/file-transfer-protocol-not-k8s.rst

.. _minio-certificate-key-file-sftp-k8s:

Connect to MinIO Using SFTP with a Certificate Key File
-------------------------------------------------------

.. versionadded:: RELEASE.2024-05-07T06-41-25Z


MinIO supports mutual TLS (mTLS) certificate-based authentication on SFTP, where both the server and the client verify the authenticity of each other.

This type of authentication requires the following:

1. Public key file for the trusted certificate authority
2. Public key file for the MinIO Server minted and signed by the trusted certificate authority
3. Public key file for the user minted and signed by the trusted certificate authority for the client connecting by SFTP and located in the user's ``.ssh`` folder (or equivalent for the operating system)

The keys must include a `principals list <https://man.openbsd.org/ssh-keygen#CERTIFICATES>`__ of the user(s) that can authenticate with the key:

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

Require service account or LDAP for authentication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To force authentication to SFTP using LDAP or service account credentials, append a suffix to the username.
Valid suffixes are either ``=ldap`` or ``=svc``.

.. code-block:: console

   > sftp -P 8022 my-ldap-user=ldap@[minio@localhost]:/bucket


.. code-block:: console

   > sftp -P 8022 my-ldap-user=svc@[minio@localhost]:/bucket


- Replace ``my-ldap-user`` with the username to use.
- Replace ``[minio@localhost]`` with the address of the MinIO server.

