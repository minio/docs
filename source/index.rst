================================================================================
MinIO Object Storage for |platform|
================================================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO is an object storage solution that provides an Amazon Web Services S3-compatible API and supports all core S3 features. 
MinIO is built to deploy anywhere - public or private cloud, baremetal infrastructure, orchestrated environments, and edge infrastructure.

.. cond:: linux

   This site documents Operations, Administration, and Development of MinIO deployments on Linux platforms for the latest stable version of MinIO: |minio-tag|.

.. cond:: windows

   This site documents Operations, Administration, and Development of MinIO deployments on Windows platforms for the latest stable version of MinIO: |minio-tag|.

.. cond:: macos

   This site documents Operations, Administration, and Development of MinIO deployments on Mac OSX platforms for the latest stable version of MinIO: |minio-tag|.

.. cond:: container

   This site documents Operations, Administration, and Development of MinIO deployments on Containers for the latest stable version of MinIO: |minio-tag|.

.. cond:: k8s and not (openshift or eks or gke or aks)

   This site documents Operations, Administration, and Development of MinIO deployments on Kubernetes platform for the latest stable version of the MinIO Operator: |operator-version-stable|.

.. cond:: openshift

   This site documents Operations, Administration, and Development of MinIO deployments on OpenShift 4.7+ through the :openshift-docs:`Red Hat® OpenShift® Container Platform 4.7+ <welcome/index.html>` for the latest stable version of the MinIO Operator: |operator-version-stable|.

.. cond:: eks

   This site documents Operations, Administration, and Development of MinIO deployments on `Amazon Elastic Kubernetes Service <https://aws.amazon.com/eks/>`__ for the latest stable version of the MinIO Operator: |operator-version-stable|.

.. cond:: gke

   This site documents Operations, Administration, and Development of MinIO deployments on `Google Kubernetes Engine <https://cloud.google.com/kubernetes-engine>`__ for the latest stable version of the MinIO Operator: |operator-version-stable|.

.. cond:: aks

   This site documents Operations, Administration, and Development of MinIO deployments on `Azure Kubernetes Engine <https://azure.microsoft.com/en-us/products/kubernetes-service/#overview>`__ for the latest stable version of the MinIO Operator: |operator-version-stable|.

.. cond:: not (eks or aks or gke)

   MinIO is released under dual license `GNU Affero General Public License v3.0  <https://www.gnu.org/licenses/agpl-3.0.en.html?ref=docs>`__ and `MinIO Commercial License <https://min.io/pricing?jmp=docs>`__.
   Deployments registered through |SUBNET| use the commercial license and include access to 24/7 MinIO support.

.. cond:: eks

   MinIO is released under dual license `GNU Affero General Public License v3.0  <https://www.gnu.org/licenses/agpl-3.0.en.html?ref=docs>`__ and `MinIO Commercial License <https://min.io/pricing?jmp=docs>`__.
   Deploying MinIO through the :minio-web:`AWS Marketplace <product/multicloud-elastic-kubernetes-service>` includes the commercial license and access to 24/7 MinIO support through |SUBNET|.

.. cond:: gke

   MinIO is released under dual license `GNU Affero General Public License v3.0  <https://www.gnu.org/licenses/agpl-3.0.en.html?ref=docs>`__ and `MinIO Commercial License <https://min.io/pricing?jmp=docs>`__.
   Deploying MinIO through the :minio-web:`GKE Marketplace <product/multicloud-google-kubernetes-service>` includes the commercial license and access to 24/7 MinIO support through |SUBNET|.

.. cond:: aks

   MinIO is released under dual license `GNU Affero General Public License v3.0  <https://www.gnu.org/licenses/agpl-3.0.en.html?ref=docs>`__ and `MinIO Commercial License <https://min.io/pricing?jmp=docs>`__.
   Deploying MinIO through the :minio-web:`AKS Marketplace <product/multicloud-azure-kubernetes-service>` includes the commercial license and access to 24/7 MinIO support through  |SUBNET|.

You can get started exploring MinIO features using the :ref:`minio-console` and our ``play`` server at https://play.min.io. 
``play`` is a *public* MinIO cluster running the latest stable MinIO server. 
Any file uploaded to ``play`` should be considered public and non-protected.
For more about connecting to ``play``, see :ref:`MinIO Console play Login <minio-console-play-login>`.

