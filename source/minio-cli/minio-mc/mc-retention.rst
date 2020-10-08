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

.. note::

   Starting in version :release:`RELEASE.2020-09-18T00-13-21Z`, 
   :mc:`mc retention` fully replaces :mc:`mc lock` for setting the default 
   object lock settings for a bucket.

   Use :mc-cmd:`mc retention set` with the 
   :mc-cmd-option:`~mc retention set default` option to set the default
   object lock settings for a bucket.

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

.. list-table::
   :header-rows: 1
   :widths: 50 50
   :width: 100%

   * - Operate on Multiple Versions
     - Operate on Single Version

   * - | :mc-cmd-option:`mc retention set versions`
       | :mc-cmd-option:`mc retention clear versions`
       | :mc-cmd-option:`mc retention info versions`

     - | :mc-cmd-option:`mc retention set version-id`
       | :mc-cmd-option:`mc retention clear version-id`
       | :mc-cmd-option:`mc retention info version-id`

Interaction with Legal Holds
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Locking an object prevents any modification or deletion of that
object, similar to the :mc-cmd:`COMPLIANCE <mc retention set MODE>` object
locking mode. Objects can have simultaneous retention-based locks *and*
legal hold locks. 

The legal hold lock *overrides* any retention locking, such that an object under
legal hold remains locked *even if* the retention period expires. Setting,
modifying, or clearing retention settings for an object under legal hold has no
effect until the legal hold either expires or is explicitly disabled.

For more information on object legal holds, see :mc-cmd:`mc legalhold`.

Examples
--------

Set Default Bucket Retention Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc retention set` with the
:mc-cmd-option:`~mc retention set recursive` and
:mc-cmd-option:`~mc retention set default` to set the default bucket
retention settings.

.. code-block:: shell
   :class: copyable

   mc retention --recursive --default set ALIAS/PATH MODE DURATION

- Replace :mc-cmd:`ALIAS <mc retention set TARGET>` with the
  :mc:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc retention set TARGET>` with the path to the bucket.

- Replace :mc-cmd:`MODE <mc retention set MODE>` with the retention mode to
  enable. MinIO supports the AWS S3 retention modes ``governance`` and
  ``compliance``.

- Replace :mc-cmd:`DURATION <mc retention set VALIDITY>` with the duration which
  the object lock should remain in effect. For example, to set a retention
  period of 30 days, specify ``30d``

.. include:: /includes/facts-locking.rst
   :start-after: start-command-requires-locking-desc
   :end-before: end-command-requires-locking-desc

Set Object Lock Configuration for Versioned Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tabs::

   .. tab:: Specific Version

      Use :mc-cmd:`mc retention set` with
      :mc-cmd-option:`~mc retention set version-id` to apply the retention
      settings to a specific object version:

      .. code-block:: shell
         :class: copyable

         mc retention set --version-id VERSION ALIAS/PATH MODE DURATION

      - Replace :mc-cmd:`VERSION <mc retention set version-id>` with the version
        of the object.

      - Replace :mc-cmd:`ALIAS <mc retention set TARGET>` with the
        :mc:`alias <mc alias>` of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc retention set TARGET>` with the path to the object.

      - Replace :mc-cmd:`MODE <mc retention set MODE>` with the retention mode
        to enable. MinIO supports the AWS S3 retention modes ``governance`` and
        ``compliance``.

      - Replace :mc-cmd:`DURATION <mc retention set VALIDITY>` with the duration
        which the object lock should remain in effect. For example, to set a
        retention period of 30 days, specify ``30d``

   .. tab:: All Versions

      Use :mc-cmd:`mc retention set` with
      :mc-cmd-option:`~mc retention set versions` to apply the retention
      settings to a specific object version:

      .. code-block:: shell
         :class: copyable

         mc retention set --versions ALIAS/PATH MODE DURATION

      - Replace :mc-cmd:`ALIAS <mc retention set TARGET>` with the
        :mc:`alias <mc alias>` of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc retention set TARGET>` with the path to the object.

      - Replace :mc-cmd:`MODE <mc retention set MODE>` with the retention mode
        to enable. MinIO supports the AWS S3 retention modes ``governance`` and
        ``compliance``.

      - Replace :mc-cmd:`DURATION <mc retention set VALIDITY>` with the duration
        which the object lock should remain in effect. For example, to set a
        retention period of 30 days, specify ``30d``


.. include:: /includes/facts-locking.rst
   :start-after: start-command-requires-locking-desc
   :end-before: end-command-requires-locking-desc

Retrieve Object Lock Settings for an Object or Object(s)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tabs::

   .. tab:: Specific Object

      .. code-block:: shell
         :class: copyable

         mc retention info ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc retention info TARGET>` with the
        :mc:`alias <mc alias>` of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc retention info TARGET>` with the path to the
        object.

   .. tab:: Multiple Objects

      Use :mc-cmd:`mc retention info` with
      :mc-cmd-option:`~mc retention info recursive` to retrieve the retention
      settings for all objects in a bucket:

      .. code-block:: shell
         :class: copyable

         mc retention infoset --recursive ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc retention info TARGET>` with the
        :mc:`alias <mc alias>` of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc retention info TARGET>` with the path to the 
        bucket.


