.. _minio-operator:

=========================
MinIO Kubernetes Operator
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

The MinIO Kubernetes Operator ("MinIO Operator") brings native support for
deploying and managing MinIO deployments ("MinIO Tenant") on a Kubernetes
cluster. 

The MinIO Operator requires familiarity with interacting with a Kubernetes
cluster, including but not limited to using the ``kubectl`` command line tool
and interacting with Kubernetes ``YAML`` objects. Users who would prefer a more
simplified experience should use the :ref:`minio-kubernetes` for deploying
and managing MinIO Tenants.


Deploying the MinIO Operator
----------------------------

You can use :github:`kustomize <kubernetes-sigs/kustomize>` to deploy the
MinIO Operator to a Kubernetes cluster:

<Instructions to follow>

MinIO Tenant Object
-------------------

The following example Kubernetes object describes a MinIO Tenant with the
following resources:

- 4 :mc:`minio` server processes.
- 4 Volumes per server.
- 2 MinIO Console Service (MCS) proccesses.

.. ToDo : - 2 MinIO Key Encryption Service (KES) processes.

.. code-block:: yaml
   :class: copyable

   apiVersion: minio.min.io/v1
   kind: Tenant
   metadata:
     creationTimestamp: null
     name: minio-tenant-1
     namespace: minio-tenant-1
   scheduler:
     name: ""
   spec:
     certConfig: {}
     console:
       consoleSecret:
         name: minio-tenant-1-console-secret
       image: minio/console:v0.3.14
       metadata:
         creationTimestamp: null
         name: minio-tenant-1
       replicas: 2
       resources: {}
     credsSecret:
       name: minio-tenant-1-creds-secret
     image: minio/minio:RELEASE.2020-09-26T03-44-56Z
     imagePullSecret: {}
     liveness:
       initialDelaySeconds: 10
       periodSeconds: 1
       timeoutSeconds: 1
     mountPath: /export
     requestAutoCert: true
     serviceName: minio-tenant-1-internal-service
     zones:
     - resources: {}
       servers: 4
       volumeClaimTemplate:
         apiVersion: v1
         kind: persistentvolumeclaims
         metadata:
           creationTimestamp: null
         spec:
           accessModes:
           - ReadWriteOnce
           storageClassName: local-storage
           resources:
             requests:
               storage: 10Gi
         status: {}
       volumesPerServer: 4


MinIO Specification Syntax
--------------------------

The MinIO Operator adds a 
:kube-api:`CustomResourceDefinition 
<#customresourcedefinition-v1-apiextensions-k8s-io>` that extends the
Kubernetes Object API to support creating MinIO ``Tenant`` objects.

.. tabs::

   .. tab:: ``Tenant`` Object Overview

      The following ``YAML`` block describes a MinIO Tenant object and its
      top-level fields.

      .. code-block:: yaml

         apiVersion: minio.min.io/v1
         kind: Tenant
         metadata:
            name: minio
            labels:
               app: minio
            annotations:
               prometheus.io/path: <string>
               prometheus.io/port: "<string>"
               prometheus.io/scrape: "<bool>"
         spec:

            certConfig: <object>
            console: <object>
            credsSecret: <object>
            env: <object>
            externalCertSecret: <array>
            externalClientCertSecret: <object>
            image: minio/minio:latest
            imagePullPolicy: IfNotPresent
            kes: <object>
            mountPath: <string>
            podManagementPolicy: <string>
            priorityClassName: <string>
            requestAutoCert: <boolean>
            s3: <object>
            securityContext: <object>
            serviceAccountName: <string>
            subPath: <string>
            zones: <array>

      Select the
      :guilabel:`YAML Field Description` tab for a more detailed description of
      each field.


   .. tab:: YAML Field Description

      The following table describes each top-level field in the MinIO Tenant
      object.

      .. list-table::
         :header-rows: 1
         :widths: 30 10 60
         :width: 100%

         * - Field
           
           - | Required / 
             | Recommended / 
             | Optional

           - Description
         
         * - foo
           - bar
           - baz

      Select the :guilabel:`Tenant Object Description` tab
      for an example of the YAML object file.


Required Fields
~~~~~~~~~~~~~~~

Automatic TLS Certificate
~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO Console Service
~~~~~~~~~~~~~~~~~~~~~

MinIO Key Encryption Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Pod Management and Priority
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Security Context Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~







