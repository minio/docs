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
#. The MinIO Subscription Network, |subnet-short|, provides either 24 hour or 1 hour :abbr:`SLA (Service Level Agreement)` depending on subscription level.
   
   For current licensing levels and pricing, refer to the |SUBNET| page.

.. _minio-docs-subnet:

SUBNET
------

SUBNET delivers 24/7/365 Direct-to-engineer support through a MinIO-built portal that blends the best of Slack and Zendesk.

Features of SUBNET include:

- Security and architecture reviews (depending on :abbr:`SLA (Service Level Agreement)`)
- Access to Panic Button (depending on :abbr:`SLA (Service Level Agreement)`)
- Secure communication channel to exchange logs and software binaries
- Unlimited seats for your team
- Unlimited issues

For more information, see details at the |SUBNET| page.

Registering Your MinIO Deployment with SUBNET
---------------------------------------------

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

      Refer to :mc:`mc license register` for instructions.

      For clusters without direct Internet access, refer to the instructions in the :ref:`airgap example <minio-license-register-airgap>` of the :mc:`mc license register` documentation.


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

Logs
----

Use the subcommands for ``mc support logs`` to :mc:`~mc support logs enable` or :mc:`~mc support logs disable` the submission of MinIO logs to SUBNET.
You can also use :mc:`mc support logs status` to check if a log submission is in progress.

Use :mc:`mc support logs show` command to display logs from the command line.
Use the parameter flags for the :mc:`mc support logs show` command to limit the displayed logs by type or quantity.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/troubleshooting/encrypting-files