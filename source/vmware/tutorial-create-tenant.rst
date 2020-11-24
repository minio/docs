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

       Select either a vSAN Direct *or* vSAN SNA-based storage policy.

       vSAN Direct and vSAN SNA require using locally-attached disks. MinIO
       strongly recommends *against* using networked storage.

   * - :vmware7-docs:`Namespace 
       <vmware-vsphere-with-tanzu/GUID-1544C9FE-0B23-434E-B823-C59EFC2F7309.html>`
       
     - MinIO supports only *one* MinIO Tenant per Kubernetes Namespace.

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
       
       The namespace *must* already exist in the cluster. MinIO supports
       deploying *exactly one* MinIO Tenant per namespace. 

   * - :guilabel:`Storage Class`
     - Select an available Storage Class associated to the specified namespace.

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

.. note::

   This section is only visible if you selected :guilabel:`Advanced Mode` in the
   :guilabel:`Tenant Configuration` section.

The :guilabel:`Configure` section contains configuration settings for using
custom Docker images or repositories when deploying MinIO pods:

.. tabs::

   .. tab:: :guilabel:`Use custom image`

      .. list-table::
         :header-rows: 1
         :widths: 40 60
         :width: 100%

         * - Field
           - Description

         * - :guilabel:`Use custom image`
           - Enables using a custom Docker image for deploying pods on the MinIO
             Tenant. 

         * - :guilabel:`MinIO's Image`
           - The custom Docker image to use for deploying :mc:`minio server` 
             pods.

             Only visible if :guilabel:`Use custom image` is activated.

         * - :guilabel:`Console's Image`
           - The custom Docker image to use for deploying MinIO Console pods.

             Only visible if :guilabel:`Use custom image` is activated.

   .. tab:: :guilabel:`Set Custom Image Registry`

      .. list-table::
         :header-rows: 1
         :widths: 40 60
         :width: 100%

         * - Field
           - Description

         * - :guilabel:`Set Custom Image Registry`
           - Enables using a private Docker repository for retrieving docker
             images for deploying the MinIO Tenant.

         * - :guilabel:`Endpoint`
           - The URL endpoint for the private Docker repository.

             Only visible if :guilabel:`Set Custom Image Registry` is activated.

         * - :guilabel:`Username`
           - The username for the specified :guilabel:`Endpoint`

             Only visible if :guilabel:`Set Custom Image Registry` is activated.

         * - :guilabel:`Password`
           - The username for the specified :guilabel:`Endpoint`.

             Only visible if :guilabel:`Set Custom Image Registry` is activated. 


.. _minio-vmware-create-idp:

4) :guilabel:`IDP`
------------------

.. note::

   This section is only visible if you selected :guilabel:`Advanced Mode` in the
   :guilabel:`Tenant Configuration` section.

The :guilabel`IDP` section contains configuration settings for using an external
IDentity Provider (IDP) for client authentication and authorization. See
:ref:`minio-sts` for more complete documentation on MinIO identity federation:

.. tabs::

   .. tab:: :guilabel:`OpenID`

      .. list-table::
         :header-rows: 1
         :widths: 40 60
         :width: 100%

         * - Field
           - Description

         * - :guilabel:`OpenID`
           - Enables using an OpenID Provider for external management of client
             access to the MinIO Tenant. Mutually exclusive with 
             :guilabel:`Active Directory`.

         * - :guilabel:`URL`
           - Specify the URL for the OpenID Provider. Ensure the configured
             network access rules grant the MinIO Tenant access to the specified
             URL endpoint.

         * - :guilabel:`Client ID`
           - Specify the Client ID to use for connecting to the OpenID Provider.

         * - :guilabel:`Secret ID`
           - Specify the Secret ID to use for connecting to the OpenID Provider.

   .. tab:: :guilabel:`Active Directory`

      .. list-table::
         :header-rows: 1
         :widths: 40 60
         :width: 100%

         * - Field
           - Description

         * - :guilabel:`Active Directory`
           - Enables using Microsoft Active Directory *or* an LDAP service for
             external management of client access to the MinIO Tenant. Mutually
             exclusive with :guilabel:`Active Directory`.

         * - :guilabel:`URL`
           - The endpoint for the Active Directory or LDAP service. Ensure the
             configured network access rules grant the MinIO tenant access to 
             the specified URL endpoint.
      
         * - :guilabel:`Skip TLS Verification`
           - Directs MinIO to skip verification of TLS certificates and connect to
             Active Directory or LDAP services presenting untrusted certificates
             (e.g. self-signed).

         * - :guilabel:`Server Insecure`
           - Allows plain text connections to the Active Directory or LDAP server.

         * - :guilabel:`User Search Filter`
           - Specify the LDAP query MinIO executes as part of client
             authentication/authorization. For example: ``(userPrincipalName=%s)``

             MinIO substitutes the username provided by the client into the
             ``%s`` placeholder *before* executing the query.

         * - :guilabel:`Group Search Base DN`
           - Specify the base Distinguished Name (DN) MinIO uses when
             querying for LDAP groups in which the authenticated user has membership.
             Specify multiple DNs as a semicolon-separated list.

         * - :guilabel:`Group Search Filter`
           - Specify the LDAP query MinIO executes as part of client
             authentication/authorization.

         * - :guilabel:`Group Name Attribute`
           - Specify the Common Name (CN) attribute MinIO uses when querying for
             LDAP groups in which the authenticated user has membership.

