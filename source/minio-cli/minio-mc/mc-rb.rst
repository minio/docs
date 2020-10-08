=========
``mc rb``
=========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc rb

Description
-----------

.. start-mc-rb-desc

The :mc:`mc rb` command removes a bucket and all its contents on the target
S3-compatible service.

Removing a bucket with :mc:`mc rb` also removes any configurations associated to
that bucket. To remove only the contents of a bucket, use :mc:`mc rm` instead.

.. end-mc-rb-desc

Example
-------

Remove a Bucket
~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc rb ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc rb TARGET>` with the :mc-cmd:`alias <mc alias>` of
  a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc rb TARGET>` with the path to the bucket to remove.

Syntax
------

:mc:`~mc rb` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc rb [FLAGS] TARGET [TARGET...]

.. mc-cmd:: TARGET

   *REQUIRED*

   The full path to the bucket to remove. Specify ``TARGET`` as
   ``ALIAS/PATH``, where:

   - ``ALIAS`` is the :mc:`alias <mc alias>` of a configured S3-compatible
     host, *and*

   - ``PATH`` is the path to the bucket.

.. mc-cmd:: force
   :option:

   Allows running :mc:`mc rb` on a bucket with versioning enabled.

.. mc-cmd:: dangerous
   :option:
   
   Allows running :mc:`mc rb` when the :mc-cmd:`~mc rb TARGET` specifies the
   root (all buckets) on the S3-compatible service.
