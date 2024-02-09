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

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_BROWSER

         Specify ``off`` to disable the embedded MinIO Console.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Animation
~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_BROWSER_LOGIN_ANIMATION

         .. versionadded:: MinIO Server RELEASE.2023-05-04T21-44-30Z

         Specify ``off`` to disable the animated login screen for the MinIO Console. 
         Defaults to ``on``.
   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Browser Redirect
~~~~~~~~~~~~~~~~

*Optional*

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

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_BROWSER_REDIRECT_URL

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

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_BROWSER_SESSION_DURATION

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

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_SERVER_URL

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

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_LOG_QUERY_URL

         Specify the URL of a PostgreSQL service to which MinIO writes :ref:`Audit logs <minio-logging-publish-audit-logs>`. 
         The embedded MinIO Console provides a Log Search tool that allows querying the PostgreSQL service for collected logs.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Content Security Policy
~~~~~~~~~~~~~~~~~~~~~~~

*Optional*

Configure MinIO Console to generate a `Content-Security-Policy <https://en.wikipedia.org/wiki/Content_Security_Policy>`__ header in HTTP responses.
Defaults to ``default-src 'self' 'unsafe-eval' 'unsafe-inline';``

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_BROWSER_CONTENT_SECURITY_POLICY

         .. code-block:: shell
            :class: copyable

            set MINIO_BROWSER_CONTENT_SECURITY_POLICY="default-src 'self' 'unsafe-eval' 'unsafe-inline';"

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: browser csp_policy
         :delimiter: " "

         .. code-block:: shell
            :class: copyable
		 
            mc admin config set browser \
               csp_policy="default-src 'self' 'unsafe-eval' 'unsafe-inline';" \
               [ARGUMENT=VALUE ...]


Strict Transport Security
~~~~~~~~~~~~~~~~~~~~~~~~~

*Optional*

Configure MinIO console to generate a `Strict-Transport-Security <https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security>`__ header in HTTP responses.

To generate the header, you **must** set a duration using either :envvar:`MINIO_BROWSER_HSTS_SECONDS` or :mc-conf:`~browser.hsts_seconds`.
Other HSTS settings are optional.

.. tab-set::

   .. tab-item:: Environment Variables
      :sync: envvar

      .. envvar:: MINIO_BROWSER_HSTS_INCLUDE_SUB_DOMAINS

         Set to ``on`` to also apply the configured HSTS policy to all MinIO Console subdomains.
         Defaults to ``off``.

         .. code-block:: shell
            :class: copyable

            set MINIO_BROWSER_HSTS_INCLUDE_SUB_DOMAINS="on"

      .. envvar:: MINIO_BROWSER_HSTS_PRELOAD

         Set to ``on`` to direct the client browser to add the MinIO Console domain to its HSTS preload list.
         Defaults to ``off``.

         .. code-block:: shell
            :class: copyable

            set MINIO_BROWSER_HSTS_INCLUDE_SUB_DOMAINS="on"

      .. envvar:: MINIO_BROWSER_HSTS_SECONDS

         The ``max_age`` the configured policy remains in effect, in seconds.
         Defaults to ``0``, disabled.
         You **must** configure a *non-zero* duration to enable the ``Strict-Transport-Security`` header.

         .. code-block:: shell
            :class: copyable

            set MINIO_BROWSER_HSTS_SECONDS=31536000

   .. tab-item:: Configuration Settings
      :sync: config

      The following configuration settings require a service restart to take effect.
      You can do this with :mc-cmd:`mc admin service restart`.

      .. mc-conf:: browser hsts_include_subdomains
         :delimiter: " "

         Set to ``on`` to also apply the configured HSTS policy to all MinIO Console subdomains.
         Defaults to ``off``.

         .. code-block:: shell
            :class: copyable

            mc admin config set browser \
               hsts_include_subdomains="on" \
               hsts_seconds="31536000" \
               [ARGUMENT=VALUE ...]

      .. mc-conf:: browser hsts_preload
         :delimiter: " "

         Set to ``on`` to direct the client browser to add the MinIO Console domain to its HSTS preload list.
         Defaults to ``off``.

         .. code-block:: shell
            :class: copyable

            mc admin config set browser \
               hsts_preload="on" \
               hsts_seconds="31536000" \
               [ARGUMENT=VALUE ...]

      .. mc-conf:: browser hsts_seconds
         :delimiter: " "

         The ``max_age`` the configured policy remains in effect, in seconds.
         Defaults to ``0``, disabled.
         You **must** configure a *non-zero* duration to enable the ``Strict-Transport-Security`` header.

         .. code-block:: shell
            :class: copyable

            mc admin config set browser \
               hsts_seconds="31536000" \
               [ARGUMENT=VALUE ...]


