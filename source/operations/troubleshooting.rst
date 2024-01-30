===============
Troubleshooting
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

MinIO users have two options for support.

#. Community support from the `public Slack channel <https://slack.min.io>`_.
   
   Community support is best-effort only and has no :abbr:`SLA (Service Level Agreement)` or :abbr:`SLO (Service Level Objective)`.
#. The MinIO Subscription Network, |subnet-short|, provides either 48 hour or 1 hour :abbr:`SLA (Service Level Agreement)` depending on subscription level.
   
   For current licensing levels and pricing, refer to the |SUBNET| page.

.. _minio-docs-subnet:

SUBNET
------

SUBNET delivers 24/7/365 Direct-to-engineer support through a MinIO-built portal that blends the chat features of common communication tools with the support features of standard support platforms.

Features of SUBNET include:

- Security and architecture reviews (depending on :abbr:`SLA (Service Level Agreement)`)
- Access to Panic Button, which provides immediate response to critical issues (depending on :abbr:`SLA (Service Level Agreement)`)
- Secure communication channel to exchange logs and software binaries
- Unlimited seats for your team
- Unlimited issues

For more information, see details at the |SUBNET| page.

Registering Your MinIO Deployment with SUBNET
---------------------------------------------

Starting with :minio-release:`RELEASE.2023-04-07T05-28-58Z`, the Console prompts you to restart the deployment after registering with SUBNET.
You can restart through the Console by selecting :guilabel:`Restart` in the top banner or by using :mc-cmd:`mc admin service restart`. 
 
.. tab-set::

   .. tab-item:: Console

      You can register for SUBNET from the MinIO Console.

      #. Go to your MinIO cluster's URL, then sign in
      #. Select the :guilabel:`Support` option
      #. Select :guilabel:`Register`
      #. Select the tab with the method to use to register:

         - :guilabel:`Credentials` tab to use your MinIO SUBNET username and password
         - :guilabel:`API Key` tab to input an API key you already have or obtain one directly from SUBNET
         - :guilabel:`Airgap` tab for a token and instructions to register a deployment that does not have direct connection to the Internet and/or SUBNET

   .. tab-item:: Console Airgapped

      Use the steps below to register MinIO deployments that do not have direct Internet access.
      For example, deployments that exist with an airgap, behind a firewall, or in other environments with no direct Internet access.
      
      From the Console:

      #. Go to your MinIO cluster's URL, then sign in
      #. Select the :guilabel:`Support` tab, then select :guilabel:`Health`
      #. Select :guilabel:`Register your Cluster`
      #. Select the :guilabel:`Airgap` tab
      #. Copy the provided link, which includes a token value for the deployment
      #. Paste the link into a web browser on a device with access to the Internet
      #. After successful registration, copy the provided API key
      #. In the MinIO Console, select the :guilabel:`API Key` tab
      #. Paste the copied API key from SUBNET into the :guilabel:`API Key` field, then select :guilabel:`Register`

   .. tab-item:: Command Line

      You can register for SUBNET from the command line.

      .. important:: 
      
         ``mc license register`` requires :ref:`MinIO Client <minio-client>` version ``RELEASE.2023-11-20T16-30-59Z`` or later and MinIO Server ``RELEASE.2023-11-20T22-40-07Z`` or later.
         Use a MinIO Client version no older than your MinIO Server. For example, a MinIO Client released the same day or later than your MinIO Server version.

         If you are unable to upgrade the MinIO Client to the required or later version, register using the Console instead.

      Refer to :mc:`mc license register` for instructions.

      For clusters without direct Internet access, refer to the instructions in the :ref:`airgap example <minio-license-register-airgap>` of the :mc:`mc license register` documentation.

      The airgap registration process works with MinIO Client version ``RELEASE.2022-07-29T19-17-16Z`` or later.
      Earlier versions of the MinIO Client cannot register an airgapped deployment.

.. _minio-subnet-license-file-download:

Download License File
~~~~~~~~~~~~~~~~~~~~~

Download the license file from SUBNET on a machine with access to the Internet.
   
