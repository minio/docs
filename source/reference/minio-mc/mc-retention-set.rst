.. _minio-bucket-locking:

====================
``mc retention set``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc retention set

.. replacements for mc retention set

.. |command| replace:: :mc:`mc retention set`
.. |rewind| replace:: :mc-cmd:`~mc retention set --rewind`
.. |versionid| replace:: :mc-cmd:`~mc retention set --version-id`
.. |alias| replace:: :mc-cmd:`~mc retention set ALIAS`
.. |versions| replace:: :mc-cmd:`~mc retention set --versions`

Syntax
------

.. start-mc-retention-set-desc

The :mc:`mc retention set` command configures the
:ref:`Write-Once Read-Many (WORM) locking <minio-object-locking>` settings for
an object or object(s) in a bucket. You can also set the default object lock
settings for a bucket, where all objects without explicit object lock settings
inherit the bucket default.

.. end-mc-retention-set-desc

To lock an object under :ref:`legal hold <minio-object-locking-legalhold>`, 
use :mc:`mc legalhold set`.

:mc:`mc retention set` *requires* that the specified bucket has object locking
enabled. You can **only** enable object locking at bucket creation. See
:mc-cmd:`mc mb --with-lock` for documentation on creating buckets with
object locking enabled. 

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command sets a default 30 day 
      :ref:`GOVERNANCE <minio-object-locking-governance>` object lock on the 
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc retention set --default GOVERNANCE "30d" myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] retention set                         \
                          [--bypass]                            \
                          [--default]                           \
                          [--recursive]                         \
                          [--rewind "string"]                   \
                          [--versions]                          \
                          [--version-id "string"]*              \
                          MODE                                  \
                          "VALIDITY"                            \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

      :mc-cmd:`mc retention set --version-id` is mutually exclusive with
      multiple other parameters. See the reference documentation for more
      information.

Parameters
~~~~~~~~~~

.. mc-cmd:: MODE

   Sets the locking mode for the :mc-cmd:`~mc retention set ALIAS`. 
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

.. mc-cmd:: ALIAS

   *Required* 
   
   The full path to the object or objects for which to set object lock
   configuration. Specify the :ref:`alias <alias>` for the MinIO or
   S3-compatible service and the full path to bucket. For
   example:

   .. code-block:: shell

      mc retention set play/mybucket/object.txt MODE VALIDITY

   - If the ``ALIAS`` specifies a bucket or bucket prefix, include
     :mc-cmd:`~mc retention set --recursive` to apply the object lock
     settings to the bucket contents.

   - :mc:`mc retention set` by default applies to only the latest object
     version. Use :mc-cmd:`~mc retention set --version-id` or
     :mc-cmd:`~mc retention set --versions` to apply the object lock
     settings to a specific version or to all versions of the object
     respectively.

.. mc-cmd:: --bypass
   

   *Optional* Allows a user with the ``s3:BypassGovernanceRetention`` permission
   to modify the object. Requires the ``governance`` retention 
   :mc-cmd:`~mc retention set MODE`

.. mc-cmd:: --default
   

   *Optional* Sets the default object lock settings for the bucket specified to
   :mc-cmd:`~mc retention set ALIAS` using the
   :mc-cmd:`~mc retention set MODE` and :mc-cmd:`~mc retention set VALIDITY`. 
   Any objects created in the bucket inherit the default object lock settings
   unless explicitly overriden using :mc:`mc retention set`.
   
   If specifying :mc-cmd:`~mc retention set --default`, 
   :mc:`mc retention set` ignores all other flags.

.. mc-cmd:: --recursive
   :optional:
   :alias: --r

   Recursively applies the object lock settings to all objects in the
   specified :mc-cmd:`~mc retention set ALIAS` path.

   Mutually exclusive with :mc-cmd:`~mc retention set --version-id`.

.. mc-cmd:: --rewind
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: --version-id
   :optional:
   :alias: --vid
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

   Mutually exclusive with any of the following flags:
   
   - :mc-cmd:`~mc retention set --versions`
   - :mc-cmd:`~mc retention set --rewind`
   - :mc-cmd:`~mc retention set --recursive`

