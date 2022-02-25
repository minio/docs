.. start-minio-mc-globals

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

.. start-minio-mc-json-globals

.. mc-cmd:: --JSON
   :optional:

   Enables `JSON lines <http://jsonlines.org/>`_ formatted output to the
   console.

   For example:

   .. code-block:: shell
      :class: copyable

      mc --JSON COMMAND

.. end-minio-mc-json-globals

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

.. end-minio-mc-globals

.. start-minio-mc-no-flags

This command supports only global flags

.. end-minio-mc-no-flags

.. start-minio-mc-s3-compatibility

The :program:`mc` commandline tool is built for compatibility with the AWS S3
API and is tested MinIO and AWS S3 for expected functionality and behavior.

MinIO provides no guarantees for other S3-compatible services, as their S3 API
implementation is unknown and therefore unsupported. While :program:`mc`
commands *may* work as documented, any such usage is at your own risk.

.. end-minio-mc-s3-compatibility

.. start-minio-syntax

- Brackets ``[]`` indicate optional parameters. 
- Parameters sharing a line are mutually dependent.
- Parameters sharing a line *and* seperated using the pipe ``|`` operator are 
  mutually exclusive.

Copy the example to a text editor and modify as-needed before running the
command in the terminal/shell.

.. end-minio-syntax