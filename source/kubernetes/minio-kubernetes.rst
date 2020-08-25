=====================
MinIO for Kuberenetes
=====================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 2

Overview
--------

MinIO is a high performance distributed object storage server, designed for
large-scale private cloud infrastructure. MinIO is designed in a cloud-native
manner to scale sustainably in multi-tenant environments. Orchestration
platforms like Kubernetes provide perfect cloud-native environment to deploy and
scale MinIO.

.. image:: /images/Kubernetes-Minio.svg
   :align: center
   :width: 100%
   :class: no-scaled-link
   :alt: Kubernetes Orchestration with the MinIO Operator facilitates automated creation of MinIO deployments.

MinIO provides two first-party tools for deploying MinIO resources on a
Kubernetes cluster:

- The MinIO Operator (``operator``) extends the Kubernetes API and provides the
  core functionality for creation and management of MinIO resources in a 
  Kubernetes cluster. Using the ``operator`` requires familiarity with the
  Kubernetes API and creation of ``YAML`` specifications.

- The MinIO ``kubectl-minio`` plugin is a ``kubectl`` extension that 
  wraps the ``operator`` and provides a simplified interface. The
  ``kubectl-minio`` plugin requires no prior knowledge of the Kubernetes
  API or the creation of ``YAML`` specifications.

Complete guidance on Kubernetes, including the Kubernetes API and the creation
of Kubernetes clusters, is out of scope for the MinIO documentation. The MinIO
documentation focuses on guidance and reference material related to deploying
and using the ``operator``. The MinIO documentation makes a best effort to
summarize or link to Kubernetes-specific concepts and resources, and is
neither intended nor designed to replace Kubernetes-centric documentation.

MinIO Operator (``operator``)
-----------------------------

The MinIO Kubernetes Operator (``operator``) adds a MinIO-specific custom
resource definition (CRD) as an extension to the Kubernetes API. You can
create ``YAML``-formatted specifications using the syntax added by the
``operator`` to define one or more MinIO resources to deploy using
``kubectl apply -k``. 

For example, the following ``tenant.yaml`` specification
would create a distributed MinIO deployment that supports Erasure Coding:

.. code-block:: yaml

   apiVersion: v1
   kind: Secret
   metadata:
      name: minio-creds-secret
   type: Opaque
   data:
      accesskey: myMinIORootAccessKey
      secretkey: myMinIORootSecretKeyShouldBeMoreSecureThanThis
   ---
   apiVersion: minio.min.io/v1
   kind: Tenant
   metadata:
      name: minio
   spec:
      image: minio/minio:RELEASE.2020-08-18T19-41-00Z
      imagePullPolicy: IfNotPresent
      zones:
         - servers: 2
           volumesPerServer: 4
           volumeClaimTemplate:
              metadata:
                 name: data
              spec:
                 accessModes:
                    - ReadWriteOnce
                 resources:
                    requests:
                       storage: 1Ti
                 storageClassName: direct.csi.min.io

The ``storageClassName: direct.csi.min.io`` corresponds to Persistant Volumes
(``PV``) created using the MinIO Direct CSI driver.

The MinIO operator github repository contains additional :minio-git:`example
<operator/tree/master/examples>` ``YAML`` files. For more complete documentation
on the MinIO ``operator`` CRD, see :doc:`/kubernetes/operator-reference`.

You can use utilities like Kubernetes ``kustomize`` to create templates for your
MinIO deployment using the ``operator`` CRD as a base. The MinIO operator github
repository contains an example :minio-git:`kustomization.yaml
<operator/tree/master/kustomization.yaml>` file, where the ``kustomize``
templtes are located under :minio-git:`operator/tree/master/operator-kustomize`.

MinIO Plugin (``kubectl-plugin``)
---------------------------------

MinIO provides a ``kubectl`` compatible plugin :minio-git:`kubectl-minio
<operator/tree/master/kubectl-minio>` that wraps the MinIO Kubernetes Operator
and provides a simple interface through ``kubectl`` for deploying and managing
MinIO resources. The ``kubectl-minio`` interface does not require familiarity
with the Kubernetes API, the MinIO ``operator`` API extension, or the creation
of ``YAML`` specifications. 

For example, the following command creates a new MinIO deployment using
``kubectl``:

.. code-block:: shell

   kubectl minio tenant create --name myMinIO --secret myMinIOSecret \
      -- servers 4 --volumes 4 --capacity 100Ti

For more complete documentation on the MinIO ``kubectl-plugin``, see
:doc:`/kubernetes/kubectl-plugin-reference`.

.. _minio-k8s-topology-config:

Topology Configuration
----------------------

MinIO recommends a deployment toplogy where Kubernetes deploys a single
``minio`` server per node. Each storage volume used by the ``minio`` server
should correspond to a locally-attached disk. For more information on storage
volumes in Kubernetes, see :ref:`minio-k8s-volume-config`.

For example, the following diagram illustrates the relationship between a node,
a ``minio`` pod, and the local storage on the node host machine:

<diagram to follow>

Deploying each node in the Kubernetes cluster with this toplogy in mind ensures
high availability and redundancy of the MinIO deployment and its stored data
while also taking advantage of Kubernetes features like automatic handling of
pod failure.

Deploying multiple ``minio`` pods to a single node *or* splitting a single
physical disk into multiple virtual volumes trades lower operational cost and
complexity for the *illusion* of high availability and data redundancy.
These topologies may be acceptable in development or evaluatino environments
where cluster downtime or data loss does not impact production workloads. 

.. _minio-k8s-volume-config:

Volume Configuration
--------------------

MinIO recommends provisioning :kube-docs:`persistant volumes
<concepts/storage/persistent-volumes/>` (``PV``) to use as disks for each MinIO
server in the deployment. For example, if the node host machine has four
locally-attached NVME drives, you should create a single ``PV`` for each drive.
The MinIO :minio-git:`Direct CSI Driver <minio/direct-csi>` is specifically
designed and optimized for locally attached storage. Alternatively, you can
create a Kubernetes :kube-docs:`local volume <concepts/storage/volumes/#local>`
for each drive. When creating a MinIO pod specification, use a
:kube-docs:`persistantVolumeClaim
<concepts/storage/volumes/#persistentvolumeclaim>` (``PVC``) to reference the
appropriate ``PV``.

When creating a ``PVC``, consider the following recommendations:

- Set ``spec.accesMOdes`` to ``"ReadWriteOnce"``. This prevents other 
  pods from accessing the same storage disk used by the MinIO server.

- Set ``spec.resources.requests.storage`` to be less than or equal to the
  capacity of the ``PV``. 

- Set ``spec.storageClassName`` to ``direct.csi.min.io``.
  *Only required if using the Direct CSI Driver*.

- Set ``volumeMode`` to ``Filesystem``.


.. toctree::
   :titlesonly:
   :hidden:

   /kubernetes/quickstart
   /kubernetes/deploy-on-kubernetes
   /kubernetes/manage-on-kubernetes
   /kubernetes/enforce-security
   /kubernetes/direct-csi
   /kubernetes/operator-kes
   /kubernetes/operator-mcs
   /kubernetes/operator-reference
   /kubernetes/kubectl-plugin-reference
