.. start-kes-configuration-gcp-desc

|KES| uses a YAML-formatted configuration file. The following example YAML
specifies the minimum required fields for enabling |SSE| using GCP Secrets
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
       - /v1/key/list
       - /v1/status
       - /v1/metrics
       - /v1/log/audit
       - /v1/log/error
       identities:
       - ${MINIO_IDENTITY_HASH} # Replace with the output of 'kes identity of minio-kes.cert'

   # Specify the connection information for the  Secrets Manager endpoint.
   # The endpoint should be resolvable from the host.
   # This example assumes that the associated GCP account has the necessary
   # access key and secret key
   keystore:
     gcp:
       secretmanager:
         project_id: "${GCPPROJECTID}" # The GCP Project to use
         credentials:
           client_email: "${GCPCLIENTEMAIL}" # The client email for your GCP Credentials
           client_id: "${GCPCLIENTID}" # The Client ID for your GCP Credentials
           private_key_id: "${GCPPRIVATEKEYID}" # the private key ID for your GCP credentials
           private_key: "${GCPPRIVATEKEY}" # The content of your GCP Private Key

.. end-kes-configuration-gcp-desc

