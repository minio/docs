===================
``mc support diag``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support diag

Description
-----------

The :mc-cmd:`mc support diag` command generates a health report for a MinIO deployment.
For deployments registered with the MinIO subscription network (|subnet-short|), the command can automatically upload the health report for analysis.

The resulting health report is intended for use by MinIO Engineering via SUBNET and may contain internal or private data points.
Exercise caution before sending a health report to a third party or posting the health report in a public forum.

MinIO recommends that you run the health diagnostics when first provisioning the cluster and again at any failure scenario.

This diagnostic test runs as a one-shot test and can run for as long as 5 minutes.
During the test, MinIO freezes all S3 calls and queues read or write operations until the test completes.
The queue is limited based on the supported maximum concurrent :ref:`requests per host <minio-hardware-checklist-memory>`.
Requests that exceed this limit on a given host return a ``503`` error after ~10 seconds.

Use the :mc-cmd:`mc support diag` command to trigger the diagnostic test.
For clusters registered with SUBNET, the command uploads the results as part of SUBNET Health reports. 

For airgapped or firewalled environments, or other environments that prevent direct network access from the deployment, you can save the report locally with the :mc-cmd:`~mc support diag --airgap` flag.
After saving, you can then upload the results of the test to SUBNET manually.

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Sample Output
~~~~~~~~~~~~~

.. code-block:: shell

   ● Admin Info ... ✔ 
   ● CPU ... ✔ 
   ● Disk Hardware ... ✔ 
   ● Os Info ... ✔ 
   ● Mem Info ... ✔ 
   ● Process Info ... ✔ 
   ● Config ... ✔ 
   ● Drive ... ✔ 
   ● Net ... ✔ 
   *********************************************************************************
                                   WARNING!!
        ** THIS FILE MAY CONTAIN SENSITIVE INFORMATION ABOUT YOUR ENVIRONMENT ** 
        ** PLEASE INSPECT CONTENTS BEFORE SHARING IT ON ANY PUBLIC FORUM **
   *********************************************************************************
   mc: Health data saved to dc-11-health_20220511053323.json.gz

The gzipped output contains the requested health information.


Examples
--------

Generate Health Data for a Cluster and Automatically Upload to SUBNET
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generate health data for a MinIO cluster and automatically for a MinIO cluster at alias ``minio1`` for transmission to SUBNET.

.. code-block:: shell
   :class: copyable

   mc support diag minio1

The automatic upload of data only occurs for deployments registered with SUBNET using :mc-cmd:`mc license register`.

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


Syntax
------
      
The command has the following syntax:

.. code-block:: shell

   mc [GLOBALFLAGS] support diag       \
                            ALIAS      \
                            [--airgap] 


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

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
