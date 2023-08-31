.. _minio-k8s-upgrade-minio-tenant:

======================
Upgrade a MinIO Tenant
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Prerequisites
-------------

MinIO Kubernetes Operator and Plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedures on this page *requires* a valid installation of the MinIO Kubernetes Operator and assumes the local host has a matching installation of the MinIO Kubernetes Operator.
This procedure assumes the latest stable Operator and Plugin, version |operator-version-stable|.

See :ref:`deploy-operator-kubernetes` for complete documentation on deploying the MinIO Operator.

Install the Plugin
++++++++++++++++++

.. include:: /includes/k8s/install-minio-kubectl-plugin.rst

Upgrading from Operator v4.2.2
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are upgrading from Operator v4.2.2, the following must also be true:

- ``kubectl`` must have access to your Kubernetes cluster.
- MinIO Operator v4.2.2 running on your cluster.

Complete the following on your tenant(s) before beginning the upgrade:

1. Update the MinIO ``image`` to the latest version in the tenant spec YAML.
2. Ensure every pool in ``tenant.spec.pools`` explicitly sets a ``securityContext``.
   If you have not changed this previously, your pods run as ``root`` and must be changed. 

   A properly prepared pool configuration may resemble the following:

   .. code-block:: yaml
      :class: copyable

      # Replace $(LATEST-VERSION) with the MinIO version to use for the tenant.
      image: "minio/minio:$(LATEST-VERSION)"
      ...
      pools:
        - servers: 4
          name: "pool-0"
          volumesPerServer: 4
          volumeClaimTemplate:
            metadata:
              name: data
            spec:
              accessModes:
                - ReadWriteOnce
              resources:
                requests:
                  storage: 1Ti
          securityContext:
            runAsUser: 0
            runAsGroup: 0
            runAsNonRoot: false
            fsGroup: 0

   Use ``kubectl edit tenants TENANT-NAME -n NAMESPACE`` or modify the tenant YAML directly and apply the changes with ``kubectl apply -f tenant.yaml``.

   .. important::

      If you do not set the security context before upgrading, MinIO pods will not be able to perform read or write operations on existing volumes.

Upgrading from Operator 3.x.x
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are upgrading from Operator v3.x.x, the following must also be true:

- ``kubectl`` must have access to your Kubernetes cluster.
- MinIO Operator v3.x.x running on your cluster.

Complete the following on your tenant(s) before beginning the upgrade:

1. Update the MinIO ``image`` to the latest version in the tenant spec YAML.
2. Ensure every ``zone`` in ``tenant.spec.zones`` explicitly sets a zone ``name``.
3. Ensure every ``zone`` in ``tenant.spec.zones`` explicitly sets a ``securityContext``.

A properly prepared ``zones`` configuration may resemble the following:

.. code-block:: yaml
   :class: copyable

   # Replace $(LATEST-VERSION) with the MinIO version to use for the tenant.
   image: "minio/minio:$(LATEST-VERSION)"
   ...
   zones:
     - servers: 4
       name: "zone-0"
       volumesPerServer: 4
       volumeClaimTemplate:
         metadata:
           name: data
         spec:
           accessModes:
             - ReadWriteOnce
           resources:
             requests:
               storage: 1Ti
       securityContext:
         runAsUser: 0
         runAsGroup: 0
         runAsNonRoot: false
         fsGroup: 0
   - servers: 4
       name: "zone-1"
       volumesPerServer: 4
       volumeClaimTemplate:
         metadata:
           name: data
         spec:
           accessModes:
             - ReadWriteOnce
           resources:
             requests:
               storage: 1Ti
       securityContext:
         runAsUser: 0
         runAsGroup: 0
         runAsNonRoot: false
         fsGroup: 0

Use ``kubectl edit tenants TENANT-NAME -n NAMESPACE`` or modify the tenant YAML directly and apply the changes with ``kubectl apply -f tenant.yaml``.

.. important:: 

   Failing to apply the changes to the ``zones`` may result in persistent volume claims not provisioning or MinIO lacking access to perform ``read`` or ``write`` operations on the tenant.

Procedure (CLI)
---------------

This procedure documents upgrading pods running on a MinIO Tenant.

1) Validate the Active MinIO Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant info` command to return a summary of the MinIO Tenant, including the new Pool:

.. code-block:: shell
   :class: copyable

   kubectl minio tenant info TENANT_NAME \
     --namespace TENANT_NAMESPACE  

- Replace ``TENANT_NAME`` with the name of the Tenant.
- Replace ``TENANT_NAMESPACE`` with the namespace of the Tenant.

The output includes the version of the MinIO Server used by all Pods in the Tenant.

2) Upgrade the MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant upgrade` command to upgrade the container image used by *all* MinIO Pods in the Tenant. 
MinIO upgrades *all* ``minio`` server processes at once. 
This may result in downtime until the upgrade process completes.

.. code-block:: shell
   :class: copyable

   kubectl minio tenant upgrade TENANT_NAME                      \
           --image     minio:minio:RELEASE:YYYY-MM-DDTHH-MM-SSZ  \
           --namespace TENANT_NAMESPACE

- Replace ``TENANT_NAME`` with the name of the Tenant.
- Replace ``RELEASE:YYYY-MM-DDTHH-MM-SSZ`` with the specific release to use. 
  Specify ``minio/minio`` to use the latest stable version of MinIO.
- Replace ``TENANT_NAMESPACE`` with the namespace of the Tenant.

See MinIO's `DockerHub Repository <https://hub.docker.com/r/minio/minio>`__ for a list of available release tags.
