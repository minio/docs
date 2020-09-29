============
``mc alias``
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc alias

Description
-----------

.. start-mc-alias-desc

The :mc-cmd:`mc alias` command provides a convenient interface for
managing the list of S3-compatible hosts that :mc-cmd:`mc` can
connect to and run operations against.

:mc-cmd:`mc` commands that operate on S3-compatible services *require*
specifying an alias for that service.

.. end-mc-alias-desc

Using :mc-cmd:`mc alias` to add or remove an S3-compatible host is equivalent
to manually editing entries in the :program:`mc` 
:ref:`configuration file <mc-configuration>`. 

S3 Access Control and Limitations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:mc-cmd:`mc alias` requires specifying an access key and corresponding secret
key for a user on the S3-compatible host. :program:`mc` can only perform
operations on that host for which the user has explicit permission. If the
specified user cannot perform an action or access a resource on the S3 host,
:program:`mc` inherits those restrictions.

For more information on MinIO Access Control, see
:ref:`minio-auth-authz-overview`. 

For more complete documentation on S3 Access Control, see
:s3-docs:`Amazon S3 Security <security.html>`.

For all other S3-compatible services, defer to the documentation for that
service.

Common Operations
-----------------

Add an S3-Compatible Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc alias set` to add an S3-compatible service for use with
:program:`mc`:

.. code-block:: shell
   :class: copyable

   mc alias set ALIAS HOSTNAME ACCESSKEY SECRETKEY

- Replace ``ALIAS`` with the name of the alias to associate to the S3-compatible service.

- Replace ``HOSTNAME`` with the hostname or IP address of the S3-compatible service.

- Replace ``ACCESSKEY`` and ``SECRETKEY`` with the access and secret key for a 
  user on the S3-compatible service.

Remove a Configured S3-Compatible Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc alias remove` to remove an S3-compatible alias from the
:program:`mc` configuration:

.. code-block:: shell
   :class: copyable

   mc alias remove ALIAS

- Replace ``ALIAS`` with the name of the S3-compatible service to remove. 

Use :mc-cmd:`mc alias list` to list the currently configured S3-compatible
services.

List Configured S3-Compatible Services
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc alias list` to list all configured S3-compatible aliases:

.. code-block:: shell
   :class: copyable

   mc alias list


Syntax
------

.. mc-cmd:: set, s
   :fullpath:

   Adds a new S3-compatible host to the configuration file. The command
   has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc alias set ALIAS HOSTNAME ACCESS_KEY SECRET_KEY --api [S3v2|S3v4]

   :mc-cmd:`mc alias set` supports the following arguments:

   .. mc-cmd:: ALIAS

      The name to associate to the S3-compatible service.

      The specified string cannot match any existing host aliases. Use
      :mc-cmd:`~mc alias list` to view the current host aliases before
      adding a new host.

   .. mc-cmd:: HOSTNAME
   
      The URL for the S3-compatible service endpoint.

   .. mc-cmd:: ACCESS_KEY

      The access key for authenticating to the S3 service. The
      ``ACCESS_KEY`` must correspond to a user or role on the S3 service.

      :mc-cmd:`mc` can only perform an operation on the S3 service if
      the ``ACCESS_KEY`` user or role grants the required permissions.

   .. mc-cmd:: SECRET_KEY
   
      The corresponding secret for the specified ``ACCESS_KEY``. 

   .. mc-cmd:: api
      :option:
      
      The Amazon S3 Signature version to use when connecting to the
      S3 service. Supports the following values:

      - ``S3v2``
      - ``S3v4`` (Default)


.. mc-cmd:: remove, rm
   :fullpath:

   Removes a host entry from the configuration file. The command has the
   following syntax:

   .. code-block:: shell
      :class: copyable

      mc alias remove ALIAS

.. mc-cmd:: list, ls
   :fullpath:

   Lists all hosts in the configuration file. The command has the following
   syntax:

   .. code-block:: shell
      :class: copyable

      mc alias list

Examples
--------

Add a New S3 Service Alias
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc alias set myminio https://myminio.example.net myminioaccesskey myminiosecretkey
