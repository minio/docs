.. _minio-tls:

========================
Network Encryption (TLS)
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports Transport Layer Security (TLS) 1.2+ encryption of incoming and outgoing traffic. 

.. admonition:: SSL is Deprecated
   :class: note

   TLS is the successor to Secure Socket Layer (SSL) encryption.
   SSL is fully `deprecated <https://tools.ietf.org/html/rfc7568>`__ as of June 30th, 2018.

.. _minio-tls-user-generated:

Enabling TLS
------------

.. cond:: not k8s

   The sections below describe how to enable TLS for MinIO.
   You may use TLS certificates from a well-known Certificate Authority, an internal or private CA, or self-signed certs.

   Before beginning, note these important points:

   - Configure TLS on each node.
   - Ensure certs are readable by the user who runs the MinIO Server process.
   - Update :envvar:`MINIO_VOLUMES` and any needed services or apps to use an ``HTTPS`` URL.

.. cond:: k8s

   For Kubernetes clusters with a valid :ref:`TLS Cluster Signing Certificate <minio-k8s-deploy-operator-tls>`,
   the MinIO Kubernetes Operator can automatically generate TLS certificates while :ref:`deploying <minio-k8s-deploy-minio-tenant-security>` or :ref:`modifying <minio-k8s-modify-minio-tenant-security>` a MinIO Tenant. 
   The TLS certificate generation process is as follows:

   - The Operator generates a Certificate Signing Request (CSR) associated to the Tenant.
     The :abbr:`CSR (Certificate Signing Request)` includes the appropriate DNS Subject Alternate Names (SANs) for the Tenant services and pods.

     The Operator then waits for :abbr:`CSR (Certificate Signing Request)` approval

   - The :abbr:`CSR (Certificate Signing Request)` waits pending approval.
     The Kubernetes TLS API can automatically approve the :abbr:`CSR (Certificate Signing Request)` if properly configured.
     Otherwise, a cluster administrator must manually approve the :abbr:`CSR (Certificate Signing Request)` before Kubernetes can generate the necessary certificates.

   - The Operator applies the generated TLS Certificates to each MinIO Pod in the Tenant.

   The Kubernetes TLS API uses the Kubernetes cluster Certificate Authority (CA) signature algorithm when generating new TLS certificates.
   See :ref:`minio-TLS-supported-cipher-suites` for a complete list of MinIO's supported TLS Cipher Suites and recommended signature algorithms.

   By default, Kubernetes places a certificate bundle on each pod at ``/var/run/secrets/kubernetes.io/serviceaccount/ca.crt``.
   This CA bundle should include the cluster or root CA used to sign the MinIO Tenant TLS certificates.
   Other applications deployed within the Kubernetes cluster can trust this cluster certificate to connect to a MinIO Tenant using the :kube-docs:`MinIO service DNS name <concepts/services-networking/dns-pod-service/>` (e.g. ``https://minio.minio-tenant-1.svc.cluster-domain.example:443``).

   .. admonition:: Subject Alternative Name Certificates
      :class: note

      If you have a custom Subject Alternative Name (SAN) certificate that is *not* also a wildcard cert, the TLS certificate SAN **must** apply to the hostname for its parent node.
      Without a wildcard, the SAN must match exactly to be able to connect to the tenant.


.. cond:: linux

   The MinIO Server searches for TLS keys and certificates for each node and uses those credentials for enabling TLS. 
   The search location depends on your MinIO configuration:

   .. tab-set::

      .. tab-item:: Default Path

         By default, the MinIO server looks for the TLS keys and certificates for each node in the following directory:

         .. code-block:: shell

            ${HOME}/.minio/certs

         Where ``${HOME}`` is the home directory of the user running the MinIO Server process.
         You may need to create the ``${HOME}/.minio/certs`` directory if it does not exist.

         For ``systemd`` managed deployments this must correspond to the ``USER`` running the MinIO process.
         If that user has no home directory, use the :guilabel:`Custom Path` option instead.

      .. tab-item:: Custom Path

         You can specify a path for the MinIO server to search for certificates using the :mc-cmd:`minio server --certs-dir` or ``-c`` parameter.

         For example, the following command fragment directs the MinIO process to use the ``/opt/minio/certs`` directory for TLS certificates.

         .. code-block:: shell

            minio server --certs-dir /opt/minio/certs ...

         The user running the MinIO service *must* have read and write permissions to this directory.

   Place the TLS certificates for the default domain (e.g. ``minio.example.net``) in the ``/certs`` directory, with the private key as ``private.key`` and public certificate as ``public.crt``.

   For example:

   .. code-block:: shell

      /path/to/certs
        private.key
        public.crt

   You can use the MinIO :minio-git:`certgen <certgen>` to mint self-signed certificates for evaluating MinIO with TLS enabled.
   For example, the following command generates a self-signed certificate with a set of IP and DNS Subject Alternate Names (SANs) associated to the MinIO Server hosts:

   .. code-block:: shell

      certgen -host "localhost,minio-*.example.net"

   Place the generated ``public.crt`` and ``private.key`` into the ``/path/to/certs`` directory to enable TLS for the MinIO deployment.
   Applications can use the ``public.crt`` as a trusted Certificate Authority to allow connections to the MinIO deployment without disabling certificate validation.

   If you are reconfiguring an existing deployment that did not previously have TLS enabled, update :envvar:`MINIO_VOLUMES` to specify ``https`` instead of ``http``.
   You may also need to update URLs used by applications or clients.

.. cond:: container

   Start the MinIO container with the :mc-cmd:`minio/minio:latest server --certs-dir <minio server --certs-dir>` parameter and specify the path to a directory in which MinIO searches for certificates.
   You must mount a local host volume to that path when starting the container to ensure the MinIO Server can access the necessary certificates.

   Place the TLS certificates for the default domain (e.g. ``minio.example.net``) in the specified directory, with the private key as ``private.key`` and public certificate as ``public.crt``.
   For example:

   .. code-block:: shell

      /opts/certs
        private.key
        public.crt

   You can use the MinIO :minio-git:`certgen <certgen>` to mint self-signed certificates for evaluating MinIO with TLS enabled.
   For example, the following command generates a self-signed certificate with a set of IP and DNS SANs associated to the MinIO Server hosts:

   .. code-block:: shell

      certgen -host "localhost,minio-*.example.net"

   You may need to start the container and set a ``--hostname`` that matches the TLS certificate DNS SAN.

   Move the certificates to the local host machine path that the container mounts to its ``--certs-dir`` path.
   When the MinIO container starts, the server searches the specified location for certificates and uses them to enable TLS.
   Applications can use the ``public.crt`` as a trusted Certificate Authority to allow connections to the MinIO deployment without disabling certificate validation.

   If you are reconfiguring an existing deployment that did not previously have TLS enabled, update :envvar:`MINIO_VOLUMES` to specify ``https`` instead of ``http``.
   You may also need to update URLs used by applications or clients.


.. cond:: macos

   The MinIO server searches the following directory for TLS keys and certificates:

   .. code-block:: shell

      ${HOME}/.minio/certs

   For deployments started with a custom TLS directory :mc-cmd:`minio server --certs-dir`, use that directory instead of the defaults.

   Place the TLS certificates for the default domain (e.g. ``minio.example.net``) in the ``/certs`` directory, with the private key as ``private.key`` and public certificate as ``public.crt``.

   For example:

   .. code-block:: shell

      ${HOME}/.minio/certs
        private.key
        public.crt

   Where ``${HOME}`` is the home directory of the user running the MinIO Server process.
   You may need to create the ``${HOME}/.minio/certs`` directory if it does not exist.

   You can use the MinIO :minio-git:`certgen <certgen>` to mint self-signed certificates for evaluating MinIO with TLS enabled.
   For example, the following command generates a self-signed certificate with a set of IP and DNS SANs associated to the MinIO Server hosts:

   .. code-block:: shell

      certgen -host "localhost,minio-*.example.net"

   Place the generated ``public.crt`` and ``private.key`` into the ``/.minio/certs`` directory to enable TLS for the MinIO deployment.
   Applications can use the ``public.crt`` as a trusted Certificate Authority to allow connections to the MinIO deployment without disabling certificate validation.

   If you are reconfiguring an existing deployment that did not previously have TLS enabled, update :envvar:`MINIO_VOLUMES` to specify ``https`` instead of ``http``.
   You may also need to update URLs used by applications or clients.


.. cond:: windows

   The MinIO server searches the following directory for TLS keys and certificates:

   .. code-block:: shell

      %%USERPROFILE%%\.minio\certs

   For deployments started with a custom TLS directory :mc-cmd:`minio server --certs-dir`, use that directory instead of the defaults.

   Place the TLS certificates for the default domain (e.g. ``minio.example.net``) in the ``/certs`` directory, with the private key as ``private.key`` and public certificate as ``public.crt``.

   For example:

   .. code-block:: shell

      %%USERPROFILE%%\.minio\certs
        private.key
        public.crt

   Where ``%%USERPROFILE%%`` is the location of the `User Profile folder <https://docs.microsoft.com/en-us/windows/deployment/usmt/usmt-recognized-environment-variables>`__ of the user running the MinIO Server process.

   You can use the MinIO :minio-git:`certgen <certgen>` to mint self-signed certificates for evaluating MinIO with TLS enabled.
   For example, the following command generates a self-signed certificate with a set of IP and DNS SANs associated to the MinIO Server hosts:

   .. code-block:: shell

      certgen.exe -host "localhost,minio-*.example.net"

   Place the generated ``public.crt`` and ``private.key`` into the ``\.minio\certs`` directory to enable TLS for the MinIO deployment.
   Applications can use the ``public.crt`` as a trusted Certificate Authority to allow connections to the MinIO deployment without disabling certificate validation.

   If you are reconfiguring an existing deployment that did not previously have TLS enabled, update :envvar:`MINIO_VOLUMES` to specify ``https`` instead of ``http``.
   You may also need to update URLs used by applications or clients.


Multiple Domain-Based TLS Certificates
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. cond:: k8s

   The MinIO Operator supports attaching user-specified TLS certificates when :ref:`deploying <minio-k8s-deploy-minio-tenant-security>` or :ref:`modifying <minio-k8s-modify-minio-tenant-security>` the MinIO Tenant.

   These custom certificates support `Server Name Indication (SNI) <https://en.wikipedia.org/wiki/Server_Name_Indication>`__, where the MinIO server identifies which certificate to use based on the hostname specified by the connecting client.
   For example, you can generate certificates signed by your organization's preferred Certificate Authority (CA) and attach those to the MinIO Tenant.
   Applications which trust that :abbr:`CA (Certificate Authority)` can connect to the MinIO Tenant and fully validate the Tenant TLS certificates.

.. cond:: linux

   The MinIO server supports multiple TLS certificates, where the server uses `Server Name Indication (SNI) <https://en.wikipedia.org/wiki/Server_Name_Indication>`__ to identify which certificate to use when responding to a client request.
   When a client connects using a specific hostname, MinIO uses :abbr:`SNI (Server Name Indication)` to select the appropriate TLS certificate for that hostname.

   For example, consider a MinIO deployment reachable through the following hostnames:

   - ``https://minio.example.net`` (default TLS certificates)
   - ``https://s3.example.net``
   - ``https://minio.internal-example.net``


   Place the certificates in the ``/certs`` folder, creating a subfolder in ``/certs`` for each additional domain for which MinIO should present TLS certificates.
   While MinIO has no requirements for folder names, consider creating subfolders whose name matches the domain to improve human readability. 
   Place the TLS private and public key for that domain in the subfolder.
 
   The root path for this folder depends on whether you use the default certificate path *or* a custom certificate path (:mc-cmd:`minio server --certs-dir` or ``-S``).

   .. tab-set::

      .. tab-item:: Default Certificate Path

         .. code-block:: shell

            ${HOME}/.minio/certs
            private.key
            public.crt
            s3-example.net/
               private.key
               public.crt
            internal-example.net/
               private.key
               public.crt

      .. tab-item:: Custom Certificate Path

         The following example assumes the MinIO Server was started with ``--certs dir | -S /opt/minio/certs``:

         .. code-block:: shell

            /opt/minio/certs
            private.key
            public.crt
            s3-example.net/
               private.key
               public.crt
            internal-example.net/
               private.key
               public.crt

   While you can have a single TLS certificate that covers all hostnames with multiple Subject Alternative Names (SANs), this would reveal the ``internal-example.net`` and ``s3-example.net`` hostnames to any client which inspects the server certificate.
   Using a TLS certificate per hostname better protects each individual hostname from discovery.
   The individual TLS certificate SANs **must** apply to the hostname for their respective parent node.

   If the client-specified hostname or IP address does not match any of the configured TLS certificates, the connection typically fails with a certificate validation error.


.. cond:: container

   The MinIO server supports multiple TLS certificates, where the server uses `Server Name Indication (SNI) <https://en.wikipedia.org/wiki/Server_Name_Indication>`__ to identify which certificate to use when responding to a client request.
   When a client connects using a specific hostname, MinIO uses :abbr:`SNI (Server Name Indication)` to select the appropriate TLS certificate for that hostname.

   For example, consider a MinIO deployment reachable through the following hostnames:

   - ``https://minio.example.net`` (default TLS certificates)
   - ``https://s3.example.net``
   - ``https://minio.internal-example.net``

   Start the MinIO container with the :mc-cmd:`minio/minio:latest server --certs-dir <minio server --certs-dir>` parameter and specify the path to a directory in which MinIO searches for certificates.
   You must mount a local host volume to that path when starting the container to ensure the MinIO Server can access the necessary certificates.

   Place the TLS certificates for the default domain (e.g. ``minio.example.net``) in the specified directory, with the private key as ``private.key`` and public certificate as ``public.crt``.
   For other hostnames, create a subfolder whose name matches the domain to improve human readability. 
   Place the TLS private and public key for that domain in the subfolder.

   For example:

   .. code-block:: shell

      /opts/certs
        private.key
        public.crt
        s3-example.net/
          private.key
          public.crt
        internal-example.net/
          private.key
          public.crt

   When the MinIO container starts, the server searches the mounted location ``/opts/certs`` for certificates and  uses them enable TLS.
   MinIO serves clients connecting to the container using a supported hostname with the associated certificates.
   Applications can use the ``public.crt`` as a trusted Certificate Authority to allow connections to the MinIO deployment without disabling certificate validation.

   While you can have a single TLS certificate that covers all hostnames with multiple Subject Alternative Names (SANs), this would reveal the ``internal-example.net`` and ``s3-example.net`` hostnames to any client which inspects the server certificate.
   Using one TLS certificate per hostname better protects each individual hostname from discovery.
   The individual TLS certificate SANs **must** apply to the hostname for their respective parent node.

   If the client-specified hostname or IP address does not match any of the configured TLS certificates, the connection typically fails with a certificate validation error.

.. cond:: macos

   The MinIO server supports multiple TLS certificates, where the server uses `Server Name Indication (SNI) <https://en.wikipedia.org/wiki/Server_Name_Indication>`__ to identify which certificate to use when responding to a client request.
   When a client connects using a specific hostname, MinIO uses SNI to select the appropriate TLS certificate for that hostname.

   For example, consider a MinIO deployment reachable through the following hostnames:

   - ``https://minio.example.net`` (default TLS certificates)
   - ``https://s3.example.net``
   - ``https://minio.internal-example.net``

   Create a subfolder in ``/certs`` for each additional domain for which MinIO should present TLS certificates. 
   While MinIO has no requirements for folder names, consider creating subfolders whose name matches the domain to improve human readability. 
   Place the TLS private and public key for that domain in the subfolder.

   For example:

   .. code-block:: shell

      ${HOME}/.minio/certs
        private.key
        public.crt
        s3-example.net/
          private.key
          public.crt
        internal-example.net/
          private.key
          public.crt

   While you can have a single TLS certificate that covers all hostnames with multiple Subject Alternative Names (SANs), this would reveal the ``internal-example.net`` and ``s3-example.net`` hostnames to any client which inspects the server certificate.
   Using a TLS certificate per hostname better protects each individual hostname from discovery.
   The individual TLS certificate SANs **must** apply to the hostname for their respective parent node.

   If the client-specified hostname or IP address does not match any of the configured TLS certificates, the connection typically fails with a certificate validation error.

.. cond:: windows

   The MinIO server supports multiple TLS certificates, where the server uses `Server Name Indication (SNI) <https://en.wikipedia.org/wiki/Server_Name_Indication>`__ to identify which certificate to use when responding to a client request.
   When a client connects using a specific hostname, MinIO uses SNI to select the appropriate TLS certificate for that hostname.

   For example, consider a MinIO deployment reachable through the following hostnames:

   - ``https://minio.example.net`` (default TLS certificates)
   - ``https://s3.example.net``
   - ``https://minio.internal-example.net``

   Create a subfolder in ``/certs`` for each additional domain for which MinIO should present TLS certificates. 
   While MinIO has no requirements for folder names, consider creating subfolders whose name matches the domain to improve human readability. 
   Place the TLS private and public key for that domain in the subfolder.

   For example:

   .. code-block:: shell

      %%USERPROFILE%%\.minio\certs
        private.key
        public.crt
        s3-example.net\
          private.key
          public.crt
        internal-example.net\
          private.key
          public.crt

   While you can have a single TLS certificate that covers all hostnames with multiple Subject Alternative Names (SANs), this would reveal the ``internal-example.net`` and ``s3-example.net`` hostnames to any client which inspects the server certificate.
   Using a TLS certificate per hostname better protects each individual hostname from discovery.
   The individual TLS certificate SANs **must** apply to the hostname for their respective parent node.

   If the client-specified hostname or IP address does not match any of the configured TLS certificates, the connection typically fails with a certificate validation error.

.. _minio-TLS-supported-cipher-suites:

Supported TLS Cipher Suites
~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO recommends generating ECDSA (e.g. `NIST P-256 curve <https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-4.pdf>`__) or EdDSA (e.g. :rfc:`Curve25519 <7748>`) TLS private keys/certificates due to their lower computation requirements compared to RSA.

MinIO supports the following TLS 1.2 and 1.3 cipher suites as supported by `Go <https://cs.opensource.google/go/go/+/refs/tags/go1.17.1:src/crypto/tls/cipher_suites.go;l=52>`__. The lists mark recommended algorithms with a :octicon:`star-fill` icon:

.. tab-set::

   .. tab-item:: TLS 1.3

      - ``TLS_CHACHA20_POLY1305_SHA256`` :octicon:`star-fill`
      - ``TLS_AES_128_GCM_SHA256``
      - ``TLS_AES_256_GCM_SHA384``

   .. tab-item:: TLS 1.2

      - ``TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305`` :octicon:`star-fill`
      - ``TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`` :octicon:`star-fill`
      - ``TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384`` :octicon:`star-fill`
      - ``TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305``
      - ``TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256``
      - ``TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384``

.. _minio-TLS-third-party-ca:

Third-Party Certificate Authorities
-----------------------------------

.. cond:: k8s

   The MinIO Kubernetes Operator can automatically attach third-party Certificate Authorities when :ref:`deploying <minio-k8s-deploy-minio-tenant-security>` or :ref:`modifying <minio-k8s-modify-minio-tenant-security>` a MinIO Tenant.

   You can add, update, or remove CAs from the tenant at any time.
   You must restart the MinIO Tenant for the changes to the configured CAs to apply.

   The Operator places the specified CAs on each MinIO Server pod such that all pods have a consistent set of trusted CAs. 

   If the MinIO Server cannot match an incoming client's TLS certificate issuer against any of the available CAs, the server rejects the connection as invalid.

.. cond:: linux

   The MinIO Server validates the TLS certificate presented by each connecting client against the host system's trusted root certificate store.

   Place the CA certificates in the ``/certs/CAs`` folder.
   The root path for this folder depends on whether you use the default certificate path *or* a custom certificate path (:mc-cmd:`minio server --certs dir` or ``--S``)

   .. tab-set::

      .. tab-item:: Default Certificate Path

         .. code-block:: shell

            mv myCA.crt ${HOME}/certs/CAs

      .. tab-item:: Custom Certificate Path

         The following example assumes the MinIO Server was started with ``--certs dir | --S/opt/minio/certs``:

         .. code-block:: shell

            mv myCA.crt /opt/minio/certs/CAs/

   Place the certificate file for each CA into the ``/CAs`` subdirectory.
   Ensure all hosts in the MinIO deployment have a consistent set of trusted CAs in that directory.
   If the MinIO Server cannot match an incoming client's TLS certificate issuer against any of the available CAs, the server rejects the connection as invalid.

.. cond:: container

   Start the MinIO container with the :mc-cmd:`minio/minio:latest server --certs-dir <minio server --certs-dir>` parameter and specify the path to a directory in which MinIO searches for certificates.
   You must mount a local host volume to that path when starting the container to ensure the MinIO Server can access the necessary certificates.

   For deployments started with a custom TLS directory :mc-cmd:`minio server --certs-dir`, the server searches in the ``/CAs`` path at that specified directory.
   For example:

   .. code-block:: shell

      /opts/certs
        private.key
        public.crt
        /CAs
          my-ca.crt

   Place the certificate file for each CA into the ``/CAs`` subdirectory.
   Ensure all hosts in the MinIO deployment have a consistent set of trusted CAs in that directory.
   If the MinIO Server cannot match an incoming client's TLS certificate issuer against any of the available CAs, the server rejects the connection as invalid.

.. cond:: macos

   The MinIO Server validates the TLS certificate presented by each connecting client against the host system's trusted root certificate store.

   You can place additional trusted Certificate Authority files in the following directory:

   .. code-block:: shell

      ${HOME}/.minio/certs/CAs

   Where ``${HOME}`` is the home directory of the user running the MinIO Server process.
   You may need to create the ``${HOME}/.minio/certs`` directory if it does not exist.

   For deployments started with a custom TLS directory :mc-cmd:`minio server --certs-dir`, the server searches in the ``/certs/CAs`` path at that specified directory.

   Place the certificate file for each CA into the ``/CAs`` subdirectory.
   Ensure all hosts in the MinIO deployment have a consistent set of trusted CAs in that directory.
   If the MinIO Server cannot match an incoming client's TLS certificate issuer against any of the available CAs, the server rejects the connection as invalid.

.. cond:: windows

   The MinIO Server validates the TLS certificate presented by each connecting client against the host system's trusted root certificate store.

   You can place additional trusted Certificate Authority files in the following directory:

   .. code-block:: shell

      %%USERPROFILE%%\.minio\certs\CAs

   Where ``%%USERPROFILE%%`` is the location of the `User Profile folder <https://docs.microsoft.com/en-us/windows/deployment/usmt/usmt-recognized-environment-variables>`__ of the user running the MinIO Server process.

   For deployments started with a custom TLS directory :mc-cmd:`minio server --certs-dir`, the server searches in the ``\CAs`` path at that specified directory.

   Place the certificate file for each CA into the ``/CAs`` subdirectory.
   Ensure all hosts in the MinIO deployment have a consistent set of trusted CAs in that directory.
   If the MinIO Server cannot match an incoming client's TLS certificate issuer against any of the available CAs, the server rejects the connection as invalid.

Self-signed, Internal, Private Certificates, and Public CAs with Intermediate Certificates
------------------------------------------------------------------------------------------

.. cond:: not k8s

   If using Certificates signed by a non-global or non-public Certificate Authority, *or* if using a global CA that requires the use of intermediate certificates, you must provide those CAs to the MinIO Server.
   If the MinIO server does not have the necessary CAs, it may return warnings or errors related to TLS validation when connecting to other services.

   Place the CA certificates in the ``/certs/CAs`` folder.
   The root path for this folder depends on whether you use the default certificate path *or* a custom certificate path (:mc-cmd:`minio server --certs dir` or ``--c``)

   .. tab-set::

      .. tab-item:: Default Certificate Path

         .. code-block:: shell

            mv myCA.crt ${HOME}/certs/CAs

      .. tab-item:: Custom Certificate Path

         The following example assumes the MinIO Server was started with ``--certs dir | --S/opt/minio/certs``:

         .. code-block:: shell

            mv myCA.crt /opt/minio/certs/CAs/

   For a self-signed certificate, the Certificate Authority is typically the private key used to sign the cert.

   For certificates signed by an internal, private, or other non-global Certificate Authority, use the same CA that signed the cert.
   A non-global CA must include the full chain of trust from the intermediate certificate to the root.

   If the provided file is not an X.509 certificate, MinIO ignores it and may return errors for validating certificates signed by that CA.

.. cond:: k8s

   If deploying MinIO Tenants with certificates minted by a non-global or non-public Certificate Authority, *or* if using a global CA that requires the use of intermediate certificates, you must provide those CAs to the Operator to ensure it can trust those certificates.

   The Operator may log warnings related to TLS cert validation for Tenants deployed with untrusted certificates.

   The following procedure attaches a secret containing the ``public.crt`` of the Certificate Authority to the MinIO Operator.
   You can specify multiple CAs in a single certificate, as long as you maintain the ``BEGIN`` and ``END`` delimiters as-is.

   1. Create the ``operator-ca-tls`` secret

      The following creates a Kubernetes secret in the MinIO Operator namespace (``minio-operator``).

      .. code-block:: shell
         :class: copyable

         kubectl create secret generic operator-ca-tls \
            --from-file=public.crt -n minio-operator

      The ``public.crt`` file must correspond to a valid TLS certificate containing one or more CA definitions.

   2. Restart the Operator

      Once created, you must restart the Operator to load the new CAs:

      .. code-block:: shell
         :class: copyable

         kubectl rollout restart deployments.apps/minio-operator -n minio-operator



   