#. Log in to |SUBNET|
#. Go to the :guilabel:`Deployments` tab
#. Select the :guilabel:`License` button near the top of the page on the right side of the account statistics information box to display the :guilabel:`Account License`
#. Select :guilabel:`Download`

SUBNET Issues
-------------

Use SUBNET issues to engage support from MinIO engineering.

#. Log in to https://subnet.min.io
#. Select the :guilabel:`Issues` section

Use the search bar to locate an existing issue or add a new issue.

.. image:: /images/subnet/issues-section.png
   :width: 600px
   :alt: MinIO SUBNET with the Issues section displaying a list of an organization's issues
   :align: center

Select an existing issue from the list to expand the conversation or add a response.

.. image:: /images/subnet/issue-expanded.png
   :width: 600px
   :alt: A example MinIO SUBNET issue conversation
   :align: center

Reviewing Health Data in SUBNET
-------------------------------

SUBNET provides health data about the clusters registered to the organization from the :guilabel:`Deployments` section.

The view shows the total size of the org's MinIO clusters with details for each cluster.

.. image:: /images/subnet/deployments-overview.png
   :width: 600px
   :alt: MinIO SUBNET displaying the deployments overview
   :align: center

Each of the organization's clusters display below the summary data.
Select a deployment row to view additional health details.

Deployment Health
~~~~~~~~~~~~~~~~~

The deployment's details include a summary of the deployment's configuration and the number of checks run and failed.
You can select :guilabel:`Upload` to add diagnostic health data obtained from the :mc:`mc support diag` command or the MinIO Console's :guilabel:`Support > Health` page.

You can also use the :ref:`Call Home <minio-troubleshooting-call-home>` functionality to automatically run and upload a diagnostic health report.

If you need support from MinIO Engineering, you can create a :guilabel:`New Issue` for the deployment.

.. image:: /images/subnet/SUBNET-deployment-health-summary.png
   :width: 600px
   :alt: MinIO SUBNET displaying health summary information for a myminio deployment
   :align: center

SUBNET displays health checks for data points such as CPU, drives, memory, network, and security.

Failed checks display first.
Checks with warnings display after failed checks.
Checks that pass display last.

Select any failed or warned checks to display the JSON output for additional details.
You can scroll vertically through the output for the selected check.

.. image:: /images/subnet/deployment-health-tls-config-fail.png
   :width: 600px
   :alt: MinIO SUBNET's health report for a deployment showing a failed Health Report with details expanded
   :align: center

Logs
----

Use :mc:`mc admin logs` command to display logs from the command line.
The command supports type and quantity filters for further limiting logs output.

Optionally, use :ref:`Call Home <minio-troubleshooting-call-home>` to start automatically uploading real time error logs to SUBNET for analysis.

.. _minio-troubleshooting-call-home:

Call Home
---------

.. versionadded:: minio RELEASE.2022-11-17T23-20-09Z
   and mc RELEASE.2022-12-02T23-48-47Z

MinIO's opt-in Call Home service automates the collection and uploading of diagnostic data or error logs to SUBNET.
Call Home requires the cluster to have both an active SUBNET registration and reliable access to the internet.

.. important:: 

   Call Home does not work for airgapped deployments.

When enabled, Call Home can upload one or both of:

- error logs in real time
- a new diagnostic report every 24 hours

Once uploaded, you can view the diagnostic report results or logs through SUBNET as described above, but without the need to manually upload the data yourself.
Making these records automatically available in SUBNET simplifies visibility into cluster health and functionality.
If you submit an issue for support help from the MinIO engineers, the engineers have immediate access to the errors and/or logs you have uploaded.

Diagnostic Report
~~~~~~~~~~~~~~~~~

The diagnostic report upload happens every 24 hours from the time you enable Call Home.
If you restart all nodes on the deployment after enabling Call Home, the upload happens every 24 hours from the deployment restart.

.. important::

   The diagnostic report does **not** collect or upload any personally identifiable information.

The report includes information such as:

