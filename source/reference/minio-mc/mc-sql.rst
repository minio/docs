==========
``mc sql``
==========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc sql

Syntax
------

.. start-mc-sql-desc

The :mc:`mc sql` command provides an S3 Select interface for performing sql queries on objects in the specified MinIO deployment.

.. end-mc-sql-desc

See :s3-docs:`Selecting content from objects <selecting-content-from-objects>` for more information on S3 Select behavior and limitations.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command queries all objects in the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc sql --recursive --query "select * from S3Object" myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] mc sql                          \
                          --query "string"                \
                          [--csv-input "string"]          \
                          [--compression "string"]        \
                          [--csv-output "string"]         \
                          [--csv-output-header "string"]  \
                          [--encrypt-key "string"]        \
                          [--json-input "string"]         \
                          [--json-output "string"]        \
                          [--recursive]                   \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The full path to the bucket or object to run the SQL query against.
   Specify the :ref:`alias <alias>` of a configured S3 service as the prefix to the ``ALIAS`` path.
   For example:

   .. code-block:: shell

      mc sql [FLAGS] play/mybucket

.. mc-cmd:: --query, e
   :required:

   The SQL statement to execute on the specified :mc-cmd:`~mc sql ALIAS` directory or object.
   Wrap the entire SQL query in double quotes ``"``.

   Defaults to ``"select * from S3Object"``.

.. mc-cmd:: --csv-input
   :optional:

   The data format for ``.csv`` input objects.
   Specify a string of comma-seperated ``key=value,...`` pairs.
   See :ref:`mc-sql-csv-format` for more information on valid keys.

.. mc-cmd:: --compression
   :optional:

   The compression type of the input object.
   Specify one of the following supported values:

   - ``GZIP``
   - ``BZIP2``
   - ``NONE`` (default)

   Compression schemes supported by MinIO backend only:

   - ``ZSTD`` `Zstandard <https://facebook.github.io/zstd/>`__
   - ``LZ4`` `LZ4 <https://lz4.github.io/lz4/>`__ stream
   - ``S2`` `S2 <https://github.com/klauspost/compress/tree/master/s2#s2-compression>`__ framed stream
   - ``SNAPPY`` `Snappy <http://google.github.io/snappy/>`__ framed stream

.. mc-cmd:: --csv-output
   :optional:

   The data format for ``.csv`` output.
   Specify a string of comma-seperated ``key=value,...`` pairs.
   See :ref:`mc-sql-csv-format` for more information on valid keys.

   See the S3 API :s3-api:`CSVOutput <API_CSVOutput.html>` for more information.

.. mc-cmd:: --csv-output-header
   :optional:

   The header row of the ``.csv`` output file.
   Specify a string of comma-separated fields as ``field1,field2,...``.

   Omit to output a ``.csv`` with no header row.

.. mc-cmd:: --encrypt-key
   :optional:

   The encryption key to use for performing Server-Side Encryption with Client Keys (SSE-C).
   Specify comma seperated key-value pairs as ``KEY=VALUE,...``.

   - For ``KEY``, specify the MinIO deployment :mc-cmd:`alias <mc alias>` and full path to the bucket, including any bucket prefixes.
     Separate the alias and bucket path with a forward slash ``\``.
     For example, ``play/mybucket``.

   - For ``VALUE``, specify the data key to use for encryption object(s) in the bucket or bucket prefix specified to ``KEY``.

   :mc-cmd:`~mc sql --encrypt-key` can use the ``MC_ENCRYPT_KEY`` environment variable for populating the list of encryption key-value pairs as an alternative to specifying them on the command line.

.. mc-cmd:: --json-input
   :optional:

   The data format for ``.json`` or ``.ndjson`` input objects.
   Specify the type of the JSON contents as ``type=<VALUE>``.
   The value can be either:

   - ``DOCUMENT`` - JSON `document <https://www.json.org/json-en.html>`__.
   - ``LINES`` - JSON `lines <http://jsonlines.org/>`__.

   See the S3 API :s3-api:`JSONInput <API_JSONInput.html>` for more information.

.. mc-cmd:: --json-output
   :optional:

   The data format for the ``.json`` output.
   Supports the ``rd=value`` key, where ``rd`` is the ``RecordDelimiter`` for the JSON document.

   Omit to use the default newline character ``\n``.

   See the S3 API :s3-api:`JSONOutput <API_JSONOutput.html>` for more information.

