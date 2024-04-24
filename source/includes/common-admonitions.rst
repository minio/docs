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

.. The following exclusive access admonition is used on a number of pages:
   - administration/object-management.rst
   - administration/concepts.rst
   - operations/concepts.rst
   - operations/data-recovery.rst
   - operations/checklists/hardware.rst
   - operations/checklists/software.rst
   - operations/concepts/availability-and-resiliency.rst
   - operations/concepts/erasure-coding.rst
   - operations/data-recover/recover-after-drive-failure.rst
   - operations/data-recover/recover-after-node-failure.rst
   - operations/install-deploy-manage/deploy-minio-multi-node-multi-drive.rst
   - operations/install-deploy-manage/deploy-minio-single-node-multi-drive.rst
   - operations/install-deploy-manage/deploy-minio-single-node-single-drive.rst
   - operations/install-deploy-manage/deploy-minio-tenant.rst
   - operations/install-deploy-manage/expand-minio-deployment.rst
   - operations/install-deploy-manage/expand-minio-tenant.rst
   - glossary.rst

.. start-exclusive-drive-access

.. admonition:: Exclusive access to drives
   :class: warning

   MinIO **requires** *exclusive* access to the drives or volumes provided for object storage.
   No other processes, software, scripts, or human interactions should perform any actions directly on the drives or volumes provided to MinIO or the objects or files MinIO places on them.
   
   Unless directed by MinIO Engineering, do not use scripts or non-S3 tools to modify, delete, or move any of the data shards, parity shards, or metadata files on the provided drives, including from one drive or node to another.
   Such operations can easily result in widespread corruption and loss of data beyond MinIO's ability to heal.

.. end-exclusive-drive-access