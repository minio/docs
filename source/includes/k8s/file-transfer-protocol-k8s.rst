#. Enable SFTP for the desired Tenant:

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

#. Validate the configuration

   The following ``kubectl get`` command uses `yq <https://github.com/mikefarah/yq/#install>`__ to display the value of ``enableSFTP``, indicating whether SFTP is enabled:

   .. code-block:: console
      :class: copyable

      kubectl get tenants/my-tenant -n my-tenant-ns -o yaml | yq '.spec.features'

   Replace ``my-tenant`` and ``my-tenant-ns`` with the desired Tenant and namespace.

   If SFTP is enabled, the output resembles the following:

   .. code-block:: console

      enableSFTP: true

#. Use your preferred SFTP client to connect to the MinIO deployment.
   You must connect as a user whose :ref:`policies <minio-policy>` allow access to the desired buckets and objects.

   The specifics of connecting to the MinIO deployment depend on your SFTP client.
   Refer to the documentation for your client.

   The following example connects to the MinIO Tenant SFTP server forwarded to the local host system, and lists the contents of a bucket named ``runner``.

         .. code-block:: console

            > sftp -P 8022 minio@localhost
            minio@localhost's password:
            Connected to localhost.
            sftp> ls runner/
            chunkdocs  testdir

The following ``kubectl get`` command uses `yq <https://github.com/mikefarah/yq/#install>`__ to display the value of ``enableSFTP``, indicating whether SFTP is enabled:

.. code-block:: console
   :class: copyable

   kubectl get tenants/my-tenant -n my-tenant-ns -o yaml | yq '.spec.features'

Replace ``my-tenant`` and ``my-tenant-ns`` with the desired Tenant and namespace.

If SFTP is enabled, the output resembles the following:

.. code-block:: console

   enableSFTP: true

.. _minio-certificate-key-file-sftp-k8s:

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
