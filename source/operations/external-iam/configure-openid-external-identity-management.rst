.. _minio-authenticate-using-openid-generic:

===============================================
Configure MinIO for Authentication using OpenID
===============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

MinIO supports using an OpenID Connect (OIDC) compatible IDentity Provider (IDP) such as Okta, KeyCloak, Dex, Google, or Facebook for external management of user identities. 

This page has procedures for configuring OIDC for MinIO deployments in Kubernetes and Baremetal infrastructures.

Select the tab corresponding to your infrastructure to switch between instruction sets.

.. tab-set:: 
   :class: parent-tab

   .. tab-item:: Kubernetes
      :sync: k8s

      For MinIO Tenants deployed using the :ref:`MinIO Kubernetes Operator <minio-kubernetes>`, this procedure covers:

      - Configuring a MinIO Tenant to use an external OIDC provider.
      - Accessing the Tenant Console using OIDC Credentials.
      - Using the MinIO ``AssumeRoleWithWebIdentity`` Security Token Service (STS) API to generate temporary credentials for use by applications.

   .. tab-item:: Baremetal
      :sync: baremetal

      For MinIO deployments on baremetal infrastructure, this procedure covers:

      - Configuring a MinIO cluster for an external OIDC provider.
      - Logging into the cluster using the MinIO Console and OIDC credentials.
      - Using the MinIO ``AssumeRoleWithWebIdentity`` Security Token Service (STS) API to generate temporary credentials for use by applications.

This procedure is generic for OIDC compatible providers. 
Defer to the documentation for the OIDC provider of your choice for specific instructions or procedures on authentication and JWT retrieval.

Prerequisites
-------------

OpenID-Connect (OIDC) Compatible IDentity Provider
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure assumes an existing OIDC provider such as Okta, KeyCloak, Dex, Google, or Facebook. 
Instructions on configuring these services are out of scope for this procedure.

.. tab-set::
   :class: hidden

   .. tab-item:: Kubernetes
      :sync: k8s

      - For OIDC services within the same Kubernetes cluster as the MinIO Tenant, you can use Kubernetes service names to allow the MinIO Tenant to establish connectivity to the OIDC service.

      - For OIDC services external to the Kubernetes cluster, you must ensure the cluster supports routing communications between Kubernetes services and pods and the external network.
        This may require configuration or deployment of additional Kubernetes network components and/or enabling access to the public internet.

   .. tab-item:: Baremetal
      :sync: baremetal

      The MinIO deployment must have bidirectional network connectivity to the target OIDC service.

Ensure each user identity intended for use with MinIO has the appropriate :ref:`claim <minio-external-identity-management-openid-access-control>` configured such that MinIO can associate a :ref:`policy <minio-policy>` to the authenticated user.
An OpenID user with no assigned policy has no permission to access any action or resource on the MinIO cluster.


Access to MinIO Cluster
~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::
   :class: hidden

   .. tab-item:: Kubernetes
      :sync: k8s

      You must have access to the MinIO Operator Console web UI.
      You can either expose the MinIO Operator Console service using your preferred Kubernetes routing component, or use temporary port forwarding to expose the Console service port on your local machine.

   .. tab-item:: Baremetal
      :sync: baremetal

      This procedure uses :mc:`mc` for performing operations on the MinIO cluster. 
      Install ``mc`` on a machine with network access to the cluster.
      See the ``mc`` :ref:`Installation Quickstart <mc-install>` for instructions on downloading and installing ``mc``.

      This procedure assumes a configured :mc:`alias <mc alias>` for the MinIO cluster. 

.. _minio-external-identity-management-openid-configure:

Configure MinIO with OpenID External Identity Management
--------------------------------------------------------

.. tab-set::
   :class: hidden

   .. tab-item:: Kubernetes
      :sync: k8s

      .. include:: /includes/k8s/steps-configure-openid-external-identity-management.rst
   
   .. tab-item:: Baremetal
      :sync: baremetal

      .. include:: /includes/baremetal/steps-configure-openid-external-identity-management.rst
   
