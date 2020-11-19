.. _minio-vmware-create-tenant:

=====================
Create a MinIO Tenant
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

This procedure covers creating a MinIO Tenant using VMware vCenter version 7
Update 1 (7.0U1) on the VMware vSAN Data Persistence Platform (DPP), including
advanced configuration options.

This documentation assumes familiarity with all referenced VMware components,
including but not limited to VMware vCenter 7U1, vSAN, vSAN DPP, and vSAN Direct
Configuration. While this documentation *may* provide guidance for configuring
or deploying VMware components on a best-effort basis, it is not a replacement
for dedicated VMware-specific documentation.

Prerequisites
-------------

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Component
     - 

   * - VMware vCenter v7 Update 1
     -

   * - VMware ESXi Hosts
     - Ensure the cluster has *at least* as many ESXi hosts as MinIO nodes
       which you want to deploy.

   * - :vmware7-docs:`Storage Policy 
       <com.vmware.vsphere.storage.doc/GUID-720298C6-ED3A-4E80-87E8-076FFF02655A.html>` 
     - MinIO uses the disks associated to an available Storage Policy when
       provisioning PVCs. 

       The Storage Policy should point to a group of *either*:

       - vSAN Direct disks *or*

       - vSAN SNA disks

       The disks *must* be connected to the ESXi hosts onto which MinIO
       deploys. 

   * - :vmware7-docs:`Namespace 
       <vmware-vsphere-with-tanzu/GUID-1544C9FE-0B23-434E-B823-C59EFC2F7309.html>`
       
     - MinIO recommends creating a new namespace for each MinIO Tenant you
       deploy into the cluster.

       Ensure the namespace has access to the Storage Policy associated to the
       vSAN Direct or vSAN SNA disks.

   * - MinIO Client Plugin
     - :ref:`Enable <minio-vmware-enable>` the MinIO integration prior to
       beginning this procedure.

1) Open the Tenant Creation Modal
---------------------------------

Log in to the vCenter interface and select the Datacenter and Cluster
in which you want to deploy the MinIO Tenant:

IMAGE

Select :guilabel:`Configure` from the navigation bar and scroll down to the
:guilabel:`MinIO` section.

IMAGE

Click on :guilabel:`MinIO` to expand the section, then click 
:guilabel:`Tenants`.

IMAGE

Click :guilabel:`Add` to open the :guilabel:`Create Tenant` Modal. The following
steps describe each section of the modal:

.. _minio-vmware-create-tenant-configuration:

2) :guilabel:`Tenant Configuration`
-----------------------------------

This section contains the following configuration settings for the MinIO
Tenant:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Field
     - Description

   * - :guilabel:`Name` 
     - Enter the name of the MinIO Tenant. The specified string acts as a
       prefix for all resources created as part of the Tenant.

   * - :guilabel:`Namespace` 
     - Enter the name of a Namespace in your cluster.
       
       The namespace *must* already exist in the cluster.

   * - :guilabel:`Storage Class`
     - Select an available Storage Class associated to the specified namespace.
       Ensure the Storage Class provides access to the vSAN Direct Configuration
       disks in the cluster.

   * - :guilabel:`Advanced Mode`
     - Activate this checkbox to enable configuration of the following
       advanced Tenant settings:

       - :ref:`Miscellaneous Configuration <minio-vmware-create-configure>`
       - :ref:`External IDentity Providers (IDP) <minio-vmware-create-idp>`
       - :ref:`Security <minio-vmware-create-security>`
       - :ref:`Encryption <minio-vmware-create-encryption>`

.. _minio-vmware-create-configure:

3) :guilabel:`Configure`
------------------------

.. _minio-vmware-create-idp:

4) :guilabel:`IDP`
------------------

.. _minio-vmware-create-security:

5) :guilabel:`Security`
-----------------------

.. _minio-vmware-create-encryption:

6) :guilabel:`Encryption`
-------------------------

.. _minio-vmware-create-tenant-size:

7) :guilabel:`Tenant Size`
--------------------------

.. _minio-vmware-create-preview:

7) :guilabel:`Preview Configuration`
------------------------------------

.. _minio-vmware-create-credentials:

8) :guilabel:`Credentials`
--------------------------
