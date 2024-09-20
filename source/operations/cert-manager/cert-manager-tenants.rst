.. _minio-certmanager-tenants:

========================
cert-manager for Tenants
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

The following procedures create and apply the resources necessary to use cert-manager for the TLS certificates within a tenant.

.. note::

   The procedures use ``tenant-1`` as the name of the tenant.
   
   Replace the string ``tenant-1`` throughout the procedures to reflect the name of your tenant.

Prerequisites
-------------

- `kustomize <https://kustomize.io/>`__ installed
- ``kubectl`` access to your ``k8s`` cluster
- Completed the steps to :ref:`set up cert-manager <minio-setup-certmanager>`
- The MinIO Operator installed and :ref:`set up for cert-manager <minio-certmanager-operator>`.

1) Create the tenant namespace CA Issuer
----------------------------------------

Before deploying a new tenant, create a Certificate Authority and Issuer for the tenant's namespace.

1. If necessary, create the tenant's namespace.

   .. code-block:: shell
      :class: copyable

      kubectl create ns tenant-1

   This much match the value of the ``metadata.namespace`` field in the tenant's YAML.

2. Request a Certificate for a new Certificate Authority with ``spec.isCA`` set to ``true``.

   Create a file called ``tenant-1-ca-certificate.yaml`` with the following contents:

   .. code-block:: yaml
      :class: copyable
      :emphasize-lines: 7,8

      # tenant-1-ca-certificate.yaml
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        name: tenant-1-ca-certificate
        namespace: tenant-1
      spec:
        isCA: true
        commonName: tenant-1-ca
        secretName: tenant-1-ca-tls
        duration: 70128h # 8y
        privateKey:
          algorithm: ECDSA
          size: 256
        issuerRef:
          name: selfsigned-root
          kind: ClusterIssuer
          group: cert-manager.io

   .. important::

      The ``spec.issueRef.name`` must match the name of the ``ClusterIssuer`` created when :ref:`setting up cert-manager <minio-cert-manager-create-cluster-issuer>`.
      If you specified a different ``ClusterIssuer`` name or are using a different ``Issuer`` from the guide, modify the ``issuerRef`` to match your environment.


3. Apply the resource:

   .. code-block:: shell
      :class: copyable

      kubectl apply -f tenant-1-ca-certificate.yaml

4) Create the ``Issuer``
------------------------

The ``Issuer`` issues the certificates within the tenant namespace.

1. Generate a resource definition for an ``Issuer``.

   Create a file called ``tenant-1-ca-issuer.yaml`` with the following contents:

   .. code-block:: yaml
      :class: copyable

      # tenant-1-ca-issuer.yaml
      apiVersion: cert-manager.io/v1
      kind: Issuer
      metadata:
        name: tenant-1-ca-issuer
        namespace: tenant-1
      spec:
        ca:
          secretName: tenant-1-ca-tls

2. Apply the ``Issuer`` resource definition:

   .. code-block:: shell
      :class: copyable

      kubectl apply -f tenant-1-ca-issuer.yaml

3) Create a certificate for the tenant
--------------------------------------

Request that cert-manager issue a new TLS server certificate for MinIO.
The certificate must be valid for the following DNS domains:

- ``minio.<namespace>``
- ``minio.<namespace>.svc``
- ``minio.<namespace>.svc.<cluster domain>``
- ``*.<tenant-name>-hl.<namespace>.svc.<cluster domain>``
- ``*.<namespace>.svc.<cluster domain>``
- ``*.<tenant-name>.minio.<namespace>.svc.<cluster domain>'``

.. important::

   Replace the the placeholder text (marked with the ``<`` and ``>`` characters) with values for your tenant: 

   - ``<cluster domain>`` is the internal root DNS domain assigned in your Kubernetes cluster. 
     Typically, this is ``cluster.local``, but confirm the value by checking your CoreDNS configuration for the correct value for your Kubernetes cluster. 
      
     For example:

     .. code-block:: shell
        :class: copyable

        kubectl get configmap coredns -n kube-system -o jsonpath="{.data}"

     Different Kubernetes providers manage the root domain differently.
     Check with your Kubernetes provider for more information.

   - ``tenant-name`` is the name provided to your tenant in the ``metadata.name`` of the Tenant YAML. 
     For this example it is ``myminio``.

   - ``namespace`` is the value created earlier where the tenant will be installed.
     In the tenant YAML, it is defined in the the ``metadata.namespace`` field. 
     For this example it is ``tenant-1``.

