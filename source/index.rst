=====================================
MinIO High Performance Object Storage
=====================================

.. default-domain:: minio

.. cond:: container

   .. container:: extlinks-video

      - `Installing and Running MinIO on Docker: Overview <https://youtu.be/mg9NRR6Js1s?ref=docs>`__
      - `Installing and Running MinIO on Docker: Installation Lab <https://youtu.be/Z0FtabDUPtU?ref=docs>`__
      - `Object Storage Essentials <https://www.youtube.com/playlist?list=PLFOIsHSSYIK3WitnqhqfpeZ6fRFKHxIr7>`__
      
      - `How to Connect to MinIO with JavaScript <https://www.youtube.com/watch?v=yUR4Fvx0D3E&list=PLFOIsHSSYIK3Dd3Y_x7itJT1NUKT5SxDh&index=5>`__

.. cond:: k8s

   .. container:: extlinks-video

      - `Object Storage Essentials <https://www.youtube.com/playlist?list=PLFOIsHSSYIK3WitnqhqfpeZ6fRFKHxIr7>`__

      - `How to Connect to MinIO with JavaScript <https://www.youtube.com/watch?v=yUR4Fvx0D3E&list=PLFOIsHSSYIK3Dd3Y_x7itJT1NUKT5SxDh&index=5>`__

.. cond:: linux

   .. container:: extlinks-video
   
      - `Installing and Running MinIO on Linux <https://www.youtube.com/watch?v=74usXkZpNt8&list=PLFOIsHSSYIK1BnzVY66pCL-iJ30Ht9t1o>`__
   
      - `Object Storage Essentials <https://www.youtube.com/playlist?list=PLFOIsHSSYIK3WitnqhqfpeZ6fRFKHxIr7>`__
      
      - `How to Connect to MinIO with JavaScript <https://www.youtube.com/watch?v=yUR4Fvx0D3E&list=PLFOIsHSSYIK3Dd3Y_x7itJT1NUKT5SxDh&index=5>`__

.. cond:: macos

   .. container:: extlinks-video
   
      - `Object Storage Essentials <https://www.youtube.com/playlist?list=PLFOIsHSSYIK3WitnqhqfpeZ6fRFKHxIr7>`__
      
      - `How to Connect to MinIO with JavaScript <https://www.youtube.com/watch?v=yUR4Fvx0D3E&list=PLFOIsHSSYIK3Dd3Y_x7itJT1NUKT5SxDh&index=5>`__

.. cond:: windows

   .. container:: extlinks-video

      - `Object Storage Essentials <https://www.youtube.com/playlist?list=PLFOIsHSSYIK3WitnqhqfpeZ6fRFKHxIr7>`__
      
      - `How to Connect to MinIO with JavaScript <https://www.youtube.com/watch?v=yUR4Fvx0D3E&list=PLFOIsHSSYIK3Dd3Y_x7itJT1NUKT5SxDh&index=5>`__

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO is a Kubernetes-native S3-compatible object storage solution designed to deploy wherever your applications are - on premises, in the private cloud, in the public cloud, and edge infrastructure.
MinIO is designed to support modern application workload patterns where high performance distributed computing meets petabyte-scale storage requirements.

MinIO is available under two server editions, each with their own distinct license:

.. grid:: 2

   .. grid-item-card:: MinIO Object Store (MinIO)

      MinIO Object Store (MinIO) is licensed under `GNU Affero General Public License v3.0  <https://www.gnu.org/licenses/agpl-3.0.en.html?ref=docs>`__.
      
      MinIO features are available to the community as a stream of active development.

      MinIO is community-focused, with best-effort support through the MinIO Community Slack Channel and the MinIO Github repository.

   .. grid-item-card:: MinIO Enterprise Object Store (MinEOS)

      MinIO Enterprise Object Store (MinEOS) is licensed under the `MinIO Commercial License <https://min.io/pricing?jmp=docs>`__.
      
      MinEOS is available to |SUBNET| Enterprise-Lite and Enterprise-Plus customers and includes exclusive support for the :minio-blog:`Enterprise Object Store feature suite <enterprise-object-store-overview/>`.

      MinEOS include |SUBNET| access for 24/7 L1 support from MinIO Engineering, with 4 or 1 hour SLAs available based on deployment size.

This site documents Operations, Administration, and Development of MinIO deployments on supported platforms for |minio-tag|. 
MinIO Enterprise Object Storage (MinEOS) deployments can use this documentation as a baseline of features available in a current or upcoming release.

