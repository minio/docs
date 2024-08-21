===================
``mc support diag``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support diag

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only


.. dropdown:: Command History

   The command used to create the diagnostic report has changed over time.

   .. list-table::
      :header-rows: 1
      :widths: 40 30 30
      :width: 100%
   
      * - MinIO Client Release
        - Command
        - Notes
   
      * - RELEASE.2022-02-13T23-26-13Z
        - ``mc support diag``
        - Command moved to ``mc support``
   
      * - RELEASE.2020-11-17T00-39-14Z 
        - ``mc admin subnet health``
        - Command made a SUBNET subcommand
   
      * - RELEASE.2020-10-03T02-54-56Z
        - ``mc admin health``
        - Command renamed to health
   
      * - Original Command
        - ``mc admin obd``
        - Command renamed ``mc admin health``


Description
-----------

.. start-mc-support-diag-desc

The :mc-cmd:`mc support diag` command generates a health report for a MinIO deployment.

.. end-mc-support-diag-desc

For deployments registered with the MinIO subscription network (|subnet-short|), the command generates and uploads the health report for analysis.
Optionally, automate generating and uploading the report every 24 hours by enabling :mc-cmd:`~mc support callhome`.

The resulting health report is intended for use by MinIO Engineering via SUBNET and may contain internal or private data points.
Exercise caution before sending a health report to a third party or posting the health report in a public forum.

MinIO recommends that you run the health diagnostics when first provisioning the cluster and again at any failure scenario.

Use the :mc-cmd:`mc support diag` command to trigger the diagnostic test.
For clusters registered with SUBNET, the command uploads the results as part of SUBNET Health reports. 

For airgapped or firewalled environments, or other environments that prevent direct network access from the deployment, you can save the report locally with the :mc-cmd:`~mc support diag --airgap` flag.
After saving, you can then upload the results of the test to SUBNET manually.


Sample Output
~~~~~~~~~~~~~

.. code-block:: shell

   ● CPU Info ... ✔ 
   ● Disk Info ... ✔ 
   ● Net Info ... ✔ 
   ● Os Info ... ✔ 
   ● Mem Info ... ✔ 
   ● Process Info ... ✔ 
   ● Server Config ... ✔ 
   ● System Errors ... ✔ 
   ● System Services ... ✔ 
   ● System Config ... ✔ 
   ● Admin Info ... ✔ 
   *********************************************************************************
                                   WARNING!!
        ** THIS FILE MAY CONTAIN SENSITIVE INFORMATION ABOUT YOUR ENVIRONMENT ** 
        ** PLEASE INSPECT CONTENTS BEFORE SHARING IT ON ANY PUBLIC FORUM **
   *********************************************************************************
   mc: MinIO diagnostics report saved to myminio-health_20231111053323.json.gz

The gzipped output contains the requested health information.


Examples
--------

Generate Health Data for a Cluster and Automatically Upload to SUBNET
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generate health data for a MinIO cluster and automatically for a MinIO cluster at alias ``minio1`` for transmission to SUBNET.

.. code-block:: shell
   :class: copyable

   mc support diag minio1

The automatic upload of data only occurs for deployments under a Commerical License.

.. _minio-support-diagnostics-airgap:

Generate Health Data for a Cluster to Upload Manually
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generate a diagnostic report for a MinIO deployment at alias ``minio2`` and save it for manual upload to SUBNET:

.. code-block:: shell
   :class: copyable

   mc support diag minio2 --airgap

#. Run the command to download the ``.gzip`` file
#. Login to https://subnet.min.io and select the :guilabel:`Deployments` section
#. Select the deployment for the report
#. Select the :guilabel:`Upload` button
#. Drag and drop the file or browse to the ``.gzip`` file location to upload it

Upload Data to SUBNET with Strict Anonymization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generates health data for a MinIO cluster at alias ``myminio`` and anonymizes all sensitive data, including host names.

.. code-block:: shell
   :class: copyable

   mc support diag myminio --anonymize=strict


Syntax
------
      
The command has the following syntax:

.. code-block:: shell

   mc [GLOBALFLAGS] support diag                   \
                            ALIAS                  \
                            [--airgap]             \
                            [--anonymize=<string>] \
                            [--api-key string]


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.

.. mc-cmd:: --airgap
   :optional:

   Use in environments without network access to SUBNET (for example, airgapped, firewalled, or similar configuration).
   Generates the diagnostic report and saves it to the location where you ran the command.

   You must manually upload the report to SUBNET.
   
   For instructions, see the :ref:`airgap example <minio-support-diagnostics-airgap>`.

   If the deployment is airgapped, but the local device where you are using the :ref:`minio client <minio-client>` has network access, you do not need to use the ``--airgap`` flag.

.. mc-cmd:: --anonymize

   .. versionadded:: mc RELEASE.2023-11-10T21-37-17Z

   MinIO anonymizes data loaded to SUBNET.
   Beginning with mc ``RELEASE.2023-11-10T21-37-17Z``, MinIO does *not* anonymize host names.
   This is the default ``standard`` anonymization mode.

   Valid values are ``=strict`` or ``=standard``.

   To anonymize all data, including host names, pass this parameter with the ``strict`` mode.

   .. code-block:: shell
      :class: copyable

      mc support diag minio --anonymize=strict

.. mc-cmd:: --api-key
   :optional:

   Takes the account's API key value from SUBNET.
   
   This value is only required for airgapped environments where MinIO has not already stored the API key for the deployment.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
