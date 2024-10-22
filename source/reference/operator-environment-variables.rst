.. _minio-operator-envvars:

====================================
MinIO Operator Environment Variables
====================================

.. default-domain:: minio

.. contents:: Table of Contents

The :ref:`MinIO Operator <minio-operator-installation>` uses the following environment variables during startup to set configuration settings.
Configure these variables in the ``minio-operator`` container.

Setting Environment Variables in Kubernetes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To set these environment variables, modify the operator container's yaml at ``.spec.env`` or use the following ``kubectl`` command syntax:

.. code-block:: shell
   :class: copyable

   kubectl set env -n minio-operator deployment/minio-operator <ENV_VARIABLE>=<value> ... <ENV_VARIABLE2>=<value2>

Replace:

- ``minio-operator`` with the namespace for your Operator, if not using the default value.
- ``deployment/minio-operator`` with the deployment for your Operator, if not the default value.
  (Most deployments use the default value.)
- ``<ENV_VARIABLE>`` with the environment variable to set or modify.
- ``<value>`` with the value to use for the environment variable.

You can set or modify multiple environment variables by separating each ``VARIABLE=value`` pair with a space.

Available MinIO Operator Environment Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. envvar:: MINIO_OPERATOR_CERTIFICATES_VERSION

   Specifies the certificate API version to use.

   Valid values are ``v1`` or ``v1beta1``.

   When not specified, the default is the API Kubernetes provides.

.. envvar:: MINIO_OPERATOR_RUNTIME

   Specify the type of runtime to use.

   Valid values are ``EKS``, ``Rancher``, or ``OpenShift``.
   Leave blank if none of the options apply.

   When set as ``EKS``, the :envvar:`MINIO_OPERATOR_CSR_SIGNER_NAME` must be ``beta.eks.amazonaws.com/app-serving``.

.. envvar:: MINIO_OPERATOR_CSR_SIGNER_NAME

   Override the default signer for certificate signing requests (CSRs).

   When not specified, the default value is ``kubernetes.io/kubelet-serving``.

.. envvar:: OPERATOR_CERT_PASSWD
   
   *Optional*

   The password Operator should use to decrypt the private key in the TLS certificate for Operator.

.. envvar:: OPERATOR_STS_ENABLED

   Toggle STS Service ``on`` or ``off``.

   .. versionchanged:: v5.0.11

      When not specified, the default value is ``on``.

   For versions prior to Operator 5.0.11, the default value was ``off``.

.. envvar:: MINIO_CONSOLE_DEPLOYMENT_NAME

   The name to use for the Operator Console.

   When not specified, the default value is ``operator``.

.. envvar:: MINIO_CONSOLE_TLS_ENABLE

   Toggle Console TLS service ``on`` or ``off``.

   When not specified, the default value is ``off``.

.. envvar:: MINIO_OPERATOR_IMAGE

   .. versionadded:: v5.0.11

   Specify the image of the MinIO instance sidecar container loaded by the Operator.

   Omit to use the Operator image.

.. envvar:: WATCHED_NAMESPACE

   A comma-separated list of the namespace(s) Operator should watch for tenants.
   
   When not specified, the default value is ``""`` to watch all namespaces.