.. cond:: linux

   .. include:: /includes/linux/quickstart.rst

.. cond:: macos

   .. include:: /includes/macos/quickstart.rst

.. cond:: windows

   .. include:: /includes/windows/quickstart.rst

.. cond:: k8s

   .. include:: /includes/k8s/quickstart.rst

.. cond:: container

   .. include:: /includes/container/quickstart.rst

.. cond:: k8s

   .. toctree::
      :titlesonly:
      :hidden:

      /operations/installation
      /operations/install-deploy-manage/upgrade-minio-operator
      /operations/deploy-manage-tenants
      /operations/concepts
      /operations/monitoring
      /operations/external-iam
      /operations/server-side-encryption
      /operations/network-encryption
      /operations/checklists
      /operations/data-recovery
      /operations/troubleshooting
      /administration/minio-console
      /administration/object-management
      /administration/monitoring
      /administration/identity-access-management
      /administration/server-side-encryption
      /administration/bucket-replication
      /administration/batch-framework
      /administration/concepts

.. cond:: windows

   .. toctree::
      :titlesonly:
      :hidden:

      /operations/installation
      /operations/concepts
      /operations/monitoring
      /operations/external-iam
      /operations/server-side-encryption
      /operations/network-encryption
      /operations/checklists
      /operations/data-recovery
      /operations/troubleshooting
      /administration/minio-console
      /administration/object-management
      /administration/monitoring
      /administration/identity-access-management
      /administration/server-side-encryption
      /administration/bucket-replication
      /administration/batch-framework
      /administration/concepts

.. cond:: linux or macos or container

   .. toctree::
      :titlesonly:
      :hidden:

      /operations/installation
      /operations/manage-existing-deployments
      /operations/concepts
      /operations/monitoring
      /operations/external-iam
      /operations/server-side-encryption
      /operations/network-encryption
      /operations/checklists
      /operations/data-recovery
      /operations/troubleshooting
      /administration/minio-console
      /administration/object-management
      /administration/monitoring
      /administration/identity-access-management
      /administration/server-side-encryption
      /administration/bucket-replication
      /administration/batch-framework
      /administration/concepts

.. cond:: not (linux or k8s)

   .. toctree::
      :titlesonly:
      :hidden:

      Software Development Kits (SDK) <https://min.io/docs/minio/linux/developers/minio-drivers.html?ref=docs>
      Security Token Service (STS) <https://min.io/docs/minio/linux/developers/security-token-service.html?ref=docs>
      Object Lambda <https://min.io/docs/minio/linux/developers/transforms-with-object-lambda.html?ref=docs>
      File Transfer Protocol <https://min.io/docs/minio/linux/developers/file-transfer-protocol.html?ref=docs>
      MinIO Client <https://min.io/docs/minio/linux/reference/minio-mc.html?ref=docs>
      MinIO Admin Client <https://min.io/docs/minio/linux/reference/minio-mc-admin.html?ref=docs>
      Integrations <https://min.io/docs/minio/linux/integrations/integrations.html?ref=docs>

.. cond:: linux

   .. toctree::
      :titlesonly:
      :hidden:

      /developers/minio-drivers
      /developers/security-token-service
      /developers/transforms-with-object-lambda
      /developers/file-transfer-protocol
      /reference/minio-mc
      /reference/minio-mc-admin
      /reference/minio-mc-deprecated
      /reference/minio-server/minio-server
      /integrations/integrations

.. cond:: k8s

   .. toctree::
      :titlesonly:
      :hidden:

      Software Development Kits (SDK) <https://min.io/docs/minio/linux/developers/minio-drivers.html?ref=docs>
      /developers/sts-for-operator
      Object Lambda <https://min.io/docs/minio/linux/developers/transforms-with-object-lambda.html?ref=docs>
      /developers/file-transfer-protocol
      MinIO Client <https://min.io/docs/minio/linux/reference/minio-mc.html?ref=docs>
      MinIO Admin Client <https://min.io/docs/minio/linux/reference/minio-mc-admin.html?ref=docs>
      Integrations <https://min.io/docs/minio/linux/integrations/integrations.html?ref=docs>
      /reference/kubectl-minio-plugin
      /reference/operator-crd
      /reference/operator-chart-values

.. toctree::
   :titlesonly:
   :hidden:

   /glossary