.. include:: /includes/facts-locking.rst
   :start-after: start-command-requires-locking-desc
   :end-before: end-command-requires-locking-desc

Clear Object Lock Settings for an Object or Object(s)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tabs::

   .. tab:: Specific Object

      .. code-block:: shell
         :class: copyable

         mc retention clear ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc retention clear TARGET>` with the
        :mc:`alias <mc alias>` of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc retention clear TARGET>` with the path to the
        object.


   .. tab:: Multiple Objects

      Use :mc-cmd:`mc retention clear` with
      :mc-cmd-option:`~mc retention clear recursive` to clear the retention
      settings from all objects in a bucket:

      .. code-block:: shell
         :class: copyable

         mc retention clear --recursive ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc retention clear TARGET>` with the
        :mc:`alias <mc alias>` of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc retention clear TARGET>` with the path to the 
        bucket.


.. include:: /includes/facts-locking.rst
   :start-after: start-command-requires-locking-desc
   :end-before: end-command-requires-locking-desc

Syntax
------

.. replacements for mc retention set

.. |command| replace:: :mc-cmd:`mc retention set`
.. |rewind| replace:: :mc-cmd-option:`~mc retention set rewind`
.. |versionid| replace:: :mc-cmd-option:`~mc retention set version-id`
.. |alias| replace:: :mc-cmd-option:`~mc retention set TARGET`
.. |versions| replace:: :mc-cmd-option:`~mc retention set versions`

.. mc-cmd:: set
   :fullpath:

   Sets the object lock settings for the specified
   :mc-cmd:`~mc retention set TARGET` object.

   :mc-cmd:`mc retention set` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc retention set [FLAGS] TARGET MODE VALIDITY

   :mc-cmd:`mc retention set` supports the following arguments:

   .. mc-cmd:: TARGET

      *Required* 
      
      The full path to the object or objects for which to set object lock
      configuration. Specify the :mc-cmd:`alias <mc alias>` of a configured
      S3-compatible service as the prefix to the ``TARGET`` bucket path. For
      example:

      .. code-block:: shell

         mc retention play/mybucket/object.txt MODE VALIDITY

      - If the ``TARGET`` specifies a bucket or bucket prefix, include
        :mc-cmd-option:`~mc retention set recursive` to apply the object lock
        settings to the bucket contents.

      - If the ``TARGET`` bucket has versioning enabled, 
        :mc-cmd:`mc retention set`
        by default applies to only the latest object version. Use
        :mc-cmd-option:`~mc retention set version-id` or
        :mc-cmd-option:`~mc retention set versions` to apply the object lock
        settings to a specific version or to all versions of the object.

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
      
      If specifying :mc-cmd-option:`~mc retention set default`, 
      :mc-cmd:`mc retention set` ignores all other flags.

      Starting in :release:`RELEASE.2020-09-18T00-13-21Z`, 
      :mc-cmd-option:`mc retention set default` replaces the functionality of
      the deprecated :mc-cmd:`mc lock` command.

   .. mc-cmd:: rewind
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-rewind-desc
         :end-before: end-rewind-desc

   .. mc-cmd:: version-id, vid
      :option:
   
      .. include:: /includes/facts-versioning.rst
         :start-after: start-version-id-desc
         :end-before: end-version-id-desc

      Mutually exclusive with any of the following flags:
      
      - :mc-cmd-option:`~mc retention set versions`
      - :mc-cmd-option:`~mc retention set rewind`
      - :mc-cmd-option:`~mc retention set recursive`

   .. mc-cmd:: versions
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-versions-desc
         :end-before: end-versions-desc

      Use :mc-cmd-option:`~mc retention set versions` and
      :mc-cmd-option:`~mc retention set rewind` together to apply the
      retention settings to all object versions that existed at a
      specific point-in-time.

.. |command-2| replace:: :mc-cmd:`mc retention info`
.. |rewind-2| replace:: :mc-cmd-option:`~mc retention info rewind`
.. |versionid-2| replace:: :mc-cmd-option:`~mc retention info version-id`
.. |versions-2| replace:: :mc-cmd-option:`~mc retention info versions`
.. |alias-2| replace:: :mc-cmd-option:`~mc retention info TARGET`

