.. _minio-software-checklists:

==================
Software Checklist
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Use the following checklist when planning the software configuration for a production, distributed MinIO deployment.

MinIO Pre-requisites
--------------------

.. list-table::
   :widths: auto
   :width: 100%

   * - :octicon:`circle`
     - Servers running a Linux operating system with a 5.x+ kernel, such as Red Hat Enterprise Linux (RHEL) 9 or Ubuntu LTS 20.04+

   * - :octicon:`circle`
     - A method to synchronize time servers across nodes, such as with ``ntp``, ``timedatectl`` or ``timesyncd``.
       The method to use varies by operating system.
       Check with your operating system's documentation for how to synchronize time with a time server.

   * - :octicon:`circle`
     - Disable system services that index, scan, or audit the filesystem, system-level calls, or kernel-level calls.
       These services can reduce performance due to resource contention or interception of MinIO operations.

       MinIO strongly recommends uninstalling or disabling the following services on hosts running MinIO:

       - ``mlocate`` or ``plocate``
       - ``updatedb``
       - ``auditd``
       - Crowdstrike Falcon
       - Antivirus software (``clamav``)
      
       The above list represents the most common services or softwares known to cause performance or behavioral issues with high performance systems like MinIO.
       Consider removing or disabling any other service or software which functions similarly to those listed above on MinIO hosts.

       Alternatively, configure these services to ignore or exclude the MinIO Server process and *all* drives or drive paths accessed by MinIO.

   * - :octicon:`circle` 
     - System administrator access to the remote servers

   * - :octicon:`circle`
     - A management tool for distributed systems, such as Ansible, Terraform, or Kubernetes for orchestrated environments.
       Kubernetes infrastructures should use the MinIO Operator for best results.

   * - :octicon:`circle`
     - Load balancer to handle routing of requests (for example, `NGINX <https://www.nginx.com/>`__)

   * - :octicon:`circle`
     - :ref:`Prometheus <minio-metrics-collect-using-prometheus>` or a Prometheus-compatible setup for monitoring and metrics

   * - :octicon:`circle`
     - :ref:`Grafana configured <minio-grafana>` for dashboards 

   * - :octicon:`circle` 
     - (optional) :mc:`mc` installed on the local host system


MinIO Install
-------------

Install the MinIO server binary across all nodes, ensuring that each node uses the same version of that binary.

.. cond:: linux

   See the :ref:`Multi Node Multi Drive deployment guide <minio-mnmd>` for more information.

.. cond:: container or macos or windows

   See the :ref:`Single Node Single Drive deployment guide <minio-snsd>` for more information.

.. cond:: k8s

   See the :ref:`Deploy MinIO Operator <minio-operator-installation>` and :ref:`Minio Tenant deployment guide <minio-k8s-deploy-minio-tenant>` for more information.


Post Install Tasks
------------------

.. list-table::
   :widths: auto
   :width: 100%

   * - :octicon:`circle` 
     - (optional) Create an :mc:`mc alias` for each server with :mc:`mc alias set` from your local machine for command line access to work with the MinIO deployment from a local machine

   * - :octicon:`circle`
     - Configure :ref:`Bucket replication <minio-bucket-replication-requirements>` to duplicate contents of a bucket to another bucket location

   * - :octicon:`circle`
     - Configure :ref:`Site replication <minio-site-replication-overview>` to synchronize contents of multiple dispersed data center locations

   * - :octicon:`circle`
     - Configure :ref:`Object retention rules with lifecycle management <minio-lifecycle-management>` to manage when objects should expire

   * - :octicon:`circle`
     - Configure :ref:`Object storage level rules with tiering <minio-lifecycle-management-tiering>` to move objects between hot, warm, and cold storage and maximize storage cost efficiencies

.. include:: /includes/common-admonitions.rst
   :start-after: start-exclusive-drive-access
   :end-before: end-exclusive-drive-access

3rd Party Identity Provider Tasks
---------------------------------

.. list-table::
   :widths: auto
   :width: 100%

   * - :octicon:`circle`
     - | Authenticate to MinIO with :ref:`Security Token Service (STS) <minio-security-token-service>`
       | Enabling this requires MinIO support.
