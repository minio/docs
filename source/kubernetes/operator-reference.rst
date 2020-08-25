========================
MinIO Operator Reference
========================

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 2

This document explains the various fields supported by MinIO Operator and its
CRD's and how to use these fields to deploy and access MinIO server clusters.

MinIO Operator creates native Kubernetes resources within the cluster. The 
operator uses the name of the created MinIO Instance as a prefix for 
all resources created by the operator. For example, if deploying a 
MinIO instance named ``minioinstance``, the operator creates the following
resources with their associated names:

- Headless Service: ``minioinstance-hl-svc``
- StatefulSet: ``minioinstance``
- Secret: ``minioinstance-tls`` (If :kubeconf:`spec.requestAutoCert` is enabled)
- CertificateSigningRequest: ``minioinstance-csr`` (If :kubeconf:`spec.requestAutoCert` is enabled)

The MinIO Kubernetes Operator is under active development. More complete
documentation on the MinIO operator is in progress. 

For examples of using the operator, see
:minio-git:`github.com/minio/operator/examples <operator/tree/master/examples>`.

For examples of using the operator with ``kustomize``, see
:minio-git:`github.com/minio/operator/operator-kustomize
<operator/tree/master/operator-kustomize>`.


