.. _minio-mc-global-flags:

=========================
Global Command Line Flags
=========================


.. default-domain:: minio
.. mc:: mc

.. contents:: Table of Contents
   :local:
   :depth: 2

You can add the following optional flags to any :mc-cmd:`mc` command.

.. mc-cmd:: --debug
   :optional:
   
   Enables verbose output to the console.

   For example:

   .. code-block:: shell
      :class: copyable

      mc --debug COMMAND

.. mc-cmd:: --config-dir
   :optional:

   The path to a ``JSON`` formatted configuration file that
   :program:`mc` uses for storing data. See :ref:`mc-configuration` for
   more information on how :program:`mc` uses the configuration file.

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-json-globals
   :end-before: end-minio-mc-json-globals

.. mc-cmd:: --no-color
   :optional:

   Disables the built-in color theme for console output. Useful for dumb
   terminals.

.. mc-cmd:: --quiet
   :optional:

   Suppresses console output. 

.. mc-cmd:: --insecure
   :optional:

   Disables TLS/SSL certificate verification. Allows TLS connectivity to 
   servers with invalid certificates. Exercise caution when using this
   option against untrusted S3 hosts.

.. mc-cmd:: --version
   :optional:   

   Displays the current version of :mc-cmd:`mc`. 

.. mc-cmd:: --help
   :optional:

   Displays a summary of command usage on the terminal.