.. mc-cmd:: --versions
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-versions-desc
      :end-before: end-versions-desc

   Use :mc-cmd:`~mc retention set --versions` and
   :mc-cmd:`~mc retention set --rewind` together to apply the
   retention settings to all object versions that existed at a
   specific point-in-time.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Set Default Bucket Retention Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc retention set` with the
:mc-cmd:`~mc retention set --recursive` and
:mc-cmd:`~mc retention set --default` to set the default bucket
retention settings.

.. code-block:: shell
   :class: copyable

   mc retention set  --recursive --default MODE DURATION ALIAS/PATH

- Replace :mc-cmd:`MODE <mc retention set MODE>` with the retention mode to
  enable. MinIO supports the AWS S3 retention modes ``governance`` and
  ``compliance``.

- Replace :mc-cmd:`DURATION <mc retention set VALIDITY>` with the duration which
  the object lock should remain in effect. For example, to set a retention
  period of 30 days, specify ``30d``.

- Replace :mc-cmd:`ALIAS <mc retention set ALIAS>` with the
  :mc:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc retention set ALIAS>` with the path to the bucket.

.. include:: /includes/facts-locking.rst
   :start-after: start-command-requires-locking-desc
   :end-before: end-command-requires-locking-desc

Set Object Lock Configuration for Versioned Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Specific Version

      Use :mc:`mc retention set` with
      :mc-cmd:`~mc retention set --version-id` to apply the retention
      settings to a specific object version:

      .. code-block:: shell
         :class: copyable

         mc retention set --version-id VERSION MODE DURATION ALIAS/PATH

      - Replace :mc-cmd:`VERSION <mc retention set --version-id>` with the version
        of the object.

      - Replace :mc-cmd:`MODE <mc retention set MODE>` with the retention mode
        to enable. MinIO supports the AWS S3 retention modes ``governance`` and
        ``compliance``.

      - Replace :mc-cmd:`DURATION <mc retention set VALIDITY>` with the duration
        which the object lock should remain in effect. For example, to set a
        retention period of 30 days, specify ``30d``.

      - Replace :mc-cmd:`ALIAS <mc retention set ALIAS>` with the
        :mc:`alias <mc alias>` of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc retention set ALIAS>` with the path to the
        object.

   .. tab-item:: All Versions

      Use :mc:`mc retention set` with
      :mc-cmd:`~mc retention set --versions` to apply the retention
      settings to a specific object version:

      .. code-block:: shell
         :class: copyable

         mc retention set --versions  MODE DURATION ALIAS/PATH

      - Replace :mc-cmd:`MODE <mc retention set MODE>` with the retention mode
        to enable. MinIO supports the AWS S3 retention modes ``governance`` and
        ``compliance``.

      - Replace :mc-cmd:`DURATION <mc retention set VALIDITY>` with the duration
        which the object lock should remain in effect. For example, to set a
        retention period of 30 days, specify ``30d``.


      - Replace :mc-cmd:`ALIAS <mc retention set ALIAS>` with the
        :mc:`alias <mc alias>` of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc retention set ALIAS>` with the path to the
        object.


.. include:: /includes/facts-locking.rst
   :start-after: start-command-requires-locking-desc
   :end-before: end-command-requires-locking-desc

Behavior
--------

Retention of Object Versions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For buckets with :mc:`versioning enabled <mc version>`, :mc:`mc retention set`
by default operates on the *latest* version of the target object or object(s).
:mc:`mc retention set` includes specific options that when *explicitly*
specified direct the command to operate on either a specific object version *or*
all versions of an object:

.. tab-set::

   .. tab-item:: Specific Object Version

      To direct :mc:`mc retention set` to operate on a specific version of an
      object, include the ``--version-id`` argument:
      
      - :mc-cmd:`mc retention set --version-id`
      - :mc-cmd:`mc retention set --version-id`
      - :mc-cmd:`mc retention set --version-id`

   .. tab-item:: All Object Versions

      To direct :mc:`mc retention set` to operate on *all* versions of an object, 
      include the ``--versions`` argument:

      - :mc-cmd:`mc retention set --versions`
      - :mc-cmd:`mc retention set --versions`
      - :mc-cmd:`mc retention set --versions`

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

For more information on object legal holds, see :mc:`mc legalhold`.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
