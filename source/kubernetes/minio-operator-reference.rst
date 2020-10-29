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

The following operations deploy the MinIO operator using ``kustomize``
templates. Users who would prefer a more simplified deployment experience
that does *not* require familiarity with ``kustomize`` should use the
:ref:`minio-kubernetes` for deploying and managing MinIO Tenants.

.. tabs::

   .. tab:: ``kubectl``

      Use the following command to deploy the MinIO Operator using 
      ``kubectl`` and ``kustomize`` templates:

      .. code-block::
         :class: copyable
         :substitutions:

         kubectl apply -k github.com/minio/operator/\?ref\=|minio-operator-latest-version|

   .. tab:: ``kustomize``


      Use :github:`kustomize <kubernetes-sigs/kustomize>` to deploy the
      MinIO Operator using ``kustomize`` templates:

      .. code-block::
         :class: copyable
         :substitutions:

         kustomize build github.com/minio/operator/\?ref\=|minio-operator-latest-version| \
            > minio-operator-|minio-operator-latest-version|.yaml



MinIO Tenant Object
-------------------

The following example Kubernetes object describes a MinIO Tenant with the
following resources:

- 4 :mc:`minio` server processes.
- 4 Volumes per server.
- 2 MinIO Console Service (MCS) processes.

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


MinIO Operator ``YAML`` Reference
---------------------------------

The MinIO Operator adds a 
:kube-api:`CustomResourceDefinition 
<#customresourcedefinition-v1-apiextensions-k8s-io>` that extends the
Kubernetes Object API to support creating MinIO ``Tenant`` objects.

