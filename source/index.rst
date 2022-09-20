=====================================
MinIO High Performance Object Storage
=====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO is a high performance object storage solution that provides an Amazon Web Services S3-compatible API and supports all core S3 features.

MinIO is built to deploy anywhere - public or private cloud, baremetal infrastructure, orchestrated environments, and edge infrastructure. 

.. cond:: linux

   This site documents Operations, Administration, and Development of MinIO deployments on Linux platforms.

.. cond:: windows

   This site documents Operations, Administration, and Development of MinIO deployments on Windows platforms.

.. cond:: osx

   This site documents Operations, Administration, and Development of MinIO deployments on Mac OSX platforms.

.. cond:: k8s

   This site documents Operations, Administration, and Development of MinIO deployments on Kubernetes platform.

.. cond:: container

   This site documents Operations, Administration, and Development of MinIO deployments on Containers.

This documentation targets the latest stable version of MinIO: |minio-tag|.

MinIO is released under dual license `GNU Affero General Public License v3.0 
<https://www.gnu.org/licenses/agpl-3.0.en.html?ref=docs>`__ and `MinIO Commercial License <https://min.io/pricing?jmp=docs>`__. 

You can get started exploring MinIO features using our ``play`` server at
https://play.min.io. ``play`` is a *public* MinIO cluster running the latest
stable MinIO server. Any file uploaded to ``play`` should be considered public
and non-protected.

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
      /administration/concepts


.. cond:: linux or macos or windows or container

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
      /administration/concepts

.. cond:: k8s or container or macos or windows

   .. toctree::
      :titlesonly:
      :hidden:

      Software Development Kits (SDK) <https://min.io/docs/minio/linux/developers/minio-drivers.html?ref=docs>
      Security Token Service (STS) <https://min.io/docs/minio/linux/developers/security-token-service.html?ref=docs>
      MinIO Client <https://min.io/docs/minio/linux/reference/minio-mc.html?ref=docs>
      MinIO Admin Client <https://min.io/docs/minio/linux/reference/minio-mc-admin.html?ref=docs>
      Integrations <https://min.io/docs/minio/linux/integrations/integrations.html?ref=docs>

.. cond:: linux

   .. toctree::
      :titlesonly:
      :hidden:

      /developers/minio-drivers
      /developers/security-token-service
      /reference/minio-mc
      /reference/minio-mc-admin
      /reference/minio-server/minio-server
      /integrations/integrations

.. cond:: k8s

   .. toctree::
      :titlesonly:
      :hidden:

      /reference/kubectl-minio-plugin

.. toctree::
   :titlesonly:
   :hidden:

   /glossary