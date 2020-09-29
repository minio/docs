==========================
MinIO Admin (``mc admin``)
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc admin

The MinIO Client :mc-cmd:`mc` command line tool provides the :mc-cmd:`mc admin`
command for performing administrative tasks on your MinIO deployments.

While :mc-cmd:`mc` supports any S3-compatible service, 
:mc-cmd:`mc admin` *only* supports MinIO deployments.

:mc-cmd:`mc admin` has the following syntax:

.. code-block:: shell

   mc admin [FLAGS] COMMAND [ARGUMENTS]

Command Quick reference
-----------------------

The following table lists :mc-cmd:`mc admin` commands:

.. list-table::
   :header-rows: 1
   :widths: 25 75
   :width: 100%

   * - Command
     - Description

   * - :mc:`mc admin service`
     - .. include:: /minio-cli/minio-mc-admin/mc-admin-service.rst
          :start-after: start-mc-admin-service-desc
          :end-before: end-mc-admin-service-desc


.. _mc-admin-install:

Installation
------------

.. include:: /includes/minio-mc-installation.rst

Quickstart
----------

Ensure that the host machine has :command:`mc`
:ref:`installed <mc-admin-install>` prior to starting this procedure.

.. important::

   The following example temporarily disables the bash history to mitigate the
   risk of authentication credentials leaking in plain text. This is a basic
   security measure and does not mitigate all possible attack vectors. Defer to
   security best practices for your operating system for inputting sensitive
   information on the command line.

Use the :mc-cmd:`mc alias set` command to add the
deployment to the :program:`mc` configuration.

.. code-block:: shell
   :class: copyable

   bash +o history
   mc config host add <ALIAS> <ENDPOINT> ACCESS_KEY SECRET_KEY
   bash -o history

Replace each argument with the required values. Specifying only the 
``mc config host add`` command starts an input prompt for entering the
required values.

Use the :ref:`mc admin info <mc-admin-info>` command to test the connection to
the newly added MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin info <ALIAS>

Global Options
--------------

:mc-cmd:`mc admin` supports the same global options as 
:mc-cmd:`mc`. See :ref:`minio-mc-global-options`.



.. _mc-admin-info:

``mc admin info``
~~~~~~~~~~~~~~~~~

The ``mc admin info`` command returns diagnostic information of a MinIO server.

The command has the following syntax:

.. code-block:: none

   NAME:
     mc admin info COMMAND <ALIAS>

   FLAGS
     --debug    Returns verbose information for debugging

If the specified ``<ALIAS>`` corresponds to a distributed MinIO deployment, the
command returns information for each MinIO server in the deployment. Use
:subcommand:`mc alias set` to list the currently configured aliases and their
corresponding endpoints.

*Display MinIO Server Information*

.. code-block:: shell
   :class: copyable

   mc admin info myminio

.. _mc-admin-policy:

``mc admin policy``
~~~~~~~~~~~~~~~~~~~

The ``mc admin policy`` command can add, remove, list, get info, and set 
policies for a user on the MinIO server. MinIO policies are fully compatible
with AWS IAM S3 policies. See
:aws-docs:`AWS Policies and Permissions in Amazon S3 
<AmazonS3/latest/dev/access-policy-language-overview.html>`.

The command has the following syntax:

.. code-block:: none

   NAME:
     mc admin policy COMMAND <ALIAS>

   COMMANDS:
     add      add new policy
     remove   remove policy
     list     list all policies
     info     show info on a policy
     set      set IAM policy on a user or group

If the specified ``<ALIAS>`` corresponds to a distributed MinIO deployment, the
command adds the policy to each MinIO server in the deployment. Use
:subcommand:`mc alias set` to list the currently configured aliases and their
corresponding endpoints.

MinIO servers include the following canned policies:

.. code-block:: none

   diagnostics
   readonly
   readwrite
   writeonly

Example: Add a new policy to a MinIO server
```````````````````````````````````````````

Applying the following example policy ``listbucketsonly.json`` to a user
restricts that user to only listing the top layer buckets in the MinIO server.
The user cannot list any other resources, including any objects in the top layer
buckets.

The following operation creates the policy on the ``/tmp`` folder

.. code-block:: shell

   cat <<EOF >> /tmp/listbucketsonly.json
      {
      "Version": "2012-10-17",
      "Statement": [
         {
            "Effect": "Allow",
            "Action": [
            "s3:ListAllMyBuckets"
            ],
            "Resource": [
            "arn:aws:s3:::*"
            ]
         }
      ]
      }
   EOF 

Use the ``mc admin policy add`` command to add the policy to the MinIO server.
Replace ``<ALIAS>`` with the alias for the desired MinIO deployment. 

.. code-block:: shell

   mc admin policy add <ALIAS> listbucketsonly /tmp/listbucketsonly.json

Example: Remove a policy from a MinIO Server
````````````````````````````````````````````

Use the ``mc admin policy <ALIAS> remove`` command to remove a policy from the
MinIO server. 

.. todo :  what happens to current users who have that policy?

.. code-block:: shell

   mc admin policy remove <ALIAS> listbucketsonly

Example: Display an existing policy
```````````````````````````````````

Use the ``mc admin policy <ALIAS> info`` command to retrieve policy's JSON
structure. Replace ``<ALIAS>`` with the alias for the desired MinIO deployment. 

.. code-block:: shell

   mc admin policy info <ALIAS> writeonly

Example: Associate a policy to a user or group
``````````````````````````````````````````````

Use the ``mc admin policy <ALIAS> set`` command to set a policy to a user or
group:

**Set policy for a user**

.. code-block:: shell

   mc admin policy set <ALIAS> <POLICY> user=<USERNAME>

**Set policy for a group**

.. code-block:: shell

   mc admin policy set <ALIAS> <POLICY> group=<GROUP>


.. toctree::
   :titlesonly:
   :hidden:
   :glob:

   /minio-cli/minio-mc-admin/*
