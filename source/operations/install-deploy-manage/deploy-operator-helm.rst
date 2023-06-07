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

This procedure assumes familiarity the with referenced Kubernetes concepts and utilities.
While this documentation may provide guidance for configuring or deploying Kubernetes-related resources on a best-effort basis, it is not a replacement for the official :kube-docs:`Kubernetes Documentation <>`.


Procedure
---------


Install Operator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Download the Helm charts

   On your local host, download the Operator and Tenant Helm charts to a convenient directory:

   .. code-block:: shell
      :class: copyable
      :substitutions:

      curl -O https://raw.githubusercontent.com/minio/operator/master/helm-releases/operator-|operator-version-stable|.tgz
      curl -O https://raw.githubusercontent.com/minio/operator/master/helm-releases/Tenant-|operator-version-stable|.tgz

   Each chart contains a ``values.yaml`` file you can customize to suit your needs.
   For example, you may wish to change the MinIO root user credentials or the Tenant name.
   For more about customizations, see `Helm Charts <https://helm.sh/docs/topics/charts/>`__.
  
#. Deploy Operator

   The following Helm command deploys the MinIO Operator using the downloaded chart:

   .. code-block:: shell
      :class: copyable
      :substitutions:

      helm install \
      --namespace minio-operator \
      --create-namespace \
      minio-operator operator-|operator-version-stable|.tgz

#. Configure Operator

   A. Create the YAML configuration files
   
      Use ``kubectl`` and ``yq`` to create the following files:

      * service.yaml:

        .. code-block:: shell
           :class: copyable

           kubectl get service console -n minio-operator -o yaml > service.yaml
           yq e -i '.spec.type="NodePort"' service.yaml
           yq e -i '.spec.ports[0].nodePort = PORT_NUMBER' service.yaml

        Replace ``PORT_NUMBER`` with the port on which to serve the Operator GUI.

        The file contents resemble the following:

        .. dropdown:: Example ``service.yaml`` file

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
     
      * operator.yaml:

        .. code-block:: shell
           :class: copyable

           kubectl get deployment minio-operator -n minio-operator -o yaml > operator.yaml
           yq -i -e '.spec.replicas |= 1' operator.yaml

        The file contents resemble the following:

        .. dropdown:: Example ``operator.yaml`` file

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
		     
      * console-secret.yaml:

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

   B. Apply the configuration to your deployment with ``kubectl apply``:

      .. code-block:: shell
         :class: copyable

         kubectl apply -f service.yaml
         kubectl apply -f operator.yaml
         kubectl apply -f console-secret.yaml

#. To verify the installation, run the following command:

   .. code-block:: shell
      :class: copyable

      kubectl get all --namespace minio-operator

   If you initialized the Operator with a custom namespace, replace
   ``minio-operator`` with that namespace.

   The output resembles the following:

   .. code-block:: shell

      NAME                                  READY   STATUS    RESTARTS   AGE
      pod/console-59b769c486-cv7zv          1/1     Running   0          81m
      pod/minio-operator-7976b4df5b-rsskl   1/1     Running   0          81m

      NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
      service/console    ClusterIP   10.105.218.94    <none>        9090/TCP,9443/TCP   81m
      service/operator   ClusterIP   10.110.113.146   <none>        4222/TCP,4233/TCP   81m

      NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
      deployment.apps/console          1/1     1            1           81m
      deployment.apps/minio-operator   1/1     1            1           81m

      NAME                                        DESIRED   CURRENT   READY   AGE
      replicaset.apps/console-59b769c486          1         1         1       81m
      replicaset.apps/minio-operator-7976b4df5b   1         1         1       81m

	 
