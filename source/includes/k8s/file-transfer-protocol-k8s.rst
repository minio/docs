.. versionadded:: Operator v5.0.7

Overview
--------

Starting with Operator 5.0.7 and :minio-release:`MinIO Server RELEASE.2023-04-20T17-56-55Z <RELEASE.2023-04-20T17-56-55Z>`, you can use the SSH File Transfer Protocol (SFTP) to interact with the objects on a MinIO Operator Tenant deployment.

SFTP is defined by the Internet Engineering Task Force (IETF) as an extension of SSH 2.0.
It allows file transfer over SSH for use with :ref:`Transport Layer Security (TLS) <minio-tls>` and virtual private network (VPN) applications.

Enabling SFTP does not affect other MinIO features.


Supported Commands
~~~~~~~~~~~~~~~~~~

When enabled, MinIO supports the following SFTP operations:

- ``get``
- ``put``
- ``ls``
- ``mkdir``
- ``rmdir``
- ``delete``

MinIO does not support either ``append`` or ``rename`` operations.

MinIO Operator only supports the SFTP file transfer protocol.
Other protocols, such as FTP, are not supported for accessing Tenants.


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
- :ref:`Certificate Key File <minio-certificate-key-file-sftp-k8s>`

:ref:`STS <minio-security-token-service>` credentials **cannot** access buckets or objects over SFTP.

Authenticated users can access buckets and objects based on the :ref:`policies <minio-policy>` assigned to the user or parent user account.

The SFTP protocol does not require any of the ``admin:*`` :ref:`permissions <minio-policy-mc-admin-actions>`.
You may not perform other MinIO admin actions with SFTP.


Prerequisites
-------------

- MinIO Operator v5.0.7 or later.
- Enable an SFTP port (8022) for the server.
- A port to use for the SFTP commands and a range of ports to allow the SFTP server to request to use for the data transfer.


Procedure
---------

#. Enable SFTP for the desired Tenant:

   .. tab-set::

      .. tab-item:: Operator Console

         - In the Operator Console, click on the Tenant for which to enable SFTP.
         - In the :guilabel:`Configuration` tab, toggle :guilabel:`SFTP` to :guilabel:`Enabled`.
         - Click :guilabel:`Save`.
         - Click :guilabel:`Restart` to restart MinIO and apply your changes.

      .. tab-item:: Kubectl

	 Use the following Kubectl command to edit the Tenant YAML configuration:

	 .. code-block:: yaml

            kubectl edit tenants/my-tenant -n my-tenant-ns

	 Replace ``my-tenant`` and ``my-tenant-ns`` with the desired Tenant and namespace.

         In the ``features:`` section, set the value of ``enableSFTP`` to ``true``:

         .. code-block:: yaml

            spec:
              configuration:
                name: my-tenant-env-configuration
              exposeServices:
                console: true
                minio: true
              features:
                enableSFTP: true

         Kubectl restarts MinIO to apply the change.

         You may also set ``enableSFTP`` in your `Helm chart <https://github.com/minio/operator/blob/8385948929bc95648d1be82d96f829c810519674/helm/tenant/values.yaml>`__ or `Kustomize configuration <https://github.com/minio/operator/blob/8385948929bc95648d1be82d96f829c810519674/examples/kustomization/base/tenant.yaml>`__ to enable SFTP for newly created Tenants.
	 

#. If needed, configure ingress for the SFTP port according to your local policies.

#. Use your preferred SFTP client to connect to the MinIO deployment.
   You must connect as a user whose :ref:`policies <minio-policy>` allow access to the desired buckets and objects.

   The specifics of connecting to the MinIO deployment depend on your SFTP client.
   Refer to the documentation for your client.


Examples
--------

The following examples use the `SFTP CLI client <https://linux.die.net/man/1/sftp>`__ on a Linux system.

Connect to MinIO Using SFTP
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example connects to an SFTP server, lists the contents of a bucket named ``test-bucket``, and downloads an object.

.. code-block:: console

   sftp -P 8022 my-access-key@localhost
   my-access-key@localhost's password:
   Connected to localhost.
   sftp> ls
   test-bucket
   sftp> ls test-bucket
   test-bucket/test-file.txt
   sftp> get test-bucket/test-file.txt
   Fetching /test-bucket/test-file.txt to test-file.txt
   test-file.txt                    100%    6     1.3KB/s   00:00


Check if SFTP is Enabled for a Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following ``kubectl get`` command uses `yq <https://github.com/mikefarah/yq/#install>`__ to display the value of ``enableSFTP``, indicating whether SFTP is enabled:

.. code-block:: console
   :class: copyable

   kubectl get tenants/my-tenant -n my-tenant-ns -o yaml | yq '.spec.features'

Replace ``my-tenant`` and ``my-tenant-ns`` with the desired Tenant and namespace.

If SFTP is enabled, the output resembles the following:

.. code-block:: console

   enableSFTP: true

.. _minio-certificate-key-file-sftp-k8s

Connect to MinIO Using SFTP with a Certificate Key File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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