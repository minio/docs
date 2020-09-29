================
``mc retention``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc retention

Description
-----------

.. start-mc-retention-desc

The :mc:`mc retention` command configures the Write-Once Read-Many (WORM) object
lock settings for an object or object(s) in a bucket. You can also set the
default object lock settings for a bucket, where all objects without explicit
object lock settings inherit the bucket default. For more information on MinIO
object locking and data retention, see <link>.

.. end-mc-retention-desc

.. important::

   :mc:`mc retention` *requires* that the specified bucket has object locking
   enabled. You can **only** enable object locking at bucket creation. See
   :mc-cmd-option:`mc mb with-lock` for documentation on creating buckets with
   object locking enabled. 

.. note::

   Starting in version :release:``, :mc:`mc retention` fully replaces :mc:`mc
   lock` for setting the default object lock settings for a bucket.
   :release:`` deprecates and removes :mc:`mc lock`.

Syntax
------

:mc:`~mc retention` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc retention COMMANDS [COMMAND ARGUMENTS]

:mc:`~mc retention` supports the following commands:

.. mc-cmd:: set
   :fullpath:

   Sets the object lock settings for the specified
   :mc-cmd:`~mc retention set TARGET` object.

   :mc-cmd:`mc retention set` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc retention set [FLAGS] TARGET MODE VALIDITY

   - If the ``TARGET`` specifies a bucket or bucket prefix, include
     :mc-cmd-option:`~mc retention set recursive` to apply the object lock
     settings to the bucket contents.

   - If the ``TARGET`` bucket has versioning enabled, :mc-cmd:`mc retention set`
     by default applies to only the latest object version. Use
     :mc-cmd-option:`~mc retention set verison-id` or
     :mc-cmd-option:`~mc retention set versions` to apply the object lock
     settings to a specific version or to all versions of the object.

   :mc-cmd:`mc retention set` supports the following arguments:

   .. mc-cmd:: bypass
      :option:

      Allows a user with the ``s3:BypassGovernanceRetention`` permission
      to modify the object. Requires the ``governance`` retention 
      :mc-cmd:`~mc retention set MODE`

   .. mc-cmd:: recursive, r
      :option:

      Recursively applies the object lock settings to all objects in the
      specified :mc-cmd:`~mc retention set TARGET` path.

      Mutually exclusive with :mc-cmd-option:`~mc retention set version-id`.

   .. mc-cmd:: default
      :option:

      Sets the default object lock settings for the bucket specified to
      :mc-cmd:`~mc retention set TARGET` using the
      :mc-cmd:`~mc retention set MODE` and :mc-cmd:`~mc retention set VALIDITY`. 
      Any objects created in the bucket inherit the default object lock settings
      unless explicitly overriden using :mc-cmd:`mc retention set`.

      .. versionadded:: RELEASE.2020-08-XXT00-00-00Z

         :mc-cmd-option:`mc retention set default` replaces the functionality of
         the deprecated :mc-cmd:`mc lock` command.
      
      If specifying :mc-cmd-option:`~mc retention set default`, 
      :mc-cmd:`mc retention set` ignores all other flags.

   .. mc-cmd:: version-id
      :option:

      Applies the object lock settings to the specified version of the
      :mc-cmd:`~mc retention set TARGET` object. Requires
      the bucket to have versioning enabled. Use :mc:`mc version` to
      enable bucket versioning.

      Mutually exclusive with any of the following flags:
      
      - :mc-cmd-option:`~mc retention set versions`
      - :mc-cmd-option:`~mc retention set rewind`
      - :mc-cmd-option:`~mc retention set recursive`

   .. mc-cmd:: versions
      :option:

      Applies the object lock settings to all versions of the 
      :mc-cmd:`~mc retention set TARGET` object or object(s). Requires the
      bucket to have versioning enabled. Use :mc:`mc version` to enable bucket
      versioning.

      Use :mc-cmd-option:`~mc retention set rewind` and 
      :mc-cmd-option:`~mc retention set versions` together to apply the object
      lock settings to all versions of the object or object(s) which existed at
      the specified duration prior to the current date. *or* at the specified
      date.

      Mutually exclusive with :mc-cmd-option:`~mc retention set version-id`.

   .. mc-cmd:: rewind
      :option:

      Applies the object lock settings to the latest version of the object or
      object(s) which existed at either the specified duration prior to the
      current date *or* at a specific date.

      - For duration, specify a string in ``#d#hh#mm#ss`` format. For example:
        ``--rewind "1d2hh3mm4ss"``.

      - For a date in time, specify an ISO8601-formatted timestamp. For example:
        ``--rewind "2020.03.24T10:00"``.

      For example, to apply the object lock settings to the object or object(s)
      as they existed 30 days prior to the current date: ``--rewind "30d"``

      Use :mc-cmd-option:`~mc retention set rewind` and 
      :mc-cmd-option:`~mc retention set versions` together to apply the object
      lock settings to all versions of the object or object(s) which existed at
      the specified duration prior to the current date. *or* at the specified
      date.

      Mutually exclusive with :mc-cmd-option:`~mc retention set version-id`.

   .. mc-cmd:: TARGET

      *Required* The full path to the object or objects for which to set
      object lock configuration. Specify the :mc-cmd:`alias <mc alias>` of
      a configured S3-compatible service as the prefix to the ``TARGET`` bucket
      path. For example:

      .. code-block:: shell

         mc retention play/mybucket/object.txt MODE VALIDITY

      If specifying a bucket prefix, include the 
      :mc-cmd-option:`~mc retention set recursive` flag to apply the object
      lock configuration to all objects in the bucket.

   .. mc-cmd:: MODE

      Sets the locking mode for the :mc-cmd:`~mc retention set TARGET`. 
      Specify one of the following supported values:

      - ``governance``
      - ``compliance``

      See the AWS S3 documentation on :s3-docs:`Object Lock Overview
      <object-lock-overview.html>` for more information on the supported
      modes.

      Requires specifying :mc-cmd:`~mc retention set VALIDITY`.

   .. mc-cmd:: VALIDITY

      The duration which objects remain in the specified
      :mc-cmd:`~mc retention set MODE` after creation.

      - For days, specify a string formatted as ``Nd``. For example,
        ``30d`` for 30 days after object creation.

      - For years, specify a string formatted as ``Ny``. For example, 
        ``1y`` for 1 year after object creation.

