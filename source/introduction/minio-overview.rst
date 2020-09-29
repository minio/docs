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

Deploying MinIO
---------------

For Kubernetes clusters, use the MinIO Kubernetes Operator.
See :ref:`minio-kubernetes` for more information.

For bare-metal environments, including private cloud services
or containerized environments, install and run the :mc:`minio server` on
each host in the MinIO deployment. See :ref:`minio-baremetal` for more 
information.

.. toctree::
   :hidden:
   :titlesonly:

   /introduction/deployment-topologies.rst
   /introduction/erasure-coding.rst
   /introduction/bitrot-protection.rst