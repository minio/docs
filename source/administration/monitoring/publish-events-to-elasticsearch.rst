.. _minio-bucket-notifications-publish-elasticsearch:

===============================
Publish Events to Elasticsearch
===============================

.. default-domain:: minio

.. |ARN| replace:: ``arn:minio:sqs::primary:elasticsearch``

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports publishing :ref:`bucket notification
<minio-bucket-notifications>` events to an
`Elasticsearch <https://www.elastic.co/>`__ service endpoint.

MinIO relies on the :github:`elastic/go-elasticsearch` v7 project for Elastic
connectivity.

Add a Elasticsearch Endpoint to a MinIO Deployment
--------------------------------------------------

The following procedure adds a new Elasticsearch service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

Prerequisites
~~~~~~~~~~~~~

Elasticsearch v7.0 and later
++++++++++++++++++++++++++++

MinIO relies on the :github:`olivere/elastic` v7 project for Elastic
connectivity. The ``elastic/v7`` library specifically targets Elasticsearch
v7.0 and is *not compatible with earlier Elasticsearch versions*.

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.

1) Add the Elasticsearch Endpoint to MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can configure a new Elasticsearch service endpoint using either environment variables
*or* by setting runtime configuration settings.

.. tab-set::

   .. tab-item:: Environment Variables

      MinIO supports specifying the Elasticsearch service endpoint and associated
      configuration settings using 
      :ref:`environment variables 
      <minio-server-envvar-bucket-notification-elasticsearch>`. The 
      :mc:`minio server` process applies the specified settings on its 
      next startup.
      
      The following example code sets *all*  environment variables
      related to configuring an Elasticsearch service endpoint. The minimum
      *required* variables are:

      - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_ENABLE`
      - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_URL`
      - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_INDEX`
      - :envvar:`MINIO_NOTIFY_ELASTICSEARCH_FORMAT`


      .. code-block:: shell
         :class: copyable

         set MINIO_NOTIFY_ELASTICSEARCH_ENABLE_<IDENTIFIER>="on"
         set MINIO_NOTIFY_ELASTICSEARCH_URL_<IDENTIFIER>="<ENDPOINT>"
         set MINIO_NOTIFY_ELASTICSEARCH_INDEX_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_ELASTICSEARCH_FORMAT_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_ELASTICSEARCH_USERNAME_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_ELASTICSEARCH_PASSWORD_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_ELASTICSEARCH_QUEUE_DIR_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_ELASTICSEARCH_QUEUE_LIMIT_<IDENTIFIER>="<string>"
         set MINIO_NOTIFY_ELASTICSEARCH_COMMENT_<IDENTIFIER>="<string>"

      - Replace ``<IDENTIFIER>`` with a unique descriptive string for the
        TARGET service endpoint. Use the same ``<IDENTIFIER>`` value for all 
        environment variables related to the new target service endpoint.
        The following examples assume an identifier of ``PRIMARY``.

        If the specified ``<IDENTIFIER>`` matches an existing Elasticsearch
        service endpoint on the MinIO deployment, the new settings *override*
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_elasticsearch <mc admin config get>`
        to review the currently configured Elasticsearch endpoints on the MinIO
        deployment.

      - Replace ``<ENDPOINT>`` with the URL of the Elasticsearch service endpoint.
        For example:

      See :ref:`Elasticsearch Service for Bucket Notifications
      <minio-server-envvar-bucket-notification-elasticsearch>` for complete
      documentation on each environment variable.

   .. tab-item:: Configuration Settings

      MinIO supports adding or updating Elasticsearch endpoints on a running 
      :mc:`minio server` process using the :mc-cmd:`mc admin config set` command 
      and the :mc-conf:`notify_elasticsearch` configuration key. You must restart the 
      :mc:`minio server` process to apply any new or updated configuration
      settings.

      The following example code sets *all*  settings related to configuring an
      Elasticsearch service endpoint. The minimum *required* settings are:
      
      - :mc-conf:`url <notify_elasticsearch.url>`
      - :mc-conf:`index <notify_elasticsearch.index>`
      - :mc-conf:`format <notify_elasticsearch.format>` 

      .. code-block:: shell
         :class: copyable

         mc admin config set ALIAS/ notify_elasticsearch:IDENTIFIER \
            url="ENDPOINT" \
            index="<string>" \
            format="<string>" \
            username="<string>" \
            password="<string>" \
            queue_dir="<string>" \
            queue_limit="<string>" \
            comment="<string>"


      - Replace ``IDENTIFIER`` with a unique descriptive string for the
        Elasticsearch service endpoint. The following examples in this procedure
        assume an identifier of ``PRIMARY``.

        If the specified ``IDENTIFIER`` matches an existing Elasticsearch service
        endpoint on the MinIO deployment, the new settings *override* 
        any existing settings for that endpoint. Use 
        :mc-cmd:`mc admin config get notify_elasticsearch <mc admin config get>`
        to review the currently configured Elasticsearch endpoints on the MinIO
        deployment.

      - Replace ``ENDPOINT`` with the URL of the Elasticsearch service endpoint.
        For example:

        ``https://user:password@hostname:port``

      See :ref:`Elasticsearch Bucket Notification Configuration Settings
      <minio-server-config-bucket-notification-elasticsearch>` for complete 
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

