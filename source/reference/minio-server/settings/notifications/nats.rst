.. _minio-server-envvar-bucket-notification-nats:

===============================
Settings for NATS Notifications
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. admonition:: NATS Streaming Deprecated
   :class: important

   NATS Streaming is deprecated.
   Migrate to `JetStream <https://docs.nats.io/nats-concepts/jetstream>`__ instead. 

   The related MinIO configuration options and environment variables are deprecated. 

This page documents settings for configuring an NATS service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. 
See :ref:`minio-bucket-notifications-publish-nats` for a tutorial on using these settings.

Environment Variables
---------------------

You can specify multiple NATS service endpoints by appending a unique identifier ``_ID`` for each set of related NATS environment variables on to the top level key. 
For example, the following commands set two distinct NATS service endpoints as ``PRIMARY`` and ``SECONDARY`` respectively:

.. code-block:: shell
   :class: copyable

   set MINIO_NOTIFY_NATS_ENABLE_PRIMARY="on"
   set MINIO_NOTIFY_NATS_ADDRESS_PRIMARY="https://nats-endpoint.example.net:4222"

   set MINIO_NOTIFY_NATS_ENABLE_SECONDARY="on"
   set MINIO_NOTIFY_NATS_ADDRESS_SECONDARY="https://nats-endpoint.example.net:4222"

For example, :envvar:`MINIO_NOTIFY_NATS_ENABLE_PRIMARY <MINIO_NOTIFY_NATS_ENABLE>` indicates the environment variable is associated to an NATS service endpoint with ID of ``PRIMARY``.

