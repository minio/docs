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

.. image:: /images/minio-console/minio-console.png
   :width: 600px
   :alt: MinIO Console Landing Page provides a view of Buckets on the deployment
   :align: center

You can use the MinIO Console for administration tasks like Identity and 
Access Management, Metrics and Log Monitoring, or Server Configuration.

The MinIO Console is embedded as part of the MinIO Server binary starting 
with :minio-release:`RELEASE.2021-07-08T01-15-01Z`. You can also deploy a 
standalone MinIO Console using the instructions in the 
:minio-git:`github repository <console>`.

You can explore the Console using https://play.min.io:9443. Log in with
the following credentials:

- Username: ``Q3AM3UQ867SPQQA43P2F``
- Password: ``zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG``

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
         as a :rfc:`Subject Alternative Name <5280#section-4.2.1.6>` (SAN). 
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
:mc-cmd:`minio server --console-address` commandline option when starting 
each MinIO Server in the deployment. 

For example, the following command starts a distributed MinIO deployment using
a static port assignment of ``9001`` for the MinIO Console. This deployment
would respond to S3 API operations on the default MinIO server port ``:9000``
and browser access on the MinIO Console port ``:9001``.

.. code-block:: shell
   :class: copyable

   minio server https://minio-{1...4}.example.net/mnt/drive-{1...4} \
         --console-address ":9001"

Deployments behind network routing components which require static ports for 
routing rules may require setting a static MinIO Console port. For example,
load balancers, reverse proxies, or Kubernetes ingress may by default block
or exhibit unexpected behavior with the the dynamic redirection behavior.

.. _minio-console-admin-buckets:

Buckets
-------

.. image:: /images/minio-console/console-object-browser.png
   :width: 600px
   :alt: MinIO Console Object Browser
   :align: center

The Console :guilabel:`Object Browser` section displays all buckets and objects to which the authenticated user has :ref:`access <minio-policy>`.

Use the :guilabel:`Search` bar to search for specific buckets or objects.
Select the row for the bucket or object to browse. 

Select :guilabel:`Create Bucket` to create a new bucket on the deployment.
MinIO recommends no more than 500,000 buckets per deployment.

Each bucket has :guilabel:`Manage` and :guilabel:`Browse` buttons.

- Select :guilabel:`Manage` to open the management interface for the bucket:

   Some management features may not be available if the authenticated user does not have the :ref:`required administrative permissions <minio-policy-mc-admin-actions>`.

   The :guilabel:`Summary` view displays a summary of the bucket's configuration.

   The :guilabel:`Events` view supports configuring :ref:`notification events <minio-bucket-notifications>` using a configured notification target.

   The :guilabel:`Replication` view supports creating and managing :ref:`Server Side Bucket Replication Rules <minio-bucket-replication-serverside>`.

   The :guilabel:`Lifecycle` view supports creating and managing :ref:`Object Lifecycle Management Rules <minio-lifecycle-management>` for the bucket.

   The :guilabel:`Access Audit` view displays all :ref:`policies <minio-policy>` and :ref:`users <minio-users>` with access to that bucket.

   The :guilabel:`Access Rules` view supports creating and managing anonymous bucket policies to attach to the bucket or bucket prefix.
   Anonymous rules allow clients to access the bucket or prefix without explicitly authenticating with user credentials.

- Select :guilabel:`Browse` to view the contents of the bucket. 
  You can view and download individual objects, upload new objects, or use the :guilabel:`Rewind` function to view only those :ref:`versions <minio-bucket-versioning>` of an object which existed at the selected timestamp.

.. _minio-console-user-access-keys:

Access Keys
-----------

.. image:: /images/minio-console/console-access-keys.png
   :width: 600px
   :alt: MinIO Console Access Keys
   :align: center

The :guilabel:`Access Keys` section displays all :ref:`minio-id-access-keys` associated to the authenticated user. 

Access Keys support providing applications authentication credentials which inherit permissions from the "parent" user.

For deployments using an external identity manager such as Active Directory or an OIDC-compatible provider, access keys provide a way for users to create long-lived credentials.

- You can select the access key row to view its custom policy, if one exists.

   You can create or modify the policy from this screen.
   Access key policies cannot exceed the permissions granted to the parent user.

- You can create a new access key by selecting :guilabel:`Create access key`.

   The Console auto-generates an access key and password.
   You can select the eye :octicon:`eye` icon on the password field to reveal the value.
   You can override these values as needed.

   You can set a custom policy for the access key that further restricts the permissions granted to users authenticating with that key.
   Select :guilabel:`Restrict beyond user policy` to open the policy editor and modify as necessary.

   Ensure you have saved the access key password to a secure location before selecting :guilabel:`Create` to create the access key.
   You cannot retrieve or reset the password value after creating the access key.

   To rotate credentials for an application, create a new access key and delete the old one once the application updates to using the new credentials.

Identity
--------

The :guilabel:`Identity` section provides a management interface for :ref:`MinIO-Managed users <minio-users>`.

The section contains the following subsections.
Some subsections may not be visible if the authenticated user does not have the :ref:`required administrative permissions <minio-policy-mc-admin-actions>`.

.. tab-set::

   .. tab-item:: Users

      .. image:: /images/minio-console/console-users.png
         :width: 600px
         :alt: MinIO Console Manage Users
         :align: center

      The :guilabel:`Users` section displays all MinIO-managed  :ref:`users <minio-users>` on the deployment.

      This section is not visible for deployments using an external identity manager such as Active Directory or an OIDC-compatible provider.

      - Select :guilabel:`Create User` to create a new MinIO-managed user. 
        
        You can assign :ref:`groups <minio-groups>` and :ref:`policies <minio-policy>` to the user during creation.

      - Select a user's row to view details for that user.
        
        You can view and modify the user's assigned :ref:`groups <minio-groups>` and :ref:`policies <minio-policy>`.
        
        You can also view and manage any :ref:`Access Keys <minio-idp-service-account>` associated to the user.

   .. tab-item:: Groups

      .. image:: /images/minio-console/console-groups.png
         :width: 600px
         :alt: MinIO Console Manage Groups
         :align: center

      The :guilabel:`Groups` section displays all :ref:`groups <minio-groups>` on the MinIO deployment. 

      This section is not visible for deployments using an external identity manager such as Active Directory or an OIDC-compatible provider.

      - Select :guilabel:`Create Group` to create a new MinIO Group. 
        
        You can assign new users to the group during creation.

        You can assign policies to the group after creation.

      - Select the group row to open the details for that group.

        You can modify the group membership from the :guilabel:`Members` view.
        
        You can modify the group's assigned policies from the :guilabel:`Policies` view.

      Changing a user's group membership modifies the policies that user inherits. See :ref:`minio-access-management` for more information.

   .. tab-item:: Policies

      .. image:: /images/minio-console/console-policies.png
         :width: 600px
         :alt: MinIO Console Manage Policies
         :align: center

      The :guilabel:`Policies` section displays all :ref:`policies <minio-policy>` on the MinIO deployment. 
      The Policies section allows you to create, modify, or delete policies.

      :ref:`Policies <minio-policy>` define the authorized actions and resources to which an authenticated user has access.
      Each policy describes one or more actions a user, group of users, or access key can perform or conditions they must meet.

      The policies are JSON formatted text files compatible with Amazon AWS Identity and Access Management policy syntax, structure, and behavior.
      Refer to :ref:`Policy Based Action Control <minio-policy>` for details on managing access in MinIO with policies.

      This section or its contents may not be visible if the authenticated user does not have the :ref:`required administrative permissions <minio-policy-mc-admin-actions>`.

      - Select :guilabel:`+ Create Policy` to create a new MinIO Policy.

      - Select the policy row to manage the policy details.

        The :guilabel:`Summary` view displays a summary of the policy.

        The :guilabel:`Users` view displays all users assigned to the policy.

        The :guilabel:`Groups` view displays all groups assigned to the policy.

        The :guilabel:`Raw Policy` view displays the raw JSON policy.

      Use the :guilabel:`Users` and :guilabel:`Groups` views to assign a created policy to users and groups, respectively.

.. _minio-console-monitoring:

Monitoring
----------

The :guilabel:`Monitoring` section provides an interface for monitoring the MinIO deployment.

The section contains the following subsections:
Some subsections may not be visible if the authenticated user does not have the :ref:`required administrative permissions <minio-policy-mc-admin-actions>`.

