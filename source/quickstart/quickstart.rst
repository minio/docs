.. _quickstart-index:

==========
Quickstart
==========

.. default-domain:: minio

MinIO is a high performance object storage solution with native support for Kubernetes deployments. MinIO provides an Amazon Web Services S3-compatible API and supports all core S3 features. MinIO is released under `GNU Affero General Public License v3.0 <https://www.gnu.org/licenses/agpl-3.0.en.html>`__. 

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

.. toctree::
   :titlesonly:
   :hidden:
   
   /quickstart/linux
   /quickstart/container
   /quickstart/macos
   /quickstart/windows
   /quickstart/k8s