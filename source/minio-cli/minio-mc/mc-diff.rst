===========
``mc diff``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc diff

Description
-----------

.. start-mc-diff-desc

The :mc:`mc diff` mc computes the differences between two filesystem directories
or S3-compatible buckets. :mc:`mc diff` lists only those objects which are
missing or which differ in size. :mc:`mc diff` does **not** compare the contents
of objects.

.. end-mc-diff-desc

Syntax
------

:mc:`~mc diff` has the following syntax:

.. code-block:: shell

   mc diff FIRST SECOND

:mc:`~mc diff` supports the following arguments:

.. mc-cmd:: FIRST

   The path to a filesystem directory or S3-compatible bucket.

.. mc-cmd:: SECOND

   The path to a filesystem directory or S3-compatible bucket.

Behavior
--------

:mc:`mc diff` uses the following legend when formatting the diff output:

.. code-block:: none
   
   FIRST < SECOND - object exists only in FIRST 
   FIRST > SECOND - object exists only in SECOND 
   FIRST ! SECOND - Newer object exists in FIRST

Examples
--------

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc diff play/bucket1 play/bucket2