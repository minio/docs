=============================
Encryption and Key Management
=============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO supports key security features around object-level and network-level
encryption:

Server-Side Object Encryption
-----------------------------

MinIO supports :ref:`Server-Side Object Encryption (SSE) <minio-sse>` of
objects, where MinIO uses a secret key to encrypt and store objects on disk.
Only clients with access to the correct secret key can decrypt and read the
object.

<Diagram to follow>

See :ref:`Server-Side Object Encryption (SSE) <minio-sse>` for more complete
instructions on configuring MinIO for object encryption.

Transport Layer Security (TLS)
------------------------------

MinIO supports :ref:`Transport Layer Security (TLS) <minio-TLS>` encryption of
incoming and outgoing traffic. 

<Diagram to Follow>

TLS is the successor to Secure Socket Layer (SSL) encryption. SSL is fully
`deprecated <https://tools.ietf.org/html/rfc7568>`__ as of June 30th, 2018. 
MinIO uses only supported (non-deprecated) TLS protocols (TLS 1.2 and later).

See :ref:`Transport Layer Security (TLS) <minio-TLS>`
for more complete instructions on configuring MinIO for TLS.

.. toctree::
   :titlesonly:
   :hidden:

   /security/encryption/server-side-encryption
   /security/encryption/transport-layer-security
   /security/encryption/minio-kes
   /security/encryption/sse-s3-thales
