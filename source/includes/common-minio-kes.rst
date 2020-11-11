.. start-kes-insecure

Directs the command skip x.509 certificate validation during the TLS 
handshake with the KES server. This allows connections to KES servers
using untrusted certificates (i.e. self-signed or issued by an unknown 
Certificate Authority).

MinIO strongly recommends *against* using this option in production
environments.

.. end-kes-insecure