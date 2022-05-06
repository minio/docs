.. _minio-upgrade:

==========================
Upgrade a MinIO Deployment
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. admonition:: Test Upgrades Before Applying To Production
   :class: important

   MinIO **strongly discourages** performing blind updates to production
   clusters.  You should *always* test upgrades in a lower environment
   (dev/QA/staging) *before* applying upgrades to production deployments.

   Exercise particular caution if upgrading to a :minio-git:`release
   <minio/releases>` that has backwards breaking changes. MinIO includes
   warnings in release notes for any version known to not support
   downgrades.

   For MinIO deployments that are significantly behind latest stable 
   (6+ months), consider using 
   `MinIO SUBNET <https://min.io/pricing?ref=docs>`__ for additional support
   and guidance during the upgrade procedure.

Upgrade Checklist
-----------------

Review all items on the following checklist before performing an upgrade on
your MinIO deployments:

.. list-table::
   :stub-columns: 1
   :widths: 25 75
   :width: 100%

   * - Test in Lower Environments
     - Test all upgrades in a lower environment such as a dedicated 
       testing, development, or QA deployment.

       **Never** perform blind upgrades on production deployments.

   * - Upgrade Only When Necessary
     - MinIO follows a rapid development model where there may be multiple
       releases in a week. There is no requirement to follow these updates
       if your deployment is otherwise stable and functional.

       Upgrade only if there is a specific feature, bug fix, or other
       requirement necessary for your workload. Review the 
       :minio-git:`Release Notes <minio/releases>` for each Server release
       between your current MinIO version and the target version.

   * - Upgrades require Simultaneous Restart 
     - Ensure your preferred method of node management supports operating on 
       all nodes simultaneously.
     
       .. include:: /includes/common-installation.rst
          :start-after: start-nondisruptive-upgrade-desc
          :end-before: end-nondisruptive-upgrade-desc

.. _minio-upgrade-systemctl:

Update ``systemctl``-Managed MinIO Deployments
----------------------------------------------

Deployments managed using ``systemctl``, such as those created
using the MinIO :ref:`DEB/RPM packages <deploy-minio-distributed-baremetal>`,
require manual update and simultaneous restart of all nodes in the
MinIO deployment.

1. **Update the MinIO Binary on Each Node**

   .. include:: /includes/linux/common-installation.rst
      :start-after: start-upgrade-minio-binary-desc
      :end-before: end-upgrade-minio-binary-desc

2. **Restart the Deployment**

   Run ``systemctl restart minio`` simultaneously across all nodes in the
   deployment. Utilize your preferred method for coordinated execution of
   terminal/shell commands.

   .. include:: /includes/common-installation.rst
      :start-after: start-nondisruptive-upgrade-desc
      :end-before: end-nondisruptive-upgrade-desc

.. _minio-upgrade-mc-admin-update:

Update MinIO Deployments using ``mc admin update``
--------------------------------------------------

.. include:: /includes/common-installation.rst
   :start-after: start-nondisruptive-upgrade-desc
   :end-before: end-nondisruptive-upgrade-desc

The :mc-cmd:`mc admin update` command updates all MinIO server binaries in 
the target MinIO deployment before restarting all nodes simultaneously.

:mc-cmd:`mc admin update` is intended for baremetal (non-orchestrated)
deployments using manual management of server binaries.

- For deployments managed using ``systemctl``, see
  :ref:`minio-upgrade-systemctl`.

- For Kubernetes or other containerized environments, defer to the native 
  mechanisms for updating container images across a deployment.

:mc-cmd:`mc admin update` requires write access to the directory in which
the MinIO binary is saved (e.g. ``/usr/local/bin``).

The following command updates a MinIO deployment with the specified
:ref:`alias <alias>` to the latest stable release:

.. code-block:: shell
   :class: copyable

   mc admin update ALIAS

You should upgrade your :mc:`mc` binary to match or closely follow the
MinIO server release. You can use the :mc:`mc update` command to update the
binary to the latest stable release:

.. code-block:: shell
   :class: copyable

   mc update

You can specify a URL resolving to a specific MinIO server binary version.
Airgapped or internet-isolated deployments may utilize this feature for updating
from an internally-accessible server:

.. code-block:: shell
   :class: copyable

   mc admin update ALIAS https://minio-mirror.example.com/minio

Update MinIO Manually
---------------------

The following steps manually download the MinIO binary and restart the
deployment. These steps are intended for fully manual baremetal deployments
without ``systemctl`` or similar process management. These steps may also
apply to airgapped or similarly internet-isolated deployments which 
cannot use :mc-cmd:`mc admin update` to retrieve the binary over the network.

1. **Add the MinIO Binary to each node in the deployment**

   Follow your organizations preferred procedure for adding a new binary
   to the node. The following command downloads the latest stable MinIO
   binary:

   .. code-block:: shell
      :class: copyable

      wget https://dl.min.io/server/minio/release/linux-amd64/minio

2. **Overwrite the existing MinIO binary with the newer version**

   The following command sets the binary to executable and copies it to
   ``/usr/local/bin``. Replace this path with the location of the existing
   MinIO binary:

   .. code-block:: shell
      :class: copyable

      chmod +x minio
      sudo mv minio /usr/local/bin/
   
3. **Restart the deployment**

   Once all nodes have the updated binary, restart all nodes simultaneously
   using the :mc-cmd:`mc admin service` command:

   .. code-block:: shell
      :class: copyable

      mc admin service ALIAS

   Replace ``ALIAS`` with the :ref:`alias <alias>` for the target deployment.

   .. include:: /includes/common-installation.rst
      :start-after: start-nondisruptive-upgrade-desc
      :end-before: end-nondisruptive-upgrade-desc
