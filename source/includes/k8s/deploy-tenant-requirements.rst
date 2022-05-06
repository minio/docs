.. start-local-persistent-volume

.. code-block:: yaml
   :class: copyable
   :emphasize-lines: 4, 12, 14, 22

   apiVersion: v1
   kind: PersistentVolume
   metadata:
      name: <PV-NAME>
   spec:
      capacity:
         storage: 1Ti
      volumeMode: Filesystem
      accessModes:
      - ReadWriteOnce
      persistentVolumeReclaimPolicy: Retain
      storage-class: <STORAGE-CLASS>
      local:
         path: <PATH-TO-DISK>
      nodeAffinity:
         required:
            nodeSelectorTerms:
            - matchExpressions:
               - key: kubernetes.io/hostname
                  operator: In
                  values:
                  - <NODE-NAME>

.. end-local-persistent-volume

.. start-storage-class

.. code-block:: yaml
   :class: copyable

   apiVersion: storage.k8s.io/v1
   kind: StorageClass
   metadata:
      name: minio-local-storage
   provisioner: kubernetes.io/no-provisioner
   volumeBindingMode: WaitForFirstConsumer

.. end-storage-class