The :mc:`minio server` process prints a line on startup for each configured Elasticsearch
target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:elasticsearch

You must specify the ARN resource when configuring bucket notifications with
the associated Elasticsearch deployment as a target.

.. include:: /includes/common-bucket-notifications.rst
   :start-after: start-bucket-notification-find-arn
   :end-before: end-bucket-notification-find-arn


3) Configure Bucket Notifications using the Elasticsearch Endpoint as a Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc:`mc event add` command to add a new bucket notification 
event with the configured Elasticsearch service as a target:

.. code-block:: shell
   :class: copyable

   mc event add ALIAS/BUCKET arn:minio:sqs::primary:elasticsearch \
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

   mc event ls ALIAS/BUCKET arn:minio:sqs::primary:elasticsearch

4) Validate the Configured Events
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on the bucket for which you configured the new event and 
check the Elasticsearch service for the notification data. The action required
depends on which :mc-cmd:`events <mc event add --event>` were specified
when configuring the bucket notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET

Update an Elasticsearch Endpoint in a MinIO Deployment
------------------------------------------------------

The following procedure updates an existing Elasticsearch service endpoint for supporting
:ref:`bucket notifications <minio-bucket-notifications>` in a MinIO
deployment.

Prerequisites
~~~~~~~~~~~~~~

Elasticsearch v7.0 and later
++++++++++++++++++++++++++++

MinIO relies on the :github:`olivere/elastic` v7 project for Elastic
connectivity. The ``elastic/v7`` library specifically targets Elasticsearch
v7.0 and is *not compatible with earlier Elasticsearch versions*.

MinIO ``mc`` Command Line Tool
++++++++++++++++++++++++++++++

This procedure uses the :mc:`mc` command line tool for certain actions. 
See the ``mc`` :ref:`Quickstart <mc-install>` for installation instructions.


1) List Configured Elasticsearch Endpoints In The Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config get` command to list the currently
configured Elasticsearch service endpoints in the deployment:

.. code-block:: shell
   :class: copyable

   mc admin config get ALIAS/ notify_elasticsearch

Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO deployment.

The command output resembles the following:

.. code-block:: shell

   notify_elasticsearch:primary  queue_dir="" queue_limit="0"  url="https://user:password@hostname:port" format="namespace" index=""
   notify_elasticsearch:secondary queue_dir="" queue_limit="0"  url="https://user:password@hostname:port" format="namespace" index=""

The :mc-conf:`notify_elasticsearch` key is the top-level configuration key for
an :ref:`minio-server-config-bucket-notification-elasticsearch`. The
:mc-conf:`url <notify_elasticsearch.url>` key specifies the Elasticsearch
service endpoint for the given `notify_elasticsearch` key. The
``notify_elasticsearch:<IDENTIFIER>`` suffix describes the unique identifier for
that Elasticsearch service endpoint.

Note the identifier for the Elasticsearch service endpoint you want to update for
the next step. 

2) Update the Elasticsearch Endpoint
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin config set` command to set the new configuration
for the Elasticsearch service endpoint:

.. code-block:: shell
   :class: copyable

   mc admin config set ALIAS/ notify_elasticsearch:<IDENTIFIER> \
      url="https://user:password@hostname:port" \
      index="<string>" \
      format="<string>" \
      username="<string>" \
      password="<string>" \
      queue_dir="<string>" \
      queue_limit="<string>" \
      comment="<string>"

The :mc-conf:`notify_elasticsearch url <notify_elasticsearch.url>` configuration
setting is the *minimum* required for an Elasticsearch service endpoint. All
other configuration settings are *optional*. See
:ref:`minio-server-config-bucket-notification-elasticsearch` for a complete list
of Elasticsearch configuration settings.

3) Restart the MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must restart the MinIO deployment to apply the configuration changes. 
Use the :mc-cmd:`mc admin service restart` command to restart the deployment.

.. code-block:: shell
   :class: copyable

   mc admin service restart ALIAS

Replace ``ALIAS`` with the :ref:`alias <alias>` of the deployment to 
restart.

The :mc:`minio server` process prints a line on startup for each configured
Elasticsearch target similar to the following:

.. code-block:: shell

   SQS ARNs: arn:minio:sqs::primary:elasticsearch

4) Validate the Changes
~~~~~~~~~~~~~~~~~~~~~~~

Perform an action on a bucket which has an event configuration using the updated
Elasticsearch service endpoint and check the Elasticsearch service for the
notification data. The action required depends on which 
:mc-cmd:`events <mc event add --event>` were specified when configuring the bucket
notification.

For example, if the bucket notification configuration includes the 
``s3:ObjectCreated:Put`` event, you can use the 
:mc:`mc cp` command to create a new object in the bucket and trigger 
a notification.

.. code-block:: shell
   :class: copyable

   mc cp ~/data/new-object.txt ALIAS/BUCKET