.. tabs::

   .. tab:: All Top-Level Fields

      The following ``YAML`` block describes a MinIO Tenant object and its
      top-level fields.

      .. parsed-literal::

         :kubeconf:`apiVersion`: minio.min.io/v1
         :kubeconf:`kind`: Tenant
         :kubeconf:`metadata`:
            :kubeconf:`~metadata.name`: minio
            :kubeconf:`~metadata.namespace`: <string>
            :kubeconf:`~metadata.labels`:
               app: minio
            :kubeconf:`~metadata.annotations`:
               prometheus.io/path: <string>
               prometheus.io/port: "<string>"
               prometheus.io/scrape: "<bool>"
         :kubeconf:`spec`:
            :kubeconf:`~spec.certConfig`: <object>
            :kubeconf:`~spec.console`: <object>
            :kubeconf:`~spec.credsSecret`: <object>
            :kubeconf:`~spec.env`: <object>
            :kubeconf:`~spec.externalCertSecret`: <array>
            :kubeconf:`~spec.externalClientCertSecret`: <object>
            :kubeconf:`~spec.image`: minio/minio:latest
            :kubeconf:`~spec.imagePullPolicy`: IfNotPresent
            :kubeconf:`~spec.kes`: <object>
            :kubeconf:`~spec.mountPath`: <string>
            :kubeconf:`~spec.podManagementPolicy`: <string>
            :kubeconf:`~spec.priorityClassName`: <string>
            :kubeconf:`~spec.requestAutoCert`: <boolean>
            :kubeconf:`~spec.s3`: <object>
            :kubeconf:`~spec.securityContext`: <object>
            :kubeconf:`~spec.serverSet`: <array>
            :kubeconf:`~spec.serviceAccountName`: <string>
            :kubeconf:`~spec.subPath`: <string>
            :kubeconf:`~spec.serverSet`: <array>

   .. tab:: Minimum Required Fields


      Minimum Required Fields

      .. parsed-literal::

         :kubeconf:`apiVersion`: minio.min.io/v1
         :kubeconf:`kind`: Tenant
         :kubeconf:`metadata`:
            :kubeconf:`~metadata.name`: minio
            :kubeconf:`~metadata.labels`:
               app: minio
         :kubeconf:`spec`:
            :kubeconf:`~spec.serverSet` :
               - :kubeconf:`~spec.serverSet.servers` : <int> 
               :kubeconf:`~spec.serverSet.volumeClaimTemplate`:
                  :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec`:
                     :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec.accessModes`: <string>
                     :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec.resources`:
                        requests:
                           storage: <string>
               :kubeconf:`~spec.serverSet.volumesPerServer`: <int>


Core Fields
~~~~~~~~~~~

The following fields describe the core settings used to deploy a MinIO Tenant. 

.. parsed-literal::

   :kubeconf:`apiVersion`: minio.min.io/v1
   :kubeconf:`kind`: Tenant
   :kubeconf:`metadata`:
      :kubeconf:`~metadata.name`: <string>
      :kubeconf:`~metadata.namespace`: <string>
      :kubeconf:`~metadata.labels`:
         app: minio
      :kubeconf:`~metadata.annotations`:
         - prometheus.io/path: <string>
         - prometheus.io/port: <string>
         - prometheus.io/scrape: <string>
   :kubeconf:`spec`:
      :kubeconf:`~spec.credsSecret`: <object>
      :kubeconf:`~spec.env`: <object>

      :kubeconf:`~spec.serverSet`:
         - :kubeconf:`~spec.serverSet.affinity`: <object>
           :kubeconf:`~spec.serverSet.name`: <string>
           :kubeconf:`~spec.serverSet.nodeSelector`: <object>
           :kubeconf:`~spec.serverSet.resources`: <object>
           :kubeconf:`~spec.serverSet.servers`: <int>
           :kubeconf:`~spec.serverSet.tolerations`: <array>
           :kubeconf:`~spec.serverSet.volumeClaimTemplate`: <object>
           :kubeconf:`~spec.serverSet.volumesPerServer`: <integer>

.. kubeconf:: apiVersion

   *Required*

   The API Version of the MinIO Tenant Object.
   
   Specify ``minio.min.io/v1``.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-customresourcedefinition
      :end-before: end-kubeapi-customresourcedefinition

.. kubeconf:: kind

   *Required*

   The REST resource the object represents. Specify ``Tenant``.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-customresourcedefinition
      :end-before: end-kubeapi-customresourcedefinition

.. kubeconf:: metadata

   The root field for describing metadata related to the Tenant object. 

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-objectmeta
      :end-before: end-kubeapi-objectmeta

.. kubeconf:: metadata.name

   *Required*

   The name of the Tenant resource. The name *must* be unique within the 
   target namespace.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-objectmeta
      :end-before: end-kubeapi-objectmeta

.. kubeconf:: metadata.namespace

   *Required*

   The namespace in which Kubernetes deploys the Tenant resource. 
   Omit to use the "Default" namespace. MinIO recommends creating a namespace
   for each MinIO Tenant deployed in the Kubernetes cluster.

.. kubeconf:: metadata.labels

   The Kubernetes :kube-docs:`labels 
   <concepts/overview/working-with-objects/labels>` to apply to the
   MinIO Tenant Object.

   Specify *at minimum* the following key-value pair:

   .. code-block:: yaml
      :class: copyable

      metadata:
         labels:
            app: minio

.. kubeconf:: metadata.annotations

   One or more Kubernetes :kube-docs:`annotations <user-guide/annotations>` to 
   associate with the MinIO Tenant Object.

   MinIO Tenants support the following annotations:

   - ``prometheus.io/path: <string>``

   - ``prometheus.io/port: <string>``

   - ``prometheus.io/scrape: <bool>``

.. kubeconf:: spec

   The root field for the MinIO Tenant Specification.

.. kubeconf:: spec.credsSecret

   The Kubernetes secret containing values to use for setting the MinIO access
   key (:envvar:`MINIO_ACCESS_KEY`) and secret key (:envvar:`MINIO_SECRET_KEY`).
   The MinIO Operator automatically generates the secret along with values for
   the access and secret key if this field is omitted. 

   Specify an object where the ``name`` field contains the name of the
   Kubernetes secret to use:

   .. code-block:: yaml

      spec:
         credsSecret:
            name: minio-secret

   The Kubernetes secret should contain the following values:

   - ``data.accesskey`` - the Access Key for each :mc:`minio` server in the 
     Tenant.

   - ``data.secretkey`` - the Secret Key for each :mc:`minio` server in the
     Tenant.

.. kubeconf:: spec.env

   The environment variables available for use by the MinIO Tenant. 

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-envvar
      :end-before: end-kubeapi-envvar


.. kubeconf:: spec.mountPath

   *Optional*

   The mount path for Persistent Volumes bound to :mc:`minio` pods in the
   MinIO Tenant.

   Defaults to ``/export``.



.. kubeconf:: spec.s3

   *Optional*

   The S3-related features enabled on the MinIO Tenant.

   Specify any of the following supported features as part of the 
   :kubeconf:`~spec.s3` object:

   - ``bucketDNS: <boolean>`` - specify ``true`` to enable DNS lookup of
     buckets on the MinIO Tenant.



.. kubeconf:: spec.subPath

   *Optional*

   The sub path appended to the :kubeconf:`spec.mountPath`. The resulting
   full path is the directory in which MinIO stores data.

   For example, given a :kubeconf:`~spec.mountPath` of ``export`` and
   a :kubeconf:`~spec.subPath` of ``minio``, the full mount path is
   ``export/minio``.

   Defaults to empty (``""``).

.. kubeconf:: spec.serverSet

   *Required*

   The configuration for each MinIO Server Set deployed in the MinIO Tenant. A
   Server Set consists of one or more :mc:`minio` servers. 

   Each element in the :kubeconf:`~spec.serverSet` array is an object that *must*
   contain the following fields:

   - :kubeconf:`~spec.serverSet.servers`
   - :kubeconf:`~spec.serverSet.volumeClaimTemplate`
   - :kubeconf:`~spec.serverSet.volumesPerServer`

   :kubeconf:`~spec.serverSet` must have *at least* one element in the array. 

.. kubeconf:: spec.serverSet.affinity

   *Optional*

   The configuration for node affinity, pod affinity, and pod anti-affinity
   applied to each pod in the Server Set.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-affinity
      :end-before: end-kubeapi-affinity

.. kubeconf:: spec.serverSet.name

   *Optional*

   The name of the MinIO Server Set object.
   
   The MinIO Operator automatically generates the Server Set
   name if this field is omitted. 

.. kubeconf:: spec.serverSet.nodeSelector

   *Optional*

   The filter to apply when selecting which node or nodes on which to
   deploy each pod in the Server Set. See the Kubernetes documentation on 
   :kube-docs:`Assigning Pods to Nodes 
   <concepts/scheduling-eviction/assign-pod-node>` for more information.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-nodeselector
      :end-before: end-kubeapi-nodeselector

.. kubeconf:: spec.serverSet.resources

   *Optional*

   The :kube-docs:`resources 
   <concepts/configuration/manage-resources-containers/>` each pod in the
   Server Set requests.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-resources
      :end-before: end-kubeapi-resources   

.. kubeconf:: spec.serverSet.servers

   *Required*

   The number of :mc:`minio` pods to deploy in the Zone. 
   
   The minimum number of servers is ``2``. MinIO recommends
   a minimum of ``4`` servers for optimal availability and
   distribution of data in the Server Set.

.. kubeconf:: spec.serverSet.tolerations

   *Optional*

   The :kube-docs:`Tolerations 
   <concepts/scheduling-eviction/taint-and-toleration/>` applied to pods
   deployed in the Server Set.

.. kubeconf:: spec.serverSet.volumeClaimTemplate
   :noindex:

   *Required*

   The configuration template to apply to each Persistent Volume Claim (``PVC``)
   created as part of the Server Set. 

   See :kubeconf:`spec.serverSet.volumeClaimTemplate` for more complete
   documentation on the full specification of the ``volumeClaimTemplate``
   object.

   The MinIO Operator calculates the number of ``PVC`` to generate by 
   multiplying :kubeconf:`spec.serverSet.volumesPerServer` by 
   :kubeconf:`spec.serverSet.servers`.

.. kubeconf:: spec.serverSet.volumesPerServer

   *Required*

   The number of Persistent Volume Claims (``PVC``) to create for each
   :kubeconf:`server <spec.serverSet.servers>` in the Server Set.
   
   The total number of volumes in the Server Set *must* be greater than
   4. Specifically:
   
   .. parsed-literal::

     :kubeconf:`~spec.serverSet.servers` X :kubeconf:`~spec.serverSet.volumesPerServer` > 4

   The MinIO Operator calculates the number of ``PVC`` to generate by 
   multiplying :kubeconf:`spec.serverSet.volumesPerServer` by 
   :kubeconf:`spec.serverSet.servers`.

Volume Claim Template
~~~~~~~~~~~~~~~~~~~~~

The following fields describe the template used to generate Persistent Volume
Claims (``PVC``) for use in the MinIO Tenant.

.. parsed-literal::

   spec:
      serverSet:
      - :kubeconf:`~spec.serverSet.volumeClaimTemplate`
           :kubeconf:`~spec.serverSet.volumeClaimTemplate.apiVersion`: <string>
           :kubeconf:`~spec.serverSet.volumeClaimTemplate.kind`: <string>
           :kubeconf:`~spec.serverSet.volumeClaimTemplate.metadata`: <object>
           :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec`:
              :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec.accessModes`: <array>
              :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec.dataSource`: <object>
              :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec.resources`: <object>
              :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec.selector`: <object>
              :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec.storageClassName`: <string>
              :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec.volumeMode`: <string>
              :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec.volumeName`: <string>
           status: <object>

.. kubeconf:: spec.serverSet.volumeClaimTemplate

   *Required*

   The configuration template to apply to each Persistent Volume Claim (``PVC``)
   created as part of a :kubeconf:`Server Set <spec.serverSet>`. The
   :kubeconf:`~spec.serverSet.volumeClaimTemplate` dictates which Persistent Volumes
   (``PV``) the generated ``PVC`` can bind to.

   The :kubeconf:`~spec.serverSet.volumeClaimTemplate` *requires* at minimum
   the following fields:

   - :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec.resources`
   - :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec.accessModes`

   The MinIO Operator calculates the number of ``PVC`` to generate by 
   multiplying :kubeconf:`spec.serverSet.volumesPerServer` by 
   :kubeconf:`spec.serverSet.servers`.

.. kubeconf:: spec.serverSet.volumeClaimTemplate.apiVersion

   *Optional*

   The API Version of the :kubeconf:`~spec.serverSet.volumeClaimTemplate`.
   
   Specify ``minio.min.io/v1``.

.. kubeconf:: spec.serverSet.volumeClaimTemplate.kind

   *Optional*

   The REST resource the object represents.

.. kubeconf:: spec.serverSet.volumeClaimTemplate.metadata

   *Optional*

   The metadata for the :kubeconf:`~spec.serverSet.volumeClaimTemplate`. 

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-objectmeta
      :end-before: end-kubeapi-objectmeta

.. kubeconf:: spec.serverSet.volumeClaimTemplate.spec

   The specification applied to each Persistent Volume Claim (``PVC``) created
   using the :kubeconf:`~spec.serverSet.volumeClaimTemplate`.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-persistentvolumeclaimspec
      :end-before: end-kubeapi-persistentvolumeclaimspec

.. kubeconf:: spec.serverSet.volumeClaimTemplate.spec.accessModes

   *Required*

   The desired :kube-docs:`access mode 
   <concepts/storage/persistent-volumes#access-modes-1>` for each Persistent 
   Volume Claim (``PVC``) created using the
   :kubeconf:`~spec.serverSet.volumeClaimTemplate`.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-persistentvolumeclaimspec
      :end-before: end-kubeapi-persistentvolumeclaimspec

