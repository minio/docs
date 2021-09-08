.. _minio-bucket-notifications-publish-mqtt:

======================
Publish Events to MQTT
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports publishing :ref:`bucket notification
<minio-bucket-notifications>` events to `MQTT <https://www.mqtt.org/>`__ 
server/broker endpoint.

Add an MQTT Endpoint to a MinIO Deployment
------------------------------------------

The following procedure adds a new MQTT service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

.. include:: /includes/common-admonitions.rst
   :start-after: start-restart-downtime
   :end-before: end-restart-downtime

Prerequisites
~~~~~~~~~~~~~~

MQTT 3.1 or 3.1.1 Server/Broker
+++++++++++++++++++++++++++++++

This procedure assumes an existing MQTT 3.1 or 3.1.1 server/broker to which the
MinIO deployment has connectivity. See the 
`mqtt.org software listing <https://mqtt.org/software/>`__ for a list of
MQTT-compatible server/brokers.

If the MQTT service requires authentication, you *must* provide an appropriate
username and password during the configuration process to grant MinIO access
to the service.

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.

1) Add the MQTT Endpoint to MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can configure a new MQTT service endpoint using either environment variables
*or* by setting runtime configuration settings.

.. tab-set::

   .. tab-item:: Environment Variables

      MinIO supports specifying the MQTT service endpoint and associated
      configuration settings using 
      :ref:`environment variables 
      <minio-server-envvar-bucket-notification-mqtt>`. The 
      :mc:`minio server` process applies the specified settings on its 
      next startup.
      
      The following example code sets *all*  environment variables
      related to configuring an MQTT service endpoint. The minimum *required*
      variables are:

      - :envvar:`MINIO_NOTIFY_MQTT_ENABLE`
      - :envvar:`MINIO_NOTIFY_MQTT_BROKER`
      - :envvar:`MINIO_NOTIFY_MQTT_TOPIC`
      - :envvar:`MINIO_NOTIFY_MQTT_USERNAME` *Required if the MQTT server/broker enforces authentication/authorization*
      - :envvar:`MINIO_NOTIFY_MQTT_PASSWORD` *Required if the MQTT server/broker enforces authentication/authorization*

      .. code-block:: shell
         :class: copyable

         set MINIO_NOTIFY_MQTT_ENABLE_<IDENTIFIER>="on"
         set MINIO_NOTIFY_MQTT_BROKER_<IDENTIFIER>="ENDPOINT"
         set MINIO_NOTIFY_MQTT_TOPIC_<IDENTIFIER>="TOPIC"
         set MINIO_NOTIFY_MQTT_USERNAME_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_MQTT_PASSWORD_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_MQTT_QOS_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_MQTT_KEEP_ALIVE_INTERVAL_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_MQTT_RECONNECT_INTERVAL_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_MQTT_QUEUE_DIR_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_MQTT_QUEUE_LIMIT_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_MQTT_COMMENT_<IDENTIFIER>="<string>"

      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the
        MQTT service endpoint. Use the same ``<IDENTIFIER>`` value for all 
        environment variables related to the new MQTT service endpoint.
        The following examples assume an identifier of ``PRIMARY``.

        If the specified ``<IDENTIFIER>`` matches an existing MQTT service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_mqtt <mc admin config get>` to
        review the currently configured MQTT endpoints on the MinIO deployment.

      - Replace ``<ENDPOINT>`` with the URL of the MQTT service endpoint.
        For example:

        ``tcp://hostname:port``

      - Replace ``TOPIC`` with the MQTT topic to which MinIO associates 
        events published to the server/broker.

      See :ref:`MQTT Service for Bucket Notifications
      <minio-server-envvar-bucket-notification-mqtt>` for complete documentation
      on each environment variable.

   .. tab-item:: Configuration Settings

      MinIO supports adding or updating MQTT endpoints on a running 
      :mc:`minio server` process using the :mc-cmd:`mc admin config set` command 
      and the :mc-conf:`notify_mqtt` configuration key. You must restart the 
      :mc:`minio server` process to apply any new or updated configuration
      settings.

      The following example code sets *all*  settings related to configuring an
      MQTT service endpoint. The following configuration settings are the
      *minimum* required for an MQTT server/broker endpoint:

      - :mc-conf:`~notify_mqtt.broker`
      - :mc-conf:`~notify_mqtt.topic`
      - :mc-conf:`~notify_mqtt.username` *Required if the MQTT server/broker enforces authentication/authorization*
      - :mc-conf:`~notify_mqtt.password` *Required if the MQTT server/broker enforces authentication/authorization*

      .. code-block:: shell
         :class: copyable

         mc admin config set ALIAS/ notify_mqtt:IDENTIFIER \
            broker="ENDPOINT" \
            topic="TOPIC" \
            username="username" \
            password="password" \
            qos="<integer>" \
            keep_alive_interval="60s|m|h|d"
            reconnect_interval="60s|m|h|d"
            queue_dir="<string>" \
            queue_limit="<string>" \
            comment="<string>"

      - Replace ``IDENTIFIER`` with a unique descriptive string for the
        MQTT service endpoint. The following examples in this procedure
        assume an identifier of ``PRIMARY``.

        If the specified ``IDENTIFIER`` matches an existing MQTT service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_mqtt <mc admin config get>` to
        review the currently configured MQTT endpoints on the MinIO deployment.

      - Replace ``ENDPOINT`` with the URL of the MQTT service endpoint.
        For example:

        ``tcp://hostname:port``

      - Replace ``TOPIC`` with the MQTT topic to which MinIO associates 
        events published to the server/broker.

      See :ref:`MQTT Bucket Notification Configuration Settings
      <minio-server-config-bucket-notification-mqtt>` for complete 
      documentation on each setting.

2) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. important::

   MinIO restarts *all* :mc:`minio server` processes associated to the 
   deployment at the same time. Applications may experience a brief period of 
   downtime during the restart process. 

   Consider scheduling the restart during a maintenance period to minimize
   interruption of services.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :mc:`alias <mc-alias>` of the deployment to 
restart.

The :mc:`minio server` process prints a line on startup for each configured MQTT
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:mqtt

You must specify the ARN resource when configuring bucket notifications with
the associated MQTT deployment as a target.

3) Configure Bucket Notifications using the MQTT Endpoint as a Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc event add` command to add a new bucket notification 
event with the configured MQTT service as a target:

.. code-block:: shell
   :class: copyable

   mc event add ALIAS/BUCKET arn:minio:sqs::primary:mqtt \
     --event EVENTS

- Replace ``ALIAS`` with the :mc:`alias <mc-alias>` of a MinIO deployment.
- Replace ``BUCKET`` with the name of the bucket in which to configure the 
  event.
- Replace ``EVENTS`` with a comma-separated list of :ref:`events 
  <mc-event-supported-events>` for which MinIO triggers notifications.

Use :mc-cmd:`mc event list` to view all configured bucket events for 
a given notification target:

.. code-block:: shell
   :class: copyable

   mc event list ALIAS/BUCKET arn:minio:sqs::primary:MQTT

4) Validate the Configured Events
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on the bucket for which you configured the new event and 
check the MQTT service for the notification data. The action required
depends on which :mc-cmd:`events <mc-event-add-event>` were specified
when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc-cmd:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET

Update an MQTT Endpoint in a MinIO Deployment
---------------------------------------------

The following procedure updates an existing MQTT service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

.. include:: /includes/common-admonitions.rst
   :start-after: start-restart-downtime
   :end-before: end-restart-downtime

Prerequisites
~~~~~~~~~~~~~~

MQTT 3.1 or 3.1.1 Server/Broker Endpoint
++++++++++++++++++++++++++++++++++++++++

This procedure assumes an existing MQTT 3.1 or 3.1.1 server/broker to which the
MinIO deployment has connectivity. See the 
`mqtt.org software listing <https://mqtt.org/software/>`__ for a list of
MQTT-compatible server/brokers.

If the MQTT service requires authentication, you *must* provide an appropriate
username and password during the configuration process to grant MinIO access
to the service.

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.


1) List Configured MQTT Endpoints In The Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config get` command to list the currently
configured MQTT service endpoints in the deployment:

.. code-block:: shell
   :class: copyable

   mc admin config get ALIAS/ notify_mqtt

Replace ``ALIAS`` with the :mc:`alias <mc-alias>` of the MinIO deployment.

The command output resembles the following:

.. code-block:: shell

   notify_mqtt:primary  broker="tcp://mqtt-primary.example.net:port" password="" queue_dir="" queue_limit="0" reconnect_interval="0s"  keep_alive_interval="0s" qos="0" topic="" username=""
   notify_mqtt:secondary  broker="tcp://mqtt-primary.example.net:port" password="" queue_dir="" queue_limit="0" reconnect_interval="0s"  keep_alive_interval="0s" qos="0" topic="" username=""

The :mc-conf:`notify_mqtt` key is the top-level configuration key for an
:ref:`minio-server-config-bucket-notification-mqtt`. The 
:mc-conf:`broker <notify_mqtt.broker>` key specifies the MQTT server/broker endpoint 
for the given `notify_mqtt` key. The ``notify_mqtt:<IDENTIFIER>`` suffix 
describes the unique identifier for that MQTT service endpoint.

Note the identifier for the MQTT service endpoint you want to update for
the next step. 

2) Update the MQTT Endpoint
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config set` command to set the new configuration
for the MQTT service endpoint:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS/ notify_mqtt:<IDENTIFIER> \
      url="MQTT://user:password@hostname:port" \
      exchange="<string>" \
      exchange_type="<string>" \
      routing_key="<string>" \
      mandatory="<string>" \
      durable="<string>" \
      no_wait="<string>" \
      internal="<string>" \
      auto_deleted="<string>" \
      delivery_mode="<string>" \
      queue_dir="<string>" \
      queue_limit="<string>" \
      comment="<string>"

The following configuration settings are the *minimum* required for an 
MQTT server/broker endpoint:

- :mc-conf:`~notify_mqtt.broker`
- :mc-conf:`~notify_mqtt.topic`
- :mc-conf:`~notify_mqtt.username` *Required if the MQTT server/broker enforces authentication/authorization*
- :mc-conf:`~notify_mqtt.password` *Required if the MQTT server/broker enforces authentication/authorization*

All other configuration settings are *optional*. See
:ref:`minio-server-config-bucket-notification-mqtt` for a complete list of MQTT
configuration settings.

3) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. important::

   MinIO restarts *all* :mc:`minio server` processes associated to the 
   deployment at the same time. Applications may experience a brief period of 
   downtime during the restart process. 

   Consider scheduling the restart during a maintenance period to minimize
   interruption of services.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :mc:`alias <mc-alias>` of the deployment to 
restart.

The :mc:`minio server` process prints a line on startup for each configured MQTT
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:mqtt

3) Validate the Changes
~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on a bucket which has an event configuration using the updated
MQTT service endpoint and check the MQTT service for the notification data. The
action required depends on which :mc-cmd:`events <mc-event-add-event>` were
specified when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc-cmd:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET
