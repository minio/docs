.. start-minio-only

.. admonition:: SUBNET Registration Required
   :class: note

   The ``mc support`` commands are designed for MinIO deployments registered with |subnet| to ensure optimal outcome of diagnostics and performance testing. 
   Deployments not registered with SUBNET cannot use the ``mc support`` commands.

.. end-minio-only

.. start-support-logs-opt-in

The uploading feature remains disabled by default until explicitly enabled for a deployment on an opt-in only basis.
If enabled, you can disable the feature at any time with :mc-cmd:`mc support logs disable`.

.. end-support-logs-opt-in