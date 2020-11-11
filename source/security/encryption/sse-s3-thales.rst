==============================================
Server-Side Encryption with Thales CipherTrust
==============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

The MinIO Key Encryption Service (KES) supports using `Thales CipherTrust
<https://cpl.thalesgroup.com/encryption/ciphertrust-manager>`__ (formerly
Gemalto KeySecure) as an external Key Management Service (KMS). MinIO can
therefore use CipherTrust for storing Secret keys associated with 
Server-Side Encryption (SSE-S3).

This procedure documents

- Configuring Thales CipherTrust for KES connectivity.

- Configuring KES for Thales CipherTrust KMS.

- Configuring MinIO for SSE-S3.

<Diagram to Follow>

This procedure requires familiarity with Thales CipherTrust deployment and
configuration. Any references made to CipherTrust configuration is made on
a best-effort basis and is not intended as a replacement for the official
CipherTrust documentation or best practices.

Prerequisites
-------------

Thales CipherTrust / Gemalto KeySecure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure assumes a running CipherTrust Manager or KeySecure instance
with network access to the KES server. The procedure has been tested against the
following versions:

- CipherTrust Manager ``k170v`` version ``2.0.0``
- Gemalto KeySecure ``k170v`` version ``1.9.1`` and version ``1.10.0``

This procedure also requires the ``ksctl`` command line tool configured
for access to the CipherTrust Manager or Gemalto KeySecure instance. 
Ensure the ``ksctl`` ``config.yaml`` contains at minimum the following
fields:

.. code-block:: yaml
   :class: copyable

   KSCTL_URL: <CipherTrust/KeySecure Endpoint>
   KSCTL_USERNAME: <username>
   KSCTL_PASSWORD: <password>
   KSCTL_VERBOSITY: false
   KSCTL_RESP: json
   KSCTL_NOSSLVERIFY: true
   KSCTL_TIMEOUT: 30

The specified ``KSCTL_USERNAME`` must correspond to a user on the 
CipherTrust/KeySecure deployment with administrative privileges to
perform the following commands:

- Group creation (``ksctl groups create``)
- User creation (``ksctl users create``)
- Group management (``ksctl groups adduser``)
- Policy management (``ksctl policy create`` and ``ksctl polattach create``)
- Token management (``ksctl tokens create``)

For CipherTrust/KeySecure deployments configured using a TLS x.509 certificate
issued by a trusted Certificate Authority, you can set 
``KSCTL_NOSSLVERIFY: false``. The KES server includes a configuration
setting :kesconf:`keys.gemalto.keysecure.tls.ca` for specifying the CA
used by the CipherTrust/KeySecure. 

MinIO Key Encryption Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The KES server *must* have network access to:

- The CipherTrust/KeySecure deployment, *and*
- All :mc:`minio` servers in the MinIO deployment.

KES uses mutual TLS for authentication and authorization and *requires* 
specifying an x.509 certificate and corresponding private key. For production
environments, MinIO strongly recommends using a globally trusted Certificate
Authority for issuing the KES TLS certificate.

If using an internally trusted Certificate Authority, consider adding the
CA to the system trust store of the :mc:`minio` server hosts and the
CipherTrust/KeySecure deployment to allow for complete validation of the
KES certificates.

For self-signed certificates *or* certificates issued by a CA which cannot be
added to other hosts, you may need to disable TLS validation on the
:mc:`minio` and CipherTrust/KeySecure deployments to allow for
successful connectivity.

MinIO Server
~~~~~~~~~~~~

The MinIO server *must* have network access to the KES server. 

KES uses mutual TLS (mTLS) for authentication and authorization and *requires* 
each :mc:`minio` server present an x.509 certificate and corresponding
private key. Specifically, each :mc:`minio` server *must* enable
:ref:`TLS connectivity <minio-TLS>`.  MinIO strongly recommends using a 
globally trusted Certificate Authority for issuing the MinIO TLS certificate.

If using an internally trusted Certificate Authority, consider adding the
CA to the system trust store of KES host to allow for complete validation of the
MinIO certificates.

For self-signed certificates *or* certificates issued by a CA which cannot be
added to other hosts, you may need to disable TLS validation on the KES
deployment to allow for successful connectivity.

Procedure
---------