.. kubeconf:: spec.serverSet.volumeClaimTemplate.spec.dataSource

   *Optional*

   The data source to use for each Persistent Volume Claim (``PVC``)
   created using the :kubeconf:`~spec.serverSet.volumeClaimTemplate`.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-persistentvolumeclaimspec
      :end-before: end-kubeapi-persistentvolumeclaimspec

.. kubeconf:: spec.serverSet.volumeClaimTemplate.spec.resources

   *Required*

   The resources requested by each Persistent Volume Claim (``PVC``) created
   using the :kubeconf:`~spec.serverSet.volumeClaimTemplate`.

   The :kubeconf:`~spec.serverSet.volumeClaimTemplate.spec.resources` object
   *must* include a ``requests.storage`` object:

   .. code-block:: yaml

      spec:
         serverSet:
            - name: minio-server-set-1
              volumeClaimTemplate:
                 spec: 
                    resources:
                       requests:
                          storage: <string>

   The following table lists the supported units for the ``storage`` capacity.

   .. list-table::
      :header-rows: 1
      :widths: 20 80
      :width: 100%

      * - Suffix
        - Unit Size

      * - ``k``
        - KB (Kilobyte, 1000 Bytes)

      * - ``m``
        - MB (Megabyte, 1000 Kilobytes)

      * - ``g``
        - GB (Gigabyte, 1000 Megabytes)

      * - ``t``
        - TB (Terrabyte, 1000 Gigabytes)

      * - ``ki``
        - KiB (Kibibyte, 1024 Bites)

      * - ``mi``
        - MiB (Mebibyte, 1024 Kibibytes)

      * - ``gi``
        - GiB (Gibibyte, 1024 Mebibytes)

      * - ``ti``
        - TiB (Tebibyte, 1024 Gibibytes)

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-persistentvolumeclaimspec
      :end-before: end-kubeapi-persistentvolumeclaimspec
   