.. mc-cmd:: info

   Returns the current object lock setting for the specified 
   :mc-cmd:`~mc retention info TARGET`. 

   :mc-cmd:`mc retention info` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc retention info [ARGUMENTS] TARGET

   - If the ``TARGET`` specifies a bucket or bucket prefix, include 
     :mc-cmd-option:`~mc retention info recursive` to return the object
     lock settings for all objects in the bucket or bucket prefix.

   - If the ``TARGET`` bucket has versioning enabled, 
     :mc-cmd:`mc retention info` by default applies to only the latest object
     version. Use :mc-cmd-option:`~mc retention info verison-id` or
     :mc-cmd-option:`~mc retention info versions` to return the object lock
     settings for a specific version or for all versions of the object.

   :mc-cmd:`mc retention info` supports the following arguments:

   .. mc-cmd:: recursive, r
      :option:

      Recursively returns the object lock settings for all objects in the
      specified :mc-cmd:`~mc retention info TARGET` path.

      Mutually exclusive with :mc-cmd-option:`~mc retention info version-id`.

   .. mc-cmd:: default
      :option:

      Returns the default object lock settings for the bucket specified to
      :mc-cmd:`~mc retention info TARGET`.

      .. versionadded:: RELEASE.2020-08-XXT00-00-00Z

         :mc-cmd-option:`mc retention info default` replaces the functionality
         of the deprecated :mc-cmd:`mc lock info` command.
      
      If specifying :mc-cmd-option:`~mc retention info default`, 
      :mc-cmd:`mc retention info` ignores all other flags.

   .. mc-cmd:: version-id
      :option:

      Returns the object lock settings of the specified version of the
      :mc-cmd:`~mc retention info TARGET` object. Requires
      the bucket to have versioning enabled. Use :mc:`mc version` to
      enable bucket versioning.

      Mutually exclusive with any of the following flags:
      
      - :mc-cmd-option:`~mc retention info versions`
      - :mc-cmd-option:`~mc retention info rewind`
      - :mc-cmd-option:`~mc retention info recursive`

   .. mc-cmd:: versions
      :option:

      Returns the object lock settings of all versions of the 
      :mc-cmd:`~mc retention info TARGET` object or object(s). Requires the
      bucket to have versioning enabled. Use :mc:`mc version` to enable bucket
      versioning.

      Use :mc-cmd-option:`~mc retention info rewind` and 
      :mc-cmd-option:`~mc retention info versions` together to return the object
      lock settings of all versions of the object or object(s) which existed at
      the specified duration prior to the current date. *or* at the specified
      date.

      Mutually exclusive with :mc-cmd-option:`~mc retention info version-id`.

   .. mc-cmd:: rewind
      :option:

      Returns the object lock settings of the latest version of the object or
      object(s) which existed at either the specified duration prior to the
      current date *or* at a specific date.

      - For duration, specify a string in ``#d#hh#mm#ss`` format. For example:
        ``--rewind "1d2hh3mm4ss"``.

      - For a date in time, specify an ISO8601-formatted timestamp. For example:
        ``--rewind "2020.03.24T10:00"``.

      For example, to return the object lock settings to the object or object(s)
      as they existed 30 days prior to the current date: ``--rewind "30d"``

      Use :mc-cmd-option:`~mc retention info rewind` and 
      :mc-cmd-option:`~mc retention info versions` together to return the object
      lock settings of all versions of the object or object(s) which existed at
      the specified duration prior to the current date. *or* at the specified
      date.

      Mutually exclusive with :mc-cmd-option:`~mc retention info version-id`.

   .. mc-cmd:: TARGET

      *Required* The full path to the object for which to retreive
      the object lock configuration. Specify the :mc-cmd:`alias <mc alias>` of a
      configured S3-compatible service as the prefix to the ``TARGET`` bucket
      path. For example:

      .. code-block:: shell

         mc retention play/mybucket/object.txt MODE VALIDITY

      If specifying a bucket or bucket prefix, include the 
      :mc-cmd-option:`~mc retention info recursive` flag to return the object
      lock configuration to all objects in the prefix.

