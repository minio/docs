.. start-deprecate-audit-logs

.. important::

   The MinIO Tenant Console Audit Log feature is scheduled for deprecation and removal in an upcoming release.
   MinIO recommends disabling this feature in preparation for this change.

   You can instead use any webhook-capable database or logging service to capture :ref:`audit logs <minio-logging-publish-audit-logs>` from the Tenant.

.. end-deprecate-audit-logs

.. start-deprecate-prometheus

.. important::

   The Tenant Prometheus pod feature is scheduled for deprecation and removal in an upcoming release.
   MinIO recommends setting this value to ``false`` in preparation for this change.

   You can instead use any Prometheus service deployed within the Kubernetes cluster or externally to :ref:`capture Tenant metrics <minio-metrics-collect-using-prometheus>`.

.. end-deprecate-prometheus