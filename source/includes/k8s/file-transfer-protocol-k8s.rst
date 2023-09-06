.. versionadded:: Operator v5.0.7

Overview
--------

You can use the SSH File Transfer Protocol (``SFTP``) to interact with the objects on a MinIO Operator tenant deployment.

SFTP is defined by the Internet Engineering Task Force (IETF) as an extension of SSH 2.0.
It allows file transfer over SSH for use with :ref:`Transport Layer Security (TLS) <minio-tls>` and virtual private network (VPN) applications.

Enabling SFTP does not affect other MinIO features.


Supported Commands
~~~~~~~~~~~~~~~~~~

When enabled, MinIO supports the following ``sftp`` operations:

- ``get``
- ``put``
- ``ls``
- ``mkdir``
- ``rmdir``
- ``delete``

MinIO does not support either ``append`` or ``rename`` operations.

Operator only supports the SFTP file transfer protocol.
Other protocols, such as FTP, are not supported for accessing Tenants.


Considerations
--------------


Versioning
~~~~~~~~~~

SFTP clients cannot read specific :ref:`object versions <minio-bucket-versioning>` other than the latest version.

- For read operations, MinIO only returns the latest version of the requested object(s) to the sftp client.
- For write operations, MinIO applies normal versioning behavior for matching object names.

Use an S3 API Client, such as the :ref:`MinIO Client <minio-client>`.


Authentication and Access
~~~~~~~~~~~~~~~~~~~~~~~~~

``SFTP`` access requires the same authentication as any other S3 client.
MinIO supports the following authentication providers:

- :ref:`MinIO IDP <minio-internal-idp>` users and their service accounts
- :ref:`Active Directory/LDAP <minio-external-identity-management-ad-ldap>` users and their service accounts
- :ref:`OpenID/OIDC <minio-external-identity-management-openid>` service accounts

:ref:`STS <minio-security-token-service>` credentials **cannot** access buckets or objects over SFTP.
To use STS credentials to authenticate, you must use an S3 API client or port.

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

         - In the Operator Console, click on the tenant for which to enable SFTP.
         - In the :guilabel:`Configuration` tab, toggle :guilabel:`SFTP` to :guilabel:`Enabled`.
         - Click :guilabel:`Save`.
         - Click :guilabel:`Restart` to restart MinIO and apply your changes.

      .. tab-item:: Kubectl

	 Use the following command to edit the Tenant YAML configuration:

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

         You may also set ``enableSFTP`` in your Helm chart or Kustomize configuration to enable SFTP for newly created Tenants.

#. If needed, configure ingress or forwarding for the SFTP port according to your local policies.

#. Use your preferred SFTP client to connect to the MinIO deployment.
   You must connect as a user whose :ref:`policies <minio-policy>` allow access to the desired buckets and objects.

   The specifics of connecting to the MinIO deployment depend on your SFTP client.
   Refer to the documentation for your client.


Examples
--------

The examples here use the ``sftp`` CLI client on a Linux system.

Connect to MinIO Using SFTP
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example connects to an SSH FTP server, lists the contents of a bucket named ``test-bucket``, and downloads an object.

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

The following ``kubectl get`` command displays the value of ``enableSFTP``, indicating whether SFTP is enabled:

.. code-block:: console
   :class: copyable

   kubectl get tenants/my-tenant -n my-tenant-ns -o yaml | yq '.spec.features'

Replace ``my-tenant`` and ``my-tenant-ns`` with the desired Tenant and namespace.
   
If SFTP is enabled, the output resembles the following:

.. code-block:: console

   enableSFTP: true

