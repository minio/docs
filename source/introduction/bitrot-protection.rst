.. _minio-bitrot-protection:

=================
Bitrot Protection
=================

Silent data corruption or bitrot is a serious problem faced by disk drives
resulting in data getting corrupted without the user’s knowledge. The reasons
are manifold (ageing drives, current spikes, bugs in disk firmware, phantom
writes, misdirected reads/writes, driver errors, accidental overwrites) but the
result is the same - compromised data.

MinIO’s optimized implementation of the HighwayHash algorithm ensures that it
will never read corrupted data - it captures and heals corrupted objects on the
fly. Integrity is ensured from end to end by computing a hash on READ and
verifying it on WRITE from the application, across the network and to the
memory/drive. The implementation is designed for speed and can achieve hashing
speeds over 10 GB/sec on a single core on Intel CPUs.