1) Configure CipherTrust/KeySecure for KES Access
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This section assumes a running CipherTrust/KeySecure deployment accessible using
the ``ksctl`` utility.

a. Create a new group for KES
`````````````````````````````

.. container:: indent

   Issue the following ``ksctl`` command to create a new group for KES:

   .. code-block:: shell
      :class: copyable

      ksctl groups create --name KES-Service

b. Create a new user in the KES-Service group
`````````````````````````````````````````````

.. container:: indent

   *Optional:* 

   Issue the following ``ksctl`` command to create a new user for KES:

   .. code-block:: shell
      :class: copyable

      ksctl users create --name KESServiceUser --pword '<password>'

   Replace the ``<password>`` with a unique, long, and random string. Defer
   to industry best practices and/or your organization's specific password
   generation requirements.

   The command returns a JSON object containing a field ``user_id``. 
   The next step requires specifying this ID.

   You can skip this step if you already have an existing user
   which you want to assign to the ``KES-Service`` group. Use 
   
   ``ksctl users lists``
   
   to list users and their corresponding ID:

   ```local|8791ce13-2766-4948-a828-71bac67131c9``
   
c. Assign the user to the KES-Service group
```````````````````````````````````````````

.. container:: indent

   Issue the following ``ksctl`` command to assign the ``KESServiceUser`` to the
   ``KES-Service`` group:

   .. code-block:: shell
      :class: copyable

      ksctl groups adduser --name KES-Service --userid "<user_id>"

   Replace ``<user_id>`` with the ID of the user created in the previous step.
   If specifying an existing user, replace ``<user_id>`` with the ID of that 
   user.

d. Create a policy for the KES-Service group
````````````````````````````````````````````

.. container:: indent

   Create a ``kes-policy.json`` document with the following structure:

   .. code-block:: json
      :class: copyable

      {
         "allow": true,
         "name": "kes-policy",
         "actions": [
            "CreateKey",
            "ExportKey",
            "ReadKey",
            "DeleteKey"
         ],
         "resources": [
            "kylo:kylo:vault:secrets:*"
         ]
      }

   Issue the following ``ksctl`` command to create a new policy using the
   ``kes-policy.json`` document:

   .. code-block:: shell
      :class: copyable

      ksctl policy create --jsonfile kes-policy.json

   For more complete documentation on CipherTrust/KeySecure policies, 
   see `CipherTrust Manager Policies 
   <https://www.thalesdocs.com/ctp/cm/2.0/admin/policies/index.html>`__

e. Attach the policy to the KES-Service group
`````````````````````````````````````````````

.. container:: indent

   Create a ``kes-attachment.json`` policy with the following structure:

   .. code-block:: json
      :class: copyable
      
      {
         "cust" : {
            "groups" : ["KES-Service"]
         }
      }

   Issue the following ``ksctl`` command to attach the ``kes-policy`` policy to
   the ``KES-Service`` group.

   .. code-block:: shell
      :class: copyable

      ksctl polattach create -p kes-policy -g kes-attachment.json

f. Create a refresh token for KES
`````````````````````````````````

.. container:: indent

   Issue the following ``ksctl`` command to create a refresh token for KES
   to obtain short-lived authentication tokens:

   .. code-block:: shell
      :class: copyable

      ksctl tokens create \
        --user KESServiceUser --password '<password>' \
        --issue-rt | jq -r .refresh_token

   If you skipped step 
   :guilabel:`b. Create a new user in the KES-Service group`, replace
   ``KESServiceUser`` with the name of the user specified to step
   :guilabel:`c. Assign the user to the KES-Service group`. 

   The command outputs a refresh token similar to the following:

   .. code-block:: shell

      CEvk5cdHLG7si05LReIeDbXE3PKD082YdUFAnxX75md3jzV0BnyHyAmPPJiA0

   You will need this token when configuring KES.

2) Configure KES for CipherTrust/KeySecure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a. Prepare the TLS x.509 Certificates for KES
`````````````````````````````````````````````

.. container:: indent

   KES requires mutual TLS (mTLS) for performing authentication and
   authorization. Specifically, you must provide an x.509 Certificate and
   corresponding private key.

   - For local development and evaluation, you can use a self-signed
     certificate. See :ref:`minio-kes-getting-started` for
     instructions on creating self-signed certificates for KES.

   - For production environments, use a trusted Certificate Authority (CA) to
     generate the x.509 certificate.

     If using an internal CA, ensure the CipherTrust/KeySecure host includes
     that CA in the system trust store.

b. Create the root identity for KES
```````````````````````````````````

