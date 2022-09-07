.. start-minio-only

.. note::

   The ``mc support`` commands were designed for MinIO deployments registered with |subnet| to ensure optimal outcome of diagnostics and performance testing. 
   MinIO does not guarantee any functionality if used against non-MinIO deployments or if used independently of MinIO engineering and support.

.. end-minio-only

.. start-support-logs-opt-in

Uploading logs requires registration to SUBNET.
The uploading feature remains disabled by default until explicitly enabled for a deployment on an opt-in only basis.
You can then disable the feature at any time with :mc-cmd:`mc support logs disable`.

.. end-support-logs-opt-in