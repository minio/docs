#. Review the Tenant CRD

   Review the :ref:`Tenant CRD <minio-operator-crd>` ``TenantSpec.kes`` object, the ``TenantSpec.configuration`` object, and the :minio-docs:`KES Configuration reference</kes/tutorials/configuration>`.

   You must prepare all necessary configurations associated to your external Key Management Service of choice before proceeding.

#. Create or Modify your Tenant YAML to set the values of ``KesConfig`` as necessary:

   You must modify your Tenant YAML or ``Kustomize`` templates to reflect the necessary KES configuration.
   The following example is taken from the :minio-git:`MinIO Operator Kustomize examples </operator/blob/master/examples/kustomization/tenant-kes-encryption/tenant.yaml>`

   .. code-block:: yaml

      kes:
         image: "" # minio/kes:2024-06-17T15-47-05Z
         env: [ ]
         replicas: 2
         kesSecret:
            name: kes-configuration
         imagePullPolicy: "IfNotPresent"

   The ``kes-configuration`` secret must reference a Kubernetes Opaque Secret which contains a ``stringData`` object with the full KES configuration as ``server-config.yaml``.
   The ``keystore`` field must contain the full configuration associated with your preferred Key Management System.

   Reference :minio-git:`the Kustomize example <operator/blob/master/examples/kustomization/tenant-kes-encryption/kes-configuration-secret.yaml>` for additional guidance.

#. Create or Modify your Tenant YAML to set the values of ``TenantSpec.configuration`` as necessary.

   TODO

#. Generate a New Encryption Key

   .. include:: /includes/k8s/common-minio-kes.rst
      :start-after: start-kes-generate-key-desc
      :end-before: end-kes-generate-key-desc

#. Enable SSE-KMS for a Bucket

   .. include:: /includes/k8s/common-minio-kes.rst
      :start-after: start-kes-enable-sse-kms-desc
      :end-before: end-kes-enable-sse-kms-desc
