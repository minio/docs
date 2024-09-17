.. _minio-certmanager:

============
cert-manager
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

TLS certificate management with cert-manager
--------------------------------------------

`cert-manager <https://cert-manager.io/>`__ manages certificates within Kubernetes clusters.
The MinIO Operator supports using cert-manager for certificates as an alternative to the MinIO Operator managing certificates for itself and its tenants.

cert-manager obtains valid certificates from an ``Issuer`` or ``ClusterIssuer`` and can renew certificates prior to expiration.

A ``ClusterIssuer`` issues certificates for multiple namespaces.
An ``Issuer`` only mints certificates for its own namespace.

The following graphic depicts how various namespaces make use of either an ``Issuer`` or ``ClusterIssuer`` type.

- cert-manager is installed in the ``cert-manager`` namespace, which does not have either an ``issuer`` or a ``ClusterIssuer``.
- The ``default`` namespace receives the global ``Cluster Issuer``.
- Each tenant's namespace receives a local ``Issuer``.
- The ``minio-operator`` namespace receives a local ``Issuer``. 

.. image:: /images/k8s/cert-manager-cluster.svg
   :width: 600px
   :alt: A graphic depiction of a kubernetes cluster with five separate namespaces represented by different boxes. One is labeled minio-operator with a text box that says "minio-operator: issuer". A second is labeled tenant-1 with text box that says "tenant-1: issuer". A third is labeled default with a text box that says "root:ClusterIssuer". A fourth is labeled tenant-2 with a text box that says "tenant-2: issuer". The fifth is labeled cert-manager with a text box that says "minio-operator: issuer".
   :align: center

This guide shows you how to install cert-manager and set up the global ``Cluster Issuer``.

.. note::

   This guide uses a self-signed ``Cluster Issuer``. 
   You can also use `other Issuers supported by cert-manager <https://cert-manager.io/docs/configuration/issuers/>`__.
   The main difference is that you must provide the ``Issuer`` CA certificate to MinIO, instead of the CA's mentioned in this guide.


Prerequisites
-------------

- A `supported version of Kubernetes <https://kubernetes.io/releases/>`__. 
- `kustomize <https://kustomize.io/>`__ installed
- ``kubectl`` access to your ``k8s`` cluster

.. _minio-setup-certmanager:

Setup cert-manager
------------------

Install cert-manager
~~~~~~~~~~~~~~~~~~~~

The following command installs version 1.12.13 using ``kubectl``.

.. code-block:: shell
   :class: copyable
   
   kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.13/cert-manager.yaml

`Release 1.12.X LTS <https://cert-manager.io/docs/releases/release-notes/release-notes-1.12/>`__ is preferred, but you may install the latest version.
For more details on installing cert-manager, see their `installation instructions <https://cert-manager.io/docs/installation/>`__.

Create a self-signed Cluster Issuer for the cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``Cluster Issuer`` is the top level Issuer from which all other certificates in the cluster derive. 

1. Request cert-manager to generate this by creating a ``ClusterIssuer`` resource.

   Create a file called ``selfsigned-root-clusterissuer.yaml`` with the following contents:

   .. code-block:: yaml
      :class: copyable
   
      # selfsigned-root-clusterissuer.yaml
      apiVersion: cert-manager.io/v1
      kind: ClusterIssuer
      metadata:
        name: selfsigned-root
      spec:
        selfSigned: {}

2. Apply the resource to the cluster:

   .. code-block:: shell
      :class: copyable

      kubectl apply -f selfsigned-root-clusterissuer.yaml

Next steps
----------

Set up :ref:`cert-manager for the MinIO Operator <minio-certmanager-operator>`.

.. toctree::
   :titlesonly:
   :hidden:

   /operations/cert-manager/cert-manager-operator
   /operations/cert-manager/cert-manager-tenants