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
     - System administrator access to the remote servers

   * - :octicon:`circle`
     - A management tool for distributed systems, such as Ansible, Terraform, or Kubernetes for orchestrated environments.
       Kubernetes infrastructures should use the MinIO Operator for best results.

   * - :octicon:`circle`
     - Load balancer to handle routing of requests (for example, `NGINX <https://www.nginx.com/>`__)

   * - :octicon:`circle`
     - :ref:`Prometheus / Grafana <minio-metrics-collect-using-prometheus>` setup for monitoring and metrics

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

3rd Party Identity Provider Tasks
---------------------------------

.. list-table::
   :widths: auto
   :width: 100%

   * - :octicon:`circle`
     - | Authenticate to MinIO with :ref:`Security Token Service (STS) <minio-security-token-service>`
       | Enabling this requires MinIO support.