Examples
++++++++

The following examples show the rendered header for the given configuration settings.
The equivalent environment variables generate the same result.

``hsts_seconds``

  .. code-block:: shell
     :class: copyable

     mc admin config set ALIAS browser hsts_seconds=31536000

  .. code-block:: shell
     :class: copyable

     Strict-Transport-Security: max-age=31536000

``hsts_include_subdomains``

  .. code-block:: shell
     :class: copyable

     mc admin config set ALIAS browser hsts_seconds=31536000 hsts_include_subdomains=on

  .. code-block:: shell
     :class: copyable

     Strict-Transport-Security: max-age=31536000; includeSubDomains

``hsts_preload``

  .. code-block:: shell
     :class: copyable

     mc admin config set ALIAS browser hsts_seconds=31536000 hsts_include_subdomains=on hsts_preload=on

  .. code-block:: shell
     :class: copyable

     Strict-Transport-Security: max-age=31536000; includeSubDomains; preload


Referrer Policy
~~~~~~~~~~~~~~~

*Optional*

Configure MinIO Console to generate a `Referrer-Policy <https://www.w3.org/TR/referrer-policy/>`__ header in HTTP responses.
Defaults to ``strict-origin-when-cross-origin``.

.. tab-set::

   .. tab-item:: Environment Variable
      :sync: envvar

      .. envvar:: MINIO_BROWSER_REFERRER_POLICY

         .. code-block:: shell
            :class: copyable

            set MINIO_BROWSER_REFERRER_POLICY="strict-origin-when-cross-origin"

   .. tab-item:: Configuration Setting
      :sync: config

      .. mc-conf:: browser referrer_policy
         :delimiter: " "

         .. code-block:: shell

            mc admin config set browser \
               referrer_policy="strict-origin-when-cross-origin" \
               [ARGUMENT=VALUE ...]


Prometheus Settings
-------------------

The following settings manage how MinIO interacts with your Prometheus service.

Prometheus URL
~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_PROMETHEUS_URL

         Specify the URL for a Prometheus service configured to :ref:`scrape MinIO metrics <minio-metrics-collect-using-prometheus>`.

         The MinIO Console populates the :guilabel:`Dashboard` with cluster metrics using the ``minio-job`` Prometheus scraping job.

         If you are using a standalone MinIO Console process, this variable corresponds with ``CONSOLE_PROMETHEUS_URL``.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Prometheus Job ID
~~~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_PROMETHEUS_JOB_ID

         Specify the custom Prometheus job ID used for :ref:`scraping MinIO metrics <minio-metrics-collect-using-prometheus>`. 

         MinIO defaults to ``minio-job``.

         If you are using a standalone MinIO Console process, this variable corresponds with ``CONSOLE_PROMETHEUS_JOB_ID``.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.

Prometheus Auth Token
~~~~~~~~~~~~~~~~~~~~~

*Optional*

.. tab-set::

   .. tab-item:: Environment Variable

      .. envvar:: MINIO_PROMETHEUS_AUTH_TOKEN

         Specify the :prometheus-docs:`basic auth token <guides/basic-auth/>` the Console should use to connect to a Prometheus service.

         For example, a basic auth token you might use could resemble the following:

         .. code-block:: text

            eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJwcm9tZXRoZXVzIiwic3ViIjoibWluaW8iLCJleHAiOjQ4NTAwMzg0MDJ9.GZCKR3d0FH2TCvNHSd39HaVfSuQVVV0s8glICBDmhT51V6CQ_hw8gTYlKHJmcpR8aHkqiJwCqcYJhaMmqwe00XY

         If you are using a standalone MinIO Console process, this variable corresponds with ``CONSOLE_PROMETHEUS_AUTH_TOKEN``.

   .. tab-item:: Configuration Setting

      This setting does not have a configuration variable setting.
      Use the Environment Variable instead.