.. kubeconf:: spec.serverSet.volumeClaimTemplate.spec.selector

   *Optional*

   The selector logic to apply when querying available Persistent Volumes
   (``PV``) for binding to the Persistent Volume Claim (``PVC``).

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-persistentvolumeclaimspec
      :end-before: end-kubeapi-persistentvolumeclaimspec

.. kubeconf:: spec.serverSet.volumeClaimTemplate.spec.storageClassName

   *Optional*

   The storage class to apply to each Persistent Volume Claim (``PVC``) 
   created using the :kubeconf:`~spec.serverSet.volumeClaimTemplate`.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-persistentvolumeclaimspec
      :end-before: end-kubeapi-persistentvolumeclaimspec

.. kubeconf:: spec.serverSet.volumeClaimTemplate.spec.volumeMode

   *Optional*

   The type of Persistent Volume (``PV``) required by the claim. 
   Defaults to ``Filesystem`` if omitted.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-persistentvolumeclaimspec
      :end-before: end-kubeapi-persistentvolumeclaimspec

.. kubeconf:: spec.serverSet.volumeClaimTemplate.spec.volumeName

   *Optional*

   The name to apply to each Persistent Volume Claim (``PVC``) created
   using the :kubeconf:`~spec.serverSet.volumeClaimTemplate`.