.. envvar:: MINIO_NOTIFY_NATS_ENABLE

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-enable
      :end-before: end-minio-notify-nats-enable

   This environment variable corresponds with the :mc-conf:`notify_nats <notify_nats>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_ADDRESS

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-address
      :end-before: end-minio-notify-nats-address

   This environment variable corresponds with the :mc-conf:`notify_nats address <notify_nats.address>` configuration setting.

   .. include:: /includes/linux/minio-server.rst
      :start-after: start-notify-target-online-desc
      :end-before: end-notify-target-online-desc

.. envvar:: MINIO_NOTIFY_NATS_SUBJECT

   *Required*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-subject
      :end-before: end-minio-notify-nats-subject

   This environment variable corresponds with the :mc-conf:`notify_nats subject <notify_nats.subject>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_USERNAME

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-username
      :end-before: end-minio-notify-nats-username

   This environment variable corresponds with the :mc-conf:`notify_nats username <notify_nats.username>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_PASSWORD

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-password
      :end-before: end-minio-notify-nats-password

   This environment variable corresponds with the :mc-conf:`notify_nats password <notify_nats.password>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_TOKEN

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-token
      :end-before: end-minio-notify-nats-token

   This environment variable corresponds with the :mc-conf:`notify_nats token <notify_nats.token>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_TLS

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-tls
      :end-before: end-minio-notify-nats-tls

   This environment variable corresponds with the :mc-conf:`notify_nats tls <notify_nats.tls>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_TLS_SKIP_VERIFY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-tls-skip-verify
      :end-before: end-minio-notify-nats-tls-skip-verify

   This environment variable corresponds with the :mc-conf:`notify_nats tls_skip_verify <notify_nats.tls_skip_verify>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_PING_INTERVAL

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-ping-interval
      :end-before: end-minio-notify-nats-ping-interval

   This environment variable corresponds with the :mc-conf:`notify_nats ping_interval <notify_nats.ping_interval>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_JETSTREAM

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-jetstream
      :end-before: end-minio-notify-nats-jetstream

   This environment variable corresponds with the :mc-conf:`notify_nats jetstream <notify_nats.jetstream>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_STREAMING

   *Deprecated*

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-streaming
      :end-before: end-minio-notify-nats-streaming

   This environment variable corresponds with the :mc-conf:`notify_nats streaming <notify_nats.streaming>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_STREAMING_ASYNC

   *Deprecated*

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-streaming-async
      :end-before: end-minio-notify-nats-streaming-async

   This environment variable corresponds with the :mc-conf:`notify_nats streaming_async <notify_nats.streaming_async>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_STREAMING_MAX_PUB_ACKS_IN_FLIGHT

   *Deprecated*

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-streaming-max-pub-acks-in-flight
      :end-before: end-minio-notify-nats-streaming-max-pub-acks-in-flight

   This environment variable corresponds with the :mc-conf:`notify_nats streaming_max_pub_acks_in_flight <notify_nats.streaming_max_pub_acks_in_flight>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_STREAMING_CLUSTER_ID

   *Deprecated*

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-streaming-cluster-id
      :end-before: end-minio-notify-nats-streaming-cluster-id

   This environment variable corresponds with the :mc-conf:`notify_nats streaming_cluster_id <notify_nats.streaming_cluster_id>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_CERT_AUTHORITY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-cert-authority
      :end-before: end-minio-notify-nats-cert-authority

   This environment variable corresponds with the :mc-conf:`notify_nats cert_authority <notify_nats.cert_authority>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_CLIENT_CERT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-client-cert
      :end-before: end-minio-notify-nats-client-cert

   This environment variable corresponds with the :mc-conf:`notify_nats client_cert <notify_nats.client_cert>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_CLIENT_KEY

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-client-key
      :end-before: end-minio-notify-nats-client-key

   This environment variable corresponds with the :mc-conf:`notify_nats client_key <notify_nats.client_key>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_QUEUE_DIR

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-queue-dir
      :end-before: end-minio-notify-nats-queue-dir

   This environment variable corresponds with the :mc-conf:`notify_nats queue_dir <notify_nats.queue_dir>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_QUEUE_LIMIT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-queue-limit
      :end-before: end-minio-notify-nats-queue-limit

   This environment variable corresponds with the :mc-conf:`notify_nats queue_limit <notify_nats.queue_limit>` configuration setting.

.. envvar:: MINIO_NOTIFY_NATS_COMMENT

   *Optional*

   .. include:: /includes/common-mc-admin-config.rst
      :start-after: start-minio-notify-nats-comment
      :end-before: end-minio-notify-nats-comment

   This environment variable corresponds with the :mc-conf:`notify_nats comment <notify_nats.comment>` configuration setting.

.. _minio-server-config-bucket-notification-nats:

Configuration Values
--------------------

The following section documents settings for configuring an NATS
service as a target for :ref:`Bucket Nofitications <minio-bucket-notifications>`. See
:ref:`minio-bucket-notifications-publish-nats` for a tutorial on 
using these environment variables.

.. admonition:: NATS Streaming Deprecated
   :class: important

   NATS Streaming is deprecated.
   Migrate to `JetStream <https://docs.nats.io/nats-concepts/jetstream>`__ instead. 

   The related MinIO configuration options and environment variables are deprecated. 

