.. _minio-sts-operator:

===============================================
Security Token Service (STS) for MinIO Operator
===============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. versionadded:: Operator v5.0.0

   The MinIO Operator supports a set of API calls that allows an application to obtain STS credentials for a MinIO Tenant.

:ref:`STS credentials <minio-security-token-service>` allow an application to access objects on a MinIO Tenant without the need to create any credentials for the application on the tenant.

.. important:: 

   MinIO Operator launches with STS *disabled* by default.
   To use STS with the Operator, you must first explicitly enable it.

How STS Authorization Works in Kubernetes
-----------------------------------------

An application can use an ``AssumeRoleWithWebIdentity`` call to send a request for temporary credentials to the MinIO Operator.
The Operator checks the validity of the request, retrieves policies for the application, obtains credentials from the tenant, and then passes the credentials back the application.
The application uses the issued credentials to work with the object storage on the tenant.

The complete process includes the following steps:

1. An application sends an API request to the MinIO Operator containing the name of the application and a service account to use.
2. The MinIO Operator uses the Kubernetes API to check that the JWT is a valid request.
3. After confirming the validity of the JWT, the MinIO Operator checks for a ``PolicyBinding`` that matches the application.
4. The MinIO Operator sends the policy information for the application to the MinIO Tenant.
5. The tenant creates temporary credentials for the request and returns those to the MinIO Operator.
6. The MinIO Operator forwards the temporary credentials back to the application.
7. The application uses the credentials to send the object storage calls to the MinIO tenant.

Requirements
------------

STS for the MinIO Operator requires the following:

- MinIO Operator v5.0.0 or later
- Deployment **must** have :ref:`TLS configured <minio-tls>`.
- :envvar:`OPERATOR_STS_ENABLED` environment variable set to ``on``

Procedure
---------

1. Enable STS functionality for the deployment
   
   .. code-block:: shell
      :class: copyable

      kubectl -n minio-operator set env deployment/minio-operator OPERATOR_STS_ENABLED=on
   
   - Replace ``minio-operator`` with the namespace for your deployment.
   - Replace ``deployment/minio-operator`` with the value for your MinIO deployment

2. Ensure an appropriate policy exists on the MinIO Tenant for the application to use

3. Create a yaml document to add necessary resources:
   - :ref:`Service Account <minio-operator-sts-service-account>` in the MinIO Tenant for the application to use

     For more on service accounts in Kubernetes, see the :kube-docs:`Kubernetes documentation <reference/access-authn-authz/service-accounts-admin/>`.
   - Create a :ref:`Policy Binding <minio-operator-sts-policy-binding>` linking the application to the MinIO Tenant's policy

4. Apply the yaml file to create the resources on the deployment
   
   .. code-block:: shell
      :class: copyable

      kubectl apply -k path/to/yaml/file.yaml

5. Use an SDK that supports the ``AssumeRoleWithWebIdentity`` like behavior to send a call from your application to the deployment

   Some SDKs that support ``AssumeRoleRoleWithWebIdentity`` include:

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

.. code-block:: yaml
   :class: copyable

   apiVersion: v1
   kind: ServiceAccount
   metadata:
     namespace: sts-client
     name: stsclient-sa

.. _minio-operator-sts-policy-binding:

Policy Binding
~~~~~~~~~~~~~~

.. code-block:: yaml
   :class: copyable

   apiVersion: sts.min.io/v1alpha1
   kind: PolicyBinding
   metadata:
     name: binding-1
     namespace: minio-tenant-1
   spec:
     application:
       namespace: sts-client
       serviceaccount: stsclient-sa
     policies:
       - test-bucket-rw

Reference
---------

- :minio-git:`STS Examples by SDK <operator/tree/master/examples/kustomization/sts-example/sample-clients>`
- :kube-docs:`Kubernetes documentation on Service Accounts <reference/access-authn-authz/service-accounts-admin/>`
- :minio-git:`MinIO STS API <operator/blob/master/docs/policybinding_crd.adoc>`