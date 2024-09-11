.. _minio-certmanager:

============
cert-manager
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

TLS certificate management with cert-manager
--------------------------------------------

`cert-manager <https://cert-manager.io/>`__ works as a controller for managing certificates within Kubernetes clusters.
cert-manager obtains valid certificates from an ``Issuer`` or ``ClusterIssuer`` and can renew certificates prior to expiration.

The MinIO Operator supports using cert-manager for certificates as an alternative to the MinIO Operator managing certificates for itself and its tenants.

On a Kubernetes cluster, cert-manager requires a global level ``ClusterIssuer`` to generate intermediary ``Issuers`` and certificates.
At the namespace level, cert-manager issues certificates derived from an ``Issuer``.
A ``ClusterIssuer`` can issue certificates for multiple namespaces.
An ``Issuer`` only issues certificates for its own namespace.

To learn more about cert-manager Issuers, refer to the `Issuer documentation <https://cert-manager.io/docs/concepts/issuer/>`__.

Below is a logical view of a Kubernetes cluster with four namespaces:

- ``minio-operator``
- ``tenant-1``
- ``tenant-2``
- ``other-namespace``

.. image:: /images/k8s/cert-manager-namespaces.svg
   :width: 600px
   :alt: A graphic depiction of a kubernetes cluster with four namespaces. Each namespace in its own white box. One is labeled minio-operator with contents two sts content items. A second is labeled tenant-1 with a MinIO logo and four drives of a pool. A third is labeled tenant-2 with similar contents to the tenant-1 box. The fourth is labeled other namespace with contents of other pods.
   :align: center

This guide shows you how to set up a different Certificate Authority (CA) in each namespace.
Each namespace's CA references the global ``Cluster Issuer``.


The following graphic depicts how various namespaces make use of either an ``Issuer`` or ``ClusterIssuer`` type.

- cert-manager is installed in the ``cert-manager`` namespace, which does not have either an ``issuer`` or a ``ClusterIssuer``.
- The ``default`` namespace receives the global ``Cluster Issuer``.
- Each tenant's namespace receives a local ``Issuer``.
- The ``minio-operator`` namespace receives a local ``Issuer``. 
  More about services that require TLS certificates in the ``minio-operator`` namespace are covered :ref:`below <minio-operator-services-with-cert-manager>`.

.. image:: /images/k8s/cert-manager-cluster.svg
   :width: 600px
   :alt: A graphic depiction of a kubernetes cluster with five separate namespaces represented by different boxes. One is labeled minio-operator with a text box that says "minio-operator: issuer". A second is labeled tenant-1 with text box that says "tenant-1: issuer". A third is labeled default with a text box that says "root:ClusterIssuer". A fourth is labeled tenant-2 with a text box that says "tenant-2: issuer". The fifth is labeled cert-manager with a text box that says "minio-operator: issuer".
   :align: center

.. note::

   This guide uses a self-signed ``Cluster Issuer``. 
   You can also use `other Issuers supported by cert-manager <https://cert-manager.io/docs/configuration/issuers/>`__.
   The main difference is that you must provide the ``Issuer`` CA certificate to MinIO, instead of the CA's mentioned in this guide.


Prerequisites
-------------

- A `supported version of Kubernetes <https://kubernetes.io/releases/>`__. 
 
  While cert-manager supports `earlier K8s versions <https://cert-manager.io/docs/installation/supported-releases/>`__, the MinIO Operator requires a currently supported version.
- `kustomize <https://kustomize.io/>`__ installed
- ``kubectl`` access to your ``k8s`` cluster

Getting Started
---------------

Setup cert-manager
~~~~~~~~~~~~~~~~~~

Install cert-manager. 
`Release 1.12.X LTS <https://cert-manager.io/docs/releases/release-notes/release-notes-1.12/>`__ is preferred, but you may install latest.

The following command installs version 1.12.13 using ``kubectl``.

.. code-block:: shell
   :class: copyable
   
   kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.13/cert-manager.yaml

For more details on installing cert-manager, see their `installation instructions <https://cert-manager.io/docs/installation/>`__.

Create a self-signed root Issuer for the cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``Cluster Issuer`` is the top level Issuer from which all other certificates in the cluster derive. 

