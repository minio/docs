.. _minio-bucket-notifications-publish-nats:

======================
Publish Events to NATS
======================

.. default-domain:: minio

.. |ARN| replace:: ``arn:minio:sqs::primary:nats``

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports publishing :ref:`bucket notification <minio-bucket-notifications>` events to a `NATS <https://nats.io/>`__ service endpoint.

.. admonition:: NATS Streaming Deprecated
   :class: important

   NATS Streaming is deprecated.
   Migrate to `JetStream <https://docs.nats.io/nats-concepts/jetstream>`__ instead. 

   The related MinIO configuration options and environment variables are deprecated. 


Add a NATS Endpoint to a MinIO Deployment
-----------------------------------------

The following procedure adds a new NATS service endpoint for supporting :ref:`bucket notifications <minio-bucket-notifications>` in a MinIO deployment.

Prerequisites
~~~~~~~~~~~~~

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.

1) Add the NATS Endpoint to MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can configure a new NATS service endpoint using either environment variables *or* by setting runtime configuration settings.

.. tab-set::

   .. tab-item:: Environment Variables

      MinIO supports specifying the NATS service endpoint and associated configuration settings using :ref:`environment variables <minio-server-envvar-bucket-notification-nats>`. 
      The :mc:`minio server` process applies the specified settings on its next startup.
      
      The following example code sets *all*  environment variables related to configuring an NATS service endpoint. 
      The minimum *required* variables are :envvar:`MINIO_NOTIFY_NATS_ADDRESS` and :envvar:`MINIO_NOTIFY_NATS_SUBJECT`:

      .. cond:: windows
      
         .. code-block:: shell
            :class: copyable
         
               set MINIO_NOTIFY_NATS_ENABLE_<IDENTIFIER>="on"
               set MINIO_NOTIFY_NATS_ADDRESS_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_SUBJECT_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_USERNAME_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_PASSWORD_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_TOKEN_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_TLS_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_TLS_SKIP_VERIFY_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_PING_INTERVAL_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_QUEUE_DIR_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_QUEUE_LIMIT_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_CERT_AUTHORITY_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_CLIENT_CERT_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_CLIENT_KEY_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_COMMENT_<IDENTIFIER>="<string>"
               set MINIO_NOTIFY_NATS_JETSTREAM_<IDENTIFIER>="<string>"

      .. cond:: not windows

         .. code-block:: shell
            :class: copyable

               export MINIO_NOTIFY_NATS_ENABLE_<IDENTIFIER>="on"
               export MINIO_NOTIFY_NATS_ADDRESS_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_SUBJECT_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_USERNAME_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_PASSWORD_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_TOKEN_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_TLS_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_TLS_SKIP_VERIFY_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_PING_INTERVAL_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_QUEUE_DIR_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_QUEUE_LIMIT_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_CERT_AUTHORITY_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_CLIENT_CERT_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_CLIENT_KEY_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_COMMENT_<IDENTIFIER>="<string>"
               export MINIO_NOTIFY_NATS_JETSTREAM_<IDENTIFIER>="<string>"

      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the NATS service endpoint. 
        Use the same ``<IDENTIFIER>`` value for all environment variables related to the new target service endpoint.
        The following examples assume an identifier of ``PRIMARY``.

        If the specified ``<IDENTIFIER>`` matches an existing NATS service endpoint on the MinIO deployment, the new settings *override* any existing settings for that endpoint. 
        Use :mc-cmd:`mc admin config get notify_nats <mc admin config get>` to review the currently configured NATS endpoints on the MinIO deployment.

      - Replace ``<ENDPOINT>`` with the hostname and port of the NATS service endpoint.
        For example: ``nats-endpoint.example.com:4222``

      See :ref:`NATS Service for Bucket Notifications <minio-server-envvar-bucket-notification-nats>` for complete documentation on each environment variable.

   .. tab-item:: Configuration Settings

      MinIO supports adding or updating NATS endpoints on a running 
      :mc:`minio server` process using the :mc-cmd:`mc admin config set` command 
      and the :mc-conf:`notify_nats` configuration key. You must restart the 
      :mc:`minio server` process to apply any new or updated configuration
      settings.

      The following example code sets *all*  settings related to configuring an
      NATS service endpoint. The minimum *required* setting are
      :mc-conf:`notify_nats address <notify_nats.address>` and 
      :mc-conf:`notify_nats subject <notify_nats.subject>`:

      .. code-block:: shell
         :class: copyable

         mc admin config set ALIAS/ notify_nats:IDENTIFIER \
            address="HOSTNAME" \
            subject="<string>" \
            username="<string>" \
            password="<string>" \
            token="<string>" \
            nats_jetstream="<string>" \
            tls="<string>" \
            tls_skip_verify="<string>" \
            ping_interval="<string>" \
            cert_authority="<string>" \
            client_cert="<string>" \
            client_key="<string>" \
            queue_dir="<string>" \
            queue_limit="<string>" \
            comment="<string>"


      - Replace ``IDENTIFIER`` with a unique descriptive string for the NATS service endpoint. 
        The following examples in this procedure assume an identifier of ``PRIMARY``.

        If the specified ``IDENTIFIER`` matches an existing NATS service endpoint on the MinIO deployment, the new settings *override* any existing settings for that endpoint. 
        Use :mc-cmd:`mc admin config get notify_nats <mc admin config get>` to review the currently configured NATS endpoints on the MinIO deployment.

      - Replace ``ENDPOINT`` with the hostname and port of the NATS service endpoint.
        For example: ``nats-endpoint.example.com:4222``.

      See :ref:`NATS Bucket Notification Configuration Settings <minio-server-config-bucket-notification-nats>` for complete       documentation on each setting.

1) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to 
restart.

The :mc:`minio server` process prints a line on startup for each configured NATS
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:nats

You must specify the ARN resource when configuring bucket notifications with
the associated NATS deployment as a target.

.. include:: /includes/common-bucket-notifications.rst
   :start-after: start-bucket-notification-find-arn
   :end-before: end-bucket-notification-find-arn

3) Configure Bucket Notifications using the NATS Endpoint as a Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc event add` command to add a new bucket notification 
event with the configured NATS service as a target:

.. code-block:: shell
   :class: copyable

   mc event add ALIAS/BUCKET arn:minio:sqs::primary:nats \
     --event EVENTS

- Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment.
- Replace ``BUCKET`` with the name of the bucket in which to configure the 
  event.
- Replace ``EVENTS`` with a comma-separated list of :ref:`events 
  <mc-event-supported-events>` for which MinIO triggers notifications.

Use :mc:`mc event ls` to view all configured bucket events for 
a given notification target:

.. code-block:: shell
   :class: copyable

   mc event ls ALIAS/BUCKET arn:minio:sqs::primary:nats

4) Validate the Configured Events
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on the bucket for which you configured the new event and 
check the NATS service for the notification data. The action required
depends on which :mc-cmd:`events <mc event add --event>` were specified
when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET

Update an NATS Endpoint in a MinIO Deployment
---------------------------------------------

The following procedure updates an existing NATS service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

Prerequisites
~~~~~~~~~~~~~~

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.


1) List Configured NATS Endpoints In The Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config get` command to list the currently configured NATS service endpoints in the deployment:

.. code-block:: shell
   :class: copyable

   mc admin config get ALIAS/ notify_nats

Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO deployment.

The command output resembles the following:

.. code-block:: shell

   notify_nats:primary password="yoursecret" subject="" address="nats-endpoint.example.com:4222"  token="" username="yourusername" ping_interval="0" queue_limit="0" tls="off" tls_skip_verify="off" queue_dir="" streaming_enable="on" nats_jetstream="on"
   notify_nats:secondary password="yoursecret" subject="" address="nats-endpoint.example.com:4222"  token="" username="yourusername" ping_interval="0" queue_limit="0" tls="off" tls_skip_verify="off" queue_dir="" streaming_enable="on" nats_jetstream="on"

The :mc-conf:`notify_nats` key is the top-level configuration key for an :ref:`minio-server-config-bucket-notification-nats`. 
The :mc-conf:`address <notify_nats.address>` key specifies the NATS service endpoint for the given ``notify_nats`` key. 
The ``notify_nats:<IDENTIFIER>`` suffix describes the unique identifier for that NATS service endpoint.

Note the identifier for the NATS service endpoint you want to update for the next step. 

2) Update the NATS Endpoint
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config set` command to set the new configuration for the NATS service endpoint:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS/ notify_nats:IDENTIFIER \
      address="HOSTNAME" \
      subject="<string>" \
      username="<string>" \
      password="<string>" \
      token="<string>" \
      tls="<string>" \
      tls_skip_verify="<string>" \
      ping_interval="<string>" \
      nats_jetstream="<string>" \
      cert_authority="<string>" \
      client_cert="<string>" \
      client_key="<string>" \
      queue_dir="<string>" \
      queue_limit="<string>" \
      comment="<string>"

The :mc-conf:`notify_nats address <notify_nats.address>` configuration setting is the *minimum* required for an NATS service endpoint. 
All other configuration settings are *optional*. 
See :ref:`minio-server-config-bucket-notification-nats` for a complete list of NATS configuration settings.

3) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to restart.

The :mc:`minio server` process prints a line on startup for each configured NATS target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:nats

4) Validate the Changes
~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on a bucket which has an event configuration using the updated NATS service endpoint and check the NATS service for the notification data. 
The action required depends on which :mc-cmd:`events <mc event add --event>` were specified when configuring the bucket notification.

For example, if the bucket notification configuration includes the ``s3:ObjectCreated:Put`` event, you can use the :mc:`mc cp` command to create a new object in the bucket and trigger a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET
