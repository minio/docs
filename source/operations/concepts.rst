=========================
Core Operational Concepts
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The following core concepts are fundamental to operation of MinIO deployments, including but not limited to installation and management of MinIO.

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

.. code-block:: text

   / #root
   /images/
      2020-01-02-MinIO-Diagram.png
      2020-01-03-MinIO-Advanced-Deployment.png
      MinIO-Logo.png
   /videos/
      2020-01-04-MinIO-Interview.mp4
   /articles/
      /john.doe/
         2020-01-02-MinIO-Object-Storage.md
         2020-01-02-MinIO-Object-Storage-comments.json
      /jane.doe/
         2020-01-03-MinIO-Advanced-Deployment.png
         2020-01-02-MinIO-Advanced-Deployment-comments.json
         2020-01-04-MinIO-Interview.md

MinIO supports multiple levels of nested directories and objects to support 
even the most dynamic object storage workloads.

Deployment Architecture
-----------------------

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

.. _minio-intro-server-pool:

:ref:`Server Pool <minio-intro-server-pool>`
   A set of MinIO :mc-cmd:`minio server` nodes which pool their drives and
   resources for supporting object storage/retrieval requests. Server pools
   support horizontal expansion for MinIO deployments.
   
   The :mc-cmd:`~minio server HOSTNAME` argument passed to the
   :mc-cmd:`minio server` command represents a Server Pool:

   .. code-block:: shell

      minio server https://minio{1...4}.example.net/mnt/disk{1...4}
                   
                   |                    Server Pool                |

   The above example describes a single Server Pool with
   4 :mc:`minio server` nodes and 4 drives each for a total of 16 drives. 
   MinIO requires starting each :mc:`minio server` in the set with the same
   startup command to enable awareness of all set peers.

   See :mc-cmd:`minio server` for complete syntax and usage.

   MinIO calculates the size and number of Erasure Sets in the Server Pool based
   on the total number of drives in the set *and* the number of :mc:`minio`
   servers in the set. See :ref:`minio-ec-erasure-set` for more information.

.. _minio-intro-cluster:

:ref:`Cluster <minio-intro-cluster>`
   The whole MinIO deployment consisting of one or more Server Pools. Each
   :mc-cmd:`~minio server HOSTNAME` argument passed to the 
   :mc-cmd:`minio server` command represents one Server Pool:

   .. code-block:: shell

      minio server https://minio{1...4}.example.net/mnt/disk{1...4} \
                   https://minio{5...8}.example.net/mnt/disk{1...4}
                   
                   |                    Server Pool                |
   
   The above example describes two Server Pools, each consisting of 4
   :mc:`minio server` nodes with 4 drives each for a total of 32 drives. MinIO 
   always stores each unique object and all versions of that object on the 
   same Server Pool.

   Server Pool expansion is a function of Horizontal Scaling, where each new set
   expands the cluster storage and compute resources. Server Pool expansion
   is not intended to support migrating existing sets to newer hardware. 

   MinIO Standalone clusters consist of a single Server Pool with a single
   :mc:`minio server` node. Standalone clusters are best suited for initial
   development and evaluation. MinIO strongly recommends production
   clusters consist of a *minimum* of 4 :mc:`minio server` nodes in a 
   Server Pool.

Erasure Coding
--------------

High-level blurb on Erasure Coding

.. toctree::
   :titlesonly:
   :hidden:
   :glob:

   /operations/concepts/*
