.. |KEYCLOAK_URL| replace:: localhost:8080
.. |MINIO_S3_URL| replace:: localhost:9000
.. |MINIO_CONSOLE_URL| replace:: localhost:9001

1) Create the Podman Pod
~~~~~~~~~~~~~~~~~~~~~~~~

Create a Podman Pod to deploy the Keycloak and MinIO containers in a Pod with shared networking.
This ensures both containers can communicate normally.

.. code-block:: shell
   :class: copyable

   podman pod create \ 
        -p 9000:9000 -p 9001:9001 -p 8080:8080 \
        -v ~/minio-keycloak/minio:/mnt/minio \
        -n minio-keycloak

Replace ``~/minio-keycloak/minio`` with a path to an empty folder in which the MinIO container stores data.

You can alternatively deploy the Containers as Root to allow access to the host network for the purpose of inter-container networking.

Deploying via Docker Compose is out of scope for this tutorial.

2) Start the Keycloak Container
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Follow the instructions for running `Keycloak in a container <https://www.keycloak.org/server/containers>`__.
The `Try Keycloak in development mode <https://www.keycloak.org/server/containers#_trying_keycloak_in_development_mode>`__ steps are sufficient for this procedure.

.. code-block:: shell
   :class: copyable

   podman run -dt \
          --name keycloak \
          --pod minio-keycloak \
          -e KEYCLOAK_ADMIN=keycloakadmin \
          -e KEYCLOAK_ADMIN_PASSWORD=keycloakadmin123 \
          quay.io/keycloak/keycloak:latest start-dev

Go to ``localhost:8080`` to access the Keycloak container.

3) Configure or Create a Client for Accessing Keycloak
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Authenticate to the Keycloak :guilabel:`Administrative Console` and navigate to :guilabel:`Clients`.

.. include:: /includes/common/common-configure-keycloak-identity-management.rst
   :start-after: start-configure-keycloak-client
   :end-before: end-configure-keycloak-client

4) Create Client Scope for MinIO Client
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Client scopes allow Keycloak to map user attributes as part of the JSON Web Token (JWT) returned in authentication requests.
This allows MinIO to reference those attributes when assigning policies to the user.
This step creates the necessary client scope to support MinIO authorization after successful Keycloak authentication.

.. include:: /includes/common/common-configure-keycloak-identity-management.rst
   :start-after: start-configure-keycloak-client-scope
   :end-before: end-configure-keycloak-client-scope

5) Apply the Necessary Attribute to Keycloak Users/Groups
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must assign an attribute named ``policy`` to the Keycloak Users or Groups. 
Set the value to any :ref:`policy <minio-policy>` on the MinIO deployment.

.. include:: /includes/common/common-configure-keycloak-identity-management.rst
   :start-after: start-configure-keycloak-user-group-attributes
   :end-before: end-configure-keycloak-user-group-attributes

6) Start the MinIO Container
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command starts the MinIO Container and attaches it to the ``minio-keycloak`` pod.

.. code-block:: shell
   :class: copyable

   podman run -dt \
          --name minio-server \
          --pod minio-keycloak \
          quay.io/minio/minio:RELEASE.2023-02-22T18-23-45Z server /mnt/data --console-address :9001

Go to ``localhost:9001`` to access the MinIO Console.
Log in using the default credentials ``minioadmin:minioadmin``.

7) Configure MinIO for Keycloak Authentication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports multiple methods for configuring Keycloak authentication:

- Using a terminal/shell and the :mc:`mc idp openid` command
- Using environment variables set prior to starting MinIO

.. tab-set::

   .. tab-item:: CLI

      .. include:: /includes/common/common-configure-keycloak-identity-management.rst
         :start-after: start-configure-keycloak-minio-cli
         :end-before: end-configure-keycloak-minio-cli

   .. tab-item:: Environment Variables

      .. include:: /includes/common/common-configure-keycloak-identity-management.rst
         :start-after: start-configure-keycloak-minio-envvar
         :end-before: end-configure-keycloak-minio-envvar


You must restart the MinIO deployment for the changes to apply.

Check the :ref:`MinIO server logs <minio-logging>` and verify that startup succeeded with no errors related to the Keycloak configuration.


8) Generate Application Credentials using the Security Token Service (STS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-configure-keycloak-identity-management.rst
   :start-after: start-configure-keycloak-sts
   :end-before: end-configure-keycloak-sts

Next Steps
~~~~~~~~~~~~~

Applications should implement the :ref:`STS <minio-security-token-service>` flow using their :ref:`SDK <minio-drivers>` of choice.
When STS credentials expire, applications should have logic in place to regenerate the JWT token, STS token, and MinIO credentials before retrying and continuing operations.