MinIO Docker Image
~~~~~~~~~~~~~~~~~~

The following fields describe the Docker settings used by the
MinIO Tenant.

.. parsed-literal::

   spec:
      :kubeconf:`~spec.image`: <string>
      :kubeconf:`~spec.imagePullPolicy`: <string>
      :kubeconf:`~spec.imagePullSecret`: <string>

.. kubeconf:: spec.image

   The Docker image to use for the :mc:`minio` server process.

   Defaults to the latest stable release of ``minio:minio`` if omitted.

.. kubeconf:: spec.imagePullPolicy

   The Docker pull policy to use for the specified :kubeconf:`spec.image`.

   Specify one of the following values:

   - ``Always`` - Always pull the image.

   - ``Never`` - Never pull the image.

   - ``IfNotPresent`` - Pull the image if not already present.

   Defaults to ``IfNotPresent`` if omitted.

.. kubeconf:: spec.imagePullSecret

   The secret to use for pulling images from private Docker repositories. 


Transport Layer Encryption (TLS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following fields describe the Transport Layer Encryption (TLS) settings
of a MinIO Tenant, including automatic TLS certificate generation.

.. parsed-literal::

   spec:
      :kubeconf:`~spec.requestAutoCert`: <boolean>
      :kubeconf:`~spec.certConfig`:
         :kubeconf:`~spec.certConfig.commonName`: <string>
         :kubeconf:`~spec.certConfig.dnsNames`: <string>
         :kubeconf:`~spec.certConfig.organizationName`: <string>
         :kubeconf:`~spec.externalCertSecret`: 
            - name: <string>
              type: kubernetes.io/tls
         :kubeconf:`~spec.externalClientCertSecret`:
            name: <string>
            type: kubernetes.io/tls

.. kubeconf:: spec.requestAutoCert

   *Optional*

   Specify ``true`` to enable automatic TLS certificate generation and
   signing using the Kubernetes ``certificates.k8s.io`` API. The MinIO Operator
   generates *self-signed* x.509 certificates. 
   
   See the Kubernetes documentation on
   :kube-docs:`Manage TLS Certificates in a Cluster 
   <tasks/tls/managing-tls-in-a-cluster/>` for more information.

   This field is **mutually exclusive** with 
   :kubeconf:`spec.externalCertSecret`.

.. kubeconf:: spec.certConfig

   *Optional*

   The configuration settings to use when auto-generating x.509 certificates for
   TLS encryption. 

   Omit to allow the MinIO Operator to generate required fields in
   each auto-generate x.509 certificates.

   If :kubeconf:`spec.requestAutoCert` is ``false`` or omitted, this field has
   no effect.

.. kubeconf:: spec.certConfig.commonName

   *Optional*

   The x.509 Common Name to use when generating x.509 certificates for TLS
   encryption. Use wildcard patterns when constructing the ``commonName`` 
   to ensure the generated certificates match the Kubernetes-generated
   DNS names of Tenant resources. See the Kubernetes documentation on
   :kubedocs:`DNS for Services and Pods 
   <concepts/services-networking/dns-pod-service/>` for more information on 
   Kubernetes DNS.

   If :kubeconf:`spec.requestAutoCert` is ``false`` or omitted, this field has
   no effect.

.. kubeconf:: spec.certConfig.dnsNames

   *Optional*

   The DNS names to use when generating x.509 certificates for TLS encryption.

   If :kubeconf:`spec.requestAutoCert` is ``false`` or omitted, this field has
   no effect.

.. kubeconf:: spec.certConfig.organizationName

   *Optional*

   The x.509 Organization Name to use when generating x.509 certificates for
   TLS encryption.

   If :kubeconf:`spec.requestAutoCert` is ``false`` or omitted, this field has
   no effect.

.. kubeconf:: spec.externalCertSecret

   *Optional*

   One or more Kubernetes secrets that contain custom TLS certificate and 
   private key pairs. Use this field for specifying certificates signed by
   a Certificate Authority (CA) of your choice.

   Each item in the array contains an object where:

   - ``names`` specifies the name of the Kubernetes secret, and
   - ``types`` specifies ``kubernetes.io/tls``

   Use wildcard patterns when constructing the DNS-related fields
   to ensure the generated certificates match the Kubernetes-generated
   DNS names of Tenant resources. See the Kubernetes documentation on
   :kubedocs:`DNS for Services and Pods 
   <concepts/services-networking/dns-pod-service/>` for more information on 
   Kubernetes DNS.

   .. code-block:: yaml

      spec:
         externalCertSecret:
            - name: tenant-external-cert-secret-name
              type: kubernetes.io/tls

   This field is **mutually exclusive** with :kubeconf:`spec.requestAutoCert`.

.. kubeconf:: spec.externalClientCertSecret

   *Optional*

   The Kubernetes secret that contains the custom Certificate Authority
   certificate and private key used to sign x.509 certificates used by clients
   connecting to the MinIO Tenant. 

   Specify an object where:

   - ``names`` specifies the name of the Kubernetes secret, and
   - ``types`` specifies ``kubernetes.io/tls``

   .. code-block:: yaml

      spec:
         externalClientCertSecret:
            name: tenant-external-client-cert-secret-name
            type: kubernetes.io/tls




MinIO Console Service
~~~~~~~~~~~~~~~~~~~~~

The following fields describe the settings for deploying the MinIO Console 
in the MinIO Tenant.

.. parsed-literal:: 

   spec:
      :kubeconf:`~spec.console`:
         :kubeconf:`~spec.console.annotations`: <object>
         :kubeconf:`~spec.console.consoleSecret`:
            name: <string>
         :kubeconf:`~spec.console.env`: <array>
         :kubeconf:`~spec.console.externalCertSecret`: 
            name: <string>
            type: kubernetes.io/tls
         :kubeconf:`~spec.console.image`: <string>
         :kubeconf:`~spec.console.imagePullPolicy`: <string>
         :kubeconf:`~spec.console.labels`: <object>
         :kubeconf:`~spec.console.nodeSelector`: <object>
         :kubeconf:`~spec.console.replicas`: <int>
         :kubeconf:`~spec.console.resources`: <object>
         :kubeconf:`~spec.console.serviceAccountName`: <string>


.. kubeconf:: spec.console

   *Optional*

   The root field for describing MinIO Console-related configuration
   information.

   Omit to deploy the MinIO Tenant without an attached Console service.

.. kubeconf:: spec.console.consoleSecret

   *Required if specifying* :kubeconf:`spec.console`.

   The Kubernetes Secret object that contains all environment variables required
   by the MinIO Console. Specify the name of the secret as a subfield:

   .. code-block:: yaml

      spec:
         console:
            consoleSecret:
               name: console-secret-name

.. kubeconf:: spec.console.annotations

   *Optional*

   One or more Kubernetes :kube-docs:`annotations <user-guide/annotations>` to 
   associate with the MinIO Console object.

.. kubeconf:: spec.console.env

   *Optional*

   The environment variables available for use by the MinIO Console. 

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-envvar
      :end-before: end-kubeapi-envvar

.. kubeconf:: spec.console.externalCertSecret

   *Optional*

   The name of the Kubernetes secret containing the custom Certificate
   Authority certificate and private key to use for configuring TLS on the 
   Console object. Specify an object where ``names`` specifies the name
   of the secret and ``types`` specifies ``kubernetes.io/tls``:

   .. code-block:: yaml

      spec:
         console:
            externalCertSecret:
               name: console-external-secret-cert-name
               type: kubernetes.io/tls

.. kubeconf:: spec.console.image

   *Optional*

   The name of the Docker image to use for deploying the MinIO Console.

   Defaults to the latest release of MinIO Console. 

.. kubeconf:: spec.console.imagePullPolicy

   *Optional*

   The pull policy for the Docker image. Defaults to ``IfNotPresent``.

.. kubeconf:: spec.console.labels

   *Optional*

   The Kubernetes :kube-docs:`labels 
   <concepts/overview/working-with-objects/labels>` to apply to the
   MinIO Console object.

.. kubeconf:: spec.console.nodeSelector

   *Optional*

   The filter to apply when selecting which node or nodes on which to
   deploy the MinIO Console. See the Kubernetes documentation on 
   :kube-docs:`Assigning Pods to Nodes 
   <concepts/scheduling-eviction/assign-pod-node>` for more information.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-nodeselector
      :end-before: end-kubeapi-nodeselector

.. kubeconf:: spec.console.replicas

   *Optional*

   The number of MinIO Console pods to create in the cluster.

.. kubeconf:: spec.console.resources

   *Optional*

   The :kube-docs:`resources 
   <concepts/configuration/manage-resources-containers/>` each MinIO Console
   object requests.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-resources
      :end-before: end-kubeapi-resources

.. kubeconf:: spec.console.serviceAccountName

   *Optional*

   The name of the 
   :kube-docs:`Service Account 
   <reference/access-authn-authz/service-accounts-admin/>` used to run all 
   MinIO Console pods created as part of the Tenant.


MinIO Key Encryption Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following fields describe the settings for deploying the MinIO
Key Encryption Service (KES) in the MinIO Tenant.

.. parsed-literal::

   spec:
      kes:
         annotations: <object>
         labels: <object>
         clientCertSecret: <object>
            name: <string>
            type: kubernetes.io/tls
         externalCertSecret: <object>
            name: <string>
            type: kubernetes.io/tls
         image: <string>
         imagePullPolicy: <string>
         kesSecret: <string>
         nodeSelector: <object>
         replicas: <integer>
         serviceAccountName: <string>

.. kubeconf:: spec.kes

   *Optional*

   The root field for describing MinIO Key Encryption Service-related
   configuration information. 

   Omit to deploy the MinIO Tenant without an attached KES service.

.. kubeconf:: spec.kes.kesSecret

   *Required if specifying* :kubeconf:`spec.kes`.

   The Kubernetes Secret object that contains all environment variables required
   by the MinIO KES. Specify the name of the secret as a subfield:

   .. code-block:: yaml

      spec:
         kes:
            kesSecret:
               name: kes-secret-name

.. kubeconf:: spec.kes.annotations

   *Optional*

   One or more Kubernetes :kube-docs:`annotations <user-guide/annotations>` to 
   associate with the MinIO KES object.

.. kubeconf:: spec.kes.env

   *Optional*

   The environment variables available for use by the MinIO KES. 

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-envvar
      :end-before: end-kubeapi-envvar

.. kubeconf:: spec.kes.externalCertSecret

   *Optional*

   The name of the Kubernetes secret containing the custom Certificate
   Authority certificate and private key to use for configuring TLS on the 
   KES object. Specify an object where ``names`` specifies the name
   of the secret and ``types`` specifies ``kubernetes.io/tls``:

   .. code-block:: yaml

      spec:
         kes:
            externalCertSecret:
               name: kes-external-secret-cert-name
               type: kubernetes.io/tls

.. kubeconf:: spec.kes.image

   *Optional*

   The name of the Docker image to use for deploying MinIO KES.

   Defaults to the latest release of MinIO KES. 

.. kubeconf:: spec.kes.imagePullPolicy

   *Optional*

   The pull policy for the Docker image. Defaults to ``IfNotPresent``.

.. kubeconf:: spec.kes.labels

   *Optional*

   The Kubernetes :kube-docs:`labels 
   <concepts/overview/working-with-objects/labels>` to apply to the
   MinIO KES object.

.. kubeconf:: spec.kes.nodeSelector

   *Optional*

   The filter to apply when selecting which node or nodes on which to
   deploy MinIO KES. See the Kubernetes documentation on 
   :kube-docs:`Assigning Pods to Nodes 
   <concepts/scheduling-eviction/assign-pod-node>` for more information.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-nodeselector
      :end-before: end-kubeapi-nodeselector

.. kubeconf:: spec.kes.replicas

   *Optional*

   The number of MinIO Console pods to create in the cluster.

.. kubeconf:: spec.kes.serviceAccountName

   *Optional*

   The name of the 
   :kube-docs:`Service Account 
   <reference/access-authn-authz/service-accounts-admin/>` used to run all 
   MinIO KES pods created as part of the Tenant.


Pod Security, Scheduling, and Management
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following fields describe the settings for Pod Security, Pod Scheduling,
and Pod Management in the MinIO Tenant.

.. parsed-literal::

   spec:
      :kubeconf:`~spec.securityContext`: <object>
      :kubeconf:`~spec.serviceAccountName`: <string>
      :kubeconf:`~spec.podManagementPolicy`: <object>
      :kubeconf:`~spec.priorityClassName`: <string>

.. kubeconf:: spec.securityContext

   *Optional*

   Root field for configuring the 
   :kube-docs:`Security Context 
   <tasks/configure-pod-container/security-context>` of pods created as part of
   the MinIO Tenant.

   The MinIO Operator supports the following 
   :kube-api:`PodSecurityContext <#podsecuritycontext-v1-core>` fields:

   - ``fsGroup``
   - ``fsGroupChangePolicy``
   - ``runAsGroup``
   - ``runAsNonRoot``
   - ``runAsUser``
   - ``seLinuxOptions``

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-securitycontext
      :end-before: end-kubeapi-securitycontext

.. kubeconf:: spec.serviceAccountName

   *Optional*

   The name of the 
   :kube-docs:`Service Account 
   <reference/access-authn-authz/service-accounts-admin/>` used to run all 
   MinIO server :mc:`minio` pods created as part of the Tenant.

.. kubeconf:: spec.podManagementPolicy

   *Optional*

   The :kube-docs:`Pod Management Policy 
   <concepts/workloads/controllers/statefulset/#pod-management-policies>` used
   for pods created as part of the MinIO Tenant.

   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-podmanagementpolicy
      :end-before: end-kubeapi-podmanagementpolicy

.. kubeconf:: spec.priorityClassName

   *Optional*

   The Pod :kube-docs:`Priority Class 
   <concepts/configuration/pod-priority-preemption/#priorityclass>` to apply
   to pods created as part of the MinIO Tenant.


   .. include:: /includes/common-minio-kubernetes.rst
      :start-after: start-kubeapi-priorityclassname
      :end-before: end-kubeapi-priorityclassname