.. todo: More marketing/SEO below?

MinIO officially supports the following platforms:

<<<<<<< HEAD
   This site documents Operations, Administration, and Development of MinIO deployments on Red Hat Kubernetes distributions for the latest stable version of the MinIO Operator: |operator-version-stable|.

   .. important::

      Support for deploying the MinIO Operator via the RedHat Marketplace or OperatorHub was removed in 2024. 
      MinIO AIStor fully supports installation via the Marketplace and OperatorHub onto enterprise RedHat Kubernetes distributions like OpenShift Container Platform (OCP).
      |subnet| customers can open an issue for further clarification and instructions on migrating to `AIStor <https://min.io/product/aistor-overview?jmp=docs>`__.
=======
- :ref:`Kubernetes (Upstream) <deploy-minio-kubernetes>`
- :ref:`RedHat Openshift <deploy-operator-openshift>`
- :ref:`SUSE Rancher <deploy-operator-rancher>`
- :ref:`Elastic Kubernetes Service <deploy-operator-eks>`
- :ref:`Google Kubernetes Engine <deploy-operator-gke>`
- :ref:`Azure Kubernetes Service <deploy-operator-aks>`
- :ref:`Red Hat Enterprise Linux <deploy-minio-rhel>`
- :ref:`Ubuntu Linux <deploy-minio-ubuntu>`
- :ref:`MacOS <deploy-minio-macos>`
- :ref:`Container <deploy-minio-container>`
- :ref:`Windows <deploy-minio-windows>`
>>>>>>> 8da23e1 (Attempting to reduce docs to single platform)

Quickstart
----------

.. tab-set::

   .. tab-item:: Sandbox

      MinIO maintains a sandbox instance of the community server at https://play.min.io. 
      You can use this instance for experimenting or evaluating the MinIO product on your local system.

      Follow the :mc:`mc` CLI :ref:`installation guide <mc-install>` to install the utility on your local host.

      :mc:`mc` includes a pre-configured ``play`` alias for connecting to the sandbox.
      For example, you can use the following commands to create a bucket and copy objects to ``play``:

      .. code-block:: shell
         :class: copyable

         mc mb play/mynewbucket

         mc cp /path/to/file play/mynewbucket/prefix/filename.extension

         mc stat play/mynewbucket/prefix/filename.extension

      .. important::

         MinIO's Play sandbox is an ephemeral public-facing deployment with well-known access credentials.
         Any private, confidential, internal, secured, or other important data uploaded to Play is effectively made public.
         Exercise caution and discretion in any data you upload to Play.

   .. tab-item:: Baremetal

      1. Download the MinIO Server Process for your Operating System

         Follow the instructions on the `MinIO Download Page <https://min.io/downloads?ref=docs>` for your operating system to download and install the :mc:`minio server` process.

      2. Create a folder for use with MinIO

         For example, create a folder ``~/minio`` in Linux/MacOS or ``C:\minio`` in Windows.

      3. Start the MinIO Server

         Run the :mc:`minio server` specifying the path to the directory and the :mc:`~minio server --console-address` parameter to set a static console listen path:

         .. code-block:: shell
            :class: copyable

            minio server ~/minio --console-address :9001
            # For windows, use minio.exe server ~/minio --console-address :9001`

         The output includes connection instructions for both :mc:`mc` and connecting to the Console using your browser.

   .. tab-item:: Kubernetes

      Download `minio-dev.yaml <https://raw.githubusercontent.com/minio/docs/master/source/extra/examples/minio-dev.yaml>`__ to your host machine:

      .. code-block:: shell
         :class: copyable

         curl https://raw.githubusercontent.com/minio/docs/master/source/extra/examples/minio-dev.yaml -O

      The file describes two Kubernetes resources:

      - A new namespace ``minio-dev``, and
      - A MinIO pod using a drive or volume on the Worker Node for serving data

      Use ``kubectl port-forward`` to access the Pod, or create a service for the pod for which you can configure Ingress, Load Balancing, or similar Kubernetes-level networking.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/deployments/installation
   /operations/replication/multi-site-replication
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
   /developers/minio-drivers
   /developers/security-token-service
   /developers/transforms-with-object-lambda
   /developers/file-transfer-protocol
   /reference/kubernetes
   /reference/baremetal
   /reference/s3-api-compatibility
   /glossary
   /integrations/integrations