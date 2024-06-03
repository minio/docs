.. start-kes-configuration-hashicorp-vault-desc

|KES| uses a YAML-formatted configuration file. 
The following YAML provides the minimum required fields for using HashiCorp Vault as the root |KMS|. 
You must modify this YAML to reflect your deployment environment.

.. code-block:: shell
   :class: copyable
   :substitutions:

   address: 0.0.0.0:7373

   # Disable the root administrator identity, as we do not need that level of access for
   # supporting SSE operations.
   admin: 
     identity: disabled

   # Specify the TLS keys generated in the previous step here
   # For production environments, use keys signed by a known and trusted Certificate Authority (CA).
   tls:
     key:  |kesconfigcertpath|kes-server.key
     cert: |kesconfigcertpath|kes-server.cert

     # Specify the path to CAs used by KES for validating client certificates
     # This can alternatively be a single CA
     # KES uses these CAs in addition to the system trust store for validating client certificates.

     ca: |kesconfigcertpath|CAs/

   # Sets access policies for KES
   # The `minio` policy grants access to the listed APIs.
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
       - MINIO_API_KEY_HASH # Replace with the hash output returned from kes identity new 

   # Specify the connection information for the Vault server.
   # The endpoint should be resolvable from the host.
   # This example assumes that Vault is configured with an AppRole ID and
   # Secret for use with KES.
   keystore:
     vault:
       endpoint: https://HOSTNAME:8200
       engine: "/path/to/engine" # Replace with the path to the K/V Engine
       version: "v1|v2" # Specify v1 or v2 depending on the version of the K/V Engine
       approle:
         id: "VAULTAPPID"     # HashiCorp Vault AppRole ID
         secret: "VAULTAPPSECRET" # HashiCorp Vault AppRole Secret ID
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

This procedure assumes an existing `HashiCorp Vault <https://www.vaultproject.io/>`__ installation accessible from the local host.
The Vault `Quick Start <https://learn.hashicorp.com/tutorials/vault/getting-started-install>`__ provides a sufficient foundation for the purposes of this procedure.
Defer to the `Vault Documentation <https://learn.hashicorp.com/vault>`__ for guidance on deployment and configuration.

.. admonition:: KES Operations Require Unsealed Vault
   :class: important

   You must unseal the Vault instance to allow any cryptographic operations, including key creation and retrieval.
   KES returns an error if the configured Vault service is sealed.

   If you restart or otherwise seal the Vault instance, KES cannot perform any cryptographic operations against the Vault.
   You must unseal the Vault to ensure normal operations.

   See the Vault documentation on `Seal/Unseal <https://www.vaultproject.io/docs/concepts/seal>`__ for more information.

.. end-kes-prereq-hashicorp-vault-desc

.. start-kes-vault-seal-unseal-desc

.. admonition:: KES Operations Requires Unsealed Vault
   :class: important

   You must unseal the Vault instance to allow normal cryptographic operations, including key creation or retrieval.
   See the Vault documentation on `Seal/Unseal <https://www.vaultproject.io/docs/concepts/seal>`__ for more information.

.. end-kes-vault-seal-unseal-desc
