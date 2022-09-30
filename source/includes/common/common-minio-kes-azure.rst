
.. start-kes-configuration-azure-desc

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
       - /v1/key/create/*
       - /v1/key/generate/*
       - /v1/key/decrypt/*
       identities:
       - ${MINIO_IDENTITY_HASH} # Replace with the output of 'kes identity of minio-kes.cert'

   # Specify the connection information for the Key Vualt endpoint.
   # The endpoint should be resolvable from the host.
   # This example assumes that the specified Key Vault and Azure tenant/client
   # have the necessary permissions set.

   keystore:
     azure:
       keyvault:
         endpoint: "https://<keyvaultinstance>vault.azure.net" # The Azure Keyvault Instance Endpoint
         credentials:
           tenant_id: "${TENANTID}" # The directory/tenant UUID
           client_id: "${CLIENTID}" # The application/client UUID
           client_secret: "${CLIENTSECRET}" # The Active Directory secret for the application

.. end-kes-configuration-azure-desc