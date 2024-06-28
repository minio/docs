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
              credsSecret:
                name: my-tenant-secret
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

Connect to MinIO Using SFTP with a Certificate Key File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: RELEASE.2024-05-07T06-41-25Z

MinIO supports user certificate based authentication on SFTP.

This example adds a certificate signature for the MinIO user ``sftp-ca-user1``.
The signature remains valid for one week after creation.

Before beginning, the following prerequisites must be met:

- Create a trusted user Certificate Authority, such as with ``ssh-keygen -f user_ca``
- Start or restart the MinIO server to support this CA by including the following flag in the command string:

  .. code-block:: bash
     :class: copyable 

     --sftp=trusted-user-ca-key=/path/to/.ssh/user_ca.pub

Repeat the following steps for each user who accesses the MinIO Server by SFTP with a user CA key file:

1. Create user public key in client PC (testuser1 in this example) ssh-keygen
2. Provide copy of /home/testuser1/.ssh/id_rsa.pub to CA server.
3. Create a signature for the identity ``sftp-ca-user1``.
   (The name must match the username in MinIO).
   In this example, the signature is valid for one week.
   
   .. code-block:: bash
      :class: copyable

      ssh-keygen -s /home/miniouser/.ssh/user_ca -I sftp=ca-user1-2024-05-03 -n sftp-ca-user1 -V +1w id_rsa.pub

4. Copy ``id_rsa-cert.pub`` to ``/home/sftp-ca-user1/.ssh/id_rsa-cert.pub`` on the client PC.

After the certificate expires, repeat steps 3 and 4.
Alternatively, leave out the -V +1w argument when creating the signature to to add a certificate that doesn't expire.

Once completed the trusted user can connect to the MinIO server over SFTP:

.. code-block:: bash
   :class: copyable:
   
   sftp -P <SFTP port> <server IP>

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