#. Connect to the Operator Console

   To connect to the Console, first retrieve the JSON Web Token (JWT) for your deployment and then forward the Console port.

   A. Retrieve the JWT

      The Operator Console uses a JWT to authenticate and log in.
      The following commands retrieve the token for your deployment:

      .. code-block:: shell
           :class: copyable

           SA_TOKEN=$(kubectl -n minio-operator  get secret console-sa-secret -o jsonpath="{.data.token}" | base64 --decode)
           echo $SA_TOKEN

   B. Forward the Operator Console port to allow access from another host. 

      The following command temporarily forwards the Console to port 9090:

      .. code-block:: shell
         :class: copyable

         kubectl --namespace minio-operator port-forward svc/console 9090:9090

      This command forwards the pod port ``9090`` to the matching port on the local machine while active in the shell.
      The ``kubectl port-forward`` command only functions while active in the shell session.
      Terminating the session closes the ports on the local machine.

   C. Access the Console by navigating to ``http://localhost:9090`` in a browser and login with the JWT.
      
   .. note::
      
      Some Kubernetes deployments may experience issues with timeouts during port-forwarding operations with the Operator Console.
      Select the :guilabel:`NodePorts` section to view instructions for alternative access.
      You can alternatively configure your preferred Ingress to grant access to the Operator Console service.
      See https://github.com/kubernetes/kubectl/issues/1368 for more information.

.. dropdown:: NodePorts

   Use the following command to identify the :kube-docs:`NodePorts <concepts/services-networking/service/#type-nodeport>` configured for the Operator Console.
   If your local host does not have the ``jq`` utility installed, you can run the first command and locate the ``spec.ports`` section of the output.

   .. code-block:: shell
      :class: copyable

      kubectl get svc/console -n minio-operator -o json | jq -r '.spec.ports'

   The output resembles the following:

   .. code-block:: json

      [
         {
            "name": "http",
            "nodePort": 31055,
            "port": 9090,
            "protocol": "TCP",
            "targetPort": 9090
         },
         {
            "name": "https",
            "nodePort": 31388,
            "port": 9443,
            "protocol": "TCP",
            "targetPort": 9443
         }
      ]

   Use the ``http`` or ``https`` port depending on whether you deployed the Operator with Console TLS enabled via :mc-cmd:`kubectl minio init --console-tls`.

   Append the ``nodePort`` value to the externally-accessible IP address of a worker node in your Kubernetes cluster.


Deploy a Tenant
~~~~~~~~~~~~~~~

You can deploy a MinIO Tenant using either the :ref:`Operator Console <minio-operator-console>` or Helm.
To deploy a Tenant with the Console, see :ref:`Deploy and Manage MinIO Tenants <minio-installation>`.

To deploy a Tenant with Helm:

#. The following Helm command creates a MinIO Tenant using the standard chart:

   .. code-block:: shell
      :class: copyable
      :substitutions:

      helm install \
      --namespace Tenant-ns \
      --create-namespace \
      Tenant-ns Tenant-|operator-version-stable|.tgz

   To deploy more than one Tenant, create a Helm chart with the details of the new Tenant and repeat the deployment steps.
   Redeploying the same chart updates the previously deployed Tenant.

#. Expose the Tenant Console port

   Use ``kubectl port-forward`` to temporarily forward traffic from the MinIO pod to your local machine:

   .. code-block:: shell
      :class: copyable

      kubectl --namespace Tenant-ns port-forward svc/myminio-console 9443:9443
   
   .. note::
      
      To configure long term access to the pod, configure :kube-docs:`Ingress <concepts/services-networking/ingress/>` or similar network control components within Kubernetes to route traffic to and from the pod.
      Configuring Ingress is out of the scope for this documentation.

#. Login to the MinIO Console

   Access the Tenant's :ref:`minio-console` by navigating to ``http://localhost:9443`` in a browser.
   Log in to the Console with the default credentials ``myminio | minio123``.

#. Expose the Tenant MinIO port

   To test the MinIO Client :mc:`mc` from your local machine, forward the MinIO port and create an alias.

   * Forward the Tenant's MinIO port:

     .. code-block:: shell
        :class: copyable

        kubectl port-forward svc/myminio-hl 9000 -n tenant-ns

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
