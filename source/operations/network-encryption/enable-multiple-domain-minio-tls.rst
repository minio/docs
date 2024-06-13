====================================
Enable Multiple Domain TLS for MinIO
====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports Transport Layer Security (TLS) 1.2+ encryption of incoming and outgoing traffic.

.. tab-set::
   :class: parent

   .. tab-item:: Kubernetes
      :sync: k8s

      The MinIO Operator supports the following approaches to enabling TLS on a MinIO Tenant:

      - Automatic TLS provisioning using Kubernetes Cluster Signing Certificates
      - User-specified TLS using Kubernetes secrets
      - Certmanager-managed TLS certificates

      The MinIO Operator supports attaching user-specified TLS certificates when :ref:`deploying <minio-k8s-deploy-minio-tenant-security>` or :ref:`modifying <minio-k8s-modify-minio-tenant-security>` the MinIO Tenant.

      These custom certificates support `Server Name Indication (SNI) <https://en.wikipedia.org/wiki/Server_Name_Indication>`__, where the MinIO server identifies which certificate to use based on the hostname specified by the connecting client.
      For example, you can generate certificates signed by your organization's preferred Certificate Authority (CA) and attach those to the MinIO Tenant.
      Applications which trust that :abbr:`CA (Certificate Authority)` can connect to the MinIO Tenant and fully validate the Tenant TLS certificates.

   .. tab-item:: Baremetal
      :sync: baremetal

      MinIO automatically detects TLS certificates in the configured or default directory and starts with TLS enabled.

      The MinIO server supports multiple TLS certificates, where the server uses `Server Name Indication (SNI) <https://en.wikipedia.org/wiki/Server_Name_Indication>`__ to identify which certificate to use when responding to a client request.
      When a client connects using a specific hostname, MinIO uses :abbr:`SNI (Server Name Indication)` to select the appropriate TLS certificate for that hostname.

This procedure documents enabling TLS for multiple domains in MinIO.
For instructions on TLS for single domains, see TODO

Prerequisites
-------------

Access to MinIO Cluster
~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::
   :class: hidden

   .. tab-item:: Kubernetes
      :sync: k8s

      You must have access to the Kubernetes cluster, with administrative permissions associated to your ``kubectl`` configuration.
      
      This procedure assumes your permission sets extends sufficiently to support deployment or modification of MinIO-associated resources on the Kubernetes cluster, including but not limited to pods, statefulsets, replicasets, deployments, and secrets.

   .. tab-item:: Baremetal
      :sync: baremetal

      This procedure uses :mc:`mc` for performing operations on the MinIO cluster. 
      Install ``mc`` on a machine with network access to the cluster.
      See the ``mc`` :ref:`Installation Quickstart <mc-install>` for instructions on downloading and installing ``mc``.

      This procedure assumes a configured :mc:`alias <mc alias>` for the MinIO cluster. 

      This procedure also assumes SSH or similar shell-level access with administrative permissions to each MinIO host server.

TLS Certificates
~~~~~~~~~~~~~~~~

Provision the necessary TLS certificates with a :ref:`supported cipher suite <minio-TLS-supported-cipher-suites>` for use by MinIO.

.. tab-set::
   :class: hidden

   .. tab-item:: Kubernetes
      :sync: k8s

      See :ref:`minio-tls-kubernetes` for more complete guidance on the supported Tenant TLS configurations.

   .. tab-item:: Baremetal
      :sync: baremetal

      Provision certificate susing your preferred path, such as through your organizations internal Certificate Authority or by using a well-known global provider such as Digicert or Verisign.

      You can create self-signed certificates using ``openssl`` or the MinIO :minio-git:`certgen <certgen>` tool.

      For example, the following command generates a self-signed certificate with a set of IP and DNS Subject Alternate Names (SANs) associated to the MinIO Server hosts:

      .. code-block:: shell

         certgen -host "localhost,minio-*.example.net"

      See :ref:`minio-tls-baremetal` for more complete guidance on certificate generation and placement.

Procedure
---------

