.. cond:: linux or windows or macos

   .. include:: /includes/common/installation.rst

.. cond:: container

   .. include:: /includes/container/installation.rst

.. cond:: eks

   .. include:: /includes/eks/deploy-minio-on-elastic-kubernetes-service.rst

.. cond:: gke

   .. include:: /includes/gke/deploy-minio-on-google-kubernetes-engine.rst

.. cond:: aks

   .. include:: /includes/aks/deploy-minio-on-azure-kubernetes-service.rst

.. cond:: k8s and not (eks or gke or aks)

   .. include:: /includes/k8s/deploy-operator.rst
