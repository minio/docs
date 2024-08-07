:orphan:

.. _minio-operator-console:

======================
MinIO Operator Console
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. warning::

   MinIO Operator 6.0.0 deprecates and removes the Operator Console.

   You can use either Kustomization or Helm to manage and deploy MinIO Tenants.

   This page provides a historical view at the Operator Console, and will recieve no further updates or corrections.

The Operator Console provides a rich user interface for deploying and 
managing MinIO Tenants on Kubernetes infrastructure. Installing the 
MinIO :ref:`Kubernetes Operator <deploy-operator-kubernetes>` automatically
installs and configures the Operator Console.

.. screenshot temporarily removed
   .. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

This page summarizes the functions available with the MinIO Operator Console.

.. _minio-operator-console-connect:

Connect to the Operator Console
-------------------------------

.. include:: /includes/common/common-k8s-connect-operator-console.rst

Tenant Management
-----------------

The MinIO Operator Console supports deploying, managing, and monitoring MinIO Tenants on the Kubernetes cluster.

.. screenshot temporarily removed
   .. image:: /images/k8s/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

You can :ref:`deploy a MinIO Tenant <minio-k8s-deploy-minio-tenant>` through the Operator Console.

The Operator Console automatically detects MinIO Tenants deployed on the cluster when provisioned through:

- Operator Console
- Helm
- Kustomize

Select a listed tenant to open an in-browser view of that tenant's MinIO Console. 
You can use this view to directly manage, modify, expand, upgrade, and delete the tenant through the Operator UI.

.. versionadded:: Operator 5.0.0

   You can download a Log Report for a tenant from the Pods summary screen.

   The report downloads as ``<tenant-name>-report.zip``.
   The ZIP archive contains status, events, and log information for each pool on the deployment.
   The archive also includes a summary yaml file describing the deployment.

   |subnet| users relying on the commercial license should register the MinIO tenants to their SUBNET account, which can be done through the Operator Console.

Tenant Registration
-------------------

|subnet| users relying on the commercial license should register the MinIO tenants to their SUBNET account, which can be done through the Operator Console.

.. screenshot temporarily removed
   .. image:: /images/k8s/operator-console-register.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console Register Screen

#. Select the :guilabel:`Register` tab
#. Enter the :guilabel:`API Key` 
   
   You can obtain the key from |SUBNET| through the Console by selecting :guilabel:`Get from SUBNET`.

TLS Certificate Renewal
-----------------------

Operator 4.5.4 or later
~~~~~~~~~~~~~~~~~~~~~~~

Operator versions 4.5.4 and later automatically renew a tenant's certificates when the duration of the certificate has reached 80% of its life.

For example, a tenant certificate was issued on January 1, 2023, and set to expire on December 31, 2023.
80% of the 1 year life of the certificate comes on day 292, or October 19, 2023.
On that date, Operator automatically renews the tenant's certificate.

Operator 4.3.3 to 4.5.3
~~~~~~~~~~~~~~~~~~~~~~~

Operator versions 4.3.3 through 4.5.3 automatically renew tenant certificates after they reach 48 hours before expiration.

For a certificate that expires on December 31, 2023, Operator renews the certificate on December 29 or December 30, within 48 of the expiration.

Operator 4.3.2 or earlier
~~~~~~~~~~~~~~~~~~~~~~~~~

Operator versions 4.3.2 and earlier do not automatically renew certificates.
You must renew the tenant certificates on these releases separately.

Review Your MinIO License
-------------------------

To review which license you are using and the features available through different license options, select the :guilabel:`License` tab.

MinIO supports two licenses: `AGPLv3 Open Source <https://opensource.org/licenses/AGPL-3.0>`__ or a `MinIO Commercial License <https://min.io/pricing?ref=docs>`__.
Subscribers to |SUBNET| use MinIO under a commercial license.

You can also :guilabel:`Subscribe` from the License screen.
