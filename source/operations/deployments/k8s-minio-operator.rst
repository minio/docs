
.. _deploy-minio-operator:

=========================
MinIO Kubernetes Operator
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO is a Kubernetes-native high performance object store with an S3-compatible API. 
The MinIO Kubernetes Operator supports deploying MinIO Tenants onto private and public cloud infrastructures ("Hybrid" Cloud).

The MinIO Operator installs a :kube-docs:`Custom Resource Definition (CRD) <concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions>` to support describing MinIO tenants as a Kubernetes :kube-docs:`object <concepts/overview/working-with-objects/kubernetes-objects/>`. 

The MinIO Operator exists in its own namespace.
Within the Operator's namespace, the MinIO Operator utilizes two pods:

- The Operator pod for the base Operator functions to deploy, manage, modify, and maintain tenants.
- Console pod for the Operator's Graphical User Interface, the Operator Console.

See the MinIO Operator :minio-git:`CRD Reference <operator/blob/master/docs/tenant_crd.adoc>` for complete documentation on the MinIO CRD.

.. _minio-operator-prerequisites:

Operator Prerequisites
----------------------

Kubernetes Version
~~~~~~~~~~~~~~~~~~

MinIO supports `maintained Kubernetes APIs <https://kubernetes.io/releases/>`__ for deploying the Operator.

Kubernetes infrastructure running end-of-life API versions may exhibit unexpected or undesired behavior if used for deploying the Operator.

Kustomize and ``kubectl``
~~~~~~~~~~~~~~~~~~~~~~~~~

`Kustomize <https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization>`__ is a YAML-based templating tool that allows you to define Kubernetes resources in a declarative and repeatable fashion.
Kustomize is included with the :kube-docs:`kubectl <reference/kubectl>` command line tool.

This procedure assumes that your local host machine has both the matching version of ``kubectl`` for your Kubernetes cluster *and* the necessary access to that cluster to create new resources.

The `default MinIO Operator Kustomize template <https://github.com/minio/operator/blob/master/kustomization.yaml>`__ provides a starting point for customizing configurations for your local environment.
You can modify the default Kustomization file or apply your own `patches <https://datatracker.ietf.org/doc/html/rfc6902>`__ to customize the Operator deployment for your Kubernetes cluster.

.. _minio-k8s-deploy-operator-tls:

Kubernetes TLS Certificate API
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Operator manages TLS Certificate Signing Requests (CSR) using the Kubernetes ``certificates.k8s.io`` :kube-docs:`TLS certificate management API <tasks/tls/managing-tls-in-a-cluster/>` to create signed TLS certificates in the following circumstances:

- When ``autoCert`` is enabled.
- For the MinIO Console when the :envvar:`MINIO_CONSOLE_TLS_ENABLE` environment variable is set to ``on``.
- For :ref:`STS service <minio-security-token-service>` when :envvar:`OPERATOR_STS_ENABLED` environment variable is set to ``on``.
- For retrieving the health of the cluster.

The MinIO Operator reads certificates inside the ``operator-ca-tls`` secret and syncs this secret within the tenant namespace to trust private certificate authorities, such as when using cert-manager.

For any of these circumstances, the MinIO Operator *requires* that the Kubernetes ``kube-controller-manager`` configuration include the following :kube-docs:`configuration settings <reference/command-line-tools-reference/kube-controller-manager/#options>`:

- ``--cluster-signing-key-file`` - Specify the PEM-encoded RSA or ECDSA private key used to sign cluster-scoped certificates.

- ``--cluster-signing-cert-file`` - Specify the PEM-encoded x.509 Certificate Authority certificate used to issue cluster-scoped certificates.

The Kubernetes TLS API uses the CA signature algorithm for generating new TLS certificate.
MinIO recommends ECDSA (e.g. `NIST P-256 curve <https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-4.pdf>`__) or EdDSA (e.g. :rfc:`Curve25519 <7748>`) TLS private keys/certificates due to their lower computation requirements compared to RSA.
See :ref:`minio-TLS-supported-cipher-suites` for a complete list of supported TLS Cipher Suites.

If the Kubernetes cluster is not configured to respond to a generated :abbr:`CSR (Certificate Signing Request)`, the Operator cannot complete initialization. 
Some Kubernetes providers do not specify these configuration values by default. 

To check whether the ``kube-controller-manager`` specifies the cluster signing key and certificate files, use the following command:

.. code-block:: shell
   :class: copyable

   kubectl get pod kube-controller-manager-$CLUSTERNAME-control-plane \ 
     -n kube-system -o yaml

- Replace ``$CLUSTERNAME`` with the name of the Kubernetes cluster.

Confirm that the output contains the highlighted lines. 
The output of the example command above may differ from the output in your terminal:

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

   The MinIO Operator automatically generates TLS certificates for all MinIO Tenant pods using the specified Certificate Authority (CA).
   Clients external to the Kubernetes cluster must trust the Kubernetes cluster CA to connect to the MinIO Operator or MinIO Tenants. 

   Clients which cannot trust the Kubernetes cluster CA can disable TLS validation for connections to the MinIO Operator or a MinIO Tenant. 

   Alternatively, you can generate x.509 TLS certificates signed by a known and trusted CA and pass those certificates to MinIO Tenants. 
   See :ref:`minio-tls` for more complete documentation.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/deployments/k8s-deploy-minio-on-kubernetes
   /operations/deployments/k8s-deploy-operator-helm-on-kubernetes
   /operations/deployments/k8s-upgrade-minio-operator-kubernetes