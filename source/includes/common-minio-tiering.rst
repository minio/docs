.. start-create-transition-rule-desc

Use the :mc-cmd:`mc ilm add` command to create a new transition rule
for the bucket. The following example configures transition after the
specified number of calendar days:

.. code-block:: shell
   :class: copyable

   mc ilm add ALIAS/BUCKET \
   --storage-class TIERNAME \
   --transition-days DAYS \
   --noncurrentversion-transition-days NONCURRENT_DAYS
   --noncurrentversion-transition-storage-class TIERNAME

The example above specifies the following arguments:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Argument
     - Description

   * - :mc-cmd:`ALIAS <mc ilm add TARGET>`
     - Specify the :mc:`alias <mc alias>` of the MinIO deployment for which
       you are creating the lifecycle management rule.

   * - :mc-cmd:`BUCKET <mc ilm add TARGET>`
     - Specify the full path to the bucket for which you are
       creating the lifecycle management rule.

   * - :mc-cmd:`TIERNAME <mc ilm add storage-class>`
     - The remote storage tier to which MinIO transitions objects. 
       Specify the remote storage tier name created in the previous step.

       If you want to transition noncurrent object versions to a distinct
       remote tier, specify a different tier name for 
       :mc-cmd-option:`~mc ilm add noncurrentversion-transition-storage-class`.

   * - :mc-cmd:`DAYS <mc ilm add transition-days>`
     - The number of calendar days after which MinIO marks an object as 
       eligible for transition. 

   * - :mc-cmd:`NONCURRENT_DAYS <mc ilm add noncurrentversion-transition-days>`
     - The number of calendar days after which MinIO marks a noncurrent
       object version as eligible for transition. MinIO specifically measures
       the time since an object *became* non-current instead of the object
       creation time. 
       
       Omit this value to ignore noncurrent object versions.

       This option has no effect on non-versioned buckets.

     
.. end-create-transition-rule-desc

.. start-create-transition-user-desc

This step creates users and policies on the MinIO deployment for supporting
lifecycle management operations. You can skip this step if the deployment
already has users with the necessary |permissions|.

The following example uses ``Alpha`` as a placeholder :mc:`alias <mc alias>` for
the MinIO deployment. Replace this value with the appropriate alias for the
MinIO deployment on which you are configuring lifecycle management rules.
Replace the password ``LongRandomSecretKey`` with a long, random, and secure
secret key as per your organizations best practices for password generation.

.. code-block:: shell
   :class: copyable

   wget -O - https://docs.min.io/minio/baremetal/examples/LifecycleManagementAdmin.json | \
   mc admin policy add Alpha LifecycleAdminPolicy /dev/stdin
   mc admin user add Alpha alphaLifecycleAdmin LongRandomSecretKey
   mc admin policy set Alpha LifecycleAdminPolicy user=alphaLifecycleAdmin

This example assumes that the specified
aliases have the necessary permissions for creating policies and users
on the deployment. See :ref:`minio-users` and :ref:`MinIO Policy Based Access Control <minio-policy>` for more
complete documentation on MinIO users and policies respectively.

.. end-create-transition-user-desc