.. mc-cmd:: clear

   Clears the object lock setting for the specified ``TARGET``. 

   :mc-cmd:`mc retention info` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc retention clear [ARGUMENTS] TARGET

   - If the ``TARGET`` specifies a bucket or bucket prefix, include
     :mc-cmd-option:`~mc retention clear recursive` to clear the object lock
     settings to the bucket contents.

   - If the ``TARGET`` bucket has versioning enabled,
     :mc-cmd:`mc retention clear` by default applies to only the latest object
     version. Use :mc-cmd-option:`~mc retention clear verison-id` or
     :mc-cmd-option:`~mc retention clear versions` to clear the object lock
     settings for a specific version or for all versions of the object.

   :mc-cmd:`mc retention info` supports the following arguments:

   .. mc-cmd:: recursive, r
      :option:

      Recursively clears the object lock settings for all objects in the
      specified :mc-cmd:`~mc retention clear TARGET` path.

      Mutually exclusive with :mc-cmd-option:`~mc retention clear version-id`.

   .. mc-cmd:: default
      :option:

      Clears the default object lock settings for the bucket specified to
      :mc-cmd:`~mc retention clear TARGET`.

      .. versionadded:: RELEASE.2020-08-XXT00-00-00Z

         :mc-cmd-option:`mc retention clear default` replaces the functionality
         of the deprecated :mc-cmd:`mc lock clear` command.
      
      If specifying :mc-cmd-option:`~mc retention clear default`, 
      :mc-cmd:`mc retention clear` ignores all other flags.

   .. mc-cmd:: version-id
      :option:

      Clears the object lock settings of the specified version of the
      :mc-cmd:`~mc retention clear TARGET` object. Requires
      the bucket to have versioning enabled. Use :mc:`mc version` to
      enable bucket versioning.

      Mutually exclusive with any of the following flags:
      
      - :mc-cmd-option:`~mc retention clear versions`
      - :mc-cmd-option:`~mc retention clear rewind`
      - :mc-cmd-option:`~mc retention clear recursive`

   .. mc-cmd:: versions
      :option:

      Clears the object lock settings of all versions of the 
      :mc-cmd:`~mc retention clear TARGET` object or object(s). Requires the
      bucket to have versioning enabled. Use :mc:`mc version` to enable bucket
      versioning.

      Use :mc-cmd-option:`~mc retention clear rewind` and 
      :mc-cmd-option:`~mc retention clear versions` together to clear the
      object lock settings of all versions of the object or object(s) which
      existed at the specified duration prior to the current date. *or* at the
      specified date.

      Mutually exclusive with :mc-cmd-option:`~mc retention clear version-id`.

   .. mc-cmd:: rewind
      :option:

      Clears the object lock settings of the latest version of the object or
      object(s) which existed at either the specified duration prior to the
      current date *or* at a specific date.

      - For duration, specify a string in ``#d#hh#mm#ss`` format. For example:
        ``--rewind "1d2hh3mm4ss"``.

      - For a date in time, specify an ISO8601-formatted timestamp. For example:
        ``--rewind "2020.03.24T10:00"``.

      For example, to clear the object lock settings to the object or object(s)
      as they existed 30 days prior to the current date: ``--rewind "30d"``

      Use :mc-cmd-option:`~mc retention clear rewind` and 
      :mc-cmd-option:`~mc retention clear versions` together to clear the
      object lock settings of all versions of the object or object(s) which
      existed at the specified duration prior to the current date *or* at the
      specified date.

      Mutually exclusive with :mc-cmd-option:`~mc retention clear version-id`.

   .. mc-cmd:: TARGET

      *Required* The full path to the object or objects for which to clear
      the object lock configuration. Specify the :mc-cmd:`alias <mc alias>` of a
      configured S3-compatible service as the prefix to the ``TARGET`` bucket
      path. For example:

      .. code-block:: shell

         mc retention clear play/mybucket/object.txt MODE VALIDITY

      If specifying a bucket prefix, include the 
      :mc-cmd-option:`~mc retention info recursive` flag to return the object
      lock configuration to all objects in the prefix.

