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


Table of Deprecated Admin Commands
----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 30 30 40
   :width: 100%

   * - Deprecated Command
     - Replacement Command
     - Version of Change

   * - ``mc admin tier add``
     - :mc-cmd:`mc ilm tier add`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin tier edit``
     - :mc-cmd:`mc ilm tier update`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin tier ls``
     - :mc-cmd:`mc ilm tier ls`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin bucket remote add``
     - :mc-cmd:`mc replicate add`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin bucket remote rm``
     - :mc-cmd:`mc replicate rm`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin bucket remote ls``
     - :mc-cmd:`mc replicate ls`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin bucket remote update``
     - :mc-cmd:`mc replicate update`
     - mc RELEASE.2022-12-24T15-21-38Z

   * - ``mc admin bucket quota``
     - :mc-cmd:`mc quota clear`, :mc-cmd:`mc quota info`, :mc-cmd:`mc quota set`
     - mc RELEASE.2022-12-13T00-23-28Z



.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/deprecated/mc-ilm-add
   /reference/deprecated/mc-ilm-edit
   /reference/deprecated/mc-ilm-export
   /reference/deprecated/mc-ilm-import
   /reference/deprecated/mc-ilm-ls
   /reference/deprecated/mc-ilm-rm
   /reference/deprecated/mc-admin-tier
   /reference/deprecated/mc-admin-bucket-quota
