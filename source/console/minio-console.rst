.. _minio-console:

=============
MinIO Console
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


The MinIO Console is a rich graphical user interface that provides similar
functionality to the :mc:`mc` command line tool.

.. image:: /images/minio-console/console-dashboard.png
   :width: 600px
   :alt: MinIO Console Dashboard displaying Monitoring Data
   :align: center

You can use the MinIO Console for administration tasks like Identity and 
Access Management, Metrics and Log Monitoring, or Server Configuration.

The MinIO Console is embedded as part of the MinIO Server binary starting 
with :minio-release:`RELEASE.2021-07-08T01-15-01Z`. You can also deploy a 
standalone MinIO Console using the instructions in the 
:minio-git:`github repository <console>`.

You can explore the Console using https://play.min.io:9443. Log in with
the following credentials:

- Access Key: ``Q3AM3UQ867SPQQA43P2F``
- Secret Key: ``zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG``

The Play Console connects to the MinIO Play deployment at https://play.min.io.
You can also access this deployment using :mc:`mc` and using the ``play``
alias.

This page documents the high level configuration settings and features of the 
MinIO Console.

Configuration
-------------

The MinIO Console inherits the majority of its configuration settings from the
MinIO Server. The following environment variables enable specific behavior in
the MinIO Console:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Environment Variable
     - Description

   * - :envvar:`MINIO_PROMETHEUS_URL`
     - The URL for a Prometheus server configured to scrape metrics from the 
       MinIO deployment. The MinIO Console uses this server for populating the
       metrics dashboard.

       See :ref:`minio-metrics-collect-using-prometheus` for a tutorial on 
       configuring Prometheus to collect metrics from MinIO.

   * - :envvar:`MINIO_SERVER_URL`
     - The URL hostname the MinIO Console uses for connecting to the MinIO 
       Server. The hostname *must* be resolveable and reachable for the
       Console to function correctly.

       The MinIO Console connects to the MinIO Server using an IP 
       address by default. For example, when the MinIO Server starts up, 
       the server logs include a line 
       ``API: https://<IP ADDRESS 1> https://<IP ADDRESS 2>``.
       The MinIO Console defaults to connecting using ``<IP ADDRESS 1>``.

       The MinIO Console may require setting this variable in the following 
       scenarios:
       
       - The MinIO server TLS certificates do not include the local IP address
         as a :rfc:`Subject Alternative Name <rfc5280#section-4.2.1.6>` (SAN). 
         Specify a hostname contained in the TLS certificate to allow the MinIO 
         Console to validate the TLS connection.

       - The MinIO server's local IP address is not reachable by the MinIO
         Console. Specify a resolveable hostname for the MinIO Server.

       - A load balancer or reverse proxy controls traffic to the MinIO server,
         such that the MinIO Console cannot reach the server without going
         through the load balancer/proxy. Specify the load balancer/proxy 
         URL for the MinIO server.

   * - :envvar:`MINIO_BROWSER_REDIRECT_URL`
     - The externally resolvable hostname for the MinIO Console used by the 
       configured :ref:`external identity manager 
       <minio-authentication-and-identity-management>` for returning the
       authentication response.

       This variable is typically necessary when using a reverse proxy, 
       load balancer, or similar system to expose the MinIO Console to the 
       public internet. Specify an externally reachable hostname that resolves
       to the MinIO Console.

Static vs Dynamic Port Assignment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO by default selects a random port for the MinIO Console on each server
startup. Browser clients accessing the MinIO Server are automatically 
redirected to the MinIO Console on its dynamically selected port. 
This behavior emulates the legacy web browser behavior while reducing the
the risk of a port collision on systems which were running MinIO *before* the 
embedded Console update.

You can select an explicit static port by passing the 
:mc-cmd-option:`minio server console-address` commandline option when starting 
each MinIO Server in the deployment. 

For example, the following command starts a distributed MinIO deployment using
a static port assignment of ``9001`` for the MinIO Console. This deployment
would respond to S3 API operations on the default MinIO server port ``:9000``
and browser access on the MinIO Console port ``:9001``.

.. code-block:: shell
   :class: copyable

   minio server https://minio-{1...4}.example.net/mnt/disk-{1...4} \
         --console-address ":9001"

Deployments behind network routing components which require static ports for 
routing rules may require setting a static MinIO Console port. For example,
load balancers, reverse proxies, or Kubernetes ingress may by default block
or exhibit unexpected behavior with the the dynamic redirection behavior.

Dashboard
---------

.. image:: /images/minio-console/console-dashboard.png
   :width: 600px
   :alt: MinIO Console Dashboard displaying Monitoring Data
   :align: center

The Console :guilabel:`Dashboard` section displays metrics for the MinIO
deployment. This view requires configuring a Prometheus service to scrape the
deployment metrics. See :ref:`minio-metrics-collect-using-prometheus` for
complete instructions.

