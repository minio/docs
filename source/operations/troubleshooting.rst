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
#. Paid subscribers have access to the MinIO Subscription Network, |subnet-short|, which provides a :abbr:`SLA (Service Level Agreement)` based on subscription, typically 48 hours.
   
   For current licensing levels and pricing, refer to the |SUBNET| page.

Tools
-----

The :ref:`MinIO Client <minio-client>` provides several functions to display information about your MinIO deployment or monitor its activity.

- For basic information about your MinIO deployment, use :mc-cmd:`mc admin info`.

- For deeper investigation of S3 calls and responses, use :mc-cmd:`mc admin trace`.

- Use :mc:`mc admin logs` to display logs from the command line.
  The command supports type and quantity filters for further limiting logs output.

Upgrades and version support
----------------------------

MinIO regularly releases updates to introduce features, improve performance, address security concerns, or fix bugs. 
These releases can occur very frequently, and vary by product.

Always test software releases in a development environment before upgrading on a production deployment.

Recommended upgrade schedule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO recommends always installing the most recent release to obtain the security enhancements and improvements.
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