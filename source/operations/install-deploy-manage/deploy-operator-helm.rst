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

Helm is a deployment tool for automating the deployment of applications to Kubernetes clusters.
A Helm chart https://helm.sh/docs/topics/charts/ is a set of YAML files, templates, and other files that define the deployment details.
The following procedure uses a Helm Chart to install the MinIO Kubernetes Operator to a Kubernetes cluster.

**Link to Operator info to understand concepts**


Prerequesites
-------------

To install the Operator with Helm you will need the following:

* An existing cluster using Kubernetes 1.19.0 or later (1.21.0 or later recommended).
* The ``kubectl`` CLI tool with the same version as the cluster.
* Helm version xx or greater. https://helm.sh/docs/intro/install/
* yq version xx or greater. https://github.com/mikefarah/yq/#install
* Access to the cluster from your local machine, to run ``kubectl`` commands.

This procedure assumes familiarity with referenced Kubernetes concepts and utilities.
While this documentation may provide guidance for configuring or deploying Kubernetes-related resources on a best-effort basis, it is not a replacement for the official Kubernetes Documentation **link**.



Procedure
---------


Install Operator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Download the Operator and tenant Helm charts

   On your local host machine, download the Operator and tenant Helm charts:

   .. code-block:: shell
      :class: copyable

      curl -O https://raw.githubusercontent.com/minio/operator/master/helm-releases/operator-5.0.4.tgz
      curl -O https://raw.githubusercontent.com/minio/operator/master/helm-releases/tenant-5.0.4.tgz

   Save the files to any convenient working directory.
   
#. Deploy the Operator with the following Helm command:

   .. code-block:: shell
      :class: copyable

      helm install \
      --namespace minio-operator \
      --create-namespace \
      minio-operator operator-5.0.4.tgz