.. mc-conf:: notify_nats

   The top-level configuration key for defining an NATS service endpoint for use
   with :ref:`MinIO bucket notifications <minio-bucket-notifications>`.

   Use :mc-cmd:`mc admin config set` to set or update an NATS service endpoint. 
   The :mc-conf:`~notify_nats.address` and 
   :mc-conf:`~notify_nats.subject` arguments are *required* for each target.
   Specify additional optional arguments as a whitespace (``" "``)-delimited 
   list.

   .. code-block:: shell
      :class: copyable

      mc admin config set notify_nats \ 
        address="htpps://nats-endpoint.example.com:4222" \
        subject="minioevents" \
        [ARGUMENT="VALUE"] ... \

   You can specify multiple NATS service endpoints by appending ``[:name]`` to
   the top level key. For example, the following commands set two distinct NATS
   service endpoints as ``primary`` and ``secondary`` respectively:

   .. code-block:: shell

      mc admin config set notify_nats:primary \ 
         address="htpps://nats-endpoint.example.com:4222" \
         subject="minioevents" \ 
         [ARGUMENT=VALUE ...]

      mc admin config set notify_nats:secondary \
         address="htpps://nats-endpoint.example.com:4222" \
         subject="minioevents" \ 
         [ARGUMENT=VALUE ...]

   The :mc-conf:`notify_nats` configuration key supports the following 
   arguments:
   
   .. mc-conf:: address
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-address
         :end-before: end-minio-notify-nats-address

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_ADDRESS` environment variable.

      .. include:: /includes/linux/minio-server.rst
         :start-after: start-notify-target-online-desc
         :end-before: end-notify-target-online-desc

   .. mc-conf:: subject
      :delimiter: " "

      *Required*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-subject
         :end-before: end-minio-notify-nats-subject

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_SUBJECT` environment variable.

   .. mc-conf:: username
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-username
         :end-before: end-minio-notify-nats-username

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_USERNAME` environment variable.

   .. mc-conf:: password
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-password
         :end-before: end-minio-notify-nats-password

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_PASSWORD` environment variable.

   .. mc-conf:: token
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-token
         :end-before: end-minio-notify-nats-token

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_TOKEN` environment variable.

   .. mc-conf:: tls
      :delimiter: "
      
      *Optional*"

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-tls
         :end-before: end-minio-notify-nats-tls

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_TLS` environment variable.

   .. mc-conf:: tls_skip_verify
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-tls-skip-verify
         :end-before: end-minio-notify-nats-tls-skip-verify

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_TLS_SKIP_VERIFY` environment variable.

   .. mc-conf:: ping_interval
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-ping-interval
         :end-before: end-minio-notify-nats-ping-interval

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_PING_INTERVAL` environment variable.

   .. mc-conf:: jetstream
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-jetstream
         :end-before: end-minio-notify-nats-jetstream

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_JETSTREAM` environment variable.

   .. mc-conf:: streaming
      :delimiter: " "

      *Deprecated*

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-streaming
         :end-before: end-minio-notify-nats-streaming

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_STREAMING` environment variable.

   .. mc-conf:: streaming_async
      :delimiter: " "

      *Deprecated*
 
      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-streaming-async
         :end-before: end-minio-notify-nats-streaming-async

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_STREAMING_ASYNC` environment variable.

   .. mc-conf:: streaming_max_pub_acks_in_flight
      :delimiter: " "

      *Deprecated*
 
      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-streaming-max-pub-acks-in-flight
         :end-before: end-minio-notify-nats-streaming-max-pub-acks-in-flight

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_STREAMING_MAX_PUB_ACKS_IN_FLIGHT` environment variable.

   .. mc-conf:: streaming_cluster_id
      :delimiter: " "

      *Deprecated*
 
      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-streaming-cluster-id
         :end-before: end-minio-notify-nats-streaming-cluster-id

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_STREAMING_CLUSTER_ID` environment variable.

   .. mc-conf:: cert_authority
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-cert-authority
         :end-before: end-minio-notify-nats-cert-authority

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_CERT_AUTHORITY` environment variable.

   .. mc-conf:: client_cert
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-client-cert
         :end-before: end-minio-notify-nats-client-cert

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_CLIENT_CERT` environment variable.

   .. mc-conf:: client_key
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-client-key
         :end-before: end-minio-notify-nats-client-key

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_CLIENT_KEY` environment variable.

   
   .. mc-conf:: queue_dir
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-queue-dir
         :end-before: end-minio-notify-nats-queue-dir

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_QUEUE_DIR` environment variable.
      
   .. mc-conf:: queue_limit
      :delimiter: " "

      *Optional*


      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-queue-limit
         :end-before: end-minio-notify-nats-queue-limit

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_QUEUE_LIMIT` environment variable.

      
   .. mc-conf:: comment
      :delimiter: " "

      *Optional*

      .. include:: /includes/common-mc-admin-config.rst
         :start-after: start-minio-notify-nats-comment
         :end-before: end-minio-notify-nats-comment

      This configuration setting corresponds with the :envvar:`MINIO_NOTIFY_NATS_COMMENT` environment variable.