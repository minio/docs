=========
``mc rb``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc rb

Description
-----------

.. start-mc-rb-desc

The :mc:`mc rb` command removes a bucket and all its contents on the target
S3-compatible service.

Removing a bucket with :mc:`mc rb` also removes any configurations associated to
that bucket. To remove only the contents of a bucket, use :mc:`mc rb` instead.

.. end-mc-rb-desc

Syntax
------

:mc:`~mc rb` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc rb [FLAGS] SOURCE TARGET

.. mc-cmd:: force
   :option:

   Allows running :mc:`mc rb` on a bucket with versioning enabled.

.. mc-cmd:: dangerous
   :option:
   
   Allows running :mc:`mc rb` when the :mc-cmd:`~mc rb TARGET` specifies the
   root (all buckets) on the S3-compatible service.

Behavior
--------

Examples
--------

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell

   mc rb play/mybucket