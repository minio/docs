.. _minio-drivers:

===============================
Software Development Kits (SDK)
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO publishes the following Software Development Kits (SDK):

- :ref:`Go <go-sdk>`
- :ref:`Python <python-sdk>`
- :ref:`Java <java-sdk>`
- :ref:`.NET <dotnet-sdk>`
- :ref:`JavaScript <javascript-sdk>`
- :ref:`C++ <cpp-sdk>`
- :ref:`Haskell <haskell-sdk>`

.. _go-sdk:

Go
--

GitHub: `minio/minio-go <https://github.com/minio/minio-go>`__

Latest Version: |go-sdk-version|

Quickstart Guide: :doc:`/developers/go/minio-go`

Reference: :doc:`/developers/go/API`

Download from GitHub
  .. code-block:: shell
     :class: copyable

     go install github.com/minio/minio-go/v7@latest


.. _python-sdk:

Python
------

GitHub: `minio/minio-py <https://github.com/minio/minio-py>`__

Latest Version: |python-sdk-version|

Quickstart Guide: :doc:`/developers/python/minio-py`

Reference: :doc:`/developers/python/API`

Install Methods
  - pip

    .. code-block:: shell
       :class: copyable

       pip3 install minio

  - source

    .. code-block:: shell
       :class: copyable

       git clone https://github.com/minio/minio-py
       cd minio-py
       python setup.py install


.. _java-sdk:

Java
----

GitHub: `minio/minio-java <https://github.com/minio/minio-java>`__

Latest version: |java-sdk-version|

Quickstart Guide: :ref:`minio-java-quickstart`

Reference: :doc:`/developers/java/API`

Install methods
  - Maven

    .. code-block:: java
       :class: copyable
       :substitutions:

       <dependency>
           <groupId>io.minio</groupId>
           <artifactId>minio</artifactId>
           <version>|java-sdk-version|</version>
       </dependency>

  - Gradle

    .. code-block:: java
       :class: copyable
       :substitutions:

       dependencies {
           implementation("io.minio:minio:|java-sdk-version|")
       }

  - JAR

    Download the latest JAR file for version |java-sdk-version| of the SDK from the `Sonatype Maven Central Repository <|java-jar-url|>`__.

.. _dotnet-sdk:

.NET
----

GitHub: `minio/minio-dotnet <https://github.com/minio/minio-dotnet>`__

Latest Version: |dotnet-sdk-version|

Quickstart Guide: :doc:`/developers/dotnet/minio-dotnet`

Reference: :doc:`/developers/dotnet/API`

Download from NuGet
  Run the following command in the NuGet Package Manager Console.

  .. code-block:: shell
     :class: copyable

     PM> Install-Package Minio


.. _javascript-sdk:

JavaScript
----------

GitHub: `minio/minio-js <https://github.com/minio/minio-js>`__

Latest Version: |javascript-sdk-version|

Quickstart Guide: :doc:`/developers/javascript/minio-javascript`

Reference: :doc:`/developers/javascript/API`

Install
  - NPM

    .. code-block:: shell
       :class: copyable

       npm install --save minio

  - Source

    .. code-block:: shell
       :class: copyable

       git clone https://github.com/minio/minio-js
       cd minio-js
       npm install
       npm install -g

  - TypeScript

    .. code-block:: shell
       :class: copyable

       npm install --save-dev @types/minio


.. _cpp-sdk:

C++
---

GitHub: `minio/minio-cpp <https://github.com/minio/minio-cpp>`__

Latest version: |cpp-sdk-version|

Reference: `MinIO C++ SDK Reference <https://minio-cpp.min.io/>`__

Install
  - ``vcpkg``

    .. code-block:: shell
       :class: copyable

       vcpkg install minio-cpp

  - Source

    .. code-block:: shell
       :class: copyable

       git clone https://github.com/minio/minio-cpp
       cd minio-cpp
       wget --quiet -O vcpkg-master.zip https://github.com/microsoft/vcpkg/archive/refs/heads/master.zip
       unzip -qq vcpkg-master.zip
       ./vcpkg-master/bootstrap-vcpkg.sh
       ./vcpkg-master/vcpkg integrate install
       cmake -B ./build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=./vcpkg-master/scripts/buildsystems/vcpkg.cmake
       cmake --build ./build --config Debug


.. _haskell-sdk:

Haskell
-------

GitHub: `minio/minio-hs <https://github.com/minio/minio-hs>`__

Latest Version: |haskell-sdk-version|

Quickstart Guide: :doc:`/developers/haskell/minio-haskell`

Install
  Add ``minio-hs`` to your project's ``.cabal`` dependencies section.

  or

  If you are using ``hpack``, add ``minio-hs`` to your ``package.yaml`` file.

..
  Rust SDK repo does not have any releases yet. Once released, unblock this section and add to toctree.

  .. _rust-sdk:

  Rust (``minio-rs``)
  -------------------

  Latest Version
    |rust-sdk-version|

  Reference
    :doc:`MinIO Rust SDK Reference </developers/rust/minio-rust>`

  Install
    To Do


..
  Will need to add C++ and Rust to the toctree once released.

.. toctree::
   :titlesonly:
   :hidden:
   :maxdepth: 1

   /developers/go/minio-go
   /developers/python/minio-py
   /developers/dotnet/minio-dotnet
   /developers/java/minio-java
   /developers/javascript/minio-javascript
   /developers/haskell/minio-haskell