Behavior
--------

Bucket Must Enable Object Locking
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:mc:`mc retention` *requires* that the specified bucket has object locking
enabled. You can **only** enable object locking at bucket creation. See
:mc-cmd-option:`mc mb with-lock` for documentation on creating buckets with
object locking enabled. 

Retention of Object Versions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For buckets with :mc:`versioning enabled <mc version>`, :mc:`mc retention` by
default operates on the *latest* version of the target object or object(s). 

- Use the :mc-cmd-option:`mc retention set versions`,
  :mc-cmd-option:`mc retention info versions`, or
  :mc-cmd-option:`mc retention clear versions` to target 
  all versions of an object or object(s).

- Use the :mc-cmd-option:`mc retention set version-id`,
  :mc-cmd-option:`mc retention info version-id`, or
  :mc-cmd-option:`mc retention clear version-id` to target a specific
  version of an object.

Interaction with Legal Holds
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enabling a legal hold on an object prevents any modification or deletion of that
object, similar to the :mc-cmd:`COMPLIANCE <mc retention set MODE>` object
locking mode. Legal holds are independent of object lock settings - an object
can have both a legal hold *and* object locking enabled at the same time.
*However*, the legal hold *overrides* the object lock settings. That is,
regardless of the object lock settings, the legal hold prevents any object
modification or deletion until the hold is explicitly lifted. Setting,
modifying, or clearing object lock settings for an object under legal hold has
no effect until the legal hold either expires or is explicitly disabled.

For more information on object legal holds, see :mc-cmd:`mc legalhold`.

Examples
--------

Set Bucket Object Lock Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

This example assumes that the specified bucket has object locking enabled. 
See :mc-cmd-option:`mc mb with-lock` for more information on creating buckets
with object locking enabled.

.. code-block:: shell
   :class: copyable

   mc retention --recursive --default set play/mybucket/ governance 30d

Set Object Lock Configuration for Specific Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

This example assumes that the specified bucket has object locking enabled. 
See :mc-cmd-option:`mc mb with-lock` for more information on creating buckets
with object locking enabled.

.. code-block:: shell
   :class: copyable

   mc retention set play/mybucket/data.csv governance 30d

Set Object Lock Configuration for Versioned Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

This example assumes that the specified bucket has object locking enabled. 
See :mc-cmd-option:`mc mb with-lock` for more information on creating buckets
with object locking enabled.

For buckets with :mc:`versioning <mc version>` enabled, use the 
:mc-cmd-option:`~mc retention set versions` option to apply the object lock 
settings to all versions of the object.

.. code-block:: shell
   :class: copyable

   mc retention --versions set play/mybucket/data.csv governance 30d

Use the :mc-cmd-option:`~mc retention set version-id` option to apply the 
object lock settings to a specific version of the object.

.. code-block:: shell
   :class: copyable

   mc retention --version-id hTyrbac12.sdsd set play/mybucket/data.csv governance 30d

Retrieve Object Lock Settings for an Object or Object(s)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

This example assumes that the specified bucket has object locking enabled. 
See :mc-cmd-option:`mc mb with-lock` for more information on creating buckets
with object locking enabled.

.. code-block:: shell
   :class: copyable

   mc retention info play/mybucket/data.csv

To retrieve the object lock settings for all objects in the bucket or a bucket
prefix, include the :mc-cmd-option:`~mc retention info recursive` option:

.. code-block:: shell
   :class: copyable

   mc retention --recursive info play/mybucket

   mc retention --recursive info play/mybucket/myprefix/

Clear Object Lock Settings for an Object or Object(s)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

This example assumes that the specified bucket has object locking enabled. 
See :mc-cmd-option:`mc mb with-lock` for more information on creating buckets
with object locking enabled.

.. code-block:: shell
   :class: copyable

   mc retention clear play/mybucket/data.csv

To clear the object lock settings for all objects in the bucket or a bucket
prefix, include the :mc-cmd-option:`~mc retention info recursive` option:

.. code-block:: shell
   :class: copyable

   mc retention --recursive clear play/mybucket

   mc retention --recursive clear play/mybucket/myprefix/
