============
Introduction
============

.. default-domain:: minio

MinIO is a High Performance Object Storage released under Apache License v2.0.
It is API compatible with Amazon S3 cloud storage service. Use MinIO to build
high performance infrastructure for machine learning, analytics and application
data workloads.

What Is Object Storage?
-----------------------

.. _objects:

An :ref:`object <objects>` is binary data, sometimes referred to as a Binary
Large OBject (BLOB). Blobs can be images, audio files, spreadsheets, or even
binary executable code. Object Storage platforms like MinIO provide dedicated
tools and capabilities for storing, retrieving, and searching for blobs. 

.. _buckets:

MinIO Object Storage uses :ref:`buckets <buckets>` to organize objects. 
A bucket is similar to a folder or directory in a filesystem, where each
bucket can hold an arbitrary number of objects. MinIO buckets provide the 
same functionality as AWS S3 buckets. 

For example, consider an application that hosts a web blog. The application
needs to store a variety of blobs, including rich multimedia like videos and
images. The structure of objects on the MinIO server might look similar to the
following:

.. code-block:: shell

   / #root
   /images/
      2020-01-02-blog-title.png
      2020-01-03-blog-title.png
   /videos/
      2020-01-03-blog-cool-video.mp4
   /blogs/
      2020-01-02-blog.md
      2020-01-03-blog.md
   /comments/
      2020-01-02-blog-comments.json
      2020-01-02-blog-comments.json

Deployment Architecture
-----------------------

The following diagram describes the individual components in a MinIO 
deployment:

<DIAGRAM ErasureSet -> ServerSet -> Cluster >

:ref:`Erasure Set <minio-ec-erasure-set>`
   A set of disks that supports MinIO :ref:`Erasure Coding
   <minio-erasure-coding>`. Erasure Coding provides high availability,
   reliability, and redundancy of data stored on a MinIO deployment.

   MinIO divides objects into chunks and evenly distributes them among each
   drive in the Erasure Set. MinIO can continue seamlessly serving read and
   write requests despite the loss of any single drive. At the highest
   redundancy levels, MinIO can serve read requests with minimal performance
   impact despite the loss of up to half (``N/2``) of the total drives in the
   deployment.

.. _minio-intro-server-set:

:ref:`Server Set <minio-intro-server-set>`
   A set of MinIO :mc-cmd:`minio server` nodes which pool their drives and
   resources for supporting object storage/retrieval requests. The
   :mc-cmd:`~minio server HOSTNAME` argument passed to the 
   :mc-cmd:`minio server` command represents a Server Set:

   .. code-block:: shell

      minio server https://minio{1...4}.example.net/mnt/disk{1...4}
                   
                   |                    Server Set                |

   The above example describes a single Server Set with
   4 :mc:`minio server` nodes and 4 drives each for a total of 16 drives. 
   MinIO requires starting each :mc:`minio server` in the set with the same
   startup command to enable awareness of all set peers.

   See :mc-cmd:`minio server` for complete syntax and usage.

   MinIO calculates the size and number of Erasure Sets in the Server Set based
   on the total number of drives in the set *and* the number of :mc:`minio`
   servers in the set. See :ref:`minio-ec-erasure-set` for more information.

.. _minio-intro-cluster:

:ref:`Cluster <minio-intro-cluster>`
   The whole MinIO deployment consisting of one or more Server Sets. Each
   :mc-cmd:`~minio server HOSTNAME` argument passed to the 
   :mc-cmd:`minio server` command represents one Server Set:

   .. code-block:: shell

      minio server https://minio{1...4}.example.net/mnt/disk{1...4} \
                   https://minio{5...8}.example.net/mnt/disk{1...4}
                   
                   |                    Server Set                |
   
   The above example describes two Server Sets, each consisting of 4
   :mc:`minio server` nodes with 4 drives each for a total of 32 drives.

   Server Set expansion is a function of Horizontal Scaling, where each new set
   expands the cluster storage and compute resources. Server Set expansion
   is not intended to support migrating existing sets to newer hardware. 

   MinIO Standalone clusters consist of a single Server Set with a single
   :mc:`minio server` node. Standalone clusters are best suited for initial
   development and evaluation. MinIO strongly recommends production
   clusters consist of a *minimum* of 4 :mc:`minio server` nodes in a 
   Server Set.

Deploying MinIO
---------------

For Kubernetes clusters, use the MinIO Kubernetes Operator.
See :ref:`minio-kubernetes` for more information.

For bare-metal environments, including private cloud services
or containerized environments, install and run the :mc:`minio server` on
each host in the MinIO deployment. See :ref:`minio-baremetal` for more 
information.