- System settings, services, and configurations that might impact performance
- TLS certificate status, validity, expiration, and algorithm type information
- CPU core count and information
- Drive count, status, size, and available space
- Cluster size server count
- File system type
- Memory size and type
- OS symmetry and Linux kernel version
- Internode latency
- NTP synchronization
- Available resources
- MinIO version

Error Logs
~~~~~~~~~~

When the MinIO Server encounters an error, it writes it to a log.
These logs can upload in real time to SUBNET, where you or MinIO engineers can view the errors.

Enabling or Disabling Call Home
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Call Home is **disabled** by default.
You can :mc-cmd:`~mc support callhome enable` and :mc-cmd:`~mc support callhome disable` Call Home functionality at any time using the MinIO Client's :mc:`mc support callhome` commands.
The command and its subcommands allow you to enable Call Home uploads for only the diagnostics, only the error logs, or both.
Refer to the documentation on the commands for more details.

Use :mc-cmd:`mc support callhome status` to check the status of an upload.

Uploading Data to SUBNET
------------------------

If you registered the cluster with SUBNET, Performance and Inspection files can automatically upload to SUBNET.

For clusters with an airgap, firewall, or otherwise blocked from SUBNET directly, you can manually upload files to SUBNET after logging in.

#. Generate the file(s) to upload from the command line with :mc:`mc support diag` or :mc:`mc support inspect`
#. Sign in to `SUBNET <https://subnet.min.io>`_
#. Select :guilabel:`Deployments`
#. Select :guilabel:`Diagnostics`
#. Drag and drop the ``.gzip`` file(s) or browse to the file location to upload

Encrypting Data
~~~~~~~~~~~~~~~

Data from the Inspect tool in :ref:`Console <minio-console>` or the :mc:`mc support inspect` command can be encrypted.
For more details about encrypting or decrypting such files, see :ref:`Encrypting Files <minio-support-encryption>`.

Upgrades and Version Support
----------------------------

MinIO regularly releases updates to introduce features, improve performance, address security concerns, or fix bugs. 
These releases can occur very frequently, and vary by product.

Always test software releases in a development environment before upgrading on a production deployment.

Active Support Periods
~~~~~~~~~~~~~~~~~~~~~~

Version support varies by the `license <https://min.io/pricing?ref=docs>`_ used for the deployment.

.. list-table:: 
   :header-rows: 1
   :widths: 30 70
   :width: 100%  

   * - License
     - Support length 

   * - AGPLv3
     - Most recent release

   * - MinIO Standard
     - 1 year long term support of any release

   * - MinIO Enterprise
     - 5 year long term support of any release, SUBNET support for upgrade guidance and recommendations

Recommended Upgrade Schedule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO recommends always installing the most recent release to obtain the latest features, security enhancements, and performance improvements.
We recognize that such a frequent release schedule may make this impractical for some organizations.
In such cases, we recommend using MinIO and our related product releases that are no older than six months.

Version Alignment
~~~~~~~~~~~~~~~~~

As the various MinIO products release separately on their own schedules, we recommend the following version alignment practices:

MinIO
   Update to the latest release or a release no older than six months.

MinIO Client
   Update to the `mc` release that occurs immediately after the MinIO release, within one or two weeks.

MinIO Operator
   Use a MinIO version no earlier than the latest at the time of the Operator release.
   The MinIO version latest at time of release can be found in the quay.io link in the example tenant kustomization yaml file for the Operator release.

   - 4.5.5: MinIO RELEASE.2022-12-07T00-56-37Z or later
   - 4.5.6: MinIO RELEASE.2023-01-02T09-40-09Z or later
   - 4.5.7: MinIO RELEASE.2023-01-12T02-06-16Z or later
   - 4.5.8: MinIO RELEASE.2023-01-12T02-06-16Z or later

   When creating a new tenant, the Operator uses either the latest available MinIO release image or the image you specify when creating the tenant.
   
   :ref:`Upgrading the Operator <minio-k8s-upgrade-minio-operator>` does **not** automatically upgrade existing tenants.
   :ref:`Upgrade existing tenant <minio-k8s-upgrade-minio-tenant>` MinIO versions separately.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/troubleshooting/encrypting-files