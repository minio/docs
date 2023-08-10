.. _minio-drivers:

===============================
Software Development Kits (SDK)
===============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

MinIO publishes the following Software Development Kits (SDK):

1. :ref:`.NET <dotnet-sdk>`
2. :ref:`Golang <go-sdk>`
3. :ref:`Haskell <haskell-sdk>`
4. :ref:`Java <java-sdk>`
5. :ref:`JavaScript <javascript-sdk>`
6. :ref:`Python <python-sdk>`
7. :ref:`C++ <cpp-sdk>`

.. _cpp-sdk:

C++ (``minio-cpp``)
-------------------


Reference
  `MinIO C++ SDK Reference <https://minio-cpp.min.io/>`__

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

.. _dotnet-sdk:

.NET (``minio-dotnet``)
-----------------------

Latest Version
  |dotnet-sdk-version|

Reference
  :doc:`MinIO .NET SDK Reference </developers/dotnet/minio-dotnet>`

Download from NuGet
  Run the following command in the NuGet Package Manager Console.

  .. code-block:: shell
     :class: copyable

     PM> Install-Package Minio

.. _go-sdk:

Go (``minio-go``)
-----------------

Latest Version
  |go-sdk-version|

Reference
  :doc:`MinIO Go SDK Reference </developers/go/minio-go>`

Download from GitHub
  .. code-block:: go
     :class: copyable

     go get github.com/minio/minio-go/v7

.. _haskell-sdk:

Haskell (``minio-hs``)
----------------------

Latest Version
  |haskell-sdk-version|

Reference
  :doc:`MinIO Haskell SDK Reference </developers/haskell/minio-haskell>`
  
Install
  Add ``minio-hs`` to your project's ``.cabal`` dependencies section.
  
  or

  If you are using ``hpack``, add ``minio-hs`` to your ``package.yaml`` file.

.. _java-sdk:

Java (``minio-java``)
---------------------

Latest version
  |java-sdk-version|

Reference
  :ref:`MinIO Java SDK Reference <minio-java-quickstart>`
    
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
 
    Download the latest JAR file for |java-sdk-version| of the SDK from |java-jar-url|.

.. _javascript-sdk:

JavaScript (``minio-js``)
-------------------------

Latest Version
  |javascript-sdk-version|

Reference
  :doc:`MinIO JavaScript SDK Reference </developers/javascript/minio-javascript>`

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

.. _python-sdk:

Python (``minio-py``) 
---------------------

Latest Version
  |python-sdk-version|

Reference
  :doc:`MinIO Python SDK Reference </developers/python/minio-py>`
 
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
   
   /developers/dotnet/minio-dotnet
   /developers/go/minio-go
   /developers/haskell/minio-haskell
   /developers/java/minio-java
   /developers/javascript/minio-javascript
   /developers/python/minio-py
