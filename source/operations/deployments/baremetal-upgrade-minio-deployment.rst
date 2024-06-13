.. _minio-upgrade:

==========================
Upgrade a MinIO Deployment
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. important::

   For deployments older than :minio-release:`RELEASE.2024-03-30T09-41-56Z` running with :ref:`AD/LDAP <minio-ldap-config-settings>` enabled, you **must** read through the release notes for :minio-release:`RELEASE.2024-04-18T19-09-19Z` before starting this procedure.
   You must take the extra steps documented in the linked release as part of the upgrade.

.. include:: /includes/linux/steps-upgrade-minio-deployment.rst