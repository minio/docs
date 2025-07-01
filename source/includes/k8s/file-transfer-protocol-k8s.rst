#. Enable SFTP for the desired Tenant:

   Use the following Kubectl command to edit the Tenant YAML configuration:

   .. code-block:: yaml

         kubectl edit tenants/my-tenant -n my-tenant-ns

   Replace ``my-tenant`` and ``my-tenant-ns`` with the desired Tenant and namespace.

      In the ``features:`` section, set the value of ``enableSFTP`` to ``true``:

      .. code-block:: yaml

         spec:
            configuration:
               name: my-tenant-env-configuration
            credsSecret:
               name: my-tenant-secret
            exposeServices:
               console: true
               minio: true
            features:
               enableSFTP: true

      Kubectl restarts MinIO to apply the change.

      You may also set ``enableSFTP`` in your `Helm chart <https://github.com/minio/operator/blob/8385948929bc95648d1be82d96f829c810519674/helm/tenant/values.yaml>`__ or `Kustomize configuration <https://github.com/minio/operator/blob/8385948929bc95648d1be82d96f829c810519674/examples/kustomization/base/tenant.yaml>`__ to enable SFTP for newly created Tenants.
	 

#. If needed, configure ingress for the SFTP port according to your local policies.

#. Validate the configuration

   The following ``kubectl get`` command uses `yq <https://github.com/mikefarah/yq/#install>`__ to display the value of ``enableSFTP``, indicating whether SFTP is enabled:

   .. code-block:: console
      :class: copyable

      kubectl get tenants/my-tenant -n my-tenant-ns -o yaml | yq '.spec.features'

   Replace ``my-tenant`` and ``my-tenant-ns`` with the desired Tenant and namespace.

   If SFTP is enabled, the output resembles the following:

   .. code-block:: console

      enableSFTP: true

#. Use your preferred SFTP client to connect to the MinIO deployment.
   You must connect as a user whose :ref:`policies <minio-policy>` allow access to the desired buckets and objects.

   The specifics of connecting to the MinIO deployment depend on your SFTP client.
   Refer to the documentation for your client.

   The following example connects to the MinIO Tenant SFTP server forwarded to the local host system, and lists the contents of a bucket named ``runner``.

         .. code-block:: console

            > sftp -P 8022 minio@localhost
            minio@localhost's password:
            Connected to localhost.
            sftp> ls runner/
            chunkdocs  testdir

The following ``kubectl get`` command uses `yq <https://github.com/mikefarah/yq/#install>`__ to display the value of ``enableSFTP``, indicating whether SFTP is enabled:

.. code-block:: console
   :class: copyable

   kubectl get tenants/my-tenant -n my-tenant-ns -o yaml | yq '.spec.features'

Replace ``my-tenant`` and ``my-tenant-ns`` with the desired Tenant and namespace.

If SFTP is enabled, the output resembles the following:

.. code-block:: console

   enableSFTP: true