.. mc-cmd:: info
   :fullpath:

   Returns the current object lock setting for the specified 
   :mc-cmd:`~mc retention info TARGET`. 

   :mc-cmd:`mc retention info` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc retention info [ARGUMENTS] TARGET

   :mc-cmd:`mc retention info` supports the following arguments:

   .. mc-cmd:: TARGET

      *Required* 
      
      The full path to the object for which to retreive
      the object lock configuration. Specify the :mc-cmd:`alias <mc alias>` of a
      configured S3-compatible service as the prefix to the ``TARGET`` bucket
      path. For example:

      .. code-block:: shell

         mc retention info play/mybucket/object.txt

      - If the ``TARGET`` specifies a bucket or bucket prefix, include 
        :mc-cmd-option:`~mc retention info recursive` to return the object
        lock settings for all objects in the bucket or bucket prefix.

      - If the ``TARGET`` bucket has versioning enabled, 
        :mc-cmd:`mc retention info` by default applies to only the latest object
        version. Use :mc-cmd-option:`~mc retention info version-id` or
        :mc-cmd-option:`~mc retention info versions` to return the object lock
        settings for a specific version or for all versions of the object.

   .. mc-cmd:: recursive, r
      :option:

      Recursively returns the object lock settings for all objects in the
      specified :mc-cmd:`~mc retention info TARGET` path.

      Mutually exclusive with :mc-cmd-option:`~mc retention info version-id`.

   .. mc-cmd:: default
      :option:

      Returns the default object lock settings for the bucket specified to
      :mc-cmd:`~mc retention info TARGET`.

      If specifying :mc-cmd-option:`~mc retention info default`, 
      :mc-cmd:`mc retention info` ignores all other flags.

      Starting in :release:`RELEASE.2020-09-18T00-13-21Z`, 
      :mc-cmd-option:`mc retention info default` replaces the functionality of
      the deprecated :mc-cmd:`mc lock` command.

   .. mc-cmd:: rewind
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-rewind-desc-2
         :end-before: end-rewind-desc-2

   .. mc-cmd:: version-id, vid
      :option:
   
      .. include:: /includes/facts-versioning.rst
         :start-after: start-version-id-desc-2
         :end-before: end-version-id-desc-2

      Mutually exclusive with any of the following flags:
      
      - :mc-cmd-option:`~mc retention info versions`
      - :mc-cmd-option:`~mc retention info rewind`
      - :mc-cmd-option:`~mc retention info recursive`

   .. mc-cmd:: versions
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-versions-desc-2
         :end-before: end-versions-desc-2

      Use :mc-cmd-option:`~mc retention info versions` and
      :mc-cmd-option:`~mc retention info rewind` together to retrieve the
      retention settings for all object versions that existed at a
      specific point-in-time.

.. |command-3| replace:: :mc-cmd:`mc retention clear`
.. |rewind-3| replace:: :mc-cmd-option:`~mc retention clear rewind`
.. |versionid-3| replace:: :mc-cmd-option:`~mc retention clear version-id`
.. |versions-3| replace:: :mc-cmd-option:`~mc retention clear versions`
.. |alias-3| replace:: :mc-cmd-option:`~mc retention clear TARGET`

.. mc-cmd:: clear
   :fullpath:

   Clears the object lock setting for the specified ``TARGET``. 

   :mc-cmd:`mc retention clear` has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc retention clear [ARGUMENTS] TARGET

   :mc-cmd:`mc retention clear` supports the following arguments:

   .. mc-cmd:: TARGET

      *Required* The full path to the object or objects for which to clear
      the object lock configuration. Specify the :mc-cmd:`alias <mc alias>` of a
      configured S3-compatible service as the prefix to the ``TARGET`` bucket
      path. For example:

      .. code-block:: shell

         mc retention clear play/mybucket/object.txt

      - If the ``TARGET`` specifies a bucket or bucket prefix, include
        :mc-cmd-option:`~mc retention clear recursive` to clear the object lock
        settings to the bucket contents.

      - If the ``TARGET`` bucket has versioning enabled,
        :mc-cmd:`mc retention clear` by default applies to only the latest
        object version. Use :mc-cmd-option:`~mc retention clear version-id` or
        :mc-cmd-option:`~mc retention clear versions` to clear the object lock
        settings for a specific version or for all versions of the object.

   .. mc-cmd:: recursive, r
      :option:

      Recursively clears the object lock settings for all objects in the
      specified :mc-cmd:`~mc retention clear TARGET` path.

      Mutually exclusive with :mc-cmd-option:`~mc retention clear version-id`.

   .. mc-cmd:: default
      :option:

      Clears the default object lock settings for the bucket specified to
      :mc-cmd:`~mc retention clear TARGET`.
      
      If specifying :mc-cmd-option:`~mc retention clear default`, 
      :mc-cmd:`mc retention clear` ignores all other flags.

      Starting in :release:`RELEASE.2020-09-18T00-13-21Z`, 
      :mc-cmd-option:`mc retention clear default` replaces the functionality of
      the deprecated :mc-cmd:`mc lock` command.

   .. mc-cmd:: rewind
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-rewind-desc-3
         :end-before: end-rewind-desc-3

   .. mc-cmd:: version-id, vid
      :option:
   
      .. include:: /includes/facts-versioning.rst
         :start-after: start-version-id-desc-3
         :end-before: end-version-id-desc-3

      Mutually exclusive with any of the following flags:
      
      - :mc-cmd-option:`~mc retention clear versions`
      - :mc-cmd-option:`~mc retention clear rewind`
      - :mc-cmd-option:`~mc retention clear recursive`

   .. mc-cmd:: versions
      :option:

      .. include:: /includes/facts-versioning.rst
         :start-after: start-versions-desc-3
         :end-before: end-versions-desc-3

      Use :mc-cmd-option:`~mc retention clear versions` and
      :mc-cmd-option:`~mc retention clear rewind` together to remove the
      retention settings from all object versions that existed at a
      specific point-in-time.




