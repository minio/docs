.. start-minio-mc-globals

This command supports any of the :ref:`global flags <minio-mc-global-options>`.

.. end-minio-mc-globals

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

.. start-minio-mc-no-flags

This command supports only global flags

.. end-minio-mc-no-flags

.. start-minio-mc-s3-compatibility

The :program:`mc` commandline tool is built for compatibility with the AWS S3
API and is tested with MinIO and AWS S3 for expected functionality and behavior.

MinIO provides no guarantees for other S3-compatible services, as their S3 API
implementation is unknown and therefore unsupported. While :program:`mc`
commands *may* work as documented, any such usage is at your own risk.

.. end-minio-mc-s3-compatibility

.. start-minio-syntax

- Brackets ``[]`` indicate optional parameters. 
- Parameters sharing a line are mutually dependent.
- Parameters separated using the pipe ``|`` operator are mutually exclusive.

Copy the example to a text editor and modify as-needed before running the
command in the terminal/shell.
You may need to use ``sudo`` if your user does not have write permissions for the path where ``mc`` is installed.

.. end-minio-syntax
