====================
``mc support proxy``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support proxy

Description
-----------

Use the :mc-cmd:`mc support proxy` command to configure a proxy to use to communicate with |SUBNET|.


Examples
--------

Set a Proxy URL
~~~~~~~~~~~~~~~

Define the proxy URL to use when the deployment ``minio1`` communicates to SUBNET.
The proxy URL in the example is ``http://my.proxy``.

.. code-block:: shell
   :class: copyable
 
   mc support proxy set minio1 http://my.proxy

Remove the Proxy URL Congifugred for a Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command removes the URL configured as the proxy for the alias ``minio1``.

.. code-block:: shell
   :class: copyable
 
   mc support proxy remove minio1

Disable ``callhome`` Logs
~~~~~~~~~~~~~~~~~~~~~~~~~

The following command shows the URL configured as the proxy for the alias ``minio1``.

.. code-block:: shell
   :class: copyable

   mc support proxy show minio1

Syntax
------

.. mc-cmd:: set
   :fullpath:

   Create a proxy URL for the MinIO deployment to use when communicating with |SUBNET|.

   .. code-block:: shell
               
      mc support proxy set ALIAS PROXY_URL

.. mc-cmd:: show
   :fullpath:

   Display the current proxy URL configured for communicating with |SUBNET|.

   .. code-block:: shell
               
      mc support proxy show ALIAS

.. mc-cmd:: remove
   :fullpath:

   Remove the proxy URL configured for communicating with |SUBNET|.

   .. code-block:: shell
               
      mc support proxy remove ALIAS 

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

