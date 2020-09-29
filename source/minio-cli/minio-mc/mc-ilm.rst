==========
``mc ilm``
==========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc ilm

Description
-----------

.. start-mc-ilm-desc

The :mc:`mc ilm` command manages object lifecycle management
rules on a bucket. See the AWS documentation on 
:s3-docs:`Object Lifecycle Management <object-lifecycle-mgmt.html>` for more
information.

.. end-mc-ilm-desc

Syntax
------

:mc:`mc ilm` has the following syntax:

.. code-block:: shell

   mc ilm COMMAND [COMMAND FLAGS] [ARGUMENTS...]

:mc:`mc ilm` supports the following subcommands:

.. mc-cmd:: list

   Lists the current lifecycle management rules of the specified bucket. The
   subcommand has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc ilm list [FLAGS] TARGET

   The subcommand supports the following arguments:

   .. mc-cmd:: TARGET

      *Required* The full path to the bucket from which to list existing 
      lifecycle management rules. Specify the :mc-cmd:`alias <mc alias>` 
      of a configured S3 service as the prefix to the ``TARGET`` path.

      For example:

      .. code-block:: shell

         mc ilm list play/mybucket
   
   .. mc-cmd:: expiry
      :option:

      :mc-cmd:`mc ilm` returns only fields related to lifecycle rule expiration.

   .. mc-cmd:: transition
      :option:

      :mc-cmd:`mc ilm` returns only fields related to lifecycle rule transition.

   .. mc-cmd:: minimum
      :option:

      :mc-cmd:`mc ilm` returns only the following fields:
            
      - ``id``
      - ``prefix``
      - ``status``
      - ``transition set``
      - ``expiry set``

.. mc-cmd:: add

   Adds or modifies bucket lifecycle management rules. The command has
   the following syntax:

   .. code-block:: shell
      :class: copyable

      mc ilm add [FLAGS] TARGET

   .. mc-cmd:: TARGET
      
      *Required* The full path to the bucket from which to add or modify the 
      lifecycle management rule. Specify the :mc-cmd:`alias <mc alias>` 
      of a configured S3 service as the prefix to the ``TARGET`` path.

      For example:

      .. code-block:: shell

         mc ilm list play/mybucket

   .. mc-cmd:: id
      :option:

      *Required* The unique name of the rule. Specify the 
      :mc-cmd-option:`mc ilm add id` of an existing rule to modify the
      lifecycle configuration of that rule.

   .. mc-cmd:: prefix
      :option:
      
      The path to the specific subset of the :mc-cmd:`~mc ilm add TARGET` bucket
      on which to apply the lifecycle configuration rule. MinIO appends the
      :mc-cmd-option:`~mc cmd add prefix` field to the ``TARGET`` path to
      construct the full path.

      Omit to apply the rule to the entire ``TARGET`` bucket.

   .. mc-cmd:: tags
      :option:

      One or more ampersand ``&``-delimited key-value pairs describing 
      the object tags to which to apply the lifecycle configuration rule.

   .. mc-cmd:: expiry-date
      :option:

      The ISO-8601-formatted date after which MinIO removes objects 
      covered by the rule. Specifying a date that is *prior* to the
      current date marks all objects covered by the rule for removal.
            
   .. mc-cmd:: expiry-days
      :option:

      The number of days from object creation after which MinIO removes 
      objects covered by the rule. 

   .. mc-cmd:: transition-date
      :option:

      The ISO-8601-formatted date after which MinIO transitions objects 
      covered by the rule to the specified ``--storage-class``.
      Specifying a date that is *prior* to the current date marks all
      objects covered by the rule for transition.
            
   .. mc-cmd:: transition-days
      :option:

      The number of days from object creation after which MinIO
      transitions objects covered by the rule to the specified 
      ``--storage-class``.

   .. mc-cmd:: storage-class
      :option:

      The Amazon S3 storage class to transition objects covered by the 
      rule. See :s3-docs:`Transition objects using Amazon S3 Lifecycle 
      <lifecycle-transition-general-considerations.html>` for more
      information on S3 storage classes.

   .. mc-cmd:: disable
      :option:

      Disables the rule with matching :mc-cmd-option:`~mc ilm add id`.

.. mc-cmd:: remove

   Removes an existing lifecycle management rule from the bucket.  The
   command has the following syntax:

   .. code-block:: shell
      :class: copyable

       mc ilm remove [FLAGS] TARGET

   The command supports the following arguments:

   .. mc-cmd:: TARGET

      *Required* The full path to the bucket from which to remove the 
      specified lifecycle management rule. Specify the :mc-cmd:`alias
      <mc alias>` of a configured S3 service as the prefix to the
      ``TARGET`` path.

      For example:

      .. code-block:: shell

         mc ilm remove [FLAGS] play/mybucket

   .. mc-cmd:: id

      *Required* The unique name of the rule.

      Mutually exclusive with :mc-cmd-option:`mc ilm remove all`

   .. mc-cmd:: all

      *Required* Removes all rules in the bucket. Mutually exclusive with
      :mc-cmd-option:`mc ilm remove id`.

      Requires including :mc-cmd-option:`~mc ilm remove force`.

   .. mc-cmd:: force

      Required if specifying :mc-cmd-option:`~mc ilm remove all`.

.. mc-cmd:: export

   Export the JSON-formatted lifecycle configuration to ``STDOUT``. The command
   has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc ilm export TARGET

   The command supports the following arguments:

   .. mc-cmd:: TARGET

      *Required* The full path to the bucket from which to export the
      configured lifecycle management rules. Specify the
      :mc-cmd:`alias <mc alias>` of a configured S3 service as the prefix
      to the ``TARGET`` path. For example:

      .. code-block:: shell

         mc ilm export play/mybucket > play_mybucket_lifecycle_rules.json

.. mc-cmd:: import

   Import a JSON-formatted lifecycle configuration from ``STDIN``. The command
   has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc ilm import TARGET

   The command supports the following arguments:

   .. mc-cmd:: TARGET

      *Required* The full path to the bucket from which to apply the imported
      lifecycle management rules. Specify the :mc-cmd:`alias <mc alias>` of a
      configured S3 service as the prefix to the ``TARGET`` path. For example:

      .. code-block:: shell

         mc ilm import play/mybucket < play_mybucket_lifecycle_rules.json

Examples
--------

Add a Bucket Lifecycle Management Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc ilm add --id "Devices" --expiry-date "2021-01-23" play/mybucket


Remove a Bucket Lifecycle Management Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc ilm remove --id "Devices" play/mybucket