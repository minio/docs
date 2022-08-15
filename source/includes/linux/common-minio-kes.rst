.. start-kes-download-desc

Download the latest stable release (|kes-stable|) of KES from :minio-git:`github.com/minio/kes <kes/releases/latest>`.

Select the binary appropriate for the host OS architecture. 
For example, hosts running X86-64 (Intel/AMD64) should download the ``kes-linux-amd64`` package.

The following example code downloads the latest Linux AMD64-compatible binary and moves it to the system ``PATH``:

.. code-block:: shell
   :class: copyable
   :substitutions:

   wget https://github.com/minio/kes/releases/download/v|kes-stable|/kes-linux-amd64 -O /tmp/kes && \
   chmod +x /tmp/kes && \
   sudo mv /tmp/kes /usr/local/bin

   kes --version

For distributed KES topologies, repeat this step and all following KES-specific instructions for each host on which you want to deploy KES.
MinIO strongly recommends configuring a load balancer with a "Least Connections" configuration to manage connections to distributed KES hosts.

.. end-kes-download-desc

.. start-kes-service-file-desc

Create the ``/etc/systemd/system/minio.service`` file on all KES hosts:

.. literalinclude:: /extra/kes.service
   :language: shell

You may need to run ``systemctl daemon-reload`` to load the new service file into ``systemctl``.

The ``kes.service`` file runs as the ``kes-user`` User and Group by default.
You can create the user and group using the ``useradd`` and ``groupadd`` commands.
The following example creates the user and group.
These commands typically require root (``sudo``) permissions.

.. code-block:: shell
   :class: copyable

   groupadd -r kes-user
   useradd -M -r -g kes-user kes-user

.. end-kes-service-file-desc

.. start-kes-start-service-desc

Run the following command on each KES host to start the service:

.. code-block:: shell
   :class: copyable

   systemctl start kes

You can validate the startup by using ``systemctl status kes``. 
If the service started successfully, use ``journalctl -uf kes`` to check the KES output logs.

.. end-kes-start-service-desc

.. start-kes-minio-start-service-desc

For new MinIO deployments, run the following command on each MinIO host to start the service:

.. code-block:: shell
   :class: copyable

   systemctl start minio

For existing MinIO deployments, run the following command on each MinIO host to restart the service:

.. code-block:: shell
   :class: copyable

   systemctl reload minio
   systemctl restart minio

.. end-kes-minio-start-service-desc