===================================
Configure TLS/SSL for MinIO Tenants
===================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

MinIO by default automatically generates self-signed TLS certificates for 
MinIO Tenant resources. This procedure documents configuring custom 
TLS x.509 certificates for use by the MinIO Tenant.

DIAGRAM

MinIO SNI support allows pods and services in the Tenant to use both 
auto-generated and custom certificates when establishing TLS connections. 
For example, you can deploy a Tenant where only services or pods accessed by 
external clients have custom certificates signed by a trusted Certificate 
Authority, while inter-Tenant TLS traffic continues to use the 
automatically generated self-signed certificates.

DIAGRAM

Automatically Generated TLS Certificates
----------------------------------------

The MinIO Operator automatically generates TLS x.509 certificates using the 
Kubernetes 
:kube-docs:`certificates.k8s.io <tasks/tls/managing-tls-in-a-cluster/>` API. 
The Kubernetes TLS API uses the Certificate Authority (CA) specified during 
cluster bootstrapping when approving a Certificate Signing Request (CSR) 
issued through the API. The following table summarizes the domains for which the 
MinIO Operator generates a certificate:

.. list-table::
   :header-rows: 1
   :widths: 65 35
   :width: 100%

   * - Domain
     - Description

   * - ``*.minio-hl.namespace.svc.cluster.local``
     - Matches the hostname of each MinIO Pod in the Tenant.

   * - ``minio-hl.namespace.svc.cluster.local``
     - Matches the headless service corresponding to all MinIO Pods in the 
       Tenant. 

   * - ``minio.namespace.cluster.local``
     - Matches the service corresponding to the MinIO Tenant. 
       Kubernetes pods typically use this service when performing 
       operations against the MinIO Tenant.

   * - ``minio-console-svc.namespace.cluster.local``
     - Matches the service corresponding to all MinIO Console pods in the 
       Tenant.

   * - ``*.minio-kes-hl-svc.namespace.svc.cluster.local``
     - Matches the hostname of each MinIO KES Pod in the Tenant.

   * - ``minio-kes-hl-svc.namespace.svc.cluster.local``
     - Matches the headless service corresponding to all MinIO KES Pods in the 
       Tenant.

.. note::

   The ``namespace`` and ``cluster.local`` fields will differ depending 
   on the Kubernetes Namespace in which the MinIO Tenant is deployed 
   *and* the Kubernetes cluster DNS settings.

Kubernetes pods by default do *not* automatically trust certificates generated
through the Kubernetes TLS API. For applications *internal* to the Kubernetes 
cluster (i.e. applications running on Pods in the cluster), you can manually 
add the Kubernetes CA to the Pod's system trust store using the 
``update-ca-certificates`` utility:

.. code-block:: shell
   :class: copyable
   
   cp /var/run/secrets/kubernetes.io/serviceaccount/ca.crt /usr/local/share/ca-certificates/
   update-ca-certificates

For applications *external* to the Kubernetes cluster, you must configure the
appropriate Ingress resource to route traffic to the MinIO Tenant. The
requirements for fully validated TLS connectivity depend on the specific Ingress
configuration. Ingress configuration is out of scope for this documentation. See
:kube-docs:`Kubernetes Ingress <concepts/services-networking/ingress/>` for more
complete guidance.

The MinIO Operator also supports deploying MinIO Tenants with user-generated
x.509 TLS certificates and Certificate Authorities (CA). MinIO uses SNI to
determine which x.509 certificate to serve based on the hostname associated to
the request. See :ref:`minio-tls-user-generated` for more information.

.. seealso::

   `update-ca-certificates <https://manpages.ubuntu.com/manpages/xenial/man8/update-ca-certificates.8.html>`__

.. _minio-tls-user-generated:

User-Generated TLS Certificates for MinIO Object Storage
--------------------------------------------------------

The MinIO Operator supports specifying user-generated x.509 certificates for
establishing TLS connections. MinIO supports SNI where the pod or service can
select the appropriate x.509 certificate based on the hostname to which the
client is connecting. For example, consider an x.509 certificate with the
following Subject Alternative Name (SAN) DNS names:

- ``minio.example.net``
- ``*.minio.example.net``

Any MinIO pod or server with that certificate can select it in response to a 
client making a request against a matching domain.

The Operator also supports specifying Certificate Authorities (CA) used by the
MinIO Tenant for validating the x.509 certificates of external services.

The following table lists a subset of MinIO Tenant object specification fields
for specifying user-generated x.509 certificates or Certificate Authorities
(CA):

.. list-table::
   :header-rows: 1
   :widths: 45 55
   :width: 100%

   * - Field
     - Description

   * - | :kubeconf:`spec.externalCaCertSecret`
       | :kubeconf:`spec.console.externalCaCertSecret`
     - One or more Certificate Authority (CA) certificates used by Pods 
       in the MinIO Tenant when validating x.509 TLS certificates presented 
       by external services.

   * - | :kubeconf:`spec.externalCertSecret`
       | :kubeconf:`spec.console.externalCertSecret`
     - One or more x.509 certificates used by Pods in the MinIO Tenant 
       for establishing TLS connections. The pod/service uses SNI to determine 
       which certificate to serve based on the requested hostname.

Create a Kubernetes Secret with type ``kubernetes.io/tls`` for each x.509
certificate or CA which you want to add to the MinIO Tenant. See 
:kube-docs:`Kubernetes Secrets </concepts/configuration/secret/>` for 
more complete documentation.
