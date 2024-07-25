.. _minio-k8s-deploy-operator-helm:

=========================
Deploy Operator With Helm
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


Overview
--------

Helm is a tool for automating the deployment of applications to Kubernetes clusters.
A `Helm chart <https://helm.sh/docs/topics/charts/>`__ is a set of YAML files, templates, and other files that define the deployment details.
The following procedure uses a Helm Chart to install the :ref:`MinIO Kubernetes Operator <minio-operator-installation>` to a Kubernetes cluster.

Prerequisites
-------------

To install the Operator with Helm you will need the following:

* An existing Kubernetes cluster.
* The ``kubectl`` CLI tool on your local host, the same version as the cluster.
* `Helm <https://helm.sh/docs/intro/install/>`__ version 3.8 or greater.
* `yq <https://github.com/mikefarah/yq/#install>`__ version 4.18.1 or greater.
* Access to run ``kubectl`` commands on the cluster from your local host.

For more about Operator installation requirements, including supported Kubernetes versions and TLS certificates, see the :ref:`Operator deployment prerequisites <minio-operator-prerequisites>`.

This procedure assumes familiarity with the referenced Kubernetes concepts and utilities.
While this documentation may provide guidance for configuring or deploying Kubernetes-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.

.. _minio-k8s-deploy-operator-helm-repo:

Install the MinIO Operator using Helm Charts
--------------------------------------------

The following procedure installs the Operator using the MinIO Operator Chart Repository.
This method supports a simplified installation path compared to the :ref:`local chart installation <minio-k8s-deploy-operator-helm-local>`.
You can modify the Operator deployment after installation.

.. important::

   If you use Helm charts to install the Operator, you must use Helm to manage that installation.
   Do not use ``kubectl krew``, Kustomize, or similar methods to update or manage the MinIO Operator installation.

#. Add the MinIO Operator Repo to Helm

   MinIO maintains a Helm-compatible repository at https://operator.min.io.
   Add this repository to Helm:

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

      NAME                            CHART VERSION   APP VERSION     DESCRIPTION                    
      minio-operator/minio-operator   4.3.7           v4.3.7          A Helm chart for MinIO Operator
      minio-operator/operator         6.0.1           v6.0.1          A Helm chart for MinIO Operator
      minio-operator/tenant           6.0.1           v6.0.1          A Helm chart for MinIO Operator

   The ``minio-operator/minio-operator`` is a legacy chart and should **not** be installed under normal circumstances.

#. Install the Operator

   Run the ``helm install`` command to install the Operator.
   The following command specifies and creates a dedicated namespace ``minio-operator`` for installation.
   MinIO strongly recommends using a dedicated namespace for the Operator.

   .. code-block:: shell
      :class: copyable

      helm install \
        --namespace minio-operator \
        --create-namespace \
        operator minio-operator/operator
      
#. Verify the Operator installation

   Check the contents of the specified namespace (``minio-operator``) to ensure all pods and services have started successfully.

   .. code-block:: shell
      :class: copyable

      kubectl get all -n minio-operator

   The response should resemble the following:

   .. code-block:: shell

      NAME                                  READY   STATUS    RESTARTS   AGE
      pod/minio-operator-699f797b8b-th5bk   1/1     Running   0          25h
      pod/minio-operator-699f797b8b-nkrn9   1/1     Running   0          25h

      NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
      service/operator   ClusterIP   10.43.44.204    <none>        4221/TCP            25h
      service/sts        ClusterIP   10.43.70.4      <none>        4223/TCP            25h

      NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
      deployment.apps/minio-operator   2/2     2            2           25h

      NAME                                        DESIRED   CURRENT   READY   AGE
      replicaset.apps/minio-operator-79f7bfc48    2         2         2       123m

You can now :ref:`deploy a tenant using Helm Charts <deploy-tenant-helm>`.

.. _minio-k8s-deploy-operator-helm-local:

Install the MinIO Operator using Local Helm Charts
--------------------------------------------------

The following procedure installs the Operator using a local copy of the Helm Charts.
This method may support easier pre-configuration of the Operator compared to the :ref:`repo-based installation <minio-k8s-deploy-operator-helm-repo>`

#. Download the Helm charts

   On your local host, download the Operator Helm charts to a convenient directory:

   .. code-block:: shell
      :class: copyable
      :substitutions:

      curl -O https://raw.githubusercontent.com/minio/operator/master/helm-releases/operator-|operator-version-stable|.tgz


#. (Optional) Modify the ``values.yaml``

   The chart contains a ``values.yaml`` file you can customize to suit your needs.
   For details on the options available in the MinIO Operator ``values.yaml``, see :ref:`minio-operator-chart-values`.

   For example, you can change the number of replicas for ``operators.replicaCount`` to increase or decrease pod availability in the deployment.
   See :ref:`minio-operator-chart-values` for more complete documentation on the Operator Helm Chart and Values.

   For more about customizations, see `Helm Charts <https://helm.sh/docs/topics/charts/>`__.

#. Install the Helm Chart

   Use the ``helm install`` command to install the chart.
   The following command assumes the Operator chart is saved to ``./operator`` relative to the working directory.

   .. code-block:: shell
      :class: copyable

      helm install \
      --namespace minio-operator \
      --create-namespace \
      minio-operator ./operator

#. To verify the installation, run the following command:

   .. code-block:: shell
      :class: copyable

      kubectl get all --namespace minio-operator

   If you initialized the Operator with a custom namespace, replace
   ``minio-operator`` with that namespace.

   The output resembles the following:

   .. code-block:: shell

      NAME                                  READY   STATUS    RESTARTS   AGE
      pod/minio-operator-7976b4df5b-rsskl   1/1     Running   0          81m
      pod/minio-operator-7976b4df5b-x622g   1/1     Running   0          81m

      NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
      service/console    ClusterIP   10.105.218.94    <none>        9090/TCP,9443/TCP   81m
      service/operator   ClusterIP   10.110.113.146   <none>        4222/TCP,4233/TCP   81m

      NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
      deployment.apps/minio-operator   2/2     2            2           81m

      NAME                                        DESIRED   CURRENT   READY   AGE
      replicaset.apps/minio-operator-7976b4df5b   1         1         1       81m

You can now :ref:`deploy a tenant using Helm Charts <deploy-tenant-helm>`.
