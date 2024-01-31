.. _minio-sts-operator:

===============================================
Security Token Service (STS) for MinIO Operator
===============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

.. versionadded:: Operator v5.0.0

   The MinIO Operator supports a set of API calls that allows an application to obtain STS credentials for a MinIO Tenant.

Benefits of STS for MinIO Operator include:

- :ref:`STS credentials <minio-security-token-service>` allow an application to access objects on a MinIO Tenant without the need to create credentials for the application on the tenant.

- Allows applications to access objects in MinIO tenants using a Kubernetes-native authentication mechanism.
  
  Service Accounts or Service Account Tokens are a core concept of :kube-docs:`Role-Based Access Control (RBAC) <reference/access-authn-authz/rbac/>` :kube-docs:`authentication <reference/access-authn-authz/authentication/#service-account-tokens>` in Kubernetes.

- Implementing STS for MinIO Operator allows you to utilize infrastructure as code principles and configuration by using the tenant custom resource definition (CRD) and a MinIO PolicyBinding CRD.

.. important:: 

   Starting with Operator v5.0.11, STS is *enabled* by default.

   Previous versions of the Operator start with STS *disabled* by default.
   To use STS with the Operator, you must first explicitly enable it.

   The procedure on this page includes instructions to enable the STS API in the MinIO Operator.

How STS Authorization Works in Kubernetes
-----------------------------------------

An application can use an ``AssumeRoleWithWebIdentity`` call including a :kube-docs:`Kubernetes Service Account's <reference/access-authn-authz/service-accounts-admin/>` :abbr:`JWT (JSON Web Token)` to send a request for temporary credentials to the MinIO Operator.
When linked to a pod, such as through a deployment's ``.spec.spec.serviceAccountName`` field, Kubernetes mounts a :abbr:`JWT (JSON Web Token)` for the service account from a well-known location, such as ``/var/run/secrets/kubernetes.io/serviceaccount/token``.
The Pod can access those service accounts from that location.

The Operator checks the validity of the request, retrieves policies for the application, obtains credentials from the tenant, and then passes the credentials back the application.
The application uses the issued credentials to work with the object storage on the tenant.

.. image:: /images/k8s/sts-diagram.png
   :width: 600px
   :alt: A diagram showing STS token process flow on a Kubernetes MinIO deployment between the requesting application, MinIO Operator, Kubernetes API, PolicyBinding custom resource definition, and the MinIO tenant.
   :align: center

The complete process includes the following steps:

1. An application sends an ``AssumeRoleWithWebidentity`` :ref:`API request <minio-sts-assumerolewithwebidentity>` to the MinIO Operator containing the tenant namespace and a service account to use.
2. The MinIO Operator uses the Kubernetes API to check that the JSON Web Token (JWT) associated with the :ref:`service account <minio-operator-sts-service-account>` in the application's request is valid.
3. The Kubernetes API returns the results of its validity check.
4. The MinIO Operator checks for :ref:`Policy Bindings <minio-operator-sts-policy-binding>` that matches the application.
5. The PolicyBinding CRD returns the policy or policies that match the request, if any.
6. The MinIO Operator sends the combined policy information for the application to the MinIO Tenant.
7. The tenant creates temporary credentials matching the policy or policies for the request and returns those to the MinIO Operator.
8. The MinIO Operator forwards the temporary credentials back to the application.
9. The application uses the credentials to send the object storage calls to the MinIO tenant.

Requirements
------------

STS for the MinIO Operator requires the following:

- MinIO Operator v5.0.0 or later.
- The deployment **must** have :ref:`TLS configured <minio-tls>`.
- (Required for Operator v5.0.0 - 5.0.10) :envvar:`OPERATOR_STS_ENABLED` environment variable set to ``on``.

Procedure
---------

1. Enable STS functionality for the deployment

   .. note::

      This step is optional starting with Operator 5.0.11 and later.
   
   .. code-block:: shell
      :class: copyable

      kubectl -n minio-operator set env deployment/minio-operator OPERATOR_STS_ENABLED=on
   
   - Replace ``minio-operator`` with the namespace for your deployment.
   - Replace ``deployment/minio-operator`` with the value for your deployment's MinIO Operator.

     You can find the deployment value by running ``kubectl get deployments -n <namespace>``, where you replace ``<namespace>`` with the namespace for the MinIO Operator.
     Your MinIO Operator namespace is typically ``minio-operator``, though this value can change during install.

2. Ensure an appropriate :ref:`policy <minio-policy>` or policies exist on the MinIO Tenant for the application to use for the application

   The next step uses a YAML document to map one or more existing tenant policies to a service account through a custom resource called a ``PolicyBinding``.

