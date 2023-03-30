.. start-rewind-desc

Directs |command| to operate only on the object version(s) that
existed at specified point-in-time.

- To rewind to a specific date in the past, specify the date as an
  ISO8601-formatted timestamp. For example: ``--rewind "2020.03.24T10:00"``.

- To rewind a duration in time, specify the duration as a string in
  ``#d#hh#mm#ss`` format. For example: ``--rewind "1d2hh3mm4ss"``.

|rewind| requires that the specified |alias| be an S3-compatible service
that supports :ref:`minio-bucket-versioning`. For MinIO deployments, use
:mc:`mc version` to enable or disable bucket versioning.

.. end-rewind-desc

.. start-versions-desc

Directs |command| to operate on all object versions that exist in the
bucket.

|versions| requires that the specified |alias| be an S3-compatible service
that supports :ref:`minio-bucket-versioning`. For MinIO deployments, use
:mc:`mc version` to enable or disable bucket versioning.

.. end-versions-desc

.. start-version-id-desc

*Optional* Directs |command| to operate only on the specified object version.

|versionid| requires that the specified |alias| be an S3-compatible service
that supports :ref:`minio-bucket-versioning`. For MinIO deployments, use
:mc:`mc version` to enable or disable bucket versioning.

.. end-version-id-desc

.. start-versioning-admonition

.. admonition:: Requires Versioning
   :class: note

   |command| requires :ref:`bucket versioning <minio-bucket-versioning>` to
   use this feature. Use :mc:`mc version` to enable versioning on a bucket.

.. end-versioning-admonition
