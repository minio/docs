.. start-kes-configuration-hashicorp-vault

|KES| uses a YAML-formatted configuration file. The following example YAML
specifies the minimum required fields for enabling |SSE| using Hashicorp Vault:

.. code-block:: shell
   :class: copyable

   address: 0.0.0.0:7373

   # Disable the root identity, as we do not need that level of access for
   # supporting SSE operations.
   root: disabled

   # Specify the TLS keys generated in the previous step here
   # For production environments, use keys signed by a known and trusted
   # Certificate Authority (CA).
   tls:
     key:  ~/minio-kes-vault/certs/kes-server.key
     cert: ~/minio-kes-vault/certs/kes-server.cert

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
       - ${MINIO_IDENTITY_HASH} # Replace with the output of 'kes tool identity of minio-kes.cert'

   # Specify the connection information for the Vault server.
   # The endpoint should be resolvable from the host.
   # This example assumes that Vault is configured with an AppRole ID and
   # Secret for use with KES.
   keystore:
     vault:
       endpoint: https://HOSTNAME:8200
       approle:
         id: "VAULTAPPID"     # Hashicorp Vault AppRole ID
         secret: "VAULTAPPSECRET" # Hashicorp Vault AppRole Secret ID
         retry: 15s
       status:
         ping: 10s
       # Required if Vault uses certificates signed by an unknown CA,
       # e.g. self-signed or internal (non-globally trusted).  
       tls:
         ca: vault-tls.cert 

.. end-kes-configuration-hashicorp-vault

.. start-kes-prereq-hashicorp-vault

This procedure assumes an existing `Hashicorp Vault <https://www.vaultproject.io/>`__ installation accessible from the local host.
The Vault `Quick Start <https://learn.hashicorp.com/tutorials/vault/getting-started-install>`__ provides a sufficient foundation for the purposes of this procedure.
Defer to the `Vault Documentation <https://learn.hashicorp.com/vault>`__ for guidance on deployment and configuration.

MinIO requires the following Vault settings or configurations:

- Enable the Vault K/V engine. 
  KES version 0.15.0 and later support both the v1 and v2 engines. 

- For K/V v1, create an access policy ``kes-policy.hcl`` with a configuration similar to the following:
   
  .. code-block:: shell
     :class: copyable

     path "kv/*" {
          capabilities = [ "create", "read", "delete" ]
     }

  Write the policy to Vault using ``vault policy write kes-policy kes-policy.hcl``.
  
- For K/V v2, create an access policy ``kes-policy.hcl`` with a configuration similar to the following:

  .. code-block:: shell
     :class: copyable

     path "kv/data/*" {
          capabilities = [ "create", "read"]

     path "kv/metadata/*" {
          capabilities = [ "list", "delete"]
    
  Write the policy to Vault using ``vault policy write kes-policy kes-policy.hcl``

- Enable Vault AppRole authentication, create an AppRole ID, bind it to the necessary policy, and request both roleID and secret ID. 

  .. code-block:: shell
     :class: copyable

     vault write    auth/approle/role/kes-role token_num_uses=0 secret_id_num_uses=0 period=5m
     vault write    auth/approle/role/kes-role policies=kes-policy
     vault read     auth/approle/role/kes-role/role-id
     vault write -f auth/approle/role/kes-role/secret-id

.. end-kes-prereq-hashicorp-vault
