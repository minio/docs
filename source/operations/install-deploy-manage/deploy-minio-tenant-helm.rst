.. _deploy-tenant-helm:

======================================
Deploy a MinIO Tenant with Helm Charts
======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

Helm is a tool for automating the deployment of applications to Kubernetes clusters.
A `Helm chart <https://helm.sh/docs/topics/charts/>`__ is a set of YAML files, templates, and other files that define the deployment details.
The following procedure uses a Helm Chart to deploy a Tenant managed by the MinIO Operator.

This procedure requires the Kubernetes cluster have a valid :ref:`Operator <deploy-operator-kubernetes>` deployment.
You cannot use the MinIO Operator Tenant chart to deploy a Tenant independent of the Operator.

.. important::

   The MinIO Operator Tenant Chart is *distinct* from the community-managed :minio-git:`MinIO Chart <minio/tree/master/helm/minio>`.

   The Community Helm Chart is built, maintained, and supported by the community.
   MinIO does not guarantee support for any given bug, feature request, or update referencing that chart.

   The :ref:`Operator Tenant Chart <minio-tenant-chart-values>` is officially maintained and supported by MinIO.
   MinIO strongly recommends the official Helm Chart for :ref:`Operator <minio-operator-chart-values>` and :ref:`Tenants <minio-tenant-chart-values>` for production environments.

Prerequisites
-------------

You must meet the following requirements to install a MinIO Tenant with Helm:

- An existing Kubernetes cluster
- The ``kubectl`` CLI tool on your local host with version matching the cluster.
- `Helm <https://helm.sh/docs/intro/install/>`__ version 3.8 or greater.
- `yq <https://github.com/mikefarah/yq/#install>`__ version 4.18.1 or greater.
- An existing :ref:`MinIO Operator installation <deploy-operator-kubernetes>`.

This procedure assumes your Kubernetes cluster access grants you broad administrative permissions.

For more about Tenant installation requirements, including supported Kubernetes versions and TLS certificates, see the :ref:`Tenant deployment prerequisites <deploy-minio-distributed-prereqs-storage>`.

This procedure assumes familiarity the with referenced Kubernetes concepts and utilities.
While this documentation may provide guidance for configuring or deploying Kubernetes-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

Namespace
~~~~~~~~~

The tenant must use its own namespace with no other tenant.
MinIO strongly recommends using a dedicated namespace for the tenant with no other applications running in the namespace.

.. _deploy-tenant-helm-repo:

Deploy a MinIO Tenant using Helm Charts
---------------------------------------

The following procedure deploys a MinIO Tenant using the MinIO Operator Chart Repository.
This method supports a simplified installation path compared to the :ref:`local chart installation <deploy-tenant-helm-local>`.


The following procedure uses Helm to deploy a MinIO Tenant using the official MinIO Tenant Chart.

.. important::

   If you use Helm to deploy a MinIO Tenant, you must use Helm to manage or upgrade that deployment.
   Do not use ``kubectl krew``, Kustomize, or similar methods to manage or upgrade the MinIO Tenant.

This procedure is not exhaustive of all possible configuration options available in the :ref:`Tenant Chart <minio-tenant-chart-values>`.
It provides a baseline from which you can modify and tailor the Tenant to your requirements.

.. container:: procedure

   #. Verify your MinIO Operator Repo Configuration

      MinIO maintains a Helm-compatible repository at https://operator.min.io.
      If the repository does not already exist in your local Helm configuration, add it before continuing:

      .. code-block:: shell
         :class: copyable

         helm repo add minio-operator https://operator.min.io

      You can validate the repo contents using ``helm search``:

      .. code-block:: shell
         :class: copyable

         helm search repo minio-operator

      The response should resemble the following:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         NAME                            CHART VERSION   APP VERSION     DESCRIPTION                    
         minio-operator/minio-operator   4.3.7           v4.3.7          A Helm chart for MinIO Operator
         minio-operator/operator         |operator-version-stable|           v|operator-version-stable|          A Helm chart for MinIO Operator
         minio-operator/tenant           |operator-version-stable|           v|operator-version-stable|          A Helm chart for MinIO Operator

   #. Create a local copy of the Helm ``values.yaml`` for modification

      .. code-block:: shell
         :class: copyable

         curl -sLo values.yaml https://raw.githubusercontent.com/minio/operator/master/helm/tenant/values.yaml

      Open the ``values.yaml`` object in your preferred text editor.

   #. Configure the Tenant topology
      
      The following fields share the ``tenant.pools[0]`` prefix and control the number of servers, volumes per server, and storage class of all pods deployed in the Tenant:
      
      .. list-table::
         :header-rows: 1
         :widths: 30 70

         * - Field
           - Description

         * - ``servers`` 
           - The number of MinIO pods to deploy in the Server Pool.
         
         * - ``volumesPerServer`` 
           - The number of persistent volumes to attach to each MinIO pod (``servers``).
             The Operator generates ``volumesPerServer x servers`` Persistant Volume Claims for the Tenant.
         
         * - ``storageClassName`` 
           - The Kubernetes storage class to associate with the generated Persistent Volume Claims.

             If no storage class exists matching the specified value *or* if the specified storage class cannot meet the requested number of PVCs or storage capacity, the Tenant may fail to start.

         * - ``size``
           - The amount of storage to request for each generated PVC.

   #. Configure Tenant Affinity or Anti-Affinity

      The Tenant Chart supports the following Kubernetes Selector, Affinity and Anti-Affinity configurations:

      - Node Selector (``tenant.nodeSelector``)
      - Node/Pod Affinity or Anti-Affinity (``spec.pools[n].affinity``)

      MinIO recommends configuring Tenants with Pod Anti-Affinity to ensure that the Kubernetes schedule does not schedule multiple pods on the same worker node.

      If you have specific worker nodes on which you want to deploy the tenant, pass those node labels or filters to the ``nodeSelector`` or ``affinity`` field to constrain the scheduler to place pods on those nodes.

   #. Configure Network Encryption

      The MinIO Tenant CRD provides the following fields with which you can configure tenant TLS network encryption:

      .. list-table::
         :header-rows: 1
         :widths: 30 70

         * - Field
           - Description

         * - ``tenant.certificate.requestAutoCert``
           - Enable or disable MinIO :ref:`automatic TLS certificate generation <minio-tls>`.

             Defaults to ``true`` or enabled if omitted.

         * - ``tenant.certificate.certConfig``
           - Customize the behavior of :ref:`automatic TLS <minio-tls>`, if enabled.

         * - ``tenant.certificate.externalCertSecret``
           - Enable TLS for multiple hostnames via Server Name Indication (SNI).
         
             Specify one or more Kubernetes secrets of type ``kubernetes.io/tls`` or ``cert-manager``.

         * - ``tenant.certificate.externalCACertSecret``
           - Enable validation of client TLS certificates signed by unknown, third-party, or internal Certificate Authorities (CA).
         
             Specify one or more Kubernetes secrets of type ``kubernetes.io/tls`` containing the full chain of CA certificates for a given authority.

   #. Configure MinIO Environment Variables

      You can set MinIO Server environment variables using the ``tenant.configuration`` field.

      .. list-table::
         :header-rows: 1
         :widths: 30 70

         * - Field
           - Description

         * - ``tenant.configuration``
           - Specify a Kubernetes opaque secret whose data payload ``config.env`` contains each MinIO environment variable you want to set.

             The ``config.env`` data payload **must** be a base64-encoded string.
             You can create a local file, set your environment variables, and then use ``cat LOCALFILE | base64`` to create the payload.

      The YAML includes an object ``kind: Secret`` with ``metadata.name: storage-configuration`` that sets the root username, password, erasure parity settings, and enables Tenant Console.

      Modify this as needed to reflect your Tenant requirements.

   #. Deploy the Tenant

      Use ``helm`` to install the Tenant Chart using your ``values.yaml`` as an override:

      .. code-block:: shell
         :class: copyable

         helm install \
         --namespace TENANT-NAMESPACE \
         --create-namespace \
         --values values.yaml \
         TENANT-NAME minio-operator/tenant

      You can monitor the progress using the following command:

      .. code-block:: shell
         :class: copyable

         watch kubectl get all -n TENANT-NAMESPACE

   #. Expose the Tenant MinIO S3 API port

      To test the MinIO Client :mc:`mc` from your local machine, forward the MinIO port and create an alias.

      * Forward the Tenant's MinIO port:

      .. code-block:: shell
         :class: copyable

         kubectl port-forward svc/TENANT-NAME-hl 9000 -n TENANT-NAMESPACE

      * Create an alias for the Tenant service:

      .. code-block:: shell
         :class: copyable

         mc alias set myminio https://localhost:9000 minio minio123 --insecure

      You can use :mc:`mc mb` to create a bucket on the Tenant:
      
      .. code-block:: shell
         :class: copyable

         mc mb myminio/mybucket --insecure

      If you deployed your MinIO Tenant using TLS certificates minted by a trusted Certificate Authority (CA) you can omit the ``--insecure`` flag.

      See :ref:`create-tenant-connect-tenant` for additional documentation on external connectivity to the Tenant.

.. _deploy-tenant-helm-local:

Deploy a Tenant using a Local Helm Chart
----------------------------------------

The following procedure deploys a Tenant using a local copy of the Helm Charts.
This method may support easier pre-configuration of the Tenant compared to the :ref:`repo-based installation  <deploy-tenant-helm-repo>`.

#. Download the Helm charts

   On your local host, download the Tenant Helm charts to a convenient directory:

   .. code-block:: shell
      :class: copyable
      :substitutions:

      curl -O https://raw.githubusercontent.com/minio/operator/master/helm-releases/tenant-|operator-version-stable|.tgz

   Each chart contains a ``values.yaml`` file you can customize to suit your needs.
   For details on the options available in the MinIO Tenant ``values.yaml``, see :ref:`minio-tenant-chart-values`.
   
   Open the ``values.yaml`` object in your preferred text editor.

#. Configure the Tenant topology
   
   The following fields share the ``tenant.pools[0]`` prefix and control the number of servers, volumes per server, and storage class of all pods deployed in the Tenant:
   
   .. list-table::
      :header-rows: 1
      :widths: 30 70

      * - Field
        - Description

      * - ``servers`` 
        - The number of MinIO pods to deploy in the Server Pool.
      * - ``volumesPerServer`` 
        - The number of persistent volumes to attach to each MinIO pod (``servers``).
          The Operator generates ``volumesPerServer x servers`` Persistant Volume Claims for the Tenant.
      * - ``storageClassName`` 
        - The Kubernetes storage class to associate with the generated Persistent Volume Claims.

          If no storage class exists matching the specified value *or* if the specified storage class cannot meet the requested number of PVCs or storage capacity, the Tenant may fail to start.

      * - ``size``
        - The amount of storage to request for each generated PVC.

#. Configure Tenant Affinity or Anti-Affinity

   The Tenant Chart supports the following Kubernetes Selector, Affinity and Anti-Affinity configurations:

   - Node Selector (``tenant.nodeSelector``)
   - Node/Pod Affinity or Anti-Affinity (``spec.pools[n].affinity``)

   MinIO recommends configuring Tenants with Pod Anti-Affinity to ensure that the Kubernetes schedule does not schedule multiple pods on the same worker node.

   If you have specific worker nodes on which you want to deploy the tenant, pass those node labels or filters to the ``nodeSelector`` or ``affinity`` field to constrain the scheduler to place pods on those nodes.

#. Configure Network Encryption

   The MinIO Tenant CRD provides the following fields from which you can configure tenant TLS network encryption:

   .. list-table::
      :header-rows: 1
      :widths: 30 70

      * - Field
        - Description

      * - ``tenant.certificate.requestAutoCert``
        - Enables or disables MinIO :ref:`automatic TLS certificate generation <minio-tls>`

      * - ``tenant.certificate.certConfig``
        - Controls the settings for :ref:`automatic TLS <minio-tls>`.
          Requires ``spec.requestAutoCert: true``

      * - ``tenant.certificate.externalCertSecret``
        - Specify one or more Kubernetes secrets of type ``kubernetes.io/tls`` or ``cert-manager``.
          MinIO uses these certificates for performing TLS handshakes based on hostname (Server Name Indication).

      * - ``tenant.certificate.externalCACertSecret``
        - Specify one or more Kubernetes secrets of type ``kubernetes.io/tls`` with the Certificate Authority (CA) chains which the Tenant must trust for allowing client TLS connections.

#. Configure MinIO Environment Variables

   You can set MinIO Server environment variables using the ``tenant.configuration`` field.

   The field must specify a Kubernetes opaque secret whose data payload ``config.env`` contains each MinIO environment variable you want to set.

   The YAML includes an object ``kind: Secret`` with ``metadata.name: storage-configuration`` that sets the root username, password, erasure parity settings, and enables Tenant Console.

   Modify this as needed to reflect your Tenant requirements.

#. The following Helm command creates a MinIO Tenant using the standard chart:

   .. code-block:: shell
      :class: copyable
      :substitutions:

      helm install \
      --namespace TENANT-NAMESPACE \
      --create-namespace \
      TENANT-NAME tenant-|operator-version-stable|.tgz

   To deploy more than one Tenant, create a Helm chart with the details of the new Tenant and repeat the deployment steps.
   Redeploying the same chart updates the previously deployed Tenant.

#. Expose the Tenant MinIO port

   To test the MinIO Client :mc:`mc` from your local machine, forward the MinIO port and create an alias.

   * Forward the Tenant's MinIO port:

     .. code-block:: shell
        :class: copyable

        kubectl port-forward svc/TENANT-NAME-hl 9000 -n TENANT-NAMESPACE

   * Create an alias for the Tenant service:

     .. code-block:: shell
        :class: copyable

        mc alias set myminio https://localhost:9000 minio minio123 --insecure

     This example uses the non-TLS ``myminio-hl`` service, which requires :std:option:`--insecure <mc.--insecure>`.

     If you have a TLS cert configured, omit ``--insecure`` and use ``svc/minio`` instead.

   You can use :mc:`mc mb` to create a bucket on the Tenant:
   
     .. code-block:: shell
        :class: copyable

	mc mb myminio/mybucket --insecure

See :ref:`create-tenant-connect-tenant` for additional documentation on external connectivity to the Tenant.