1. Request cert-manager to generate this by creating a ``ClusterIssuer`` resource.

   Create a file called ``selfsigned-root-clusterissuer.yaml`` with the following contents:

   .. code-block:: yaml
      :class: copyable
   
      # selfsigned-root-clusterissuer.yaml
      apiVersion: cert-manager.io/v1
      kind: ClusterIssuer
      metadata:
        name: selfsigned-root
      spec:
        selfSigned: {}

2. Apply the resource to the cluster:

   .. code-block:: shell
      :class: copyable

      kubectl apply -f selfsigned-root-clusterissuer.yaml

.. _minio-operator-services-with-cert-manager:

MinIO Operator services with cert-manager
-----------------------------------------

MinIO Operator manages the TLS certificate issuing for the services hosted in the ``minio-operator`` namespace. 
That is the :ref:`Secure Token Service (sts) <minio-sts-operator>`.

This section describes how to generate the ``sts`` TLS certificate with cert-manager.

- These certificates **must** be issued *before* installing Operator.
- The cluster's self-signed root ``ClusterIssuer`` certificate must already exist, as described above.

Secure Token Service (STS)
~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO STS is a service included with MinIO Operator that provides Native IAM Authentication for Kubernetes. 
This service allows you to control access to your MinIO tenant from your kubernetes applications without having to explicitly create credentials for each application. 
For more information, see the :ref:`Secure Token Service documentation <minio-sts-operator>`.

Think of the STS Service as a webserver presented with a TLS certificate for ``https`` traffic.
This guide covers how to **disable** the automatic generation of the certificate in MinIO Operator and issue the certificate using cert-manager instead.

Create a CA Issuer for the ``minio-operator`` namespace
+++++++++++++++++++++++++++++++++++++++++++++++++++++++

The ``minio-operator`` namespace needs to have its own certificate authority (CA), derived from the cluster's ``ClusterIssuer`` certificate create earlier.

1. If it does not exist, create the ``minio-operator`` namespace

   .. code-block:: shell
      :class: copyable

      kubectl create ns minio-operator

2. Request a new Certificate with ``spec.isCA: true`` specified. 

   This is our :abbr:`CA (Certificate Authority)` for the `minio-operator` namespace.

   Create a file called ``operator-ca-tls-secret.yaml`` with the following contents:

   .. code-block:: yaml
      :class: copyable
      :emphasize-lines: 7,8

      # operator-ca-tls-secret.yaml
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        name: minio-operator-ca-certificate
        namespace: minio-operator
      spec:
        isCA: true
        commonName: operator
        secretName: operator-ca-tls
        duration: 70128h # 8y
        privateKey:
          algorithm: ECDSA
          size: 256
        issuerRef:
          name: selfsigned-root
          kind: ClusterIssuer
          group: cert-manager.io

3. Apply the resource to the cluster
   
   .. code-block:: shell
      :class: copyable

      kubectl apply -f operator-ca-tls-secret.yaml

