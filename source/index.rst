=====================================
MinIO High Performance Object Storage
=====================================

.. default-domain:: minio

Welcome to the MinIO Documentation! MinIO is a high performance object storage 
solution with native support for Kubernetes deployments. MinIO provides an 
Amazon Web Services S3-compatible API and supports all core S3 features. 
MinIO is released under `GNU Affero General Public License v3.0 
<https://www.gnu.org/licenses/agpl-3.0.en.html>`__. 

This documentation targets the latest stable version of MinIO, |minio-tag|.

You can get started exploring MinIO features using our ``play`` server at
https://play.min.io. ``play`` is a *public* MinIO cluster running the latest
stable MinIO server. Any file uploaded to ``play`` should be considered public
and non-protected.

The MinIO Client :mc:`mc` commandline interface includes an
:mc-cmd:`alias <mc alias>` for the ``play`` server. After 
`Downloading the MinIO Client <https://min.io/downloads>`__, use the 
``play`` alias to perform S3-compatible object storage operations:

.. code-block:: shell
   :class: copyable

   mc alias list play
   mc mb --with-lock play/mynewbucket
   mc cp ~/data/mytestdata play/mynewbucket

See the :doc:`MinIO Client Complete Reference </reference/minio-mc>`
for complete documentation on the available :mc:`mc` commands.

- First-time users of MinIO *or* object storage services should start with 
  our :doc:`Introduction </introduction/minio-overview>`.

- Users deploying onto a Kubernetes cluster should start with our 
  :docs-k8s:`Kubernetes documentation <>`.

Quickstart
----------

Select the card corresponding to the platform on which you want to deploy MinIO to display instructions for deploying a :ref:`Standalone <minio-installation-comparison>` MinIO server appropriate for early development and evaluation environments.

.. grid:: 3
   :gutter: 3

   .. grid-item-card:: Linux
      :link-type: ref
      :link: quickstart-linux
      
      .. image:: /images/logos/linux.svg
         :width: 100px
         :height: 100px
         :alt: Linux Quickstart
         :align: center
         :class: noshadow

   .. grid-item-card:: MacOS
      :link-type: ref
      :link: quickstart-macos
      
      .. image:: /images/logos/macos.svg
         :width: 100px
         :height: 100px
         :alt: MacOS Quickstart
         :align: center
         :class: noshadow

   .. grid-item-card:: Windows
      :link-type: ref
      :link: quickstart-windows
      
      .. image:: /images/logos/windows.svg
         :width: 100px
         :height: 100px
         :alt: Windows Quickstart
         :align: center
         :class: noshadow

   .. grid-item-card:: Kubernetes (Generic)
      :link-type: ref
      :link: quickstart-kubernetes
      
      .. image:: /images/logos/kubernetes.svg
         :width: 100px
         :height: 100px
         :alt: Kubernetes Quickstart
         :align: center
         :class: noshadow

   .. grid-item-card:: Docker / Podman
      :link-type: ref
      :link: quickstart-container
      
      .. image:: /images/logos/docker.svg
         :width: 100px
         :height: 100px
         :alt: Docker Quickstart
         :align: center
         :class: noshadow
      

:subscript:`All trademarks or logos displayed on this page are the property of their respective owners, and constitute neither an endorsement nor a recommendation of those organizations. In addition, such use of trademarks or links to the web sites of third-party organizations is not intended to imply, directly or indirectly, that those organizations endorse or have any affiliation with MinIO.`

Licensing
---------

We have designed MinIO as an Open Source software for the Open Source software
community. This requires applications to consider whether their usage of MinIO
is in compliance with the 
:minio-git:`GNU AGPLv3 license <mc/blob/master/LICENSE>`.

MinIO cannot make the determination as to whether your application's usage of
MinIO is in compliance with the AGPLv3 license requirements. You should instead
rely on your own legal counsel or licensing specialists to audit and ensure your
application is in compliance with the licenses of MinIO and all other
open-source projects with which your application integrates or interacts. We
understand that AGPLv3 licensing is complex and nuanced. It is for that reason
we strongly encourage using experts in licensing to make any such determinations
around compliance instead of relying on apocryphal or anecdotal advice.

`MinIO Commercial Licensing <https://min.io/pricing>`__ is the best option for
applications that trigger AGPLv3 obligations (e.g. open sourcing your
application). Applications using MinIO - or any other OSS-licensed code -
without validating their usage do so at their own risk.

.. toctree::
   :titlesonly:
   :hidden:

   /introduction/minio-overview
   /quickstart/quickstart
   /installation/deployment-and-management
   /security/iam-overview
   /security/encryption-overview
   Object Retention </object-retention/minio-object-retention>
   /lifecycle-management/lifecycle-management-overview
   /replication/replication-overview
   /monitoring/monitoring-overview
   /support/support-overview
   /reference/minio-mc
   /reference/minio-mc-admin
   /reference/minio-server/minio-server
   /console/minio-console
   /sdk/minio-drivers