.. Used in the following pages:
   - /monitoring/bucket-notifications/publish-events-to-amqp.rst

.. Used in the following pages:

   /reference/minio-cli/minio-mc/mc-rm.rst
   /reference/minio-cli/minio-mc/mc-mv.rst
   /reference/minio-cli/minio-mc/mc-mirror.rst

.. start-remove-api-trims-prefixes

|command| relies on the :mc:`mc` removal API for deleting objects. As part of
removing the last object in a bucket prefix, :mc:`mc` also recursively removes
each empty part of the prefix up to the bucket root. :mc:`mc` only applies the
recursive removal to prefixes created *implicitly* as part of object write
operations - that is, the prefix was not created using an explicit directory
creation command such as :mc:`mc mb`.

For example, consider a bucket ``photos`` with the following object prefixes:

- ``photos/2021/january/myphoto.jpg``
- ``photos/2021/february/myotherphoto.jpg``
- ``photos/NYE21/NewYears.jpg``

``photos/NYE21`` is the *only* prefix explicitly created using :mc:`mc mb`.
All other prefixes were *implicitly* created as part of writing the object
located at that prefix. 

If an :mc:`mc` command removes ``myphoto.jpg``, the removal API automatically
trims the empty ``/january`` prefix. If a subsequent :mc:`mc` command removes
``myotherphoto.jpg``, the removal API automatically trims both the ``/february``
prefix *and* the now-empty ``/2021`` prefix. If an :mc:`mc` command removes
``NewYears.jpg``, the ``/NYE21`` prefix remains in place since it was
*explicitly* created.

.. end-remove-api-trims-prefixes

.. Following is linked topically to the remove-api-trims-prefixes core

.. start-remove-api-trims-prefixes-fs

If using |command| for operations on a filesystem, :mc:`mc` applies this same
behavior by recursively trimming empty directory paths up to the root. However,
the :mc:`mc` remove API cannot distinguish between an explicitly created
directory path and an implicitly created one. If |command| deletes the last
object at a filesystem path, :mc:`mc` recursively deletes all empty directories
within that path up to the root as part of the removal operation.

.. end-remove-api-trims-prefixes-fs