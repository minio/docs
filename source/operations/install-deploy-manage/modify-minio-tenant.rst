.. _minio-k8s-modify-minio-tenant:

=====================
Modify a MinIO Tenant
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

The procedures on this page use the :ref:`MinIO Operator Console <minio-operator-console>` for modifying an existing tenant.

.. screenshot temporarily removed
   .. image:: /images/k8s/operator-manage-tenant.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Tenant Console

Certificate Management
----------------------

The Security section provides tools for adding and managing certificates for the tenant.

Review Certificate expiration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: Console 0.23.1

A message displays under the certificate with the date of expiration and length of time until expiration.

The message adjusts depending on the length of time to expiration:
   
- More than 30 days, the message text displays in gray.
- Within 30 days, the message text changes to orange.
- Within 10 days, the message text changes to red.
- Within 24 hours, the message displays as an hour and minute countdown in red text.
- After expiration, the message displays as ``EXPIRED``.

.. _minio-k8s-modify-minio-tenant-security:

Modify Tenant TLS Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Operator Console supports adding and removing TLS certificates from a MinIO Tenant.

From the Operator Console view, select the Tenant to open the summary view, then select :guilabel:`Security`.
You can make the following modifications:

Enable or Disable TLS
   Toggle the :guilabel:`TLS` switch to direct the Operator to either enable or disable TLS for the deployment.
   The MinIO Operator automatically generates the necessary TLS certificates using the Kubernetes TLS API.
   See :ref:`minio-tls-user-generated` for more information.

Add Custom TLS Certificates
   MinIO Tenants support `Server Name Indication (SNI) <https://en.wikipedia.org/wiki/Server_Name_Indication>`__, where the MinIO server identifies which certificate to use based on the hostname specified by the connecting client.
   The MinIO Operator can attach additional TLS certificates to the Tenant to enable SNI-based TLS connectivity.

   To customize the TLS certificates mounted on the MinIO Tenant, enable the :guilabel:`Custom Certificates` switch.
   Select the :guilabel:`Add Certificate +` button to add custom TLS certificates.

Add Trusted Certificate Authorities
   The MinIO Tenant validates the TLS certificate presented by each connecting client against the host system's trusted root certificate store.
   The MinIO Operator can attach additional third-party Certificate Authorities (CA) to the Tenant to allow validation of client TLS certificates signed by those CAs.

   To customize the trusted CAs mounted to each Tenant MinIO pod, enable the :guilabel:`Custom Certificates` switch.
   Select the :guilabel:`Add CA Certificate +` button to add third party CA certificates.

   If the MinIO Tenant cannot match an incoming client's TLS certificate issuer against either the container OS's trust store *or* an explicitly attached CA, MinIO rejects the connection as invalid.


Manage Tenant Pools
-------------------

Specify Runtime Class
~~~~~~~~~~~~~~~~~~~~~

.. versionadded:: Console 0.23.1

When adding a new pool or modifying an existing pool for a tenant, you can specify the :kube-docs:`Runtime Class Name <concepts/containers/runtime-class/>` for pools to use.

.. Following link is intended for K8s only
.. _minio-decommissioning:

Decommission a Tenant Server Pool
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO Operator 4.4.13 and later support decommissioning a server pool in a Tenant.
Specifically, you can follow the :minio-docs:`Decommission a Server pool <minio/linux/operations/install-deploy-manage/decommission-server-pool.html>` procedure to remove the pool from the tenant, then edit the tenant YAML to drop the pool from the StatefulSet.
When removing the Tenant pool, ensure the ``spec.pools.[n].name`` fields have values for all remaining pools.

.. include:: /includes/common-installation.rst
   :start-after: start-pool-order-must-not-change
   :end-before: end-pool-order-must-not-change