.. tab-set::

   .. tab-item:: Metrics

      .. image:: /images/minio-console/console-metrics-simple.png
         :width: 600px
         :alt: MinIO Console Metrics displaying point-in-time data
         :align: center

      The Console :guilabel:`Dashboard` section displays metrics for the MinIO deployment. 
      The default view provides a high-level overview of the deployment status, including the uptime and availability of individual servers and drives.

      The Console also supports displaying time-series and historical data by querying a :prometheus-docs:`Prometheus <prometheus/latest/getting_started/>` service configured to scrape data from the MinIO deployment. 
      Specifically, the MinIO Console uses :prometheus-docs:`Prometheus query API <prometheus/latest/querying/api/>` to retrieve stored metrics data and display historical metrics:

      .. image:: /images/minio-console/console-metrics.png
         :width: 600px
         :alt: MinIO Console Metrics displaying simplified data
         :align: center

      See :ref:`minio-console-metrics` for more information on the historical metric visualization.

   .. tab-item:: Logs

      .. image:: /images/minio-console/console-logs.png
         :width: 600px
         :alt: MinIO Console Logs displaying a list of server logs
         :align: center

      The Console :guilabel:`Logs` section displays :ref:`server logs <minio-logging>` generated by the MinIO Deployment.

      - Use the :guilabel:`Nodes` dropdown to filter logs to a subset of server nodes in the MinIO deployment.

      - Use the :guilabel:`Log Types` dropdown to filter logs to a subset of log types.

      - Use the :guilabel:`Filter` to apply text filters to the log results

      Select the :guilabel:`Start Logs` button to begin collecting logs using the selected filters and settings.

   .. tab-item:: Audit

      The Audit Log section provides an interface for viewing :ref:`audit logs <minio-logging>` collected by a configured PostgreSQL service.

      The Audit Logging feature is configured and enabled automatically for MinIO deployments created using the :ref:`MinIO Operator Console <minio-operator-console>`.

   .. tab-item:: Trace

      .. image:: /images/minio-console/console-trace.png
         :width: 600px
         :alt: MinIO Console Trace
         :align: center

      The :guilabel:`Trace` section provides HTTP trace functionality for a bucket or buckets on the deployment. 
      This section provides similar functionality to :mc:`mc admin trace`.

      You can modify the trace to show only specific trace calls.
      The default is to show only :guilabel:`S3` related HTTP traces.
      
      Select :guilabel:`Filters` to open additional filters to apply to trace output, such as restricting the :guilabel:`Path` on which the trace applies to a specific bucket or bucket prefix.

   .. tab-item:: Watch

      .. image:: /images/minio-console/console-watch.png
         :width: 600px
         :alt: MinIO Console Watch
         :align: center

      The :guilabel:`Watch` section displays S3 events as they occur on the selected bucket. 
      This section provides similar functionality to :mc:`mc watch`.

   .. tab-item:: Drives

      .. image:: /images/minio-console/console-drives.png
         :width: 600px
         :alt: MinIO Console Drive Health Status
         :align: center

      The :guilabel:`Drives` section displays the healing status for a bucket. 
      MinIO automatically heals objects and drives when it detects problems, such as drive-level corruption or a replacement drive.

      .. important::

         MinIO does not recommend performing manual healing unless explicitly directed by support. 

Notifications
-------------

The :guilabel:`Notifications` section provides an interface to view, add, or remove :ref:`Bucket Notification <minio-bucket-notifications>` targets.

You can use this screen configure MinIO to push notification events to the one or more target destinations, including Redis, MySQL, Kafka, PostgreSQL, AMQP, MQTT, Elastic Search, NATS, NSQ, or a Webhook.

Select the :guilabel:`Add Notification Target +` button to add a new target to the deployment.

You can select an existing notification target from the list to view its details or delete the target.

.. image:: /images/minio-console/console-add-notification-target.png
   :width: 600px
   :alt: The MinIO Console's Notification screen after selecting add new target that shows the types of destination targets users can add.
   :align: center

Tiers
-----

.. image:: /images/minio-console/console-settings-tiers.png
   :width: 600px
   :alt: MinIO Console Settings - Tiering
   :align: center

The :guilabel:`Tiers` section provides an interface for adding and managing :ref:`remote tiers <minio-lifecycle-management-tiering>` to support lifecycle management transition rules.

Select the :guilabel:`Create Tier +` button to add a new tier to the deployment.
Choose to add a MinIO, Google Cloud Storage, AWS S3, or Azure tier type.

Existing tiers display with details of their configuration and an icon showing their current online or offline status.

You can select an existing tier from the list to view its details or make changes.

Site Replication
----------------

.. image:: /images/minio-console/console-settings-site-replication.png
   :width: 600px
   :alt: MinIO Console Settings - Site Replication
   :align: center

The :guilabel:`Site Replication` section provides an interface for adding and managing the site replication configuration for the deployment.