#. Using ``kubectl`` and ``yq``, create the following YAML configuration files:

   * service.yaml

     .. code-block:: shell
        :class: copyable

        kubectl get service console -n minio-operator -o yaml > service.yaml
        yq e -i '.spec.type="NodePort"' service.yaml
        yq e -i '.spec.ports[0].nodePort = PORT_NUMBER' service.yaml

     Replace ``PORT_NUMBER`` with the port on which to serve the Operator GUI. 

     The file contents resemble the following:

     .. code-block:: yaml

        apiVersion: v1
        kind: Service
        metadata:
          annotations:
            meta.helm.sh/release-name: minio-operator
            meta.helm.sh/release-namespace: minio-operator
          creationTimestamp: "2023-05-11T14:57:42Z"
          labels:
            app.kubernetes.io/instance: minio-operator
            app.kubernetes.io/managed-by: Helm
            app.kubernetes.io/name: operator
            app.kubernetes.io/version: v5.0.4
            helm.sh/chart: operator-5.0.4
          name: console
          namespace: minio-operator
          resourceVersion: "907"
          uid: 9297fd97-806a-4715-8bd5-a1f6103149a8
        spec:
          clusterIP: 10.96.157.135
          clusterIPs:
            - 10.96.157.135
          internalTrafficPolicy: Cluster
          ipFamilies:
            - IPv4
          ipFamilyPolicy: SingleStack
          ports:
            - name: http
              port: 9090
              protocol: TCP
              targetPort: 9090
              nodePort: 30080
            - name: https
              port: 9443
              protocol: TCP
              targetPort: 9443
          selector:
            app.kubernetes.io/instance: minio-operator-console
            app.kubernetes.io/name: operator
          sessionAffinity: None
          type: NodePort
        status:
          loadBalancer: {}
     
   * operator.yaml

     .. code-block:: shell
        :class: copyable

        kubectl get deployment minio-operator -n minio-operator -o yaml > operator.yaml
        yq -i -e '.spec.replicas |= 1' operator.yaml

     The file contents resemble the following:
     
     .. code-block:: shell

        apiVersion: apps/v1
        kind: Deployment
        metadata:
          annotations:
            deployment.kubernetes.io/revision: "1"
            meta.helm.sh/release-name: minio-operator
            meta.helm.sh/release-namespace: minio-operator
          creationTimestamp: "2023-05-11T14:57:43Z"
          generation: 1
          labels:
            app.kubernetes.io/instance: minio-operator
            app.kubernetes.io/managed-by: Helm
            app.kubernetes.io/name: operator
            app.kubernetes.io/version: v5.0.4
            helm.sh/chart: operator-5.0.4
          name: minio-operator
          namespace: minio-operator
          resourceVersion: "947"
          uid: f395171e-d17c-4645-9854-3dd92f23be59
        spec:
          progressDeadlineSeconds: 600
          replicas: 1
          revisionHistoryLimit: 10
          selector:
            matchLabels:
              app.kubernetes.io/instance: minio-operator
              app.kubernetes.io/name: operator
          strategy:
            rollingUpdate:
              maxSurge: 25%
              maxUnavailable: 25%
            type: RollingUpdate
          template:
            metadata:
              creationTimestamp: null
              labels:
                app.kubernetes.io/instance: minio-operator
                app.kubernetes.io/name: operator
            spec:
              affinity:
                podAntiAffinity:
                  requiredDuringSchedulingIgnoredDuringExecution:
                    - labelSelector:
                        matchExpressions:
                          - key: name
                            operator: In
                            values:
                              - minio-operator
                      topologyKey: kubernetes.io/hostname
              containers:
                - args:
                    - controller
                  image: quay.io/minio/operator:v5.0.4
                  imagePullPolicy: IfNotPresent
                  name: operator
                  resources:
                    requests:
                      cpu: 200m
                      ephemeral-storage: 500Mi
                      memory: 256Mi
                  securityContext:
                    runAsGroup: 1000
                    runAsNonRoot: true
                    runAsUser: 1000
                  terminationMessagePath: /dev/termination-log
                  terminationMessagePolicy: File
              dnsPolicy: ClusterFirst
              restartPolicy: Always
              schedulerName: default-scheduler
              securityContext:
                fsGroup: 1000
                runAsGroup: 1000
                runAsNonRoot: true
                runAsUser: 1000
              serviceAccount: minio-operator
              serviceAccountName: minio-operator
              terminationGracePeriodSeconds: 30
        status:
          conditions:
            - lastTransitionTime: "2023-05-11T14:57:43Z"
              lastUpdateTime: "2023-05-11T14:57:43Z"
              message: Deployment does not have minimum availability.
              reason: MinimumReplicasUnavailable
              status: "False"
              type: Available
            - lastTransitionTime: "2023-05-11T14:57:43Z"
              lastUpdateTime: "2023-05-11T14:57:44Z"
              message: ReplicaSet "minio-operator-674cf5cf78" is progressing.
              reason: ReplicaSetUpdated
              status: "True"
              type: Progressing
          observedGeneration: 1
          replicas: 2
          unavailableReplicas: 2
          updatedReplicas: 2
		     
   * console-secret.yaml

     Create a ``console-secret.yaml`` file with the following contents:
     
     .. code-block:: shell
        :class: copyable

        apiVersion: v1
        kind: Secret
        metadata:
          name: console-sa-secret
          namespace: minio-operator
          annotations:
            kubernetes.io/service-account.name: console-sa
        type: kubernetes.io/service-account-token

#. ``kubectl apply`` the YAML files to apply the configuration to your deployment:

   .. code-block:: shell
      :class: copyable

      kubectl apply -f service.yaml
      kubectl apply -f operator.yaml
      kubectl apply -f console-secret.yaml

   
#. Connect to the Operator Console

   include Connect to the Operator Console 

Deploy a Tenant
~~~~~~~~~~~~~~~

You may deploy a MinIO tenant using either the Operator Console or Helm.
To deploy a tenant with Operator, see Deploy and Manage MinIO Tenants.

To deploy a tenant with Helm:

#. The following Helm command creates a MinIO tenant:

   .. code-block:: shell
      :class: copyable

      helm install \
      --namespace tenant-ns \
      --create-namespace \
      tenant-ns tenant-5.0.4.tgz

#. Expose the tenant Console port

   **link to port forwarding info**
   
#. Login to the MinIO Console

   Default credentials: myminio/minio123
