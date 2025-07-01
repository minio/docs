.. _minio-authenticate-using-ad-ldap-generic:

================================================================
Configure MinIO for Authentication using Active Directory / LDAP
================================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


Overview
--------

MinIO supports configuring a single Active Directory / LDAP Connect for external management of user identities.

The procedure on this page provides instructions for:

.. tab-set::
   :class: parent-tab

   .. tab-item:: Kubernetes
      :sync: k8s

      For MinIO Tenants deployed using the :ref:`MinIO Kubernetes Operator <minio-kubernetes>`, this procedure covers:

      - Configuring a MinIO Tenant to use an external AD/LDAP provider
      - Accessing the Tenant Console using AD/LDAP Credentials.
      - Using the MinIO ``AssumeRoleWithLDAPIdentity`` Security Token Service (STS) API to generate temporary credentials for use by applications.

   .. tab-item:: Baremetal
      :sync: baremetal

      For MinIO deployments on baremetal infrastructure, this procedure covers:

      - Configuring a MinIO cluster for an external AD/LDAP provider.
      - Accessing the MinIO Console using AD/LDAP credentials.
      - Using the MinIO ``AssumeRoleWithLDAPIdentity`` Security Token Service (STS) API to generate temporary credentials for use by applications.

This procedure is generic for AD/LDAP services.
See the documentation for the AD/LDAP provider of your choice for specific instructions or procedures on configuration of user identities.

Prerequisites
-------------

Access to MinIO Cluster
~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::
   

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

Active Directory / LDAP Compatible IDentity Provider
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure assumes an existing Active Directory or LDAP service.
Instructions on configuring AD/LDAP are out of scope for this procedure.

.. tab-set::
   

   .. tab-item:: Kubernetes
      :sync: k8s

      - For AD/LDAP deployments within the same Kubernetes cluster as the MinIO Tenant, you can use Kubernetes service names to allow the MinIO Tenant to establish connectivity to the AD/LDAP service.

      - For AD/LDAP deployments external to the Kubernetes cluster, you must ensure the cluster supports routing communications between Kubernetes services and pods and the external network.
        This may require configuration or deployment of additional Kubernetes network components and/or enabling access to the public internet.

   .. tab-item:: Baremetal
      :sync: baremetal

      The MinIO deployment must have bidirectional network connectivity to the target AD / LDAP service.

MinIO requires a read-only access keys with which it :ref:`binds <minio-external-identity-management-ad-ldap-lookup-bind>` to perform authenticated user and group queries.
Ensure each AD/LDAP user and group intended for use with MinIO has a corresponding :ref:`policy <minio-external-identity-management-ad-ldap-access-control>` on the MinIO deployment. 
An AD/LDAP user with no assigned policy *and* with membership in groups with no assigned policy has no permission to access any action or resource on the MinIO cluster.

.. _minio-external-identity-management-ad-ldap-configure:

Configure MinIO with Active Directory or LDAP External Identity Management
--------------------------------------------------------------------------

.. include:: /includes/baremetal/steps-configure-ad-ldap-external-identity-management.rst

Disable a Configured Active Directory / LDAP Connection
-------------------------------------------------------

.. versionadded:: RELEASE.2023-03-20T20-16-18Z

You can enable and disable the configured AD/LDAP connection as needed.

Use :mc:`mc idp ldap disable` to deactivate a configured connection.
Use :mc:`mc idp ldap enable` to activate a previously configured connection.
