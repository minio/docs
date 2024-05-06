===================
Deprecated Commands
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

The following table lists the commands deprecated by MinIO.
The table includes:

- Deprecated Command
- Replacement command (if applicable)
- Version of deprecation

Table of Deprecated Commands
----------------------------

.. list-table::
   :header-rows: 1
   :widths: 30 30 40
   :width: 100%

   * - Deprecated Command
     - Replacement Command
     - Version of Change

   * - ``mc ilm add``
     - :mc-cmd:`mc ilm rule add`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc ilm edit``
     - :mc-cmd:`mc ilm rule edit`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc ilm export``
     - :mc-cmd:`mc ilm rule export`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc ilm import``
     - :mc-cmd:`mc ilm rule import`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc ilm ls``
     - :mc-cmd:`mc ilm rule ls`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc ilm rm``
     - :mc-cmd:`mc ilm rule rm`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc replicate diff``
     - :mc-cmd:`mc replicate backlog`
     - mc RELEASE.2023-07-18T21-05-38Z


Table of Deprecated Admin Commands
----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 30 30 40
   :width: 100%

   * - Deprecated Command
     - Replacement Command
     - Version of Change

   * - ``mc admin bucket remote add``
     - :mc-cmd:`mc replicate add`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin bucket remote ls``
     - :mc-cmd:`mc replicate ls`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin bucket remote rm``
     - :mc-cmd:`mc replicate rm`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin bucket remote update``
     - :mc-cmd:`mc replicate update`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin bucket quota``
     - :mc-cmd:`mc quota clear`, :mc-cmd:`mc quota info`, :mc-cmd:`mc quota set`
     - mc RELEASE.2022-12-13T00-23-28Z

   * - ``mc admin console``
     - :mc-cmd:`mc admin logs`
     - mc RELEASE.2022-06-26T18-51-48Z

   * - ``mc admin idp ldap add``
     - :mc-cmd:`mc idp ldap add`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp ldap disable``
     - :mc-cmd:`mc idp ldap disable`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp ldap enable``
     - :mc-cmd:`mc idp ldap enable`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp ldap info``
     - :mc-cmd:`mc idp ldap info`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp ldap ls``
     - :mc-cmd:`mc idp ldap ls`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp ldap policy``
     - :mc-cmd:`mc idp ldap policy`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp ldap rm``
     - :mc-cmd:`mc idp ldap rm`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp ldap update``
     - :mc-cmd:`mc idp ldap update`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp openid add``
     - :mc-cmd:`mc idp openid add`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp openid disable``
     - :mc-cmd:`mc idp openid disable`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp openid enable``
     - :mc-cmd:`mc idp openid enable`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp openid info``
     - :mc-cmd:`mc idp openid info`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp openid ls``
     - :mc-cmd:`mc idp openid ls`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp openid rm``
     - :mc-cmd:`mc idp openid rm`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin idp openid update``
     - :mc-cmd:`mc idp openid update`
     - mc RELEASE.2023-05-26T23-31-54Z

   * - ``mc admin policy add``
     - :mc-cmd:`mc admin policy create`
     - mc RELEASE.2023-03-20T17-17-53Z 

   * - ``mc admin policy set``
     - :mc-cmd:`mc admin policy attach`
     - mc RELEASE.2023-03-20T17-17-53Z 

   * - ``mc admin policy unset``
     - :mc-cmd:`mc admin policy detach`
     - mc RELEASE.2023-03-20T17-17-53Z 

   * - ``mc admin policy update``
     - :mc-cmd:`mc admin policy attach` or :mc-cmd:`mc admin policy detach`
     - mc RELEASE.2023-03-20T17-17-53Z 

   * - ``mc admin profile``
     - :mc:`mc support profile`
     - mc RELEASE.2023-04-06T16-51-10Z

   * - ``mc admin replicate edit``
     - :mc:`mc admin replicate update`
     - mc RELEASE.2023-01-11T03-14-16Z

   * - ``mc admin replicate remove``
     - :mc:`mc admin replicate rm`
     - mc RELEASE.2023-01-11T03-14-16Z

   * - ``mc admin speedtest``
     - :mc:`mc support perf`
     - mc RELEASE.2022-07-24T02-25-13Z

   * - ``mc admin tier add``
     - :mc:`mc ilm tier add`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin tier edit``
     - :mc-cmd:`mc ilm tier update`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin tier ls``
     - :mc:`mc ilm tier ls`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin top``
     - :mc:`mc support top`
     - mc RELEASE.2022-08-11T00-30-48Z

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/deprecated/mc-ilm-add
   /reference/deprecated/mc-ilm-edit
   /reference/deprecated/mc-ilm-export
   /reference/deprecated/mc-ilm-import
   /reference/deprecated/mc-ilm-ls
   /reference/deprecated/mc-ilm-rm
   /reference/deprecated/mc-admin-bucket-quota
   /reference/deprecated/mc-admin-console
   /reference/deprecated/mc-admin-idp-ldap
   /reference/deprecated/mc-admin-idp-ldap-policy
   /reference/deprecated/mc-admin-idp-openid
   /reference/deprecated/mc-admin-profile
   /reference/deprecated/mc-admin-speedtest
   /reference/deprecated/mc-admin-tier
   /reference/deprecated/mc-admin-top
