============
``mc alias``
============

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 1

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

.. important::

   :mc-cmd:`mc alias` requires specifying an access key and corresponding
   secret key for a user on the S3-compatible host. :program:`mc` can
   only perform operations on that host for which the user has explicit
   permission. If the specified user cannot perform an action or access
   a resource on the S3 host, :program:`mc` inherits those restrictions.

Quick Reference
---------------

:mc-cmd:`mc alias add ALIAS HOSTNAME ACCESSKEY SECRETKEY <mc alias add>`
   Adds the specified S3-compatible host to the
   :program:`mc` :ref:`configuration file <mc-configuration>`.
   :program:`mc` commands can access the host using the
   specified ``ALIAS``.

:mc-cmd:`mc alias remove ALIAS <mc alias remove>`
   Removes the S3-compatible host associated to the specified alias from the
   :program:`mc` :ref:`configuration file <mc-configuration>`. 

:mc-cmd:`mc alias list <mc alias list>`
   Lists all S3-compatible hosts and aliases in the :program:`mc`
   :ref:`configuration file <mc-configuration>`.

Syntax
------

:mc-cmd:`~mc alias` has the following syntax:

.. code-block:: shell
   
   mc alias COMMAND [COMMAND FLAGS | -h ] [ARGUMENTS]

:mc-cmd:`~mc alias` supports the following commands:

.. mc-cmd:: add, a

   Adds a new S3-compatible host to the configuration file. The command
   has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc alias add ALIAS HOSTNAME ACCESS_KEY SECRET_KEY --api [S3v2|S3v4]

   :mc-cmd:`mc alias add` supports the following arguments:

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

   Removes a host entry from the configuration file. The command has the
   following syntax:

   .. code-block:: shell
      :class: copyable

      mc alias remove ALIAS

.. mc-cmd:: list, ls

   Lists all hosts in the configuration file. The command has the following
   syntax:

   .. code-block:: shell
      :class: copyable

      mc alias list

Behavior
--------

Examples
--------

Add a New S3 Service Alias
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc alias add myminio https://myminio.example.net myminioaccesskey myminiosecretkey

Remove an Existing S3 Service Alias
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc alias remove myminio 


List All Configured S3 Service Aliases
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc alias list