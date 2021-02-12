.. Used in the following pages:
   - /monitoring/bucket-notifications/publish-events-to-amqp.rst

.. start-restart-downtime

.. important::

   This procedure *requires* restarting all :mc:`minio server` processes
   associated to the deployment at the same time. There is typically a brief
   period of time during which API operations are interrupted or may fail.

   Applications using an S3-compatible SDK with built-in retry logic *or* which
   implement manual retry logic typically experience no notable interruption in
   services. For applications which cannot use retry-logic, consider scheduling
   a maintenance period to minimize interruption of services while performing
   this procedure.

.. end-restart-downtime