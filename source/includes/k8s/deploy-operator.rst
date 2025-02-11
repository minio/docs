.. _minio-operator-installation:
.. _minio-operator-installation-kustomize:
.. _deploy-operator-kubernetes:
.. _deploy-operator-kubernetes-kustomize:

=========================
Deploy the MinIO Operator
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

MinIO is a Kubernetes-native high performance object store with an S3-compatible API. 
The MinIO Kubernetes Operator supports deploying MinIO Tenants onto private and public cloud infrastructures ("Hybrid" Cloud).

The following procedure installs the latest stable version (|operator-version-stable|) of the MinIO Operator on Kubernetes infrastructure.

The MinIO Operator installs a :kube-docs:`Custom Resource Definition (CRD) <concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions>` to support describing MinIO tenants as a Kubernetes :kube-docs:`object <concepts/overview/working-with-objects/kubernetes-objects/>`. 
See the MinIO Operator :minio-git:`CRD Reference <operator/blob/master/docs/tenant_crd.adoc>` for complete documentation on the MinIO CRD.

This documentation assumes familiarity with referenced Kubernetes concepts, utilities, and procedures. 
While this documentation *may* provide guidance for configuring or deploying Kubernetes-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

.. cond:: openshift

   .. important::

      Support for deploying the MinIO Operator via the RedHat Marketplace or OperatorHub was removed in 2024. 
      |subnet| customers can open an issue for further clarification and instructions on migrating to `AIStor <https://min.io/product/aistor-overview?jmp=docs>`__.

      This documentation provides guidance through the general method of operator installation onto Kubernetes infrastructure.

MinIO Operator Components
-------------------------

The MinIO Operator exists in its own namespace in which it creates Kubernetes resources.
Those resources includes pods, services, replicasets, and deployments.

The Operator pods monitor all namespaces by default for objects using the MinIO CRD and manages those resources automatically.

When you use the Operator to create a tenant, the tenant *must* have its own namespace.
Within that namespace, the Operator generates the pods required by the tenant configuration.

Each Tenant pod runs three containers:

- MinIO Container that runs all of the standard MinIO functions, equivalent to basic MinIO installation on baremetal.
  This container stores and retrieves objects in the provided mount points (persistent volumes). 

- InitContainer that only exists during the launch of the pod to manage configuration secrets during startup.
  Once startup completes, this container terminates. 

- Sidecar container used to initialize the MinIO tenant.
  The sidecar retrieves and validates the configuration for each tenant and creates the necessary local resources in the pod. 

  .. versionchanged:: Operator 6.0.0
     
     The Sidecar has its own image and release cycle separate from the rest of the MinIO Operator.
     The MinIO Operator stores the tenant's environment variables in the sidecar, allowing the Operator to update the variables without requiring a rolling restart.

The tenant utilizes Persistent Volume Claims to talk to the Persistent Volumes that store the objects.

.. Image references Console pods, need to fix this up

.. .. image:: /images/k8s/OperatorsComponent-Diagram.png
..    :width: 600px
..    :alt: A diagram of the namespaces and pods used by or maintained by the MinIO Operator.
..    :align: center

.. _minio-operator-prerequisites:

Prerequisites
-------------

Kubernetes Version |k8s-floor|
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO tests |operator-version-stable| against a floor of Kubernetes API of |k8s-floor|.
MinIO **strongly recommends** maintaining Kubernetes infrastructure using `actively maintained Kubernetes API versions <https://kubernetes.io/releases/>`__.


MinIO **strongly recommends** upgrading Kubernetes clusters running with `End-Of-Life API versions <https://kubernetes.io/releases/patch-releases/#non-active-branch-history>`__



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

.. versionchanged:: Operator v.5.0.0

   The MinIO Operator manages TLS Certificate Signing Requests (CSR) using the Kubernetes ``certificates.k8s.io`` :kube-docs:`TLS certificate management API <tasks/tls/managing-tls-in-a-cluster/>` to create signed TLS certificates in the following circumstances:
   
   - When ``autoCert`` is enabled.
   - For the MinIO Tenant Console when the :envvar:`MINIO_CONSOLE_TLS_ENABLE` environment variable is set to ``on``.
   - For :ref:`STS service <minio-security-token-service>` when :envvar:`OPERATOR_STS_ENABLED` environment variable is set to ``on``.
   - For retrieving the health of the cluster.
   
   Beginning with Operator 6.0.0, the MinIO Operator reads certificates inside the ``operator-ca-tls`` secret to trust private certificate authorities throughout the Kubernetes cluster, such as when using cert-manager.
   Previous versions of the Operator sync the ``operator-ca-tls`` certificates to each tenant.

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

Certificate Management with cert-manager
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Rather than the MinIO Operator managing certificates, you can configure the deployment to use `cert-manager <https://cert-manager.io/>`__.
For instructions for deploying the MinIO Operator and tenants using cert-manager, refer to the :ref:`cert-manager page <minio-certmanager>`.

Procedure
---------

The following steps deploy Operator using Kustomize and a ``kustomization.yaml`` file from the MinIO Operator GitHub repository.
To install Operator using a Helm chart, see :ref:`Deploy Operator with Helm <minio-k8s-deploy-operator-helm>`.

.. include:: /includes/common/common-install-operator-kustomize.rst

.. toctree::
   :titlesonly:
   :hidden:

   /operations/install-deploy-manage/deploy-operator-helm
   