Configuring site replication requires that only a single site have existing buckets or objects (if any).

Configuration
-------------
This section contains the following subsections.
Some subsections may not be visible if the authenticated user does not have the :ref:`required administrative permissions <minio-policy-mc-admin-actions>`.

.. image:: /images/minio-console/console-settings-configuration.png
   :width: 600px
   :alt: MinIO Console Settings - Configuration View
   :align: center

The :guilabel:`Configuration` section provides an interface for viewing and retrieving :ref:`configuration settings <minio-server-configuration-settings>` for all MinIO Servers in the deployment. 

The interface functionality mimics that of using :mc-cmd:`mc admin config get` or :mc-cmd:`mc admin config set`.
Refer to those commands for details on how to define the many options.

Some configuration settings may require restarting the MinIO deployment to apply changes.

Support
-------

The :guilabel:`Support` section provides an interface for generating health and performance reports.
Support functionality requires registering your deployment with |subnet|. 
Unregistered deployments display a :guilabel:`Register Your Cluster` button to register with your |subnet| account.
See the :guilabel:`License` section in the Console or visit the `MinIO SUBNET <https://min.io/pricing?jmp=docs>` website for more information on registration.

This section contains the following subsections.
Some subsections may not be visible if the authenticated user does not have the :ref:`required administrative permissions <minio-policy-mc-admin-actions>`.

.. tab-set::

   .. tab-item:: Health

      .. image:: /images/minio-console/console-health.png
         :width: 600px
         :alt: MinIO Console - Health Diagnostics
         :align: center

      The :guilabel:`Health` section provides an interface for running a health diagnostic for the MinIO Deployment.
      
      The resulting health report is intended for use by MinIO Engineering via |subnet| and may contain internal or private data points such as hostnames.
      Exercise caution before sending a health report to a third party or posting the health report in a public forum.

   .. tab-item:: Performance

      .. image:: /images/minio-console/console-performance.png
         :width: 600px
         :alt: MinIO Console - Performance Tests
         :align: center

      The :guilabel:`Performance` section provides an interface for running a performance test of the deployment.
      The resulting test can provide a general guideline of deployment performance under S3 ``GET`` and ``PUT`` requests.

      For more complete performance testing, consider using a combination of load-testing using your staging application environments and the MinIO :minio-git:`WARP <warp>` tool.

   .. tab-item:: Profile

      .. image:: /images/minio-console/console-profile.png
         :width: 600px
         :alt: MinIO Console - Profile Tests
         :align: center

      The :guilabel:`Profile` section provides an interface for running system profiling of the deployment.
      The results can provide insight into the MinIO server process running on a given node.

      The resulting report is intended for use by MinIO Engineering via |subnet|.
      Independent or third-party use of these profiles for diagnostics and remediation is done at your own risk.

   .. tab-item:: Inspect

      .. image:: /images/minio-console/console-inspect.png
         :width: 600px
         :alt: MinIO Console - Inspect an Object
         :align: center

      The :guilabel:`Inspect` section provides an interface for capturing the erasure-coded metadata associated to an object or objects.
      MinIO Engineering may request this output as part of diagnostics in |subnet|.


      The resulting object may be read using MinIO's :minio-git:`debugging tool <minio/tree/master/docs/debugging#decoding-metadata>`. 
      Independent or third-party use of the output for diagnostics or remediation is done at your own risk.
      You can optionally encrypt the object such that it can only be read if the generated encryption key is included as part of the debugging toolchain.

License
-------

The :guilabel:`License` section displays information on the licensing status of the MinIO deployment.

For deployments not registered via |subnet|, the Console displays a table comparison of MinIO License and Support plans:

.. image:: /images/minio-console/console-license.png
   :width: 600px
   :alt: MinIO Console - License Plans
   :align: center

Existing customers can register the deployment with their |subnet| account by clicking :guilabel:`Register this cluster` in the top-right corner of the screen.

MinIO is Open Source software under the :minio-git:`GNU AGPLv3 license <mc/blob/master/LICENSE>`.
Applications using MinIO should follow local laws and regulations around licensing to ensure compliance with the AGPLv3 license, which may include open sourcing the application stack.

Proprietary application stacks can register for either the SUBNET :guilabel:`Standard` or :guilabel:`Enterprise` License and Support plan to use MinIO under a commercial license.

Documentation
-------------

The :guilabel:`Documentation` tab opens this documentation site in a separate browser window or tab.
