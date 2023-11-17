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

   Do not use ``kubectl krew`` or similar methods to update or manage the MinIO Operator installation.
   If you use Helm charts to install the Operator, you must use Helm to manage that installation.

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
      minio-operator/operator         5.0.10          v5.0.10         A Helm chart for MinIO Operator
      minio-operator/tenant           5.0.10          v5.0.10         A Helm chart for MinIO Operator

   The ``minio-operator/minio-operator`` is a legacy chart and should **not** be installed under normal circumstances.

#. Install the Operator

   Run the ``helm install`` command to install the Operator:

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
      pod/console-68d955874d-vxlzm          1/1     Running   0          25h
      pod/minio-operator-699f797b8b-th5bk   1/1     Running   0          25h
      pod/minio-operator-699f797b8b-nkrn9   1/1     Running   0          25h

      NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
      service/console    ClusterIP   10.43.195.224   <none>        9090/TCP,9443/TCP   25h
      service/operator   ClusterIP   10.43.44.204    <none>        4221/TCP            25h
      service/sts        ClusterIP   10.43.70.4      <none>        4223/TCP            25h

      NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
      deployment.apps/console          1/1     1            1           25h
      deployment.apps/minio-operator   2/2     2            2           25h

      NAME                                        DESIRED   CURRENT   READY   AGE
      replicaset.apps/console-68d955874d          1         1         1       25h
      replicaset.apps/minio-operator-699f797b8b   2         2         2       25h

#. (Optional) Enable NodePort Access to the Console

   You can enable :kube-docs:`Node Port <concepts/services-networking/service/#type-nodeport>` access to the ``service/console`` service to allow simplified access to the MinIO Operator.
   You can skip this step if you intend to configure the Operator Console service to use a Kubernetes Load Balancer, ingress, or similar control plane component that enables external access.

   Edit the ``service/console`` and set the ``spec.ports[0].nodePort`` and ``spec.type`` fields as follows:

   .. code-block:: yaml
      
      spec:
        ports:
        - name: http
          port: 9090
          protocol: TCP
          targetPort: 9090
          nodePort: 30090
      type: NodePort
   
   You can attempt to connect to the MinIO Operator Console by specifying port ``30090`` on any of the worker nodes in the deployment.

#. Retrieve the Console Access Token

   The MinIO Operator uses a JSON Web Token (JWT) saved as a Kubernetes Secret for controlling access to the Operator Console.

   Use the following command to retrieve the JWT for login.
   You must have permission within the Kubernetes cluster to read secrets:

   .. code-block:: shell
      :class: copyable

      kubectl get secret/console-sa-secret -n minio-operator -o json | jq -r ".data.token" | base64 -d

   The output should resemble the following:

   .. code-block:: shell

      eyJhbGciOiJSUzI1NiIsImtpZCI6IlRtV2x3Z1RILVREaThhQm9iemFfLW95NHFHT0ZZOHFBRjlZalBRcWZiSDgifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJtaW5pby1vcGVyYXRvciIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJjb25zb2xlLXNhLXNlY3JldCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJjb25zb2xlLXNhIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiY2M1ZjEwYzktYzU1ZC00MjNiLTgxM2MtNmU5ZDY2ZGI5NDYyIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Om1pbmlvLW9wZXJhdG9yOmNvbnNvbGUtc2EifQ.F-Pt5nU9xaugjRksWAOTShBW_eNTf8UwXvLfGxEK6l3_41NYsLgvTg5m0hYLUiYr6v2HwkEu0XzqTJbPoeSrFds8BOjeiCoP2Lmw4tRPo9tSXhAq-_elWt83YpJl-zjUpna5nVSWJWXKgj1Iga-9gw-Q63UygEcyTJ9_AwCNU9T0HdPzqccS9XrEUdsXFQxR9RwZY4TGC8K7cD9sc_OmfEiuyilRgyC_gFRvtCQfFv1DP0GKyjMGo2ffu-2Tq2U7zK5epWdqmNSvbIa0ZRoPlPedZ6nYY935lNgTIIW1oykRYrgwZZiv4CzfTH2gPswjtPc5ICtDDRUjYEhdTq3gtw

   If the output includes a trailing ``%`` make sure to omit it from the result.
   
#. Log into the MinIO Operator Console

   If you configured the ``svc/console`` service for access through ingress, a cluster load balancer, you can access the Console using the configured hostname and port.

   If you configured the service for access through NodePorts, specify the hostname of any worker node in the cluster with that port as ``HOSTNAME:NODEPORT`` to access the Console.

   Alternatively, you can use ``kubectl port forward`` to temporary forward ports for the Console:
   
   .. code-block:: shell
      :class: copyable

      kubectl port-forward svc/console -n minio-operator 9090:9090

   You can then use ``http://localhost:9090`` to access the MinIO Operator Console.

   Once you access the Console, use the Console JWT to log in.

You can now :ref:`deploy and manage MinIO Tenants using the Operator Console <deploy-minio-distributed>`.

You can also :ref:`deploy a tenant using Helm Charts <deploy-tenant-helm>`.

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

   The chart contains a ``values.yaml`` file you can customize to suit your needs.
   For more about customizations, see `Helm Charts <https://helm.sh/docs/topics/charts/>`__.
  
#. Deploy Operator

   The following Helm command deploys the MinIO Operator using the downloaded chart:

   .. code-block:: shell
      :class: copyable
      :substitutions:

      helm install \
      --namespace minio-operator \
      --create-namespace \
      operator operator-|operator-version-stable|.tgz

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

You can now :ref:`deploy and manage MinIO Tenants using the Operator Console <deploy-minio-distributed>`.

You can also :ref:`deploy a tenant using Helm Charts <deploy-tenant-helm>`.