.. container:: indent

   KES requires specifying a :ref:`root <minio-kes-root>` identity on startup.
   
   - For local development and evaluation, you can use the
     :mc-cmd:`kes tool identity new` command to create a self-signed
     x.509 certificate and private key:

     .. code-block:: shell
        :class: copyable

        kes tool identity new --key=root.key --cert=root.cert root

   - For production environments, use a trusted Certificate Authority (CA) to
     generate the x.509 certificate. If using an internal CA, ensure the
     KES host includes that CA in the system trust store.

   Use the :mc:`kes tool identity of` command to compute the
   :ref:`identity <minio-kes-authorization>` of the certificate.

   .. code-block:: shell

      kes tool identity of root.cert

   The command outputs a SHA-256 hash. You must specify this value in a 
   later step.

c. Create the identity for the KES client
`````````````````````````````````````````

.. container:: indent

   The :mc:`kes` client supports interfacing with and performing operations 
   on a KES :mc:`~kes server`. The KES client *must* provide an
   x.509 certificate and corresponding private key to connect to the KES
   server.

   - For local development and evaluation, you can use the
     :mc-cmd:`kes tool identity new` command to create a self-signed
     x.509 certificate and private key:

     .. code-block:: shell
        :class: copyable

        kes tool identity new --key=kes-client.key --cert=kes-client.cert kes-client

   - For production environments, use a trusted Certificate Authority (CA) to
     generate the x.509 certificate.

     If using an internal CA, ensure the KES host includes
     that CA in the system trust store.

   Use the :mc:`kes tool identity of` command to compute the
   :ref:`identity <minio-kes-authorization>` of the certificate.

   .. code-block:: shell

      kes tool identity of kes-client.cert

   The command outputs a SHA-256 hash. You must specify this value in a 
   later step.

d. Create an identity for each MinIO server
```````````````````````````````````````````

.. container:: indent

   Each :mc:`minio` server which communicates with KES *must* provide an
   x.509 certificate and corresponding private key to connect to the KES
   server.

   - For local development and evaluation, you can use the
     :mc-cmd:`kes tool identity new` command to create a self-signed
     x.509 certificate and private key:

     .. code-block:: shell
        :class: copyable

        kes tool identity new --key=minio-server-1.key --cert=minio-server-1.cert minio-server-1

   - For production environments, use a trusted Certificate Authority (CA) to
     generate the x.509 certificate.

     If using an internal CA, ensure the KES host includes
     that CA in the system trust store.

   Use the :mc:`kes tool identity of` command to compute the
   :ref:`identity <minio-kes-authorization>` of the certificate.

   .. code-block:: shell

      kes tool identity of minio-server-1.cert

   The command outputs a SHA-256 hash. You must specify this value in a 
   later step.

d. Create the KES server configuration
``````````````````````````````````````

.. container:: indent

   The KES :mc:`~kes server` process uses a 
   :ref:`configuration file <minio-kes-config>` during startup. 
   The following example configuration file includes the minimum required
   fields for starting KES with CipherTrust/KeySecure. You can save this
   file as ``kes-config.yaml``. You *must* modify this file according to your
   deployment prior to using it to start KES.

   .. code-block:: yaml
      :class: copyable

      root: "<ROOT-IDENTITY>"

      tls:
         key: server.key
         cert: server.cert

      policy:
         my-app:
            paths:
               - /v1/key/create/my-app*
               - /v1/key/generate/my-app*
               - /v1/key/generate/my-app*
            identities:
            - "<KES-CLIENT-CERT>"
            - "<MINIO-KMS-CERT>"

      keys:
         gemalto:
            keysecure:
               endpoint: "https://ciphertrust.example.net"
               credentials:
                  token: "<REFRESH-TOKEN>"
                  domain: "<DOMAIN>"
                  retry: 15s
               tls:
                  ca: "ciphertrust-ca.cert"

   - Replace the ``<ROOT-IDENTITY>`` with the hash of the certificate
     generated or selected as part of 
     :guilabel:`2.b. Create the root identity for KES`.

     You *may* disable root access by specifying ``"_"`` or 
     ``"disabled"`` for the root user. *However*, you must then include
     a :kesconf:`policy` which grants administrative access to specific 
     client x.509 :ref:`identities <minio-kes-authorization>`.

   - Replace ``<KES-CLIENT-CERT>`` with the hash of the certificate
     generated or selected as part of 
     :guilabel:`2.c. Create the identity for the KES client`.

   - Replace ``<MINIO-KMS-CERT>`` with the hash of the certificate
     generated or selected as part of 
     :guilabel:`2.d. Create an identity for each MinIO server`.

     For distributed clusters, you may need to specify multiple identities.

   - Replace ``<REFRESH-TOKEN>`` with the refresh token generated
     in :guilabel:`1.f. Create a refresh token for KES`.

   - Replace ``<DOMAIN>`` with the domain of the CipherTrust/KeySecure 
     deployment. Omit to default to "root".

   - Replace ``ciphertrust-ca.cert`` with the Certificate Authority (CA) used
     to sign the CipherTrust/KeySecure TLS certificates. Optional if the 
     CipherTrust/KeySecure certificate was signed by a globally trusted
     CA.

