.. _minio-mc-batch-generate:

=====================
``mc batch generate``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc batch generate

.. versionchanged:: MinIO RELEASE.2022-10-08T20-11-00Z or later

Syntax
------

.. start-mc-batch-generate-desc

The :mc:`mc batch generate` command creates a basic YAML-formatted template file for the specified job type.

.. end-mc-batch-generate-desc

After MinIO creates the file, open it in your preferred text editor tool to further customize.
You can define one job task definition per batch file.

See :ref:`job types <minio-batch-job-types>` for the supported jobs you can generate.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command creates a basic YAML file for a replicate job on the ``mybucket`` bucket of the ``myminio`` alias.

      .. code-block:: shell
         :class: copyable

         mc batch generate myminio/mybucket replicate

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] batch generate \
                                TARGET   \
                                JOBTYPE

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:
   
   The :ref:`alias <alias>` used to generate the YAML template file.
   The specified ``alias`` does not restrict the deployment(s) where you can use the generated file.
   
   For example:

   .. code-block:: none

      mc batch generate myminio replicate

.. mc-cmd:: JOBTYPE
   :required:
   
   The type of job to generate a YAML document for.
   
   Currently, :mc:`mc batch` only supports the ``replicate`` job type.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Generate a ``yaml`` File for a Replicate Job Type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command generates a YAML blueprint for a replicate type batch job and names the file ``replicate`` with the ``.yaml`` extension:

.. code-block:: shell
   :class: copyable

   mc batch generate alias replicate > replicate.yaml

- Replace ``alias`` with the :mc:`alias <mc alias>` to use to generate the yaml file.

- Replace ``replicate`` with the type of job to generate a yaml file for.
 
  At the time of release, :mc:``mc batch`` only supports the ``replicate`` job type. 


S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

.. _minio-batch-job-types:

Job Types
---------

:mc:`mc batch` currently supports the following job task types:

- ``replicate``
  
  Replicate objects between two MinIO deployments.
  Provides similar functionality to :ref:`bucket replication <minio-bucket-replication>` as a batch job rather than continual scanning function.

MinIO may add more job types in the future.

``replicate``
~~~~~~~~~~~~~

Use the ``replicate`` job type to create a batch job that replicates objects from the local MinIO deployment to another MinIO location.

The YAML **must** define the source and target deployments.
Optionally, the YAML can also define flags to filter which objects replicate, send notifications for the job, or define retry attempts for the job.

For the **source deployment**

- Required information

  .. list-table::
     :widths: 25 75
     :width: 100%

     * - ``type:``
       - Must be ``minio``.
     * - ``bucket:`` 
       - The bucket on the deployment.

- Optional information

  .. list-table::
     :widths: 25 75
     :width: 100%

     * - ``prefix:`` 
       - The prefix on the object(s) that should replicate.

     * - ``endpoint:`` 
       - | Location of the source deployment, must be ``local``.

     * - ``credentials:`` 
       - The ``accesskey:`` and ``secretKey:`` or the ``sessionToken:`` that grants access to the object(s).

For the **target deployment**

- Required information

  .. list-table::
     :widths: 25 75
     :width: 100%

     * - ``type:`` 
       - Must be ``minio``.
     * - ``bucket:`` 
       - The bucket on the deployment.

- Optional information

  .. list-table::
     :widths: 25 75
     :width: 100%
  
     * - ``prefix:`` 
       - The prefix on the object(s) to replicate.

     * - ``endpoint:`` 
       - | The location of the source deployment.
         | If the location is not remote, use ``local``.

     * - ``credentials:`` 
       - The ``accesskey`` and ``secretKey`` or the ``sessionToken`` that grants access to the object(s).
    
For **filters**

.. list-table::
   :widths: 25 75
   :width: 100%

   * - ``newerThan:`` 
     - A string representing a length of time in ``#d#h#s`` format.
       
       Only objects newer than the specified length of time replicate.
       For example, ``7d``, ``24h``, ``5d12h30s`` are valid strings.
   * - ``olderThan:`` 
     - A string representing a length of time in ``#d#h#s`` format.
       
       Only objects older than the specified length of time replicate.
   * - ``createdAfter:`` 
     - A date in ``YYYY-MM-DD`` format.
  
       Only objects created after the date replicate.
   * - ``createdBefore:`` 
     - A date in ``YYYY-MM-DD`` format.
       
       Only objects created prior to the date replicate.

For **notifications**

.. list-table::
   :widths: 25 75
   :width: 100%

   * - ``endpoint:`` 
     - The predefined endpoint to send events for notifications.
   * - ``token:`` 
     - An optional :abbr:`JWT <JSON Web Token>` to access the ``endpoint``.

For **retry attempts**

If something interrupts the job, you can define how many attempts to retry the job batch.
For each retry, you can also define how long to wait between attempts.

.. list-table::
   :widths: 25 75
   :width: 100%

   * - ``attempts:`` 
     - Number of tries to complete the batch job before giving up.
   * - ``delay:`` 
     - The least amount of time to wait between each attempt.


Sample YAML
+++++++++++

.. code-block:: yaml

   replicate:
     apiVersion: v1
     # source of the objects to be replicated
     source:
       type: TYPE # valid values are "s3"
   	   bucket: BUCKET
	     prefix: PREFIX
	     # endpoint: ENDPOINT
	     # credentials:
       #   accessKey: ACCESS-KEY
       #   secretKey: SECRET-KEY
       #   sessionToken: SESSION-TOKEN # Available when rotating credentials are used

     # target where the objects must be replicated
     target:
	     type: TYPE # valid values are "s3"
	     bucket: BUCKET
	     prefix: PREFIX
	     # endpoint: ENDPOINT
	     # credentials:
       #   accessKey: ACCESS-KEY
       #   secretKey: SECRET-KEY
       #   sessionToken: SESSION-TOKEN # Available when rotating credentials are used

     # optional flags based filtering criteria
     # for all source objects
     flags:
	     filter:
	       newerThan: "7d" # match objects newer than this value (e.g. 7d10h31s)
	       olderThan: "7d" # match objects older than this value (e.g. 7d10h31s)
	       createdAfter: "date" # match objects created after "date"
	       createdBefore: "date" # match objects created before "date"

	       # tags:
         #   - key: "name"
         #     value: "pick*" # match objects with tag 'name', with all values starting with 'pick'

         ## NOTE: metadata filter not supported when "source" is non MinIO.
	       # metadata:
      	 #   - key: "content-type"
      	 #     value: "image/*" # match objects with 'content-type', with all values starting with 'image/'

	     notify:
	       endpoint: "https://notify.endpoint" # notification endpoint to receive job status events
	       token: "Bearer xxxxx" # optional authentication token for the notification endpoint

	     retry:
	       attempts: 10 # number of retries for the job before giving up
	       delay: "500ms" # least amount of delay between each retry
