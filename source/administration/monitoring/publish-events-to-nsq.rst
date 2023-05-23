.. _minio-bucket-notifications-publish-nsq:

=====================
Publish Events to NSQ
=====================

.. default-domain:: minio

.. |ARN| replace:: ``arn:minio:sqs::primary:nsq``

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports publishing :ref:`bucket notification
<minio-bucket-notifications>` events to `NSQ <https://nsq.io/>`__ 
service endpoint.

Add a NSQ Endpoint to a MinIO Deployment
----------------------------------------

The following procedure adds a new NSQ service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

Prerequisites
~~~~~~~~~~~~~

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.

1) Add the NSQ Endpoint to MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can configure a new NSQ service endpoint using either environment variables
*or* by setting runtime configuration settings.

.. tab-set::

   .. tab-item:: Environment Variables

      MinIO supports specifying the NSQ service endpoint and associated
      configuration settings using 
      :ref:`environment variables 
      <minio-server-envvar-bucket-notification-nsq>`. The 
      :mc:`minio server` process applies the specified settings on its 
      next startup.
      
      The following example code sets *all*  environment variables
      related to configuring an NSQ service endpoint. The minimum
      *required* variables are
      :envvar:`MINIO_NOTIFY_NSQ_NSQD_ADDRESS` and 
      :envvar:`MINIO_NOTIFY_NSQ_TOPIC`:


      .. code-block:: shell
         :class: copyable

         set MINIO_NOTIFY_NSQ_ENABLE_<IDENTIFIER>="on"
         set MINIO_NOTIFY_NSQ_NSQD_ADDRESS_<IDENTIFIER>="<ENDPOINT>"
         set MINIO_NOTIFY_NSQ_TOPIC_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_NSQ_TLS_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_NSQ_TLS_SKIP_VERIFY_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_NSQ_QUEUE_DIR_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_NSQ_QUEUE_LIMIT_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_NSQ_COMMENT_<IDENTIFIER>="<string>"

      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the
        TARGET service endpoint. Use the same ``<IDENTIFIER>`` value for all 
        environment variables related to the new target service endpoint.
        The following examples assume an identifier of ``PRIMARY``.

        If the specified ``<IDENTIFIER>`` matches an existing NSQ service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_nsq <mc admin config get>` to
        review the currently configured NSQ endpoints on the MinIO deployment.

      - Replace ``<ENDPOINT>`` with the URL of the NSQ service endpoint.
        For example, ``https://nsq-service.example.com:4150``.

      See :ref:`NSQ Service for Bucket Notifications
      <minio-server-envvar-bucket-notification-nsq>` for complete documentation
      on each environment variable.

   .. tab-item:: Configuration Settings

      MinIO supports adding or updating NSQ endpoints on a running 
      :mc:`minio server` process using the :mc-cmd:`mc admin config set` command 
      and the :mc-conf:`notify_nsq` configuration key. You must restart the 
      :mc:`minio server` process to apply any new or updated configuration
      settings.

      The following example code sets *all*  settings related to configuring an
      NSQ service endpoint. The minimum *required* setting is 
      :mc-conf:`notify_nsq nsqd_address <notify_nsq.nsqd_address>` and 
      :mc-conf:`notify_nsq topic <notify_nsq.topic>`:

      .. code-block:: shell
         :class: copyable

         mc admin config set ALIAS/ notify_nsq:IDENTIFIER \
           nsqd_address="ENDPOINT" \
           topic="<string>" \
           tls="<string>" \
           tls_skip_verify="<string>" \
           queue_dir="<string>" \
           queue_limit="<string>" \
           comment="<string>"


      - Replace ``IDENTIFIER`` with a unique descriptive string for the
        NSQ service endpoint. The following examples in this procedure
        assume an identifier of ``PRIMARY``.

        If the specified ``IDENTIFIER`` matches an existing NSQ service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_nsq <mc admin config get>` to
        review the currently configured NSQ endpoints on the MinIO deployment.

      - Replace ``ENDPOINT`` with the URL of the NSQ service endpoint.
        For example:

        ``NSQ://user:password@hostname:port``

      See :ref:`NSQ Bucket Notification Configuration Settings
      <minio-server-config-bucket-notification-nsq>` for complete 
      documentation on each setting.

2) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to 
restart.

The :mc:`minio server` process prints a line on startup for each configured NSQ
target similar to the following:

.. code-block:: shell

   SQS ARNs: |ARN|

You must specify the ARN resource when configuring bucket notifications with the associated NSQ deployment as a target.

.. include:: /includes/common-bucket-notifications.rst
   :start-after: start-bucket-notification-find-arn
   :end-before: end-bucket-notification-find-arn

3) Configure Bucket Notifications using the NSQ Endpoint as a Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc event add` command to add a new bucket notification event with the configured NSQ service as a target:

.. code-block:: shell
   :class: copyable

   mc event add ALIAS/BUCKET arn:minio:sqs::primary:nsq \
     --event EVENTS

- Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment.
- Replace ``BUCKET`` with the name of the bucket in which to configure the event.
- Replace ``EVENTS`` with a comma-separated list of :ref:`events 
  <mc-event-supported-events>` for which MinIO triggers notifications.

Use :mc:`mc event ls` to view all configured bucket events for a given notification target:

.. code-block:: shell
   :class: copyable

   mc event ls ALIAS/BUCKET arn:minio:sqs::primary:nsq

4) Validate the Configured Events
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on the bucket for which you configured the new event and check the NSQ service for the notification data. 
The action required depends on which :mc-cmd:`events <mc event add --event>` were specified when configuring the bucket notification.

For example, if the bucket notification configuration includes the ``s3:ObjectCreated:Put`` event, you can use the :mc:`mc cp` command to create a new object in the bucket and trigger a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET

Update an NSQ Endpoint in a MinIO Deployment
--------------------------------------------

The following procedure updates an existing NSQ service endpoint for supporting :ref:`bucket notifications <minio-bucket-notifications>` in a MinIO deployment.

Prerequisites
~~~~~~~~~~~~~~

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.


1) List Configured NSQ Endpoints In The Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config get` command to list the currently configured NSQ service endpoints in the deployment:

.. code-block:: shell
   :class: copyable

   mc admin config get ALIAS/ notify_nsq

Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO deployment.

The command output resembles the following:

.. code-block:: shell

   notify_nsq:primary nsqd_address="https://nsq.example.com" queue_dir="" queue_limit="0"  tls="off" tls_skip_verify="off" topic=""
   notify_nsq:secondary nsqd_address="https://nsq.example.com" queue_dir="" queue_limit="0"  tls="off" tls_skip_verify="off" topic=""

The :mc-conf:`notify_nsq` key is the top-level configuration key for an :ref:`minio-server-config-bucket-notification-nsq`. 
The :mc-conf:`nsqd_address <notify_nsq.nsqd_address>` key specifies the NSQ service endpoint for the given `notify_nsq` key. 
The ``notify_nsq:<IDENTIFIER>`` suffix describes the unique identifier for that NSQ service endpoint.

Note the identifier for the NSQ service endpoint you want to update for the next step. 

2) Update the NSQ Endpoint
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config set` command to set the new configuration for the NSQ service endpoint:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS/ notify_nsq:<IDENTIFIER> \
      nsqd_address="NSQ://user:password@hostname:port" \
      topic="<string>" \
      tls="<string>" \
      tls_skip_verify="<string>" \
      queue_dir="<string>" \
      queue_limit="<string>" \
      comment="<string>"

The :mc-conf:`notify_nsq nsqd_address <notify_nsq.nsqd_address>` configuration setting is the *minimum* required for an NSQ service endpoint. 
All other configuration settings are *optional*. 
See :ref:`minio-server-config-bucket-notification-nsq` for a complete list of NSQ configuration settings.

3) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to restart.

The :mc:`minio server` process prints a line on startup for each configured NSQ target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:NSQ

4) Validate the Changes
~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on a bucket which has an event configuration using the updated NSQ service endpoint and check the NSQ service for the notification data. 
The action required depends on which :mc-cmd:`events <mc event add --event>` were specified when configuring the bucket notification.

For example, if the bucket notification configuration includes the ``s3:ObjectCreated:Put`` event, you can use the :mc:`mc cp` command to create a new object in the bucket and trigger a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET