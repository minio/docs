.. _minio-mc-ilm-rule-ls:

==================
``mc ilm rule ls``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm rule list
.. mc:: mc ilm rule ls

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z

   ``mc ilm rule ls`` replaces ``mc ilm ls``.

.. versionchanged:: RELEASE.2023-05-26T23-31-54Z

   ``mc ilm rule ls --json`` output includes the policy modification time in ``updateAt``.
   
Syntax
------

.. start-mc-ilm-rule-ls-desc

The :mc:`mc ilm rule ls` command summarizes all configured object lifecycle management rules on a MinIO bucket in a tabular format.

.. end-mc-ilm-rule-ls-desc

The :mc:`mc ilm rule list` command has equivalent functionality to :mc:`mc ilm rule ls`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command lists all lifecycle management rules for the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc ilm rule ls myminio/mydata

      The output of the command might resemble the following:

      .. code-block:: shell
      
         ┌───────────────────────────────────────────────────────────────────────────────┐
         │ Transition for latest version (Transition)                                    │
         ├────────┬─────────┬────────┬─────────────────────┬──────────────┬──────────────┤
         │ ID     │ STATUS  │ PREFIX │ TAGS                │ DAYS TO TIER │ TIER         │
         ├────────┼─────────┼────────┼─────────────────────┼──────────────┼──────────────┤
         │ rule-1 │ Enabled │ doc/   │ key1=val1&key2=val2 │            0 │ WARM-MINIO-1 │
         └────────┴─────────┴────────┴─────────────────────┴──────────────┴──────────────┘
         ┌────────────────────────────────────────────────────────────────┐
         │ Transition for older versions (NoncurrentVersionTransition)    │
         ├────────┬─────────┬────────┬──────┬──────────────┬──────────────┤
         │ ID     │ STATUS  │ PREFIX │ TAGS │ DAYS TO TIER │ TIER         │
         ├────────┼─────────┼────────┼──────┼──────────────┼──────────────┤
         │ rule-2 │ Enabled │ logs/  │ -    │           10 │ WARM-MINIO-1 │
         └────────┴─────────┴────────┴──────┴──────────────┴──────────────┘
         ┌────────────────────────────────────────────────────────────────────────────────────────┐
         │ Expiration for latest version (Expiration)                                             │
         ├────────┬─────────┬────────┬─────────────────────┬────────────────┬─────────────────────┤
         │ ID     │ STATUS  │ PREFIX │ TAGS                │ DAYS TO EXPIRE │ EXPIRE DELETEMARKER │
         ├────────┼─────────┼────────┼─────────────────────┼────────────────┼─────────────────────┤
         │ rule-1 │ Enabled │ doc/   │ key1=val1&key2=val2 │             30 │ false               │
         └────────┴─────────┴────────┴─────────────────────┴────────────────┴─────────────────────┘
         ┌──────────────────────────────────────────────────────────────────────────────────┐
         │ Expiration for older versions (NoncurrentVersionExpiration)                      │
         ├────────┬─────────┬────────┬─────────────────────┬────────────────┬───────────────┤
         │ ID     │ STATUS  │ PREFIX │ TAGS                │ DAYS TO EXPIRE │ KEEP VERSIONS │
         ├────────┼─────────┼────────┼─────────────────────┼────────────────┼───────────────┤
         │ rule-1 │ Enabled │ doc/   │ key1=val1&key2=val2 │             15 │             0 │
         │ rule-2 │ Enabled │ logs/  │ -                   │              1 │             3 │
         └────────┴─────────┴────────┴─────────────────────┴────────────────┴───────────────┘

   .. tab-item:: SYNTAX

      The :mc:`mc ilm rule ls` command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] ilm rule ls     \
                          [--expiry]      \
                          [--transition]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:
   
   The :ref:`alias <alias>` and full path to the bucket on the MinIO deployment for which to list the object lifecycle management rules. 
   For example:

   .. code-block:: none

      mc ilm rule ls myminio/mydata


.. mc-cmd:: --expiry
   :optional:
   
   :mc:`mc ilm rule ls` returns only fields related to lifecycle rule expiration.

   Mutually exclusive with :mc-cmd:`~mc ilm rule ls --transition`.

.. mc-cmd:: --transition
   :optional:

   :mc:`mc ilm rule ls` returns only fields related to lifecycle rule transition.

   Mutually exclusive with :mc-cmd:`~mc ilm rule ls --expiry`.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

List Bucket Lifecycle Management Rules
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc ilm rule ls` to list a bucket's lifecycle management rules:

.. code-block:: shell
   :class: copyable

   mc ilm rule ls ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc ilm rule ls ALIAS>` with the :mc:`alias <mc alias>` of the S3-compatible host.

- Replace ``PATH`` with the path to the bucket on the S3-compatible host.

Show Policy Modification Time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc ilm rule ls` with :std:option:`--json <mc.--json>` to show the time the policy for a bucket was last updated.

.. code-block:: shell
   :class: copyable

   mc ilm rule ls ALIAS/PATH --json

- Replace :mc-cmd:`ALIAS <mc ilm rule ls ALIAS>` with the :mc:`alias <mc alias>` of the S3-compatible host.

- Replace ``PATH`` with the path to the bucket on the S3-compatible host.

The ``updateAt`` property in the JSON output contains the date and time the policy was updated.

The output resembles the following:

.. code-block:: shell

   {
    "status": "success",
    "target": "myminio/mybucket",
    "config": {
     "Rules": [
      {
       "Expiration": {
        "Days": 30
       },
       "ID": "ci1o2mg0sko6f1r3krv0",
       "Status": "Enabled"
      }
     ]
    },
    "updatedAt": "2023-06-09T19:45:30Z"
   }



Required Permissions
--------------------

For permissions required to list rules, refer to the :ref:`required permissions <minio-mc-ilm-rule-permissions>` on the parent command.


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