1. Request a ``Certificate`` for the domains mentioned above

   Create a file called ``tenant-1-minio-certificate.yaml``.
   The contents of the file should resemble the following, modified to reflect your cluster and tenant configurations: 

   .. code-block:: yaml
      :class: copyable

      # tenant-1-minio-certificate.yaml
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        name: tenant-certmanager-cert
        namespace: tenant-1
      spec:
        dnsNames:
          - "minio.tenant-1"
          - "minio.tenant-1.svc"
          - 'minio.tenant-1.svc.cluster.local'
          - '*.minio.tenant-1.svc.cluster.local'
          - '*.myminio-hl.tenant-1.svc.cluster.local'
          - '*.myminio.minio.tenant-1.svc.cluster.local'
        secretName: myminio-tls
        issuerRef:
          name: tenant-1-ca-issuer

   .. tip::

      For this example, the Tenant name is ``myminio``. 
      We recommend naming the secret in the field ``spec.secretName`` as ``<tenant-name>-tls`` as a naming convention.

2. Apply the certificate resource:

   .. code-block:: shell
      :class: copyable

      kubectl apply -f tenant-1-minio-certificate.yaml

3. Validate the changes took effect:

   .. code-block:: shell
      :class: copyable

      kubectl describe secret/myminio-tls -n tenant-1

   .. note::

      - Replace ``tenant-1`` with the namespace for your tenant.
      - Replace ``myminio-tls`` with the name of your secret, if different.

4) Deploy the tenant using cert-manager for TLS certificate management
----------------------------------------------------------------------

When deploying a Tenant, you must set the TLS configuration such that:

- The Tenant does not automatically generate its own certificates (``spec.requestAutoCert: false``) *and*
- The Tenant has a valid cert-manager reference (``spec.externalCertSecret``)

This directs the Operator to deploy the Tenant using the cert-manager certificates exclusively.

The following YAML ``spec`` provides a baseline configuration meeting these requirements:

.. code-block:: yaml
   :emphasize-lines: 6,9,11

   apiVersion: minio.min.io/v2
   kind: Tenant
   metadata:
     name: myminio
     namespace: tenant-1
   spec:
   ...
     ## Disable default tls certificates.
     requestAutoCert: false
     ## Use certificates generated by cert-manager.
     externalCertSecret:
       - name: myminio-tls
         type: cert-manager.io/v1
   ...

5) Trust the tenant's CA in MinIO Operator
------------------------------------------

The MinIO Operator does not trust the tenant's CA by default.
To trust the tenant's CA, you must pass the certificate to the Operator as a secret.

To do this, create a secret with the prefix ``operator-ca-tls-`` followed by a unique identifier in the `minio-operator` namespace.

MinIO Operator mounts and trusts **all** certificates issued by the provided Certificate Authorities. 
This is required because the MinIO Operator performs health checks using the ``/minio/health/cluster`` endpoint.

Create ``operator-ca-tls-tenant-1`` secret
++++++++++++++++++++++++++++++++++++++++++

Copy the tenant's cert-manager generated CA public key (``ca.crt``) into the `minio-operator` namespace. 
This allows Operator to trust the cert-manager issued CA and all certificates derived from it.

1. Create a ``ca.crt`` file containing the CA:

   .. code-block:: shell
      :class: copyable

      kubectl get secrets -n tenant-1 tenant-1-ca-tls -o=jsonpath='{.data.ca\.crt}' | base64 -d > ca.crt

2. Create the secret:

   .. code-block:: shell
      :class: copyable

      kubectl create secret generic operator-ca-tls-tenant-1 --from-file=ca.crt -n minio-operator

.. tip::

   In this example we chose a secret name of ``operator-ca-tls-tenant-1``. 
   We used the tenant namespace ``tenant-1`` as a suffix for easy identification of which namespace the CA comes from.
   Use the name of your tenant namespace for easier linking secrets to the related resources.

6) Deploy the tenant 
--------------------

With the Certificate Authority and ``Issuer`` in place for the tenant's namespace, you can now :ref:`deploy the object store tenant <minio-k8s-deploy-minio-tenant>`.

Use the tenant YAML modified above to disable AutoCert and reference the secret you generated.