.. mc-cmd:: --recursive, r
   :optional:

   Recursively searches the specified :mc-cmd:`~mc sql ALIAS` directory using the :mc-cmd:`~mc sql --query` SQL statement.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Select all Columns in all Objects in a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc sql` with the :mc-cmd:`~mc sql --recursive` and :mc-cmd:`~mc sql --query` options to apply the query to all objects  in a bucket:

.. code-block:: shell
   :class: copyable

   mc sql --recursive --query "select * from S3Object" ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc sql ALIAS>` with the :ref:`alias <alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc sql ALIAS>` with the path to the bucket on the MinIO deployment.

Run an Aggregation Query on an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc sql` with the :mc-cmd:`~mc sql --query` option to query an object on an MinIO deployment:

.. code-block:: shell

   mc sql --query "select count(s.power) from S3Object" ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc sql ALIAS>` with the :ref:`alias <alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc sql ALIAS>` with the path to the object on the MinIO deployment.

Behavior
--------

Input Formats
~~~~~~~~~~~~~

:mc:`mc sql` supports the following input formats:

.. list-table:: Input Format Types
   :header-rows: 1
		 
   * - Type
     - ``content-type`` Value

   * - ``.csv``
     - ``text/csv``

   * - ``.json``
     - ``application/json``

   * - ``.parquet``
     - none

For ``.csv`` file types, use :mc-cmd:`mc sql --csv-input` to specify the CSV data format.
See :ref:`mc-sql-csv-format` for more information on CSV formatting fields.

For ``.json`` file types, use :mc-cmd:`mc sql --json-input` to specify the JSON data format.

For ``.parquet`` file types, :mc:`mc sql` automatically interprets the data format.

:mc:`mc sql` determines the type by the file extension of the target object.
For example, an object named ``data.json`` is interpreted as a JSON file.

You can query data of a supported type but a different extension if the object has the appropriate ``content-type``.
For more information, see :mc-cmd:`mc cp --attr`.

.. _mc-sql-csv-format:

CSV Formatting Fields
~~~~~~~~~~~~~~~~~~~~~

The following table lists valid key-value pairs for use with :mc-cmd:`mc sql --csv-input` and :mc-cmd:`mc sql --csv-output`.
Certain key pairs are only valid for :mc-cmd:`~mc sql --csv-input`.
See the documentation for S3 API :s3-api:`CSVInput <API_CSVInput.html>` for more information on S3 CSV formatting.

.. list-table::
   :header-rows: 1
   :widths: 20 20 60
   :width: 100%

   * - Key
     - ``--csv-input`` Only
     - Description

   * - ``rd``
     -
     - The character that seperates each record (row) in the input ``.csv`` file.

       Corresponds to ``RecordDelimiter`` in the S3 API ``CSVInput``.

   * - ``fd``
     -
     - The character that seperates each field in a record. Defaults to ``,``.

       Corresponds to ``FieldDelimeter`` in the S3 API ``CSVInput``.

   * - ``qc``
     -
     - The character used for escaping when the ``fd`` character is part of a value. Defaults to ``"``.

       Corresponds to ``QuoteCharacter`` in the S3 API ``CSVInput``.

   * - ``qec``
     -
     - The character used for escaping a quotation mark ``"`` character inside an already escaped value. 

       Corresponds to ``QuoteEscapeCharacter`` in the S3 API ``CSVInput``.

   * - ``fh``
     - Yes
     - The content of the first line in the ``.csv`` file.

       Specify one of the following supported values:

       - ``NONE`` - The first line is not a header.
       - ``IGNORE`` - Ignore the first line.
       - ``USE`` - The first line is a header.

       For ``NONE`` or ``IGNORE``, you must specify column positions ``_#`` to identify a column in the :mc-cmd:`~mc sql --query` statement.

       For ``USE``, you can specify header values to identify a column in the :mc-cmd:`~mc sql --query` statement.

       Corresponds to ``FieldHeaderInfo`` in the S3 API ``CSVInput``.

   * - ``cc``
     - Yes
     - The character used to indicate a record should be ignored.
       The character *must* appear at the beginning of the record.

       Corresponds to ``Comment`` in the S3 API ``CSVInput``.

   * - ``qrd``
     - Yes
     - Specify ``TRUE`` to indicate that fields may contain record delimiter values (``rd``).

       Defaults to ``FALSE``.

       Corresponds to ``AllowQuotedRecordDelimiter`` in the S3 API ``CSVInput``.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
