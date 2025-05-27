.. _minio-console:

=============
MinIO Console
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


The MinIO Console is a rich graphical user interface that supports browsing buckets and objects on your deployment.

This page provides an overview of the MinIO Console and describes configuration options and instructions for logging in.

Overview
--------

.. versionchanged:: RELEASE.2025-05-24T17-08-30Z

   The Console now presents only object browser capabilities similar to those available through the :mc:`mc` tool.
   For administrative interactions, such as user management, use the :mc:`mc admin` command.

The MinIO Console is embedded as part of the MinIO Server. 
You can also deploy a standalone MinIO Console using the instructions in the :minio-git:`github repository <console>`.

Supported Browsers
~~~~~~~~~~~~~~~~~~

MinIO Console runs on a variety of current, stable release browsers.

For the best experience in the MinIO Console, use the latest stable release of your preferred browser.
Some browsers that are supported include:

- Chrome
- Edge
- Safari
- Firefox
- Opera

This list is *not* exhaustive and is subject to change.

For a full list of browsers and versions for running MinIO Console, see the `Browserslist <https://browsersl.ist/#q=%3E0.2%25%2Cnot+dead+and+not+op_mini+all>`__ website.

.. tip:: 
   
   MinIO Console does *not* support Opera Mini.

Configuration
-------------

The MinIO Console inherits the majority of its configuration settings from the
MinIO Server. The following environment variables enable specific behavior in
the MinIO Console:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Environment Variable
     - Description

   * - :envvar:`MINIO_PROMETHEUS_URL`
     - The URL for a Prometheus server configured to scrape metrics from the 
       MinIO deployment. The MinIO Console uses this server for populating the
       metrics dashboard.

       See :ref:`minio-metrics-collect-using-prometheus` for a tutorial on 
       configuring Prometheus to collect metrics from MinIO.

   * - :envvar:`MINIO_BROWSER_REDIRECT_URL`
     - The externally resolvable hostname for the MinIO Console used by the 
       configured :ref:`external identity manager 
       <minio-authentication-and-identity-management>` for returning the
       authentication response.

       This variable is typically necessary when using a reverse proxy, 
       load balancer, or similar system to expose the MinIO Console to the 
       public internet. Specify an externally reachable hostname that resolves
       to the MinIO Console.

.. _minio-console-port-assignment:

Static vs Dynamic Port Assignment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO by default selects a random port for the MinIO Console on each server
startup. Browser clients accessing the MinIO Server are automatically 
redirected to the MinIO Console on its dynamically selected port. 
This behavior emulates the legacy web browser behavior while reducing the
the risk of a port collision on systems which were running MinIO *before* the 
embedded Console update.

You can select an explicit static port by passing the 
:mc-cmd:`minio server --console-address` commandline option when starting 
each MinIO Server in the deployment. 

For example, the following command starts a distributed MinIO deployment using
a static port assignment of ``9001`` for the MinIO Console. This deployment
would respond to S3 API operations on the default MinIO server port ``:9000``
and browser access on the MinIO Console port ``:9001``.

.. code-block:: shell
   :class: copyable

   minio server https://minio-{1...4}.example.net/mnt/drive-{1...4} \
         --console-address ":9001"

Deployments behind network routing components which require static ports for 
routing rules may require setting a static MinIO Console port. For example,
load balancers, reverse proxies, or Kubernetes ingress may by default block
or exhibit unexpected behavior with the the dynamic redirection behavior.

You must also ensure that the host system firewall grants access to the configured Console port.

.. _minio-console-play-login:

Logging In
----------

The MinIO Console displays a login screen for unauthenticated users.
The Console defaults to providing a username and password prompt for a :ref:`MinIO-managed user <minio-internal-idp>`.

For deployments configured with multiple :ref:`identity managers <minio-authentication-and-identity-management>`, you can also log in using credentials generated using a :ref:`Security Token Service (STS) <minio-security-token-service>` API.

.. admonition:: Try out the Console using MinIO's Play testing environment
   :class: note

   You can explore the Console using https://play.min.io:9443. 
   Log in with the following credentials:

   - Username: ``Q3AM3UQ867SPQQA43P2F``
   - Password: ``zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG``

   The Play Console connects to the MinIO Play deployment at https://play.min.io.
   You can also access this deployment using :mc:`mc` and using the ``play`` alias.

Documentation
-------------

The :guilabel:`Documentation` tab opens this documentation site in a separate browser window or tab.

.. toctree::
   :titlesonly:
   :hidden:

   /administration/console/managing-objects
