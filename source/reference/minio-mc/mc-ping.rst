===========
``mc ping``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ping

Syntax
------

.. start-mc-pipe-desc

The :mc:`mc ping` command performs a liveness check on a specified target.

.. end-mc-pipe-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following sends a response request to the target(s) and outputs the minimum, maximum, average, and roundtrip times of the response, as well as the number of errors encountered when processing the request.

      .. code-block:: shell
         :class: copyable

         mc ping play -c 5

      The command pings the deployment at the :mc:`~mc alias` ``play`` for five cycles.
      The output resembles the following:

      .. code-block:: shell

         1: https://play.min.io   min=213.00ms   max=213.00ms   average=213.00ms   errors=0   roundtrip=213.00ms
         2: https://play.min.io   min=67.15ms    max=213.00ms   average=140.07ms   errors=0   roundtrip=67.15ms 
         3: https://play.min.io   min=67.15ms    max=213.00ms   average=115.85ms   errors=0   roundtrip=67.41ms 
         4: https://play.min.io   min=61.26ms    max=213.00ms   average=102.20ms   errors=0   roundtrip=61.26ms 
         5: https://play.min.io   min=61.26ms    max=213.00ms   average=95.03ms    errors=0   roundtrip=66.36ms 

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] ping                       \
                          TARGET                     \
                          [--count, -c value]        \
                          [--error-count, -e value]  \
                          [--interval, -i value]     \
                          [--distributed, -a value]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:

   The full path to the :ref:`alias <minio-mc-alias>` or prefix where the command should run.

.. mc-cmd:: --count, -c
   :optional:

   Specify the number of times to perform the check.

   If not specified, the liveness check performs continuously until stopped.

.. mc-cmd:: --error-count, -e
   :optional:
   
   Specify a number of errors to receive before exiting.

   For example, to stop the ping process after receiving five errors, use

   .. code-block:: shell
      :class: copyable

      mc ping TARGET -e 5

.. mc-cmd:: --interval, -i
   :optional:

   The length of time in seconds to wait between requests.

   By default, the command waits 1 second between requests.

.. mc-cmd:: --distributed, -a
   :optional:

   Send requests to all servers in the MinIO cluster.
         
   .. note::
      
      Use this option for distributed deployments where you have direct access to each node or pod.
      This flag does not work when nodes are placed behind a service, such as a load balancer.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Return Latency and Liveness for 5 Requests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command sends a liveness check for a deployment with the alias ``myminio`` five times, outputs the result of each check, then ends.

.. code-block:: shell
   :class: copyable

   mc ping myminio --count 5

Send Liveness Checks Repeatedly with 5 Minute Wait Between Each Request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command sends continuous liveness check requests with an interval of 5 minutes (300 seconds) between each request.

.. code-block:: shell
   :class: copyable

   mc ping myminio --interval 300

End Liveness Checks for Error Counts Greater Than 20
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command sends continuous liveness checks until 20 errors have been encountered:

.. code-block:: shell
   :class: copyable

   mc ping myminio --error-count 20