.. tab-set::
   :class: hidden

   .. tab-item:: Kubernetes
      :sync: k8s

      The MinIO Operator supports three methods of TLS certificate management on MinIO Tenants:

      - MinIO automatic TLS certificate generation
      - User-specified TLS certificates
      - ``cert-manager`` managed TLS certificates

      You can also deploy MinIO Tenants without TLS enabled.

      .. tab-set::

         .. tab-item:: MinIO Auto-TLS

            The following steps apply to both new and existing MinIO Deployments using ``Kustomize``:

            1. Review the :ref:`Tenant CRD <minio-operator-crd>` ``TenantSpec.requestAutoCert`` and ``TenantSpec.certConfig`` fields.

               For existing MinIO Tenants, review the Kustomize resources used to create the Tenant and introspect those fields and their current configuration, if any.

            2. Create or Modify your Tenant YAML to set the values of ``requestAutoCert`` and ``certConfig`` as necessary.
               For example:

               .. code-block:: yaml

                  spec:
                     requestAutoCert: true
                     certConfig:
                       commonName: "CN=MinioTenantCommonName"
                       organizationName: "O=MyOrganizationName"
                       dnsNames:
                         - 'minio-tenant.domain.tld'
                         - '*.kubernete.cluster.dns.path.tld'

               The ``spec.certConfig.dnsNames`` should contain a list of :abbr:`SAN (Subject Alternate Names)` the TLS certificate covers.

               See the :minio-git:`Kustomize Tenant base YAML <operator/blob/master/examples/kustomization/base/tenant.yaml>` for a baseline template for guidance in creating or modifying your Tenant resource.

            3. Apply the new Kustomization template

               Once you apply the changes, the MinIO Operator automatically redeploys the Tenant with the updated configuration.

         .. tab-item:: CertManager

            The following steps apply to both new and existing MinIO Deployments using ``Kustomize``:

            1. Review the :ref:`Tenant CRD <minio-operator-crd>` ``TenantSpec.externalCertsCecret`` fields

               For existing MinIO Tenants, review the Kustomize resources used to create the Tenant and introspect that field's current configuration, if any.

            2. Create or Modify your Tenant YAML to reference the appropriate ``cert-manager`` resources.

               For example, the following Tenant YAML fragment references a cert-manager resource ``myminio-tls``:

               .. code-block:: yaml

                        apiVersion: minio.min.io/v2
                        kind: Tenant
                        metadata:
                        name: myminio
                        namespace: minio-tenant
                        spec:
                           ## Disable default tls certificates.
                           requestAutoCert: false
                           ## Use certificates generated by cert-manager.
                           externalCertSecret:
                              - name: default-domain
                                type: cert-manager.io/v1
                              - name: internal-domain
                                type: cert-manager.io/v1
                              - name: external-domain
                                type: cert-manager.io/v1

            3. Apply the new Kustomization Template

               Once you apply the changes, the MinIO Operator automatically redeploys the Tenant with the updated configuration.


         .. tab-item:: User-Specified

            The following steps apply to both new and existing MinIO deployments using ``Kustomize``:

            1. Review the :ref:`Tenant CRD <minio-operator-crd>` ``TenantSpec.externalCertSecret`` field.

               For existing MinIO Tenants, review the Kustomize resources used to create the Tenant and introspect that field's current configuration, if any.

            2. Create or modify your Tenant YAML to reference a secret of type ``kubernetes.io/tls``:

               For example, the following Tenant YAML fragment references two TLS secrets for each domain for which the MinIO Tenant accepts connections:

               .. code-block:: yaml

                  apiVersion: minio.min.io/v2
                  kind: Tenant
                  metadata:
                  name: myminio
                  namespace: minio-tenant
                  spec:
                     ## Disable default tls certificates.
                     requestAutoCert: false
                     ## Use certificates generated by cert-manager.
                     externalCertSecret:
                     - name: domain-certificate-1
                     type: kubernetes.io/tls
                     - name: domain-certificate-2
                     type: kubernetes.io/tls

            3. Apply the new Kustomization Template

               Once you apply the changes, the MinIO Operator automatically redeploys the Tenant with the updated configuration.

   .. tab-item:: Baremetal
      :sync: baremetal

      The MinIO Server searches for TLS keys and certificates for each node and uses those credentials for enabling TLS.
      MinIO automatically enables TLS upon discovery and validation of certificates.
      The search location depends on your MinIO configuration:

      .. tab-set::

         .. tab-item:: Default Path
            :sync: baremetal-default

            By default, the MinIO server looks for the TLS keys and certificates for each node in the following directory:

            .. code-block:: shell

               ${HOME}/.minio/certs

            Where ``${HOME}`` is the home directory of the user running the MinIO Server process.
            You may need to create the ``${HOME}/.minio/certs`` directory if it does not exist.

            For ``systemd`` managed deployments this must correspond to the ``USER`` running the MinIO process.
            If that user has no home directory, use the :guilabel:`Custom Path` option instead.

         .. tab-item:: Custom Path
            :sync: baremetal-custom

            You can specify a path for the MinIO server to search for certificates using the :mc-cmd:`minio server --certs-dir` or ``-S`` parameter.

            For example, the following command fragment directs the MinIO process to use the ``/opt/minio/certs`` directory for TLS certificates.

            .. code-block:: shell

               minio server --certs-dir /opt/minio/certs ...

            The user running the MinIO service *must* have read and write permissions to this directory.

      Place the certificates in the ``/certs`` folder, creating a subfolder in ``/certs`` for each additional domain for which MinIO should present TLS certificates.
      While MinIO has no requirements for folder names, consider creating subfolders whose name matches the domain to improve human readability. 
      Place the TLS private and public key for that domain in the subfolder.

      .. code-block:: shell

         /path/to/certs
            private.key
            public.crt
            s3-example.net/
               private.key
               public.crt
            internal-example.net/
               private.key
               public.crt
