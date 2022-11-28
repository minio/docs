.. _minio-operator-installation:
.. _deploy-operator-kubernetes:

=========================
Deploy the MinIO Operator
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

MinIO is a Kubernetes-native high performance object store with an S3-compatible
API. The MinIO Kubernetes Operator supports deploying MinIO Tenants onto private
and public cloud infrastructures ("Hybrid" Cloud).

The following procedure installs the latest stable version
(|operator-version-stable|) of the MinIO Operator and MinIO Plugin on Kubernetes
infrastructure:

- The MinIO Operator installs a :kube-docs:`Custom Resource Document (CRD)
  <concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions>`
  to support describing MinIO tenants as a Kubernetes :kube-docs:`object
  <concepts/overview/working-with-objects/kubernetes-objects/>`. See the MinIO
  Operator :minio-git:`CRD Reference <operator/blob/master/docs/crd.adoc>` for
  complete documentation on the MinIO CRD.

- The MinIO Kubernetes Plugin brings native support for deploying and managing
  MinIO tenants on a Kubernetes cluster using the :mc:`kubectl minio` command. 

This documentation assumes familiarity with all referenced Kubernetes
concepts, utilities, and procedures. While this documentation *may* 
provide guidance for configuring or deploying Kubernetes-related resources 
on a best-effort basis, it is not a replacement for the official
:kube-docs:`Kubernetes Documentation <>`.

Prerequisites
-------------

Kubernetes Version 1.19.0
~~~~~~~~~~~~~~~~~~~~~~~~~

Starting with v4.0.0, the MinIO Operator and MinIO Kubernetes Plugin require
Kubernetes 1.19.0 and later. The Kubernetes infrastructure *and* the 
``kubectl`` CLI tool must have the same version of 1.19.0+.

Prior to v4.0.0, the MinIO Operator and Plugin required Kubernetes 1.17.0. You 
*must* upgrade your Kubernetes infrastructure to 1.19.0 or later to use 
the MinIO Operator or Plugin v4.0.0 or later.

``kubectl`` Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure assumes that your local host machine has both the correct version of ``kubectl`` for your Kubernetes cluster *and* the necessary access to that cluster to create new resources.

.. _minio-k8s-deploy-operator-tls:

Kubernetes TLS Certificate API
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Operator automatically generates TLS Certificate Signing Requests (CSR) and uses the Kubernetes ``certificates.k8s.io`` :kube-docs:`TLS certificate management API <tasks/tls/managing-tls-in-a-cluster/>` to create signed TLS certificates.

The MinIO Operator therefore *requires* that the Kubernetes ``kube-controller-manager`` configuration include the following :kube-docs:`configuration settings <reference/command-line-tools-reference/kube-controller-manager/#options>`:

- ``--cluster-signing-key-file`` - Specify the PEM-encoded RSA or ECDSA private key used to sign cluster-scoped certificates.

- ``--cluster-signing-cert-file`` - Specify the PEM-encoded x.509 Certificate Authority certificate used to issue cluster-scoped certificates.

The Kubernetes TLS API uses the CA signature algorithm for generating new TLS certificate.
MinIO recommends ECDSA (e.g. `NIST P-256 curve <https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-4.pdf>`__) or EdDSA (e.g. :rfc:`Curve25519 <7748>`) TLS private keys/certificates due to their lower computation requirements compared to RSA.
See :ref:`minio-TLS-supported-cipher-suites` for a complete list of supported TLS Cipher Suites.

The Operator cannot complete initialization if the Kubernetes cluster is 
not configured to respond to a generated CSR. Certain Kubernetes 
providers do not specify these configuration values by default. 

To verify whether the ``kube-controller-manager`` has the required 
settings, use the following command. Replace ``$CLUSTER-NAME`` with the name 
of the Kubernetes cluster:

.. code-block:: shell
   :class: copyable

   kubectl get pod kube-controller-manager-$CLUSTERNAME-control-plane \ 
     -n kube-system -o yaml

Confirm that the output contains the highlighted lines. The output of 
the example command above may differ from the output in your terminal:

.. code-block:: shell
   :emphasize-lines: 12,13

    spec:
    containers:
    - command:
        - kube-controller-manager
        - --allocate-node-cidrs=true
        - --authentication-kubeconfig=/etc/kubernetes/controller-manager.conf
        - --authorization-kubeconfig=/etc/kubernetes/controller-manager.conf
        - --bind-address=127.0.0.1
        - --client-ca-file=/etc/kubernetes/pki/ca.crt
        - --cluster-cidr=10.244.0.0/16
        - --cluster-name=my-cluster-name
        - --cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt
        - --cluster-signing-key-file=/etc/kubernetes/pki/ca.key
    ...

.. important::

   The MinIO Operator automatically generates TLS certificates for all 
   MinIO Tenant pods using the specified Certificate Authority (CA).
   Clients external to the Kubernetes cluster must trust the  
   Kubernetes cluster CA to connect to the MinIO Operator or MinIO Tenants. 

   Clients which cannot trust the Kubernetes cluster CA can try disabling TLS 
   validation for connections to the MinIO Operator or a MinIO Tenant. 

   Alternatively, you can generate x.509 TLS certificates signed by a known
   and trusted CA and pass those certificates to MinIO Tenants. 
   See :ref:`minio-tls` for more complete documentation.

Procedure
---------

.. include:: /includes/common/common-install-operator-kubectl-plugin.rst

.. toctree::
   :titlesonly:
   :hidden:

   /operations/install-deploy-manage/upgrade-minio-operator