.. ToDo

   Link to STS docs for JWT, LDAP auth + policies, otherwise users wont 
   know what to configure for policies here.

For more complete documentation on securing access to MinIO Tenants, see
:ref:`minio-auth-authz-overview`.

.. _minio-vmware-create-security:

5) :guilabel:`Security`
-----------------------

.. note::

   This section is only visible if you selected :guilabel:`Advanced Mode` in the
   :guilabel:`Tenant Configuration` section.

The :guilabel:`Security` section contains configuration settings for automatic
and custom TLS certificate generation for resources in the MinIO Tenant:

.. tabs::

   .. tab:: :guilabel:`Autocert`

      .. list-table::
         :header-rows: 1
         :widths: 40 60
         :width: 100%

         * - Field
           - Description

         * - :guilabel:`Enable TLS`
           - Enables TLS authentication for the MinIO Tenant.

             MinIO *strongly recommends* enabling TLS regardless of the
             deployment environment (e.g. development, staging, or production).

         * - :guilabel:`Autocert`
           - Enables automatic generation of self-signed certificates for use by
             resources in the MinIO Tenant. 

             Clients may need to explicitly disable TLS certificate verification
             to connect to the MinIO Tenant, as self-signed certificates
             are typically not trusted by default.

             Only visible if :guilabel:`Enable TLS` is activated.

   .. tab:: :guilabel:`Custom Certificate`

      .. list-table::
         :header-rows: 1
         :widths: 40 60
         :width: 100%

         * - Field
           - Description

         * - :guilabel:`Enable TLS`
           - Enables TLS authentication for the MinIO Tenant.

             MinIO *strongly recommends* enabling TLS regardless of the
             deployment environment (e.g. development, staging, or production).

         * - :guilabel:`Custom Certificate`
           - Enables specifying one or more pre-generated TLS x.509 certificates for
             use by resources in the MinIO Tenant. Use this option to provide
             certificates signed by a specific Certificate Authority.

         * - :guilabel:`MinIO TLS Certs`
           - Specify a :guilabel:`Key` private key and :guilabel:`Cert` public
             certificate. MinIO attempts to match the specified certificates to
             :mc:`minio server` pods in the Tenant.

             You can specify additional certificates by clicking the
             :guilabel:`Add One More` button.

         * - :guilabel:`Console TLS Certs`
           - Specify a :guilabel:`Key` private key and :guilabel:`Cert` public
             certificate. MinIO attempts to match the specified certificates to
             MinIO Console pods in the Tenant.

.. _minio-vmware-create-encryption:

6) :guilabel:`Encryption`
-------------------------

.. note::

   This section is only visible if you selected :guilabel:`Advanced Mode` in the
   :guilabel:`Tenant Configuration` section.

The :guilabel:`Encryption` section contains configuration settings for
Server-Side Encryption of Objects (SSE-S3) stored on the MinIO Tenant. See
:ref:`minio-sse` for more complete documentation on MinIO SSE:

.. tabs::

   .. tab:: :guilabel:`Vault`

      .. list-table::
         :header-rows: 1
         :widths: 40 60
         :width: 100%

         * - Field
           - Description

         * - :guilabel:`Enable Server Side Encryption`
           - Enables configuring SSE of objects on the MinIO Tenant.

         * - :guilabel:`Vault`
           - Enables SSE using Hashicorp Vault as the Key Management Service
             (KMS).

         * - :guilabel:`Endpoint`
           - Specify the URL endpoint for the Vault service. Ensure the
             configured network access rules grant the MinIO Tenant access
             to the specified URL endpoint.

         * - :guilabel:`Engine`
           - Specify the path of the Vault engine to use for storing keys
             generated for supporting SSE-S3.

         * - :guilabel:`Namespace`
           - Specify the namespace on the Vault in which MinIO stores keys
             generated for supporting SSE-S3.

         * - :guilabel:`Prefix`
           - Specify the string prefix to apply when MinIO stores keys
             generated for supporting SSE-S3.

         * - :guilabel:`App Role`
           - Specify the credentials MinIO uses to perform AppRole
             authentication to the Vault server.

             - :guilabel:`Engine` - Specify the engine to use for 
               authentication.

             - :guilabel:`Id` - Specify the AppRole ID to use for
               authentication.

             - :guilabel:`Secret` - Specify the AppRole Secret to use for
               authentication.

             - :guilabel:`Retry` - Specify the number of seconds to wait before
               retrying connections to the Vault server.
         
         * - :guilabel:`TLS`
           - Specify the TLS certificates to use when connecting to the Vault
             server.
             
             - :guilabel:`Key` - Specify the private key ``*.key`` file.

             - :guilabel:`Cert` - Specify the public key ``*.cert`` file.

             - :guilabel:`CA` - Specify the Certificate Authority ``*.crt`` 
               file used to sign the *Vault* TLS certificates.

         * - :guilabel:`Status`
           - Specify how often MinIO should check the status of the Vault
             server. Set :guilabel:`Ping` to the amount of time to wait between
             status checks.

   .. tab:: :guilabel:`AWS`

      .. list-table::
         :header-rows: 1
         :widths: 40 60
         :width: 100%

         * - Field
           - Description

         * - :guilabel:`Enable Server Side Encryption`
           - Enables configuring Server-Side Encryption of objects on the
             MinIO Tenant.

         * - :guilabel:`AWS`
           - Enables SSE using Amazon Web Service Key Management System
             (AWS KMS) as the Key Management Service (KMS).

         * - :guilabel:`Endpoint`
           - Specify the URL endpoint for the AWS KMS service. Ensure the
             configured network access rules grant the MinIO Tenant access
             to the specified URL endpoint.

         * - :guilabel:`Region`
           - Specify the AWS region of the AWS KMS service.

         * - :guilabel:`KMS Key`
           - The AWS KMS Customer Master Key (CMK) to use for cryptographic
             key operations related to SSE.

         * - :guilabel:`Credentials`
           - Specify the credential to use when making requests to the
             AWS KMS service.

             - :guilabel:`Access Key` - Specify an AWS Access Key.

             - :guilabel:`Secret Key` - Specify the corresponding Secret Key.

             - :guilabel:`Token` - Specify the AWS Token.

   .. tab:: :guilabel:`Gemalto`

      .. list-table::
         :header-rows: 1
         :widths: 40 60
         :width: 100%

         * - Field
           - Description

         * - :guilabel:`Enable Server Side Encryption`
           - Enables configuring Server-Side Encryption of objects on the
             MinIO Tenant.

         * - :guilabel:`Gemalto`
           - Enable SSE using Gemalto KeyVault or Thales CipherTrust as the
             Key Management Service.

         * - :guilabel:`Endpoint`
           - Specify the URL endpoint for the KeyVault or CipherTrust 
             service. Ensure the configured network access rules grant the
             MinIO Tenant access to the specified URL endpoint.

         * - :guilabel:`Credentials`
           - Specify the credentials to use when making requests to the
             KeyVault or CipherTrust service.

             - :guilabel:`Token` - Specify a KeyVault or CipherTrust access 
               token.

             - :guilabel:`Domain` - Specify the domain of the user associated
               to the access token.

             - :guilabel:`Retry` - Specify the number of seconds to wait before
               retrying connections to the KeyVault or CipherTrust service.

         * - :guilabel:`TLS`
           - Specify the Certificate Authority ``*.crt`` file used to sign the
             *KeyVault/CipherTrust* TLS certificates.

.. _minio-vmware-create-tenant-size:

7) :guilabel:`Tenant Size`
--------------------------

The :guilabel:`Tenant Size` section contains configuration settings for
nodes in the MinIO Tenant:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Field
     - Description

   * - :guilabel:`Number of Nodes`
     - Specify the number of nodes to create for the MinIO Tenant.

   * - :guilabel:`Storage Size`
     - Specify the total amount of storage in the cluster.

       MinIO automatically calculates the number of volumes per node based
       on the specified storage size and the Storage Class selected 
       in the :ref:`Tenant Configuration <minio-vmware-tenant-configuration>`
       step.

       The requested storage *must* be less than or equal to the available
       storage in the specified Storage Class.

   * - :guilabel:`Memory per Node`
     - Specify the amount of RAM to allocate to each node on the MinIO Tenant.
       MinIO recommends a *minimum* of 2Gi of RAM per node.
       
       Click the exclamation mark :guilabel:`!` hint to view recommended 
       memory allocations based on total available storage.

The :guilabel:`Resource Allocation` section displays the results of the
specified configuration settings:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Field
     - Description

   * - :guilabel:`Volumes per Node`
     - The number of Persistent Volume Claims (PVC) that MinIO generates 
       per node in the Tenant. 

       MinIO calculates this value based on the requested 
       :guilabel:`Storage Size` and the number of available disks in the
       :guilabel:`Storage Class`.

   * - :guilabel:`Disk Size`
     - The requested storage capacity for each PVC that MinIO generates for
       the Tenant.

       MinIO calculates this value based on the requested 
       :guilabel:`Storage Size` and the number of available disks in the
       :guilabel:`Storage Class`.

   * - :guilabel:`Total Number of Volumes`
     - The total number of PVC that MinIO generates for the Tenant. 

       MinIO calculates this value based on the requested 
       :guilabel:`Storage Size` and the number of available disks in the
       :guilabel:`Storage Class`.

   * - :guilabel:`Erasure Code Parity`
     - The default :ref:`Erasure Code Settings <minio-erasure-coding>`
       settings for the cluster.

       MinIO Erasure Coding provides high availability and resilience of 
       stored data. High parity values allows MinIO to tolerate multiple drive
       failure while continuing to service read and write operations. However,
       high parity reduces total available storage. 

       You can modify the default erasure code parity after starting the
       cluster by using :mc-cmd:`mc admin config set` to modify the 
       ``storage_class standard=EC:N`` setting, where ``N`` is the number of
       parity blocks to create per object. MinIO recommends ``EC:4`` as a
       safe default that balances resilience against total cluster storage.

   * - :guilabel:`Raw Capacity`
     - The total raw capacity of storage based on the 
       requested :guilabel:`Storage Size`.

   * - :guilabel:`Usable Capacity`
     - The total estimated usable storage capacity based on the
       :guilabel:`Erasure Code Parity`.

       The actual usable capacity depends on the erasure code parity used
       in practice during regular workloads. For example, lowering the
       erasure code parity settings after creating the Tenant would increase
       the total estimated usable storage on the cluster.


.. _minio-vmware-create-preview:

7) :guilabel:`Preview Configuration`
------------------------------------

The :guilabel:`Preview Configuration` section contains the details for the
MinIO Tenant. Review the summary *before* proceeding to the next step.

- The :guilabel:`Name`, :guilabel:`Namespace`, and
  :guilabel:`Storage Class` settings are derived from the 
  :ref:`minio-vmware-tenant-configuration` section. 

- The :guilabel:`Nodes`, :guilabel:`Total Number of Volumes`, 
  :guilabel:`Volumes per Node`, :guilabel:`Disk Size`, 
  :guilabel:`Erasure Code Parity`, :guilabel:`Raw Capacity`, and
  :guilabel:`Usable Capacity` settings are derived from the
  :ref:`minio-vmware-tenant-size` section.

.. _minio-vmware-create-credentials:

8) :guilabel:`Credentials`
--------------------------

The :guilabel:`Credentials` section contains the credentials required for
connecting to the MinIO Tenant and MinIO Console.

IMAGE

- The :guilabel:`MinIO's Access Key` and :guilabel:`MinIO's Secret Key` 
  are the credentials for the :ref:`minio-users-root`. 

- The :guilabel:`Console's Access Key` and :guilabel:`Console's Secret Key`
  are the credentials for accessing the MinIO Console.

MinIO displays the Access Keys *once*. Click the :guilabel:`Copy Credentials`
button to copy the keys to your system clipboard. Store the keys in a secure
location, such as a password-protected key vault. 

.. important::

   The MinIO Access Key and Secret Key credentials are associated to the
   :ref:`root <minio-users-root>` user for the MinIO Tenant. Any client
   which accesses the MinIO Tenant with these credentials has superuser 
   access to perform *any* operation on the Tenant.

Click :guilabel:`Finish` to close the :guilabel:`Create Tenant` modal and
return to the :guilabel:`Cluster` view.

9) Monitor Tenant Creation
--------------------------

You can monitor the Tenant creation from the :guilabel:`Tenants` subsection
of the :guilabel:`MinIO` section of the cluster :guilabel:`Configure` tab.

IMAGE

The :guilabel:`Current State` describes the stage of Tenant deployment. The 
cluster :guilabel:`Tasks` view provides a more granular view of MinIO as it
creates the required resources for the Tenant.

When the :guilabel:`Current State` reads as <TODO>, the Tenant is ready to
access.

10) Connect to your Tenant
--------------------------

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
self-signed certificates, and may be required for Tenants created using
:ref:`Autocert <minio-vmware-create-security>` TLS certificate generation.