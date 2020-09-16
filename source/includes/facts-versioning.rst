.. start-rewind-desc

Directs |command| to operate only on the object version(s) that existed at
specified point-in-time.

- To rewind to a specific date in the past, specify the date as an
  ISO8601-formatted timestamp. For example: ``--rewind "2020.03.24T10:00"``.

- To rewind a duration in time, specify the duration as a string in
  ``#d#hh#mm#ss`` format. For example: ``--rewind "1d2hh3mm4ss"``.

|rewind| requires that the specified |alias| be an S3-compatible service
that supports :ref:`minio-bucket-versioning`. For MinIO deployments, use
:mc-cmd:`mc version` to enable or disable bucket versioning.

.. end-rewind-desc

.. start-versions-desc

Directs |command| to operate on all object versions that exist in the bucket.

|versions| requires that the specified |alias| be an S3-compatible service
that supports :ref:`minio-bucket-versioning`. For MinIO deployments, use
:mc-cmd:`mc version` to enable or disable bucket versioning.

.. end-versions-desc

.. start-version-id-desc

Directs |command| to operate only on the specified object version.

|versionid| requires that the specified |alias| be an S3-compatible service
that supports :ref:`minio-bucket-versioning`. For MinIO deployments, use
:mc-cmd:`mc version` to enable or disable bucket versioning.

.. end-version-id-desc

..

   So this is an ugly workaround. Since you can't override substitutions
   on a single page, those reference commands with multiple subcommands
   get kind of messy. Instead, the following sections "duplicate"
   the core content for supporting commands with multiple subcommands that
   support versioning arguments.

   The ideal path forward would be to extend the include directive to
   allow for per-directive replacement, but that will take significant
   engineering effort. So until then, kludges it is.

..
   ----------------- 2nd Argument --------------------

.. start-rewind-desc-2

Directs |command-2| to operate only on the object version(s) that existed at
specified point-in-time.

- To rewind to a specific date in the past, specify the date as an
  ISO8601-formatted timestamp. For example: ``--rewind "2020.03.24T10:00"``.

- To rewind a duration in time, specify the duration as a string in
  ``#d#hh#mm#ss`` format. For example: ``--rewind "1d2hh3mm4ss"``.

|rewind-2| requires that the specified |alias-2| be an S3-compatible service
that supports :ref:`minio-bucket-versioning`. For MinIO deployments, use
:mc-cmd:`mc version` to enable or disable bucket versioning.

.. end-rewind-desc-2

.. start-versions-desc-2

Directs |command-2| to operate on all object versions that exist in the bucket.

|versions-2| requires that the specified |alias-2| be an S3-compatible service
that supports :ref:`minio-bucket-versioning`. For MinIO deployments, use
:mc-cmd:`mc version` to enable or disable bucket versioning.

.. end-versions-desc-2

.. start-version-id-desc-2

Directs |command-2| to operate only on the specified object version.

|versionid-2| requires that the specified |alias-2| be an S3-compatible service
that supports :ref:`minio-bucket-versioning`. For MinIO deployments, use
:mc-cmd:`mc version` to enable or disable bucket versioning.

.. end-version-id-desc-2



..

   -------------- 3rd Subcommand --------------

.. start-rewind-desc-3

Directs |command-3| to operate only on the object version(s) that existed at
specified point-in-time.

- To rewind to a specific date in the past, specify the date as an
  ISO8601-formatted timestamp. For example: ``--rewind "2020.03.24T10:00"``.

- To rewind a duration in time, specify the duration as a string in
  ``#d#hh#mm#ss`` format. For example: ``--rewind "1d2hh3mm4ss"``.

|rewind-3| requires that the specified |alias-3| be an S3-compatible service
that supports :ref:`minio-bucket-versioning`. For MinIO deployments, use
:mc-cmd:`mc version` to enable or disable bucket versioning.

.. end-rewind-desc-3

.. start-versions-desc-3

Directs |command-3| to operate on all object versions that exist in the bucket.

|versions-3| requires that the specified |alias-3| be an S3-compatible service
that supports :ref:`minio-bucket-versioning`. For MinIO deployments, use
:mc-cmd:`mc version` to enable or disable bucket versioning.

.. end-versions-desc-3

.. start-version-id-desc-3

Directs |command-3| to operate only on the specified object version.

|versionid-3| requires that the specified |alias-3| be an S3-compatible service
that supports :ref:`minio-bucket-versioning`. For MinIO deployments, use
:mc-cmd:`mc version` to enable or disable bucket versioning.

.. end-version-id-desc-3