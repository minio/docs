=====================================
MinIO High Performance Object Storage
=====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO is a high performance object storage solution that provides an Amazon Web Services S3-compatible API and supports all core S3 features.

MinIO is built to anywhere - public or private cloud, baremetal infrastructure, orchestrated environments, and edge infrastructure. 

.. cond:: linux

   This site documents Operations, Administration, and Development of MinIO deployments on Linux platforms.

.. cond:: windows

   This site documents Operations, Administration, and Development of MinIO deployments on Windows platforms.

.. cond:: osx

   This site documents Operations, Administration, and Development of MinIO deployments on Mac OSX platforms.

.. cond:: k8s

   This site documents Operations, Administration, and Development of MinIO deployments on Kubernetes platform.

This documentation targets the latest stable version of MinIO: |minio-tag|.

MinIO is released under `GNU Affero General Public License v3.0 
<https://www.gnu.org/licenses/agpl-3.0.en.html>`__. 

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


Licensing
---------

We have designed MinIO as an Open Source software for the Open Source software
community. This requires applications to consider whether their usage of MinIO
is in compliance with the 
:minio-git:`GNU AGPLv3 license <mc/blob/master/LICENSE>`.

MinIO cannot make the determination as to whether your application's usage of
MinIO is in compliance with the AGPLv3 license requirements. You should instead
rely on your own legal counsel or licensing specialists to audit and ensure your
application is in compliance with the licenses of MinIO and all other
open-source projects with which your application integrates or interacts. We
understand that AGPLv3 licensing is complex and nuanced. It is for that reason
we strongly encourage using experts in licensing to make any such determinations
around compliance instead of relying on apocryphal or anecdotal advice.

`MinIO Commercial Licensing <https://min.io/pricing>`__ is the best option for
applications that trigger AGPLv3 obligations (e.g. open sourcing your
application). Applications using MinIO - or any other OSS-licensed code -
without validating their usage do so at their own risk.

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
      /developers/minio-drivers
      /developers/security-token-service
      /reference/minio-mc
      /reference/minio-mc-admin
      /reference/kubectl-minio-plugin
      /glossary
      
.. cond:: linux or macos or windows

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
      /developers/minio-drivers
      /developers/security-token-service
      /reference/minio-mc
      /reference/minio-mc-admin
      /reference/minio-server/minio-server
      /glossary