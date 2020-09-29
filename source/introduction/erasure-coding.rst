.. _minio-erasure-coding:

==============
Erasure Coding
==============

.. default-domain:: minio

MinIO protects data with per-object, inline erasure coding, which is written in
assembly code to deliver the highest performance possible. MinIO uses
Reed-Solomon code to stripe objects into `n/2` data and ``n/2`` parity blocks -
although these can be configured to any desired redundancy level.

This means that in a 12 drive setup, an object is sharded across as 6 data and 6
parity blocks. Even if you lose as many as 5 ((n/2)–1) drives, be it parity or
data, you can still reconstruct the data reliably from the remaining drives.
MinIO's implementation ensures that objects can be read or new objects are
written even if multiple devices are lost or unavailable. Finally, MinIO's
erasure code is at the object level and can heal one object at a time.