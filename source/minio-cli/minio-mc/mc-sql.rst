==========
``mc sql``
==========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc sql

Description
-----------

.. start-mc-sql-desc

The :mc:`mc sql` command provides an S3 Select interface for performing sql
queries on objects in the specified S3-compatible service. 

.. end-mc-sql-desc

See :s3-docs:`Selecting content from objects 
<selecting-content-from-objects>` for more information on S3 Select behavior
and limitations.

Syntax
------

:mc:`mc sql` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc sql [FLAGS] TARGET [TARGET...]

:mc:`mc sql` supports the following arguments:

.. mc-cmd:: TARGET

   *Required* The full path to the bucket or object to run the SQL query
   against. Specify the :mc-cmd:`alias <mc alias>` of a configured
   S3 service as the prefix to the ``TARGET`` path. For example:

   .. code-block:: shell

      mc sql [FLAGS] play/mybucket

.. mc-cmd:: query, e
   :option:

   The SQL statement to execute on the specified :mc-cmd:`~mc sql TARGET`
   directory or object. Wrap the entire SQL query in double quotes ``"``.

   Defaults to ``"select * from s3object"``.

.. mc-cmd:: recursive, r
   :option:

   Recursively searches the specified :mc-cmd:`~mc sql TARGET` directory
   using the :mc-cmd-option:`~mc sql query` SQL statement.


.. mc-cmd:: csv-input
   :option:

   The data format for ``.csv`` input objects. Specify a string of
   comma-seperated ``key=value,...`` pairs. See :ref:`mc-sql-csv-format`
   for more information on valid keys.

.. mc-cmd:: json-input
   :option:

   The data format for ``.json`` input objects. Specify the type of the JSON
   contents as ``type=<VALUE>``. The value can be either:

   - ``DOCUMENT`` - JSON `document <https://www.json.org/json-en.html>`__.
   - ``LINES`` - JSON `lines <http://jsonlines.org/>`__.

   See the S3 API :s3-api:`JSONInput <API_JSONInput.html>` for more
   information.

.. mc-cmd:: compression
   :option:

   The compression type of the input object. Specify one of the following
   supported values:

   - ``GZIP``
   - ``BZIP2``
   - ``NONE`` (default)

.. mc-cmd:: csv-output
   :option:

   The data format for ``.csv`` output. Specify a string of comma-seperated
   ``key=value,...`` pairs. See :ref:`mc-sql-csv-format` for more information
   on valid keys.

   See the S3 API :s3-api:`CSVOutput <API_CSVOutput.html>` for more
   information.

.. mc-cmd:: csv-output-header
   :option:

   The header row of the ``.csv`` output file. Specify a string of
   comma-separated fields as ``field1,field2,...``.

   Omit to output a ``.csv`` with no header row.


.. mc-cmd:: json-output
   :option:

   The data format for the ``.json`` output. Supports the 
   ``rd=value`` key, where ``rd`` is the ``RecordDelimiter`` for the JSON
   document.

   Omit to use the default newline character ``\n``.

   See the S3 API :s3-api:`JSONOutput <API_JSONOutput.html>` for more
   information.

.. mc-cmd:: encrypt-key
   :option:

   The encryption key to use for performing Server-Side Encryption with Client
   Keys (SSE-C). Specify comma seperated key-value pairs as ``KEY=VALUE,...``.
   
   - For ``KEY``, specify the S3-compatible service 
     :mc-cmd:`alias <mc alias>` and full path to the bucket, including any
     bucket prefixes. Separate the alias and bucket path with a forward slash 
     ``\``. For example, ``play/mybucket``

   - For ``VALUE``, specify the data key to use for encryption object(s) in
     the bucket or bucket prefix specified to ``KEY``.

   :mc-cmd-option:`~mc sql encrypt-key` can use the ``MC_ENCRYPT_KEY``
   environment variable for populating the list of encryption key-value
   pairs as an alternative to specifying them on the command line.

Behavior
--------

Input Formats
~~~~~~~~~~~~~

:mc:`mc sql` supports the following input formats:

- ``.csv``
- ``.json``
- ``.parquet``

For ``.csv`` file types, use :mc-cmd-option:`mc sql csv-input` to 
specify the CSV data format. See :ref:`mc-sql-csv-format` for more 
information on CSV formatting fields.

For ``.json`` file types, use :mc-cmd-option:`mc sql json-input` to specify
the JSON data format.

For ``.parquet`` file types, :mc-cmd:`mc sql` automatically interprets the
data format.

.. _mc-sql-csv-format:

CSV Formatting Fields
~~~~~~~~~~~~~~~~~~~~~

The following table lists valid key-value pairs for use with
:mc-cmd-option:`mc sql csv-input` and :mc-cmd-option:`mc sql csv-output`. 
Certain key pairs are only valid for :mc-cmd-option:`~mc sql csv-input`
See the documentation for S3 API :s3-api:`CSVInput <API_CSVInput.html>` for more 
information on S3 CSV formatting.

.. list-table:: 
   :header-rows: 1
   :widths: 20 20 60
   :width: 100%

   * - Key
     - ``--csv-input`` Only
     - Description

   * - ``rd``
     -
     - The character that seperates each record (row) in the input ``.csv``
       file.
         
       Corresponds to ``RecordDelimiter`` in the S3 API ``CSVInput``.

   * - ``fd``
     -
     - The character that seperates each field in a record. Defaults to 
       ``,``.
      
       Corresponds to ``FieldDelimeter`` in the S3 API ``CSVInput``.
   
   * - ``qc``
     -
     - The character used for escaping when the ``fd`` character is part of 
       a value. Defaults to ``"``.

       Corresponds to ``QuoteCharacter`` in the S3 API ``CSVInput``.
   
   * - ``qec``
     -
     - The character used for escaping a quotation mark ``"`` character
       inside an already escaped value. 

       Corresponds to ``QuoteEscapeCharacter`` in the S3 API ``CSVInput``.
   
   * - ``fh``
     - Yes
     - The content of the first line in the ``.csv`` file. 
        
       Specify one of the following supported values:

       - ``NONE`` - The first line is not a header.
       - ``IGNORE`` - Ignore the first line.
       - ``USE`` - The first line is a header.

       For ``NONE`` or ``IGNORE``, you must specify column positions
       ``_#`` to identify a column in the :mc-cmd-option:`~mc sql query` 
       statement.

       For ``USE``, you can specify header values to identify a column in 
       the :mc-cmd-option:`~mc sql query` statement.

       Corresponds to ``FieldHeaderInfo`` in the S3 API ``CSVInput``.
   
   * - ``cc``
     - Yes
     - The character used to indicate a record should be ignored. The
       character *must* appear at the beginning of the record.

       Corresponds to ``Comment`` in the S3 API ``CSVInput``.
   
   * - ``qrd``
     - Yes
     - Specify ``TRUE`` to indicate that fields may contain record delimiter
       values (``rd``).

       Defaults to ``FALSE``.

       Corresponds to ``AllowQuotedRecordDelimiter`` in the S3 API
       ``CSVInput``.

Examples
--------

Select all Columns in all Objects in a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell

   mc sql --recursive \
     --query "select * from S3Object" s3/personalbucket/my-large-csvs/

Run an Aggregation Query on an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell

   mc sql --query "select count(s.power) from S3Object" myminio/iot-devices/power-ratio.csv

Run an Aggregation Query on an Encrypted Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell

   mc sql --encrypt-key "myminio/iot-devices=32byteslongsecretkeymustbegiven1" \
    --query "select count(s.power) from S3Object" myminio/iot-devices/power-ratio-encrypted.csv
