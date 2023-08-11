.. start-kes-download-desc

Download the latest stable release (|kes-stable|) of KES from :minio-git:`github.com/minio/kes <kes/releases/latest>`.

Select the binary appropriate for the host OS architecture. 
For example, hosts running X86-64 (Intel/AMD64) should download the ``kes-linux-amd64`` package.

The following example code downloads the latest Linux AMD64-compatible binary and moves it to the system ``PATH``:

.. code-block:: shell
   :class: copyable
   :substitutions:

   curl --retry 10 https://github.com/minio/kes/releases/download/|kes-stable|/kes-linux-amd64 -o /tmp/kes
   chmod +x /tmp/kes
   sudo mv /tmp/kes /usr/local/bin

   kes --version

For distributed KES topologies, repeat this step and all following KES-specific instructions for each host on which you want to deploy KES.
MinIO uses a round-robin approach by default for routing connections to multiple configured KES servers.
For more granular controls, deploy a dedicated load balancer to manage connections to distributed KES hosts.

.. end-kes-download-desc

.. start-kes-service-file-desc

Create the ``/lib/systemd/system/kes.service`` file on all KES hosts:

.. literalinclude:: /extra/kes.service
   :language: shell

You may need to run ``systemctl daemon-reload`` to load the new service file into ``systemctl``.

The ``kes.service`` file runs as the ``kes`` User and Group by default.
You can create the user and group using the ``useradd`` and ``groupadd`` commands.
The following example creates the user and group.
These commands typically require root (``sudo``) permissions.

.. code-block:: shell
   :class: copyable

   groupadd -r kes
   useradd -M -r -g kes kes

The ``kes`` user and group must have read access to all files used by the KES service:

.. code-block:: shell
   :class: copyable
   :substitutions:

   chown -R kes:kes /opt/kes

.. end-kes-service-file-desc

.. start-kes-start-service-desc

Run the following command on each KES host to start the service:

.. code-block:: shell
   :class: copyable

   systemctl start kes

You can validate the startup by using ``systemctl status kes``. 
If the service started successfully, use ``journalctl -uf kes`` to check the KES output logs.

.. end-kes-start-service-desc

.. start-kes-minio-start-service-desc

For new MinIO deployments, run the following command on each MinIO host to start the service:

.. code-block:: shell
   :class: copyable

   systemctl start minio

For existing MinIO deployments, run the following command on each MinIO host to restart the service:

.. code-block:: shell
   :class: copyable

   systemctl reload minio
   systemctl restart minio

.. end-kes-minio-start-service-desc

.. start-kes-generate-kes-certs-prod-desc

KES requires TLS connectivity for all client connections, including those originating from MinIO.
See :ref:`minio-tls` for more information on enabling TLS for the MinIO deployment.

Depending on your Vault configuration, you may also need to create a dedicated set of TLS certificates for KES to connect and authenticate to Vault.

Defer to your organization's best practices around generating production-ready TLS certificates.

Place the certificates and corresponding private keys in a directory that the KES service user has permissions to access and read the directory's contents.
For example:

.. code-block:: shell
   :substitutions:

   -rw-r--r-- 1 kes:kes |kescertpath|/kes-server.cert
   -rw-r--r-- 1 kes:kes |kescertpath|/kes-server.key

   # If the Vault certs are self-signed or use a non-global CA
   # Include those CA certs as well

   -rw-r--r-- 1 kes:kes |kescertpath|/vault-CA.cert

.. end-kes-generate-kes-certs-prod-desc

.. start-kes-generate-key-desc

MinIO requires that the |EK| exist on the root KMS *before* performing |SSE| operations using that key. 
Use ``kes key create`` *or* :mc-cmd:`mc admin kms key create` to add a new |EK| for use with |SSE|.

The following command uses the ``kes key create`` command to add a new External Key (EK) stored on the root KMS server for use with encrypting the MinIO backend.

.. code-block:: shell
   :class: copyable

   mc admin kms key create ALIAS KEYNAME

.. end-kes-generate-key-desc