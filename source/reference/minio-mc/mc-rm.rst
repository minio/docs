=========
``mc rm``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc rm

.. |command| replace:: :mc:`mc rm`
.. |rewind| replace:: :mc-cmd:`~mc rm --rewind`
.. |versions| replace:: :mc-cmd:`~mc rm --versions`
.. |versionid| replace:: :mc-cmd:`~mc rm --version-id`
.. |alias| replace:: :mc-cmd:`~mc rm ALIAS`

Syntax
------

.. start-mc-rm-desc

The :mc:`mc rm` command removes objects from a bucket on a MinIO deployment. 
To completely remove a bucket, use :mc:`mc rb` instead.

.. end-mc-rm-desc

You can also use :mc:`mc rm` against the local filesystem to produce similar
results to the ``rm`` commandline tool.

.. important::

   :mc:`mc rm` supports removing multiple objects *or* files in a single
   command. Consider using the :mc-cmd:`~mc rm --fake`
   option to validate that the operation targets only the desired objects/files.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes multiple objects from the 
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc rm --recursive myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] rm  \
                          [--bypass]               \
                          [--dangerous]            \
                          [--fake]                 \
                          [--force]*               \
                          [--incomplete]           \
                          [--newer-than "string"]  \
                          [--non-current]          \
                          [--older-than "string"]  \
                          [--recursive]            \
                          [--rewind "string"]      \
                          [--stdin]                \
                          [--version-id "string"]* \
                          [--versions]             \
                          ALIAS [ALIAS ...]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

      :mc-cmd:`mc rm --force` is required by multiple parameters.
      :mc-cmd:`mc rm --version-id` is mutually exclusive with multiple
      parameters. See the reference documentation for more information.

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The :ref:`alias <alias>` of a MinIO deployment and the full path to
   the object to remove. For example:

   .. code-block:: shell

      mc rm play/mybucket/object.txt

   You can specify multiple objects on the same or different MinIO deployments.
   For example:

   .. code-block:: shell

      mc rm play/mybucket/object.txt play/mybucket/otherobject.txt

   If specifying the path to a bucket or bucket prefix, you **must** also
   specify the :mc-cmd:`~mc rm --recursive` and 
   :mc-cmd:`~mc rm --force` arguments. For example:

   .. code-block:: shell

      mc rm --recursive --force play/mybucket/

      mc rm --recursive --force play/mybucket/myprefix/

   Consider first running the command with the
   :mc-cmd:`~mc rm --fake` flag to validate the scope of the
   recursive delete operation.

   For removing a file from a local filesystem, specify the full path to that
   file:

   .. code-block:: shell

      mc rm ~/data/myoldobject.txt

.. mc-cmd:: --bypass
   
   
   *Optional* Allows removing an object held under 
   :ref:`GOVERNANCE <minio-object-locking-governance>` object locking. 

.. mc-cmd:: --dangerous
   
   
   *Optional* Allows running :mc:`mc rm` when the :mc-cmd:`~mc rm ALIAS`
   specifies the root (all buckets) on the MinIO deployment.

   When combined with :mc-cmd:`~mc rm --versions`, this flag
   directs :mc:`mc rm` to permanently remove all objects *and* versions from
   the ``ALIAS`` target.

   Consider first running the command with the :mc-cmd:`~mc rm --fake` to
   validate the scope of the site-wide delete operation.

   .. warning::

      Running :mc-cmd:`mc rm --dangerous` with the
      :mc-cmd:`~mc rm --versions` flag is irreversible. Exercise all 
      possible due diligence in ensuring the command applies to only the desired
      ``ALIAS`` targets prior to execution.

.. mc-cmd:: --encrypt-key
   

   *Optional* The encryption key to use for performing Server-Side Encryption
   with Client Keys (SSE-C). Specify comma separated key-value pairs as
   ``KEY=VALUE,...``.
   
   - For ``KEY``, specify the S3-compatible service 
     :mc-cmd:`alias <mc alias>` and full path to the bucket, including any
     bucket prefixes. Separate the alias and bucket path with a forward slash 
     ``\``. For example, ``play/mybucket``

   - For ``VALUE``, specify the data key to use for encryption object(s) in
     the bucket or bucket prefix specified to ``KEY``.

   :mc-cmd:`~mc rm --encrypt-key` can use the ``MC_ENCRYPT_KEY``
   environment variable for populating the list of encryption key-value
   pairs as an alternative to specifying them on the command line.

.. mc-cmd:: --fake
   

   *Optional* Perform a fake remove operation. Use this operation to perform 
   validate that the :mc:`mc rm` operation will only
   remove the desired objects or buckets.

.. mc-cmd:: --force
   

   *Optional* Allows running :mc:`mc rm` with any of the following arguments:
   
   - :mc-cmd:`~mc rm --recursive`
   - :mc-cmd:`~mc rm --versions`
   - :mc-cmd:`~mc rm --stdin`

.. mc-cmd:: --incomplete, I
   

   *Optional* Remove incomplete uploads for the specified object.

   If any :mc-cmd:`~mc rm ALIAS` specifies a bucket, 
   you **must** also specify :mc-cmd:`~mc rm --recursive`
   and :mc-cmd:`~mc rm --force`.

.. mc-cmd:: --newer-than
   

   *Optional* Remove object(s) newer than the specified number of days. Specify
   a string in ``#d#hh#mm#ss`` format. For example: ``--newer-than 1d2hh3mm4ss``

   Defaults to ``0`` (all objects).

