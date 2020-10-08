===========
``mc lock``
===========

.. default-domain:: minio

.. mc:: mc lock

Description
-----------

.. start-mc-lock-desc

The :mc:`mc lock` command sets or gets the bucket default object lock
configuration. Object locking enables Write-Once Read-Many (WORM)
object retention for a configurable period of time.

.. end-mc-lock-desc

.. admonition:: DEPRECATED
   :class: important

   :mc:`mc lock` was deprecated in :release:`RELEASE.2020-09-18T00-13-21Z`. Use
   :mc:`mc retention` to set, retrieve, or clear the bucket default object lock
   configuration.

   For older versions of :program:`mc`, use ``mc lock --help`` for usage.