.. _minio-server-envvar-bucket-notification-nats:
.. _minio-server-config-bucket-notification-nats:

==========================
NATS Notification Settings
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. admonition:: NATS Streaming Deprecated
   :class: important

   NATS Streaming is deprecated.
   Migrate to `JetStream <https://docs.nats.io/nats-concepts/jetstream>`__ instead. 

   The related MinIO configuration options and environment variables are deprecated. 

This page documents settings for configuring an NATS service as a target for :ref:`Bucket Notifications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-nats` for a tutorial on using these settings.

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-defined
   :end-before: end-minio-settings-defined

Multiple NATS Targets
---------------------

You can specify multiple NATS service endpoints by appending a unique identifier ``_ID`` for each set of related NATS settings on to the top level key. 

Example
~~~~~~~

For example, the following commands set two distinct NATS service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

      .. code-block:: shell
         :class: copyable
      
         set MINIO_NOTIFY_NATS_ENABLE_PRIMARY="on"
         set MINIO_NOTIFY_NATS_ADDRESS_PRIMARY="https://nats-endpoint.example.net:4222"
      
         set MINIO_NOTIFY_NATS_ENABLE_SECONDARY="on"
         set MINIO_NOTIFY_NATS_ADDRESS_SECONDARY="https://nats-endpoint.example.net:4222"

      With these settings, :envvar:`MINIO_NOTIFY_NATS_ENABLE_PRIMARY <MINIO_NOTIFY_NATS_ENABLE>` indicates the environment variable is associated to an NATS service endpoint with ID of ``PRIMARY``.

   .. tab-item:: Configuration Settings
      :sync: config

      .. code-block:: shell
   
         mc admin config set notify_nats:primary \ 
            address="https://nats-endpoint.example.com:4222" \
            subject="minioevents" \ 
            [ARGUMENT=VALUE ...]
   
         mc admin config set notify_nats:secondary \
            address="https://nats-endpoint.example.com:4222" \
            subject="minioevents" \ 
            [ARGUMENT=VALUE ...]

Settings
--------

Enable
~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_ENABLE

      Specify ``on`` to enable publishing bucket notifications to an NATS service endpoint.
      
      Defaults to ``off``.

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats

      The top-level configuration key for defining an NATS service endpoint for use with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

      Use :mc-cmd:`mc admin config set` to set or update an NATS service endpoint. 
      The :mc-conf:`~notify_nats.address` and :mc-conf:`~notify_nats.subject` arguments are *required* for each target.
      Specify additional optional arguments as a whitespace (``" "``)-delimited list.
   
      .. code-block:: shell
         :class: copyable
   
         mc admin config set notify_nats \ 
           address="https://nats-endpoint.example.com:4222" \
           subject="minioevents" \
           [ARGUMENT="VALUE"] ... \
   
Address
~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_ADDRESS

   .. tab-item:: Configuration Setting
      :sync: config
      
      .. mc-conf:: notify_nats address
         :delimiter: " "

Specify the NATS service endpoint to which MinIO publishes bucket events. 
For example, ``https://nats-endpoint.example.com:4222``.

.. include:: /includes/linux/minio-server.rst
   :start-after: start-notify-target-online-desc
   :end-before: end-notify-target-online-desc

Subject
~~~~~~~

*Required*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_SUBJECT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats subject
         :delimiter: " "

Specify the subscription to which MinIO associates events published to the NATS endpoint.

Username
~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_USERNAME

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats username
         :delimiter: " "

Specify the username for connecting to the NATS service endpoint.

Password
~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_PASSWORD

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats password
         :delimiter: " "

Specify the passport for connecting to the NATS service endpoint.

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

Token
~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_TOKEN

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats token
         :delimiter: " "

Specify the token for connecting to the NATS service endpoint.

.. versionchanged:: RELEASE.2023-06-23T20-26-00Z

   MinIO redacts this value when returned as part of :mc-cmd:`mc admin config get`.

TLS
~~~

*Optional*

.. tab-set::
   
   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_TLS

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats tls
         :delimiter: "

Specify ``on`` to enable TLS connectivity to the NATS service endpoint.

TLS Skip Verify
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_TLS_SKIP_VERIFY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats tls_skip_verify
         :delimiter: " "

Enables or disables TLS verification of the NATS service endpoint TLS certificates.

- Specify ``on`` to disable TLS verification (Default).
- Specify ``off`` to enable TLS verification.

Ping Interval
~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_PING_INTERVAL

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats ping_interval
         :delimiter: " "

Specify the duration interval for client pings to the NATS server. 
MinIO supports the following time units:

- ``s`` - seconds, ``"60s"``
- ``m`` - minutes, ``"5m"``
- ``h`` - hours, ``"1h"``
- ``d`` - days, ``"1d"``

Jetstream
~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_JETSTREAM

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats jetstream
         :delimiter: " "

Specify ``on`` to enable JetStream support for streaming events to a NATS JetStream service endpoint.

Streaming
~~~~~~~~~

*Deprecated*   

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_STREAMING

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats streaming
         :delimiter: " "

Specify ``on`` to enable asynchronous publishing of events to the NATS service endpoint.

Streaming Async
~~~~~~~~~~~~~~~

*Deprecated*   

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_STREAMING_ASYNC

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats streaming_async
         :delimiter: " "

Specify ``on`` to enable asynchronous publishing of events to the NATS service endpoint.

Max ACK Responses In Flight
~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Deprecated*

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_STREAMING_MAX_PUB_ACKS_IN_FLIGHT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats streaming_max_pub_acks_in_flight
         :delimiter: " "

Specify the number of messages to publish without waiting for an ACK response from the NATS service endpoint.

Streaming Cluster ID
~~~~~~~~~~~~~~~~~~~~

*Deprecated*

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_STREAMING_CLUSTER_ID
   
   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats streaming_cluster_id
         :delimiter: " "

Specify the unique ID for the NATS streaming cluster.

Cert Authority
~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_CERT_AUTHORITY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats cert_authority
         :delimiter: " "

Specify the path to the Certificate Authority chain used to sign the NATS service endpoint TLS certificates.

Client Cert
~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_CLIENT_CERT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats client_cert
         :delimiter: " "

Specify the path to the client certificate to use for performing mTLS authentication to the NATS service endpoint.

Client Key
~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_CLIENT_KEY

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats client_key
         :delimiter: " "

Specify the path to the client private key to use for performing mTLS authentication to the NATS service endpoint.

Queue Directory
~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_QUEUE_DIR

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats queue_dir
         :delimiter: " "

Specify the directory path to enable MinIO's persistent event store for undelivered messages, such as ``/opt/minio/events``.

MinIO stores undelivered events in the specified store while the NATS server/broker is offline and replays the stored events when connectivity resumes.

Queue Limit
~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_QUEUE_LIMIT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats queue_limit
         :delimiter: " "

Specify the maximum limit for undelivered messages. 
Defaults to ``100000``.

Comment
~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_NOTIFY_NATS_COMMENT

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: notify_nats comment
         :delimiter: " "

Specify a comment to associate with the NATS configuration.