User: Object Browser
--------------------

.. image:: /images/minio-console/console-object-browser.png
   :width: 600px
   :alt: MinIO Console Object Browser
   :align: center

The Console :guilabel:`Object Browser` section displays all buckets and objects
to which the authenticated user has :ref:`access <minio-policy>`.

Use the :guilabel:`Search` bar to search for specific buckets or objects.
Select the row for the bucket or object to browse. 

Selecting an object provides information on that object, including the option to
download or delete that object.

Selecting a bucket provides the option to upload new objects to the bucket.

You can create a new bucket from the :guilabel:`All Buckets` view by
selecting :guilabel:`+ Create Bucket`.

User: Service Accounts
----------------------

.. image:: /images/minio-console/console-service-accounts.png
   :width: 600px
   :alt: MinIO Console Service Accounts
   :align: center

The :guilabel:`Accounts` section displays all :ref:`minio-idp-service-account`
associated to the authenticated user. Service accounts support providing
applications authentication credentials which inherit permissions from the
"parent" user. 

You can create new service accounts by seelcting 
:guilabel:`+ Create Service Account`. You can specify an inline 
:ref:`policy <minio-policy>` to further restrict the permissions of the new
service account.

.. image:: /images/minio-console/console-service-accounts-create.png
   :width: 600px
   :alt: MinIO Console Service Account Create
   :align: center

The Console only displays the service account credentials *once*. You cannot
change or retrieve the credentials later. To rotate credentials for an 
application, create a new service account and delete the old one once the 
application updates to using the new credentials.

Admin: Buckets
--------------

.. image:: /images/minio-console/console-bucket.png
   :width: 600px
   :alt: MinIO Console Bucket Management
   :align: center

The :guilabel:`Buckets` section displays all buckets to which the authenticated
user has access. 

.. image:: /images/minio-console/console-bucket-create-bucket.png
   :width: 600px
   :alt: MinIO Console Create Bucket
   :align: center

You can create new buckets by selecting :guilabel:`+ Create Bucket`.

You can select a bucket to view more specific details for that bucket:

.. image:: /images/minio-console/console-bucket-overview.png
   :width: 600px
   :alt: MinIO Console Create Bucket
   :align: center

- The :guilabel:`Summary` tab displays a summary of the bucket configuration.

- The :guilabel:`Events` tab supports configuring 
  :ref:`notification events <minio-bucket-notifications>` using a configured
  notification target.

- The :guilabel:`Replication` tab supports creating and managing 
  :ref:`Server Side Bucket Replication Rules
  <minio-bucket-replication-serverside>`. See
  :ref:`minio-bucket-replication-serverside-oneway` for more information on the
  requirements and process for enabling server-side bucket replication.

  You can activate a similar modal by selecting :guilabel:`+ Set Replication` 
  from the :guilabel:`Buckets` view with a bucket checkbox activated.

- The :guilabel:`Lifecycle` tab supports creating and managing 
  :ref:`Object Lifecycle Management Rules <minio-lifecycle-management>` for
  the bucket.

- The :guilabel:`Access Audit` tab provides a view of all 
  :ref:`policies <minio-policy>` and :ref:`users <minio-users>` with access
  to that bucket.

Admin: Users
------------

.. image:: /images/minio-console/console-users.png
   :width: 600px
   :alt: MinIO Console Manage Users
   :align: center

The :guilabel:`Users` section displays all MinIO-managed 
:ref:`users <minio-users>` on the deployment. This tab or its contents may
not be visible if the authenticated user does not have the 
:ref:`required administrative permissions <minio-policy-mc-admin-actions>`

Select :guilabel:`+ Create User` to create a new MinIO user. You can assign 
:ref:`groups <minio-groups>` to the user during creation.

.. image:: /images/minio-console/console-users-create.png
   :width: 600px
   :alt: MinIO Console Create Users
   :align: center

Select a user's row to view details for that user.

.. image:: /images/minio-console/console-users-details.png
   :width: 600px
   :alt: MinIO Console User Details
   :align: center

- The :guilabel:`Groups` tab displays all groups in which the user has 
  membership. You can add or remove assigned groups from this tab.

- The :guilabel:`Service Accounts` tab displays all 
  :ref:`service accounts <minio-idp-service-account>` for the user.

- The :guilabel:`Policies` tab displays all :ref:`policies <minio-policy>`
  attached to the user. You can add or remove assigned policies from this tab.

Admin: Groups
-------------

.. image:: /images/minio-console/console-groups.png
   :width: 600px
   :alt: MinIO Console Manage Groups
   :align: center

The :guilabel:`Groups` section displays all :ref:`groups <minio-groups>` on the
MinIO deployment. This tab or its contents may
not be visible if the authenticated user does not have the 
:ref:`required administrative permissions <minio-policy-mc-admin-actions>`

Select :guilabel:`+ Create Group` to create a new MinIO Group. You can assign
new users to the group during creation.

.. image:: /images/minio-console/console-groups-create-group.png
   :width: 600px
   :alt: MinIO Console Create Group
   :align: center

Select a group's row to view the user assignment for that group.

.. image:: /images/minio-console/console-groups-assign.png
   :width: 600px
   :alt: MinIO Console Assign Users to Group
   :align: center

Changing a user's group membership modifies the policies that user inherits.
See :ref:`minio-access-management` for more information.

Admin: IAM Policies
-------------------

.. image:: /images/minio-console/console-iam.png
   :width: 600px
   :alt: MinIO Console Manage IAM Policies
   :align: center

The :guilabel:`IAM Policies` section displays all :ref:`policies <minio-policy>`
on the MinIO deployment. This tab or its contents may
not be visible if the authenticated user does not have the 
:ref:`required administrative permissions <minio-policy-mc-admin-actions>`

Select :guilabel:`+ Create Policy` to create a new MinIO Policy.

.. image:: /images/minio-console/console-iam-create.png
   :width: 600px
   :alt: MinIO Console Create New Policy
   :align: center

Select a policy's row to view the details for that policy, including 
:ref:`user <minio-users>` and :ref:`group <minio-groups>` assignments:

.. image:: /images/minio-console/console-iam-details.png
   :width: 600px
   :alt: MinIO Console View Policy Details
   :align: center

- The :guilabel:`Details` tab displays the JSON document of the policy.

- The :guilabel:`Users` tab displays all users assigned the policy.

- The :guilabel:`Groups` tab displays all groups assigned the policy.

Admin: Settings
---------------

.. image:: /images/minio-console/console-settings.png
   :width: 600px
   :alt: MinIO Console Settings
   :align: center

The :guilabel:`Settings` displays 
:ref:`configuration settings <minio-server-configuration-settings>` for all
MinIO Servers in the deployment. This tab or its contents may
not be visible if the authenticated user does not have the 
:ref:`required administrative permissions <minio-policy-mc-admin-actions>`

The :guilabel:`Lambda Notifications` tab displays all configured 
:ref:`bucket notification targets <minio-bucket-notifications>` for the 
deployment. These targets support configuring bucket notification events.

.. image:: /images/minio-console/console-settings-lambda.png
   :width: 600px
   :alt: MinIO Console Settings Lambda Notifications
   :align: center

The :guilabel:`Tiers` tab displays all configured 
:ref:`remote tiers <minio-lifecycle-management-tiering>` on the deployment.
These tiers support transition lifecycle management rules.

.. image:: /images/minio-console/console-settings-tiers.png
   :width: 600px
   :alt: MinIO Console Settings Tiering
   :align: center

Tools: Watch
------------

.. image:: /images/minio-console/console-watch.png
   :width: 600px
   :alt: MinIO Console Watch
   :align: center

The :guilabel:`Watch` section displays S3 events as they occur on the selected
bucket. This section provides similar functionality to :mc:`mc watch`.

This tab or its contents may
not be visible if the authenticated user does not have the 
:ref:`required administrative permissions <minio-policy-mc-admin-actions>`

Tools: Trace
------------

.. image:: /images/minio-console/console-trace.png
   :width: 600px
   :alt: MinIO Console Trace
   :align: center

The :guilabel:`Trace` section provides HTTP trace functionality for a bucket
or buckets on the deployment. This section provides similar functionality to
:mc:`mc admin trace`.

This tab or its contents may
not be visible if the authenticated user does not have the 
:ref:`required administrative permissions <minio-policy-mc-admin-actions>`

Tools: Heal
-----------

.. image:: /images/minio-console/console-heal.png
   :width: 600px
   :alt: MinIO Console Healing
   :align: center

The :guilabel:`Heal` section displays the healing status for a bucket. 
MinIO automatically heals objects and drives when it detects problems, such
as drive-level corruption or a replacement drive.

MinIO does not recommend performing manual healing unless explicitly directed
by support. 

This tab or its contents may
not be visible if the authenticated user does not have the 
:ref:`required administrative permissions <minio-policy-mc-admin-actions>`

Tools: Diagnostics
------------------

.. image:: /images/minio-console/console-diagnostics.png
   :width: 600px
   :alt: MinIO Console Diagnostics
   :align: center

The :guilabel:`Diagnostic` section provides an interface for generating a 
diagnostic report for supporting `MinIO SUBNET 
<https://min.io/pricing?ref-docs>`__ support tickets.

The Diagnostic file contains configuration information about the deployment
and may therefore include private or confidential information about your
infrastructure. Do **not** share this information outside of
MinIO SUBNET. 