d. Start the KES server
```````````````````````

.. container:: indent

   Start the KES :mc:`~kes server` process using the configuration file:

   .. code-block:: shell
      :class: copyable

      kes server --config=kes-config.yaml

   If using self-signed certificates for the :kesconf:`root` identity
   *or* for any application :kesconf:`identity <policy.policyname.identities>`,
   you *must* specify :mc-cmd-option:`--auth=off <kes server auth>` to 
   disable TLS certificate validation.

e. Connect to the KES server and generate a Secret key
``````````````````````````````````````````````````````

.. container:: indent

   Set the following environment variables on a host machine with 
   access to the :mc:`kes server` process:

   .. code-block:: shell
      :class: copyable

      export KES_CLIENT_CERT=<KES-CLIENT-CERT>
      export KES_CLIENT_KEY=kes-client.key

   Replace ``<KES-CLIENT-CERT>`` with the hash of the certificate
   generated or selected as part of 
   :guilabel:`2.c. Create the identity for the KES client`.

   Issue the following command to create a new Secret key for use with
   enabling Server Side Encryption. KES stores the Secret key on the 
   CipherTrust/KeySecure server.

   .. code-block:: shell
      :class: copyable

      kes key create my-app-sse-key

   If using self-signed certificates, you must include the
   :mc-cmd-option:`~kes key create insecure` option.

3. Configure the MinIO Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a. Set the Environment Variables
````````````````````````````````

.. container:: indent

   Set the following environment variables on each :mc:`minio` server host:

   .. code-block:: shell

      export MINIO_KMS_KES_ENDPOINT="https://kes.example.net:7373"
      export MINIO_KMS_KES_KEY_FILE="minio-server-1.key"
      export MINIO_KMS_KES_CERT_FILE="minio-server-1.cert"
      export MINIO_KMS_KES_KEY_NAME="my-app-sse-key"

   - Set :envvar:`MINIO_KMS_KES_ENDPOINT` to the HTTP endpoint of the KES 
     server.

   - Set :envvar:`MINIO_KMS_KES_CERT_FILE` to the x.509 certificate 
     generated or selected as part of 
     :guilabel:`2.d. Create an identity for each MinIO server`.

   - Set :envvar:`MINIO_KMS_KES_KEY_FILE` to the private key 
     corresponding to the specified :envvar:`MINIO_KMS_KES_CERT_FILE`. 

   - Set :envvar:`MINIO_KMS_KES_KEY_NAME` to the name of the Secret key created 
     in :guilabel:`2.e. Connect to the KES server and generate a Secret key`.

b. Start or Restart the MinIO server
````````````````````````````````````

.. container:: indent

   Restart each :mc:`minio` server in the deployment to load the 
   KES environment variables.

   To test Server-Side Encryption, create an object on the MinIO deployment 
   using one of the following methods:

   - Use an :mc:`mc` command which supports SSE-S3 encryption:

     .. code-block:: shell
        :class: copyable

        mc cp --encrypt ~/Downloads/data.csv myminio/data/data.csv

   - Issue a request including the ``x-amz-server-side-encryption`` 
     header. 

   <TODO> - more detail
