.. _quickstart-kubernetes:

=========================
Quickstart for Kubernetes
=========================

.. default-domain:: minio

.. |OS| replace:: Kubernetes

This procedure deploys a Single-Node Single-Drive MinIO server onto |OS| for early development and evaluation of MinIO Object Storage and its S3-compatible API layer. 

Use the :ref:`MinIO Operator <minio-operator-installation>` to deploy and manage production-ready MinIO tenants on Kubernetes.

Prerequisites
-------------

- An existing Kubernetes deployment where *at least* one Worker Node has a locally-attached drive.
- A local ``kubectl`` installation configured to create and access resources on the target Kubernetes deployment.
- Familiarity with Kubernetes environments
- Familiarity with using a Terminal or Shell environment

Procedure
---------

#. **Download the MinIO Object**

   .. tab-set::

      .. tab-item:: Download the MinIO Kubernetes Object Definition

         Download `minio-dev.yaml <https://raw.githubusercontent.com/minio/docs/master/source/extra/examples/minio-dev.yaml>`__ to your host machine:

         .. code-block:: shell
            :class: copyable

            curl https://raw.githubusercontent.com/minio/docs/master/source/extra/examples/minio-dev.yaml -O

         The file describes two Kubernetes resources:

         - A new namespace ``minio-dev``, and
         - A MinIO pod using a drive or volume on the Worker Node for serving data

         Select the :guilabel:`Overview of the MinIO Object YAML` for a more detailed description of the object.

      .. tab-item:: Overview of the MinIO Object YAML

         The ``minio-dev.yaml`` contains the following Kubernetes resources:

         .. literalinclude:: /extra/examples/minio-dev.yaml
            :language: yaml

         The object deploys two resources:

         - A new namespace ``minio-dev``, and
         - A MinIO pod using a drive or volume on the Worker Node for serving data

         The MinIO resource definition uses Kubernetes :kube-docs:`Node Selectors and Labels <concepts/scheduling-eviction/assign-pod-node/#built-in-node-labels>` to restrict the pod to a node with matching hostname label. 
         Use ``kubectl get nodes --show-labels`` to view all labels assigned to each node in the cluster.

         The MinIO Pod uses a :kube-docs:`hostPath <concepts/storage/volumes/#hostpath>` volume for storing data. This path *must* correspond to a local drive or folder on the Kubernetes worker node.

         Users familiar with Kubernetes scheduling and volume provisioning may modify the ``spec.nodeSelector``, ``volumeMounts.name``, and ``volumes`` fields to meet more specific requirements.

#. **Apply the MinIO Object Definition**

   The following command applies the ``minio-dev.yaml`` configuration and deploys the objects to Kubernetes:

   .. code-block:: shell
      :class: copyable

      kubectl apply -f minio-dev.yaml

   The command output should resemble the following:

   .. code-block:: shell

      namespace/minio-dev created
      pod/minio created

   You can verify the state of the pod by running ``kubectl get pods``:

   .. code-block:: shell
      :class: copyable

      kubectl get pods -n minio-dev

   The output should resemble the following:

   .. code-block:: shell

      NAME    READY   STATUS    RESTARTS   AGE
      minio   1/1     Running   0          77s

   You can also use the following commands to retrieve detailed information on the pod status:

   .. code-block:: shell
      :class: copyable

      kubectl describe pod/minio -n minio-dev

      kubectl logs pod/minio -n minio-dev

#. **Temporarily Access the MinIO S3 API and Console**

   Use the ``kubectl port-forward`` command to temporarily forward traffic from the MinIO pod to the local machine:

   .. code-block:: shell
      :class: copyable

      kubectl port-forward pod/minio 9000 9090
   
   The command forwards the pod ports ``9000`` and ``9090`` to the matching port on the local machine while active in the shell.
   The ``kubectl port-forward`` command only functions while active in the shell session.
   Terminating the session closes the ports on the local machine.

   .. note::
      
      The following steps of this procedure assume an active ``kubectl port-forward`` command.

      To configure long term access to the pod, configure :kube-docs:`Ingress <concepts/services-networking/ingress/>` or similar network control components within Kubernetes to route traffic to and from the pod. Configuring Ingress is out of the scope for this documentation.

#. **Connect your Browser to the MinIO Server**

   Access the :ref:`minio-console` by opening a browser on the local machine and navigating to ``http://127.0.0.1:9090``.

   Log in to the Console with the credentials ``minioadmin | minioadmin``.
   These are the default :ref:`root user <minio-users-root>` credentials.

   .. image:: /images/minio-console/console-login.png
      :width: 600px
      :alt: MinIO Console displaying login screen
      :align: center

   You can use the MinIO Console for general administration tasks like Identity and Access Management, Metrics and Log Monitoring, or Server Configuration. 
   Each MinIO server includes its own embedded MinIO Console.

   .. image:: /images/minio-console/minio-console.png
      :width: 600px
      :alt: MinIO Console displaying bucket start screen
      :align: center

   For more information, see the :ref:`minio-console` documentation.

#. **(Optional) Connect the MinIO Client**

   If your local machine has :mc:`mc` :ref:`installed <mc-install>`, use the :mc-cmd:`mc alias set` command to authenticate and connect to the MinIO deployment:

   .. code-block:: shell
      :class: copyable

      mc alias set k8s-minio-dev http://127.0.0.1:9000 minioadmin minioadmin
      mc admin info k8s-minio-dev

   - The name of the alias
   - The hostname or IP address and port of the MinIO server
   - The Access Key for a MinIO :ref:`user <minio-users>`
   - The Secret Key for a MinIO :ref:`user <minio-users>`

Next Steps
----------

- :ref:`Connect your applications to MinIO <minio-drivers>`
- :ref:`Configure Object Retention <minio-object-retention>`
- :ref:`Configure Security <minio-authentication-and-identity-management>`
- :ref:`Deploy MinIO for Production Environments <deploy-minio-distributed>`
