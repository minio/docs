.. _minio-server-envvar-console:

======================
MinIO Console Settings
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This page covers settings that manage access and behavior for the MinIO Console. 

.. include:: /includes/common-mc-admin-config.rst
   :start-after: start-minio-settings-defined
   :end-before: end-minio-settings-defined

Browser Settings
----------------

The following settings control behavior for the embedded MinIO Console.

MinIO Console
~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_BROWSER

         *Optional*

         Specify ``off`` to disable the embedded MinIO Console.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Animation
~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_BROWSER_LOGIN_ANIMATION

         *Optional*

         .. versionadded:: MinIO Server RELEASE.2023-05-04T21-44-30Z

         Specify ``off`` to disable the animated login screen for the MinIO Console. 
         Defaults to ``on``.
   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Browser Redirect
~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_BROWSER_REDIRECT

         .. versionadded:: MinIO Server RELEASE.2023-09-16T01-01-47Z

        Specify whether requests from a web browser automatically redirect to the Console address.
        Defaults to ``true``.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Browser Redirect URL
~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_BROWSER_REDIRECT_URL

         *Optional*

         Specify the Fully Qualified Domain Name (FQDN) the MinIO Console listens for incoming connections on.
   
         If you want to host the MinIO Console exclusively from a reverse-proxy service, you must specify the hostname managed by that service.
   
         For example, consider a reverse proxy configured to route ``https://example.net/minio/`` to the MinIO Console.
         You must set this environment variable to match that hostname for the Console to both listen and respond to requests using that hostname.

         If you omit this variable, the Console listens and responds to all IP addresses or hostnames associated to the host machine on which the MinIO Server runs.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Session Duration
~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_BROWSER_SESSION_DURATION

         *Optional*

         .. versionadded:: MinIO Server RELEASE.2023-08-23T10-07-06Z

         Specify the duration of a browser session for working with the MinIO Console.

         MinIO supports the following units of time measurement:

         - ``s`` - seconds, "60s"
         - ``m`` - minutes, "60m"
         - ``h`` - hours, "24h"
         - ``d`` - days, "7d"
      
         Defaults to ``12h``.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Server URL
~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_SERVER_URL

         *Optional*

         Specify the Fully Qualified Domain Name (FQDN) the MinIO Console must use for connecting to the MinIO Server.
         The Console also uses this value for setting the root hostname when generating presigned URLs.

         This setting may be required if:

         - The MinIO Server uses a TLS certificate that does not include the host local IP(s) in the certificate Subject Alternative Name (SAN) *or*

         - The Console must use a specific hostname to connect or reference the MinIO Server, e.g. due to a reverse proxy or similar configuration.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Log Query URL
~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_LOG_QUERY_URL

         *Optional*

         Specify the URL of a PostgreSQL service to which MinIO writes :ref:`Audit logs <minio-logging-publish-audit-logs>`. 
         The embedded MinIO Console provides a Log Search tool that allows querying the PostgreSQL service for collected logs.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Prometheus Settings
-------------------

The following settings manage how MinIO interacts with your Prometheus service.

Prometheus URL
~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_PROMETHEUS_URL

         *Optional*

         Specify the URL for a Prometheus service configured to :ref:`scrape MinIO metrics <minio-metrics-collect-using-prometheus>`.

         The MinIO Console populates the :guilabel:`Dashboard` with cluster metrics using the ``minio-job`` Prometheus scraping job.

         If you are using a standalone MinIO Console process, this variable corresponds with ``CONSOLE_PROMETHEUS_URL``.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Prometheus Job ID
~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_PROMETHEUS_JOB_ID

         *Optional*

         Specify the custom Prometheus job ID used for :ref:`scraping MinIO metrics <minio-metrics-collect-using-prometheus>`. 

         MinIO defaults to ``minio-job``.

         If you are using a standalone MinIO Console process, this variable corresponds with ``CONSOLE_PROMETHEUS_JOB_ID``.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Prometheus Auth Token
~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_PROMETHEUS_AUTH_TOKEN

         *Optional*

         Specify the :prometheus-docs:`basic auth token <guides/basic-auth/>` the Console should use to connect to a Prometheus service.

         For example, a basic auth token you might use could resemble the following:

         .. code-block:: text

            eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJwcm9tZXRoZXVzIiwic3ViIjoibWluaW8iLCJleHAiOjQ4NTAwMzg0MDJ9.GZCKR3d0FH2TCvNHSd39HaVfSuQVVV0s8glICBDmhT51V6CQ_hw8gTYlKHJmcpR8aHkqiJwCqcYJhaMmqwe00XY

         If you are using a standalone MinIO Console process, this variable corresponds with ``CONSOLE_PROMETHEUS_AUTH_TOKEN``.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.
