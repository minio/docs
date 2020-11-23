.. _minio-vmware:

=======================
MinIO on VMware vSphere
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

MinIO is a Kubernetes-native, high performance object storage suite that
maintains AWS S3 API compatibility, allowing applications to seamlessly migrate
to private or hybrid cloud infrastructures.  

Starting with VMware vSphere 7 Update 1 (7U1), vSphere includes MinIO's
first-party integration through the vSAN Data Persistence Platform (DPP). 
IT administrators using vSphere can provision high-performance multi-tenant
object storage entirely through the vCenter interface and with minimal
manual interaction with the underlying Kubernetes infrastructure. 

IMAGE

This documentation assumes familiarity with all referenced VMware components,
including but not limited to VMware vCenter,VMware vSAN, VMware vSAN Data
Persistence Platform, vSAN Direct, and vSAN SNA. While this
documentation *may* provide guidance for configuring or deploying VMware
components on a best-effort basis, it is not a replacement for dedicated
VMware-specific documentation.

vSAN Direct and vSAN SNA Storage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

VMware vSphere 7U1 and the VMware Data Persistence Platform (DPP) offer
two vSAN data paths specifically designed for cloud-native stateful
services like MinIO.

.. class:: bold-dt

vSAN SNA Drives
   Allows creating vSAN storage objects that are co-located with their
   associated compute resources. Each MinIO pod only uses drives that are local
   to the node it is running on. The pod relies on MinIO :ref:`Erasure Coding
   <minio-erasure-coding>` to provide durability or availability of data instead
   of vSAN.

vSAN Direct
   Allows creating independent datastores on every disk attached to a node,
   where applications running on that node can have direct access to those
   disks. The MinIO Tenant can fully utilize the available throughput of the
   locally attached disk without the overhead of network-attached storage.

   vSAN Direct drives are ideal for running MinIO Tenants.

While MinIO can make efficient use of either data path, vSAN Direct is well aligned with MinIO's best practices around ensuring a fast path between
a MinIO process and its storage. vSAN Direct also allows for independent fault domains for the disks used by a MinIO Pod.

MinIO recommends using only *one* type of vSAN data path for all drives intended
for use by a given MinIO Tenant. vSphere administrators should create
a :vmware7-docs:`Storage Policy
<com.vmware.vsphere.storage.doc/GUID-720298C6-ED3A-4E80-87E8-076FFF02655A.html>`
associated to either the vSAN SNA or vSAN Direct disks and ensure that the
:vmware7-docs:`namespace
<vmware-vsphere-with-tanzu/GUID-1544C9FE-0B23-434E-B823-C59EFC2F7309.html>` in
which the MinIO Tenant will be deployed has access to that policy.

.. ToDo: Link to vmware docs on configuring/provisioning Direct/SNA Drives

.. _minio-vmware-enable:

Enable MinIO for VMware vSphere
-------------------------------

VMware vSphere 7 Update 1 XXX includes the MinIO Client Plugin. You have to
explicitly enable the plugin from the :guilabel:`Client Plugins` view in
vCenter. 

From the :guilabel:`Menu`, select :guilabel:`Administration`, then select
:guilabel:`Client Plugins`. 

IMAGE

Select the :guilabel:`MinIO` checkbox and click :guilabel:`Enable` to enable the
plugin. 

IMAGE

Use the :ref:`minio-vmware-getting-started` procedure to deploy a MinIO Tenant
for evaluation and development. See :ref:`minio-vmware-create-tenant` for a
complete guide to deploying MinIO Tenants using vCenter.

.. _minio-vmware-getting-started:

Getting Started
---------------

The following procedure creates a MinIO Tenant through the VMware vCenter
interface. This procedure does not cover advanced configuration such as
Server Side Encryption (SSE-S3) or external IDentity Providers (IDP). 
See <Future Doc> for a complete description of all Tenant creation options.

Prerequisites
~~~~~~~~~~~~~

This procedure assumes the following:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Component
     - 

   * - VMware vSphere v7 Update 1
     - 

   * - VMware ESXi Hosts
     - Ensure the cluster has *at least* as many ESXi hosts as MinIO nodes
       which you want to deploy.

   * - :vmware7-docs:`Storage Policy 
       <com.vmware.vsphere.storage.doc/GUID-720298C6-ED3A-4E80-87E8-076FFF02655A.html>` 
     - MinIO ensures any PVCs generated to support the Tenant bind *only* to
       PVs associated to the specified storage policy. 

       The Storage Policy should point to a group of *either*:

       - vSAN Direct disks *or*

       - vSAN SNA disks

       The disks *must* be directly connected to the ESXi hosts onto which MinIO
       deploys. MinIO strongly recommends *against* provisioning networked
       storage for use with the Tenant.

   * - :vmware7-docs:`Namespace 
       <vmware-vsphere-with-tanzu/GUID-1544C9FE-0B23-434E-B823-C59EFC2F7309.html>`
       
     - MinIO recommends creating a new namespace for each MinIO Tenant you
       deploy into the cluster.

       Ensure the namespace has access to the Storage Policy associated to the
       vSAN Direct or vSAN SNA disks.

   * - MinIO Client Plugin
     - :ref:`Enable <minio-vmware-enable>` the MinIO integration prior to
       beginning this procedure.


Procedure
~~~~~~~~~

1) Navigate to the MinIO Dashboard
``````````````````````````````````

Log in to the vCenter interface and select the Datacenter and Cluster
in which you want to deploy the MinIO Tenant:

IMAGE

Select :guilabel:`Configure` from the navigation bar and scroll down to the
:guilabel:`MinIO` section.

IMAGE

Click on :guilabel:`MinIO` to expand the section, then click 
:guilabel:`Tenants`.

IMAGE

2) Open the Create Tenant Modal
```````````````````````````````

Click :guilabel:`Add` to open the :guilabel:`Create Tenant` Modal. 
The :guilabel:`Tenant Configuration` step presents the following
configuration fields:

.. list-table::
   :header-rows: 1
   :widths: 20 80
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

Click :guilabel:`Next` after entering the requested information.

The :guilabel:`Advanced Mode` checkbox opens advanced configuration options for
the Tenant. This procedure does not require access to advanced configuration
options. See <PROCEDURE> for more information on Advanced Configuration.

3) Configure the Tenant Size
````````````````````````````

The :guilabel:`Tenant Size` step of the :guilabel:`Create Tenant` modal
presents the following configuration fields:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Field
     - Description

   * - :guilabel:`Number of Nodes`
     - The number of hosts to allocate to the MinIO Tenant. MinIO deploys
       one :mc:`minio server` process per host.

   * - :guilabel:`Storage Size`
     - The amount of storage to allocate to the MinIO Tenant. 
       
   * - :guilabel:`Memory per Node [Gi]`
     - The amount of virtual memory in Gibibytes to allocate to each
       node in the MinIO Tenant.

       Click the hint :guilabel:`!` for a table of MinIO-recommended 
       memory size for the specified storage.


The :guilabel:`Tenant Size` step includes the :guilabel:`Resource Allocation`
section which displays a summary of the resources to allocate for the MinIO
Tenant. MinIO automatically calculates the optimal configuration for each
resource:

.. list-table:: 
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Field
     - Description

   * - :guilabel:`Volumes per Node`
     - The number of PVCs MinIO generates per node in the Tenant. 
       MinIO automatically calculates this number based on the specified
       :guilabel:`Storage Size` and the :guilabel:`Number of Nodes`.

   * - :guilabel:`Disk Size`
     - The total requested capacity of each PVC generated for the Tenant.

   * - :guilabel:`Total Number of Volumes`
     - The total number of PVCs generated for the Tenant.

   * - :guilabel:`Erasure Code Parity`
     - The default Erasure Code settings used by the MinIO Tenant.
       
       You can modify the default parity settings after deploying the MinIO
       Tenant. Use the :mc:`mc admin config set` command to change the
       ``storage_class standard:EC:N`` value, where ``N`` is the preferred
       parity setting.

   * - :guilabel:`Raw Capacity`
     - The total storage capacity of the cluster, not including Erasure Coding
       parity blocks.

   * - :guilabel:`Usable Capacity`
     - The total usable storage capacity based on the 
       :guilabel:`Erasure Code Parity` settings.

Validate that the planned resource allocation meets the requirements of
workloads that will run on the MinIO Tenant before clicking :guilabel:`Next`.

4) Review the Configuration
```````````````````````````

The :guilabel:`Preview Configuration` step of the :guilabel:`Create Tenant`
modal presents a summary of the MinIO Tenant prior to creation. 

IMAGE

Click :guilabel:`Create` to begin Tenant Creation.

5) Copy the Tenant Credentials
``````````````````````````````

The :guilabel:`Credentials` step of the :guilabel:`Create Tenant` modal
displays the Access Keys and Secret Keys for the MinIO Tenant and MinIO Console.

IMAGE

MinIO displays the Access Keys *once*. Click the :guilabel:`Copy Credentials`
button to copy the keys to your system clipboard. 

Store the keys in a secure location, such as a password-protected key vault.
Ensure only authorized users can access the generated keys. 

.. important::

   The MinIO Access Key and Secret Key credentials are associated to the
   :ref:`root <minio-users-root>` user for the MinIO Tenant. Any client
   which accesses the MinIO Tenant with these credentials has superuser 
   access to perform *any* operation on the Tenant.

Click :guilabel:`Finish` to close the :guilabel:`Create Tenant` modal and
return to the :guilabel:`Cluster` view.

6) Connect to the Tenant
````````````````````````

From the :guilabel:`Configure` tab in the :guilabel:`Cluster` view, select the
:guilabel:`Tenants` section under :guilabel:`MinIO` to open the
:guilabel:`MinIO Tenants` view.

IMAGE

This view displays all MinIO Tenants created in the cluster. 

To view the newly created Tenant, click the radio button to the left of that
Tenant and then select :guilabel:`Details`

IMAGE

You may need to wait until the MinIO Tenant is fully deployed and reports
its :guilabel:`Current State` as :guilabel:`Initialized`. 

The :guilabel:`MinIO Endpoint` displays the IP address to use for connecting
to the MinIO Tenant. 

IMAGE

You can specify this endpoint along with the MinIO Access Key and Secret Key
to connect to the Tenant and begin performing operations on it. For example,
the following operation uses the :mc:`mc` command line tool to configure
an alias for the new MinIO Tenant and retrieve its status:

.. code-block:: shell

   mc alias --insecure set vmw-minio-tenant https://192.168.21.130 ACCESSKEY SECRETKEY

   mc admin --insecure info vmw-minio-tenant

The ``--insecure`` option allows connecting to an endpoint using
self-signed certificates, and is required for the Tenant created as part of
this procedure.

Next Steps
``````````

The created MinIO Tenant is appropriate for local development and evaluation of
MinIO. 

- For documentation on MinIO SDKs, see <LINK>

- For more detailed instructions on configuring advanced features, such as
  custom TLS certificates or Server Side Encryption, see <PROCEDURE>


.. toctree::
   :titlesonly:
   :hidden:

   /vmware/tutorial-create-tenant.rst
   /vmware/tutorial-manage-tenant.rst
   /vmware/production-considerations.rst
