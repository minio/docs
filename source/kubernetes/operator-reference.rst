========================
MinIO Operator Reference
========================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 2

This document explains the various fields supported by MinIO Operator and its
CRD's and how to use these fields to deploy and access MinIO server clusters.

MinIO Operator creates native Kubernetes resources within the cluster. The 
operator uses the name of the created MinIO Instance as a prefix for 
all resources created by the operator. For example, if deploying a 
MinIO instance named ``minioinstance``, the operator creates the following
resources with their associated names:

- Headless Service: ``minioinstance-hl-svc``
- StatefulSet: ``minioinstance``
- Secret: ``minioinstance-tls`` (If :kubeconf:`spec.requestAutoCert` is enabled)
- CertificateSigningRequest: ``minioinstance-csr`` (If :kubeconf:`spec.requestAutoCert` is enabled)

The MinIO Kubernetes Operator is under active development. The contents of
this page may change at any time.

Configuration File Overview
---------------------------

The following example shows all possible MinIO Kubernetes Operator configuration
options.

.. code-block:: yaml
   :class: copyable

   apiVerison: operator.min.io/v1
   kind: "MinIOInstance"
   metadata: <object>
   scheduler: <string>
   spec:
       metadata: <object>
       image: <string>
       zones: <int>
       volumesPerServer: <int>
       imagePullSecret: <string>
       credsSecret: <string>
       replicas: <int>
       podManagementPolicy: <string>
       mountPath: <string>
       subPath: <string>
       volumeClaimTemplate: <object>
       env: <object>
       requestAutoCert: <bool>
       certConfig: <object>
       externalCertSecret: <object>
       resources: <object>
       liveness: <object>
       nodeSelector: <object>
       tolerations: <object>
       securityContext: <object>
       serviceAccountName: <string>
       mcs:
           image: <string>
           replicas: <int>
           mcsSecret: <string>
           metadata: <object>
       kes:
           replicas: <int>
           image: <string>
           configSecret: <string>
           metadata: <object>

Configuration Options
---------------------

.. kubeconf:: kind

   *Type*: String

   Specify ``MinIOInstance``. 

.. kubeconf:: metadata

   *Type*: Object

   Metadata related to the ``MinIOInstance``. For example, the 
   following sets the ``label`` for the ``MinIOInstance`` object:

   .. code-block:: yaml

      metadata:
          labels: minio
   
   See :kube-api:`#objectmeta-v1-meta` for more complete documentation on
   supported metadata options.

.. kubeconf:: spec

   *Type*: Object

   The specifications used by the MinIO Operator to deploy the MinIO
   server cluster.

   Options marked as **Required** must be included in the configuration
   document.

.. kubeconf:: spec.metadata

   *Type* : Object

   Metadata related to all pods launched by the MinIO operator. For example, the 
   following sets the ``label`` for all pods launched by the MinIO instance

   .. code-block:: yaml

      metadata:
          labels: minio
   
   See :kube-api:`metadata reference documentation <#objectmeta-v1-meta>` for 
   more complete documentation on supported metadata options.

.. kubeconf:: spec.requestAutoCert

   *Type*: Boolean

   *Defaults*: ``false``

   Specify ``true`` to enable automatic TLS certificate generation for each
   resource created by the MinIO Operator. The operator uses the root
   Certificate Authority (CA) configured for the Kubernetes cluster to generate
   the required Certificate Signing Requests (CSR).