3. Create YAML resources for the Service Account and Policy Binding: 

   - Create the :ref:`Service Account <minio-operator-sts-service-account>` in the MinIO Tenant for the application to use.

     For more on service accounts in Kubernetes, see the :kube-docs:`Kubernetes documentation <reference/access-authn-authz/service-accounts-admin/>`.
   - Create a :ref:`Policy Binding <minio-operator-sts-policy-binding>` in the target tenant's namespace that links the application to one or more of the MinIO Tenant's policies.

4. Apply the YAML file to create the resources on the deployment
   
   .. code-block:: shell
      :class: copyable

      kubectl apply -k path/to/yaml/file.yaml

5. Use an SDK that supports the ``AssumeRoleWithWebIdentity`` like behavior to send a call from your application to the deployment

   The STS API expects a JWT for the service account to exist in the Kubernetes environment.
   When linked to a pod, such as through a deployment's ``.spec.spec.serviceAccountName`` field, Kubernetes mounts a :abbr:`JWT (JSON Web Token)` for the service account from a well-known location, such as ``/var/run/secrets/kubernetes.io/serviceaccount/token``.
   
   Alternatively, you can define the token path as an environment variable:

   .. code-block:: shell
      :class: copyable

      AWS_WEB_IDENTITY_TOKEN_FILE=/var/run/secrets/kubernetes.io/serviceaccount/token

   The following MinIO SDKs support ``AssumeRoleRoleWithWebIdentity``:

   - :ref:`Golang <go-sdk>`
   - :ref:`Java <java-sdk>`
   - :ref:`JavaScript <javascript-sdk>`
   - :ref:`.NET <dotnet-sdk>`
   - :ref:`Python <python-sdk>`

   For examples of using the SDKs to assume a role, see :minio-git:`GitHub <operator/tree/master/examples/kustomization/sts-example/sample-clients>`.

Example Resources
-----------------

.. _minio-operator-sts-service-account:

Service Account
~~~~~~~~~~~~~~~

A Service Account is a :kube-docs:`Kubernetes resource type <reference/access-authn-authz/service-accounts-admin/>` that allows an external application to interact with the Kubernetes deployment.
When linked to a pod, such as through a deployment's ``.spec.spec.serviceAccountName`` field, Kubernetes mounts a :abbr:`JWT (JSON Web Token)` for the service account from a well-known location, such as ``/var/run/secrets/kubernetes.io/serviceaccount/token``.

The following yaml creates a service account called ``stsclient-sa`` for the ``sts-client`` namespace.

.. code-block:: yaml
   :class: copyable

   apiVersion: v1
   kind: ServiceAccount
   metadata:
     namespace: sts-client # The namespace to add the service account to. Usually a tenant, but can be any namespace in the deployment.
     name: stsclient-sa # The name to use for the service account.

.. _minio-operator-sts-policy-binding:

Policy Binding
~~~~~~~~~~~~~~

A ``PolicyBinding`` is a MinIO-specific custom resource type for Kubernetes that links an ``application`` to a set of policies.

Create Policy Bindings in the namespace of the tenant they are for.

For the purposes of the MinIO Operator, an application is any requesting resource that identifies with a specific service account and tenant namespace.
The ``PolicyBinding`` resource links the application to one or more policies for the tenant on that namespace.

The below yaml creates a ``PolicyBinding`` that links an application using the service account ``stsclient-sa`` that exists in the namespace ``sts-client`` to the policy ``test-bucket-rw`` in the target tenant located in the namespace ``minio-tenant-1``.
The policies granted in the yaml definition **must** already exist on the MinIO Tenant.

.. code-block:: yaml
   :class: copyable

   apiVersion: sts.min.io/v1alpha1
   kind: PolicyBinding
   metadata:
     name: binding-1
     namespace: minio-tenant-1 # The namespace of the tenant this binding is for
   spec:
     application:
       namespace: sts-client # The namespace that contains the service account for the application
       serviceaccount: stsclient-sa # The service account to use for the application
     policies:
       - test-bucket-rw # A policy that already exists in the tenant
       # - test-bucket-policy-2 # Add as many policies as needed

Reference
---------

- :minio-git:`STS Examples by SDK <operator/tree/master/examples/kustomization/sts-example/sample-clients>`
- :kube-docs:`Kubernetes documentation on Service Accounts <reference/access-authn-authz/service-accounts-admin/>`
- :minio-git:`MinIO STS API <operator/blob/master/docs/policybinding_crd.adoc>`