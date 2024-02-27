
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

Depending on your selected KMS target's configuration, you may also need to create a dedicated set of TLS certificates for KES to connect and authenticate to the KMS.

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