.. start-kes-configuration-aws-desc

|KES| uses a YAML-formatted configuration file. The following example YAML
specifies the minimum required fields for enabling |SSE| using AWS Secrets
Manager:

.. code-block:: shell
   :class: copyable
   :substitutions:

   address: 0.0.0.0:7373

   # Disable the root identity, as we do not need that level of access for
   # supporting SSE operations.
   root: disabled

   # Specify the TLS keys generated in the previous step here
   # For production environments, use keys signed by a known and trusted
   # Certificate Authority (CA).
   tls:
     key:  |kesconfigcertpath|kes-server.key
     cert: |kesconfigcertpath|kes-server.cert

   # Create a policy named 'minio' that grants access to the 
   # /create, /generate, and /decrypt KES APIs for any key name
   # KES uses mTLS to grant access to this policy, where only the client 
   # whose TLS certificate hash matches one of the "identities" can
   # use this policy. Specify the hash of the MinIO server TLS certificate
   # hash here.
   policy:
     minio:
       allow:
       - /v1/key/create/*   # You can replace these wildcard '*' with a string prefix to restrict key names
       - /v1/key/generate/* # e.g. '/minio-'
       - /v1/key/decrypt/*
       - /v1/key/bulk/decrypt
       - /v1/key/list/*
       - /v1/status
       - /v1/metrics
       - /v1/log/audit
       - /v1/log/error
       identities:
       - ${MINIO_IDENTITY_HASH} # Replace with the output of 'kes identity of minio-kes.cert'

                                # In production environments, each client connecting to KES must
                                # Have their TLS hash listed under at least one `policy`.

   # Specify the connection information for the KMS and Secrets Manager endpoint.
   # The endpoint should be resolvable from the host.
   # This example assumes that the associated AWS account has the necessary
   # access key and secret key
   keystore:
     aws:
       secretsmanager:
         endpoint: secretsmanager.REGION.amazonaws.com # use the Secrets Manager endpoint for your region
         region: REGION # e.g. us-east-1
         kmskey: "" # Optional. The root AWS KMS key to use for cryptographic operations. Formerly described as the "Customer Master Key".
         credentials:
           accesskey: "AWSACCESSKEY" # AWS Access Key
           secretkey: "AWSSECRETKEY" # AWS Secret Key


.. end-kes-configuration-aws-desc

.. start-kes-configuration-aws-container-desc

|KES| uses a YAML-formatted configuration file. The following example YAML
specifies the minimum required fields for enabling |SSE| using AWS Secrets
Manager:

.. code-block:: shell
   :class: copyable
   :substitutions:

   address: 0.0.0.0:7373

   # Disable the root identity, as we do not need that level of access for
   # supporting SSE operations.
   root: disabled

   # Specify the TLS keys generated in the previous step here
   # For production environments, use keys signed by a known and trusted
   # Certificate Authority (CA).
   tls:
     key:  /certs/server.key
     cert: /certs/server.cert

   # Create a policy named 'minio' that grants access to the 
   # /create, /generate, and /decrypt KES APIs for any key name
   # KES uses mTLS to grant access to this policy, where only the client 
   # whose TLS certificate hash matches one of the "identities" can
   # use this policy. Specify the hash of the MinIO server TLS certificate
   # hash here.
   policy:
     minio:
       allow:
       - /v1/key/create/*
       - /v1/key/generate/*
       - /v1/key/decrypt/*
       identities:
       - ${MINIO_IDENTITY_HASH} # Replace with the output of 'kes identity of minio-kes.cert'

   # Specify the connection information for the KMS and Secrets Manager endpoint.
   # The endpoint should be resolvable from the host.
   # This example assumes that the associated AWS account has the necessary
   # access key and secret key
   keystore:
     aws:
       secretsmanager:
         endpoint: secretsmanager.REGION.amazonaws.com # use the Secrets Manager endpoint for your region
         region: REGION # e.g. us-east-1
         kmskey: "" # Optional. The root AWS KMS key to use for cryptographic operations. Formerly described as the "Customer Master Key".
         credentials:
           accesskey: "${AWSACCESSKEY}" # AWS Access Key
           secretkey: "${AWSSECRETKEY}" # AWS Secret Key


Save the configuration file as ``|path|/config/kes-config.yaml``. Any field with
value ``${VARIABLE}`` uses the environment variable with matching name as the
value. You can use this functionality to set credentials without writing them to
the configuration file.

- Set ``MINIO_IDENTITY_HASH`` to the output of 
  ``kes identity of minio-kes.cert``.

- Replace the ``REGION`` with the appropriate region for AWS Secrets Manager.
  The value **must** match for both ``endpoint`` and ``region``.

- Set ``AWSACCESSKEY`` and ``AWSSECRETKEY`` to the appropriate
  :ref:`AWS Credentials <minio-sse-aws-prereq-aws>`.


.. end-kes-configuration-aws-container-desc