.. mc-cmd:: --non-current
   

   *Optional* Removes all :ref:`non-current <minio-bucket-versioning-delete>`
   object versions from the specified :mc-cmd:`~mc rm ALIAS`.

   This option has no effect on buckets without 
   :ref:`versioning <minio-bucket-versioning>` enabled.

.. mc-cmd:: --older-than
   

   *Optional* Remove object(s) older than the specified time limit. Specify a
   string in ``#d#hh#mm#ss`` format. For example: ``--older-than 1d2hh3mm4ss``.

      
   Defaults to ``0`` (all objects).

.. mc-cmd:: --recursive, r
   
   
   *Optional* Recursively remove the contents of each :mc-cmd:`~mc rm ALIAS`
   bucket or bucket prefix.

   If specifying :mc-cmd:`~mc rm --recursive`, you **must** also
   specify :mc-cmd:`~mc rm --force`.

   For buckets with :ref:`versioning <minio-bucket-versioning>` enabled,
   this option by default produces a delete marker for each removed object.
   Include the :mc-cmd:`~mc rm --versions` flag to recursively remove
   all objects *and* object versions from the bucket.

   Consider first running the command with the 
   :mc-cmd:`~mc rm --fake` flag to validate the scope of the
   recursive delete operation.

   Mutually exclusive with :mc-cmd:`mc rm --version-id`

.. mc-cmd:: --rewind
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: --stdin
   

   *Optional* Read object names or buckets from ``STDIN``.

.. mc-cmd:: --versions
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-versions-desc
      :end-before: end-versions-desc

   Use :mc-cmd:`~mc rm --versions` and 
   :mc-cmd:`~mc rm --rewind` together to remove all object
   versions which existed at a specific point in time.

.. mc-cmd:: --version-id, vid
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

   Mutually exclusive with any of the following flags:
   
   - :mc-cmd:`~mc rm --versions`
   - :mc-cmd:`~mc rm --rewind`
   - :mc-cmd:`~mc rm --recursive`

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Remove a Single Object
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc rm ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc rm ALIAS>` with the :mc:`alias <mc alias>` of
  a configured S3-compatible service.

- Replace :mc-cmd:`PATH <mc rm ALIAS>` with the path to the object.


Recursively Remove a Bucket's Contents
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc rm` with the
:mc-cmd:`~mc rm --recursive` and :mc-cmd:`~mc rm --force` options
to recursively remove a bucket's contents.

.. code-block:: shell
   :class: copyable

   mc rm --recursive --force ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc rm ALIAS>` with the :mc:`alias <mc alias>` of
  a configured S3-compatible service.

- Replace :mc-cmd:`PATH <mc rm ALIAS>` with the path to the bucket.

This operation does *not* remove the bucket. Use :mc:`mc rb` to remove the
bucket along with all contents and associated configurations.

Remove All Incomplete Upload Files for an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc rm` with the :mc-cmd:`~mc rm --incomplete` option to remove
incomplete upload files for an object. 

.. code-block:: shell
   :class: copyable

   mc rm --incomplete --recursive --force ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc rm ALIAS>` with the :mc:`alias <mc alias>` of
  a configured S3-compatible service.

- Replace :mc-cmd:`PATH <mc rm ALIAS>` with the path to the object.

Removing incomplete upload files prevents resuming the upload using the
:mc-cmd:`mc mv --continue` or :mc-cmd:`mc cp --continue` commands.

Roll Object Back To Previous Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc rm` with :mc-cmd:`~mc rm --versions` and 
:mc-cmd:`~mc rm --newer-than` to
remove all object versions newer than the specified duration of time. This
effectively "rolls back" the object to its state at that time.

.. important::

   Removing specific versions of an object is a *destructive* action. You cannot
   restore the deleted object versions.

.. code-block:: shell
   :class: moveable

   mc rm ALIAS/PATH --versions --newer-than DURATION

- Replace :mc-cmd:`ALIAS <mc rm ALIAS>` with the :mc:`alias <mc alias>` of
  a configured S3-compatible service.

- Replace :mc-cmd:`PATH <mc rm ALIAS>` with the path to the object. For 
  example, ``/mybucket/myobject``.

- Replace :mc-cmd:`DURATION <mc rm --newer-than>` with the number of days in the
  past from the current host time from which the operation begins removing
  versions of the object. For example, to remove all versions of the object
  created in the last 30 days, specify ``"30d"``.

Behavior
--------

Deleting Bucket Contents
~~~~~~~~~~~~~~~~~~~~~~~~

Using :mc:`mc rm` to remove all contents in a bucket does not delete the bucket
itself. Any configurations associated to the bucket remain in place, such as
:mc-cmd:`default object lock settings <mc retention set --default>`.

To completely remove a bucket, use :mc:`mc rb` instead of :mc:`mc rm`.

MinIO Trims Empty Prefixes on Object Removal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-admonitions.rst
   :start-after: start-remove-api-trims-prefixes
   :end-before: end-remove-api-trims-prefixes

.. include:: /includes/common-admonitions.rst
   :start-after: start-remove-api-trims-prefixes-fs
   :end-before: end-remove-api-trims-prefixes-fs

Delete Operations in Versioned Buckets
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports keeping multiple :ref:`versions <minio-bucket-versioning>` of an
object in a single bucket. :ref:`Deleting <minio-bucket-versioning-delete>` an
object in a versioned bucket results in a special ``DeleteMarker`` tombstone
that marks an object as deleted while retaining all previous versions of that
object.

- To remove a specific object version from a bucket, use
  :mc-cmd:`mc rm --version-id`

- To remove all versions of an object from a bucket, use
  :mc-cmd:`mc rm --versions`

- To remove all non-current versions of an object from a bucket, use
  :mc-cmd:`mc rm --non-current`


S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
