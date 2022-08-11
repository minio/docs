.. start-kes-configuration-hashicorp-vault-desc

|KES| uses a YAML-formatted configuration file. 
The following YAML provides the minimum required fields for using Hashicorp Vault as the root |KMS| and is intended for use in this tutorial.

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

   # Sets access policies for KES
   # The `minio` policy grants access to the listed APIs.
   policy:
     minio:
       allow:
       - /v1/key/create/*   # You can replace these wildcard '*' with a string prefix to restrict key names
       - /v1/key/generate/* # e.g. '/minio-'
       - /v1/key/decrypt/*
       identities:
       - ${MINIO_IDENTITY_HASH} # Replace with the output of 'kes tool identity of minio-kes.cert'
                                # In production environments, each client connecting to KES must
                                # Have their TLS hash listed under at least one `policy`.

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
       # Replace this value with the full path to the Vault CA certificate.
       tls:
         ca: vault-tls-CA.cert 

.. end-kes-configuration-hashicorp-vault-desc

.. start-kes-prereq-hashicorp-vault-desc

This procedure assumes an existing `Hashicorp Vault <https://www.vaultproject.io/>`__ installation accessible from the local host.
The Vault `Quick Start <https://learn.hashicorp.com/tutorials/vault/getting-started-install>`__ provides a sufficient foundation for the purposes of this procedure.
Defer to the `Vault Documentation <https://learn.hashicorp.com/vault>`__ for guidance on deployment and configuration.

MinIO |KES| supports both the V1 and V2 Vault engines.
Select the corresponding tab to the engine used by your Vault deployment for instructions on configuring the necessary permissions:

.. tab-set::

   .. tab-item:: Vault Engine V1

      Create an access policy ``kes-policy.hcl`` with a configuration similar to the following:
         
      .. code-block:: shell
         :class: copyable

         path "kv/*" {
               capabilities = [ "create", "read", "delete" ]
         }

      Write the policy to Vault using ``vault policy write kes-policy kes-policy.hcl``.

   .. tab-item:: Vault Engine V2

      Create an access policy ``kes-policy.hcl`` with a configuration similar to the following:

      .. code-block:: shell
         :class: copyable

         path "kv/data/*" {
               capabilities = [ "create", "read"]

         path "kv/metadata/*" {
               capabilities = [ "list", "delete"]
         
      Write the policy to Vault using ``vault policy write kes-policy kes-policy.hcl``

MinIO requires using AppRole authentication for secure communication with the Vault server.
The following commands:

- Create an App Role ID for |KES|
- Binds that role to the created KES policy
- Requests a RoleID and SecretID

  .. code-block:: shell
     :class: copyable

     vault write    auth/approle/role/kes-role token_num_uses=0 secret_id_num_uses=0 period=5m
     vault write    auth/approle/role/kes-role policies=kes-policy
     vault read     auth/approle/role/kes-role/role-id
     vault write -f auth/approle/role/kes-role/secret-id

You must specify both RoleID and SecretID as part of this procedure.

.. end-kes-prereq-hashicorp-vault-desc

