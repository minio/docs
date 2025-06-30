=====================================
MinIO High Performance Object Storage
=====================================

.. default-domain:: minio

.. cond:: mindocs

   .. container:: extlinks-video

      - `Installing and Running MinIO on Docker: Overview <https://youtu.be/mg9NRR6Js1s?ref=docs>`__
      - `Installing and Running MinIO on Docker: Installation Lab <https://youtu.be/Z0FtabDUPtU?ref=docs>`__
      - `Object Storage Essentials <https://www.youtube.com/playlist?list=PLFOIsHSSYIK3WitnqhqfpeZ6fRFKHxIr7>`__
      
      - `How to Connect to MinIO with JavaScript <https://www.youtube.com/watch?v=yUR4Fvx0D3E&list=PLFOIsHSSYIK3Dd3Y_x7itJT1NUKT5SxDh&index=5>`__

.. contents:: Table of Contents
   :local:
   :depth: 2

MinIO is a Kubernetes-native S3-compatible object storage solution designed to deploy wherever your applications are - on premises, in the private cloud, in the public cloud, and edge infrastructure.
MinIO is designed to support modern application workload patterns where high performance distributed computing meets petabyte-scale storage requirements.

This site documents Operations, Administration, and Development of MinIO Community Object Storage deployments on supported platforms for |minio-tag|. 

.. todo: More marketing/SEO below?

.. important::

   Support for deploying the MinIO Operator via the RedHat Marketplace or OperatorHub was removed in 2024. 
   MinIO AIStor fully supports installation via the Marketplace and OperatorHub onto enterprise RedHat Kubernetes distributions like OpenShift Container Platform (OCP).
   |subnet| customers can open an issue for further clarification and instructions on migrating to `AIStor <https://min.io/product/aistor-overview?jmp=docs>`__.

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

         Follow the instructions on the `MinIO Download Page <https://min.io/downloads?ref=docs>`__ for your operating system to download and install the :mc:`minio server` process.

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