Kubernetes creates a new secret with the name ``operator-ca-tls`` in the ``minio-operator`` namespace.
This certificate serves as the :abbr:`CA (Certificate Authority)` that issues TLS certificates only for the services in the ``minio-`operator`` namespace.

.. important::

   Make sure to trust this certificate in any applications that need to interact with the ``sts`` service.


Use the secret to create the `Issuer`
+++++++++++++++++++++++++++++++++++++

Use the secret created above to add an ``Issuer`` resource for the ``minio-operator`` namespace.

1. Create a file called ``operator-ca-issuer.yaml`` with the following contents: 

   .. code-block:: yaml

      # operator-ca-issuer.yaml
      apiVersion: cert-manager.io/v1
      kind: Issuer
      metadata:
        name: minio-operator-ca-issuer
        namespace: minio-operator
      spec:
        ca:
          secretName: operator-ca-tls


2. Apply the resource to the cluster
   
   .. code-block:: shell

      kubectl apply -f operator-ca-issuer.yaml

Create TLS certificate for STS service
++++++++++++++++++++++++++++++++++++++

Now that the ``Issuer`` exists in the ``minio-operator`` namespace, cert-manager can add a certificate.

The certificate from cert-manager must be valid for the following DNS domains:

- ``sts``
- ``sts.minio-operator.svc.``
- ``sts.minio-operator.svc.<cluster domain>``

  .. important::

      Replace ``<cluster domain>`` with the actual values for your MinIO tenant.
      ``cluster domain`` is the internal root DNS domain assigned in your Kubernetes cluster. 
      Typically, this is ``cluster.local``, but confirm the value by checking your coredns configuration for the correct value for your Kubernetes cluster. 
      
      For example:

      .. code-block:: shell
         :class: copyable

         kubectl get configmap coredns -n kube-system -o jsonpath="{.data}"

      Different Kubernetes providers manage the root domain differently.
      Check with your Kubernetes provider for more information.

1. Create a ``Certificate`` for the domains mentioned above:

   Create a file named ``sts-tls-certificate.yaml`` with the following contents:

   .. code-block:: yaml
      :class: copyable
      :emphasize-lines: 7,12

      # sts-tls-certificate.yaml
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        name: sts-certmanager-cert
        namespace: minio-operator
      spec:
        dnsNames:
          - sts
          - sts.minio-operator.svc
          - sts.minio-operator.svc.cluster.local
        secretName: sts-tls
        issuerRef:
          name: minio-operator-ca-issuer

   .. important::
   
      The ``spec.secretName`` is not optional! 
   
      The secret name **must be** ``sts-tls``.
      Confirm this by setting ``spec.secretName: sts-tls`` as highlighted above.


2. Apply the resource to the cluster:

   .. code-block:: shell
      :class: copyable

      kubectl apply -f sts-tls-certificate.yaml

This creates a secret called ``sts-tls`` in the ``minio-operator`` namespace.

.. warning::
  
   Failing to provide the ``sts-tls`` secret containing the TLS certificate or providing an invalid key-value pair in the secret will prevent the STS service from starting.

Install Operator with Auto TLS disabled for STS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When installing the Operator deployment, set the ``OPERATOR_STS_AUTO_TLS_ENABLED`` environment variable to ``off`` in the ``minio-operator`` container. 

Disabling this environment variable prevents the MinIO Operator from issuing the certificate for STS.
Instead, Operator waits for the TLS certificate issued by cert-manager.

There are several options for defining an environment variable.
The steps below define the variable with kustomize.

1. Create a kustomization patch file called ``kustomization.yaml`` with the below contents:

   .. code-block:: yaml
      :class: copyable
   
      # minio-operator/kustomization.yaml
      apiVersion: kustomize.config.k8s.io/v1beta1
      kind: Kustomization
      
      resources:
      - github.com/minio/operator/resources
      
      patches:
      - patch: |-
          apiVersion: apps/v1
          kind: Deployment
          metadata:
            name: minio-operator
            namespace: minio-operator
          spec:
            template:
              spec:
                containers:
                  - name: minio-operator
                    env:
                      - name: OPERATOR_STS_AUTO_TLS_ENABLED
                        value: "off"
                      - name: OPERATOR_STS_ENABLED
                        value: "on"

2. Apply the kustomization resource to the cluster:

   .. code-block:: shell
      :class: copyable
   
      kubectl apply -k minio-operator

Manage tenant TLS certificates with cert-manager
------------------------------------------------

The following procedures create and apply the resources necessary to use cert-manager for the TLS certificates within a tenant.

The procedures use ``tenant-1`` as the name of the tenant.
Replace the string ``tenant-1`` throughout the procedures to reflect the name of your tenant.

Create the tenant namespace CA Issuer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Before deploying a new tenant, create a Certificate Authority and Issuer for the tenant's namespace.

1. If necessary, create the tenant's namespace.

   .. code-block:: shell
      :class: copyable

      kubectl create ns tenant-1

2. Request a Certificate for a new Certificate Authority.

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

       The ``spec.isCA`` field must be set to ``true`` to create this certificate as a certificate authority.
       See the emphasized lines above.

3. Apply the request file to the cluster.

   .. code-block:: shell
      :class: copyable

      kubectl apply -f tenant-1-ca-certificate.yaml

4. Generate a resource definition for an ``Issuer``.

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

5. Apply the ``Issuer`` resource definition to the cluster.

   .. code-block:: shell
      :class: copyable

      kubectl apply -f tenant-1-ca-issuer.yaml

Deploy the tenant 
~~~~~~~~~~~~~~~~~

With the Certificate Authority and ``Issuer`` in place for the tenant's namespace, you can now deploy the object store tenant.

Create a certificate for the tenant
+++++++++++++++++++++++++++++++++++

Request that cert-manager issue a new TLS server certificate for MinIO.
The certificate must be valid for the following DNS domains:

- ``minio.<namespace>``
- ``minio.<namespace>.svc``
- ``minio.<namespace>.svc.<cluster domain>``
- ``*.<tenant-name>-hl.<namespace>.svc.<cluster domain>``
- ``*.<namespace>.svc.<cluster domain>``
- ``*.<tenant-name>.minio.<namespace>.svc.<cluster domain>'``

.. important::

   Replace the filler strings (``<string-example>``) with values for your tenant: 

   - ``<cluster domain>`` is the internal root DNS domain assigned in your Kubernetes cluster. 
     Typically, this is ``cluster.local``, but confirm the value by checking your coredns configuration for the correct value for your Kubernetes cluster. 
      
     For example:

     .. code-block:: shell
        :class: copyable

        kubectl get configmap coredns -n kube-system -o jsonpath="{.data}"

     Different Kubernetes providers manage the root domain differently.
     Check with your Kubernetes provider for more information.

   - ``tenant-name`` is the name provided to your tenant in the ``metadata.name`` of the Tenant YAML. 
     For this example it is ``myminio``.

   - ``namespace`` is the namespace where the tenant is created, the ``metadata.namespace`` notes that in the Tenant YAML. 
     For this example it is ``tenant-1``.

1. Request a ``Certificate`` for the domains mentioned above

   Create a file called ``tenant-1-minio-certificate.yaml`` with the following contents: 

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
      We recommend naming the secret in the field ``spec.secretName`` as ``<tenant-name>-tls``, following the naming convention the MinIO Operator uses when creating certificates without cert-manager.

2. Apply the certificate resource to the cluster.

   .. code-block:: shell
      :class: copyable

      kubectl apply -f tenant-1-minio-certificate.yaml

Configure the tenant to use the certificate created by cert-manager 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

In the tenant spec, do the following:

- Disable Autocert by setting the ``spec.requestAutoCert`` field to ``false``. 

  This instructs the MinIO Operator to not attempt to issue certificates and instead rely on cert-manager to provide them in a secret.
- Reference the Secret containing the TLS certificate from the previous procedure in `spec.externalCertSecret`.


1. Modify the tenant YAML ``spec`` section to reflect the above
   
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

Trust the tenant's CA in MinIO Operator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO Operator can trust as many CA certificates as provided. 

To do this, create a secret with the prefix ``operator-ca-tls-`` followed by a unique identifier in the `minio-operator` namespace.

MinIO Operator mounts and trusts **all** certificates issued by the provided Certificate Authorities. 
This is required because the MinIO Operator performs health checks using the ``/minio/health/cluster`` endpoint.

If Operator is not correctly configured to trust the MinIO tenant's Certificate (or its CA), you will see an error message like the following in the Operator Pod logs:

.. code-block:: shell

   Failed to get cluster health: Get "https://minio.tenant-1.svc.cluster.local/minio/health/cluster":
   x509: certificate signed by unknown authority

For more details about health checks, refer to :ref:`Healthcheck API <minio-healthcheck-api>`.

Create ``operator-ca-tls-tenant-1`` secret
++++++++++++++++++++++++++++++++++++++++++

Copy the tenant's cert-manager generated CA public key (``ca.crt``) into the `minio-operator` namespace. 
This allows Operator to trust the cert-manager issued CA and all certificates derived from it.

1. Create a `ca.crt` file containing the CA:

   .. code-block:: shell
      :class: copyable

      kubectl get secrets -n tenant-1 tenant-1-ca-tls -o=jsonpath='{.data.ca\.crt}' | base64 -d > ca.crt

2. Create the secret:

   .. code-block:: shell
      :class: copyable

      kubectl create secret generic operator-ca-tls-tenant-1 --from-file=ca.crt -n minio-operator

.. tip::

   In this example we chose a secret name of ``operator-ca-tls-tenant-1``. 
   Note the tenant namespace ``tenant-1`` is used as suffix for easy identification of which namespace the CA is coming from.
   Use the name of your tenant namespace for easier linking secrets to the related resources.