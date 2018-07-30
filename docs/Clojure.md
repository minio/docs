# How to use Minio SDK for java with Clojure

In this receipe we will learn how to use `minio-java` with Clojure.

## Prerequisites
Install `Clojure` and `Leiningen`.

Check by running 
```
lein --help
```

## Steps for setup
Create a new Clojure project using Leiningen.
```
lein new <templateName> <projectName>
```

```
lein new app projectName
```

Navigate to `project.clj` look at `:dependencies` section, listing what project requires in order to load, compile and run.
```
lein deps
```
Run this command to install list of dependencies to your project.

Use Leiningen to start Clojure now
```
lein repl
```
Or you can run the project using command - `lein run`

Test the project by running `(-main)`
```
user=> (-main)
Hello, World!
nil
```

## Getting started with minio-java

First, download minio-java.
```
git clone git@github.com:minio/minio-java.git
```

Compile a jar
By running this command in minio-java directory
```
./gradlew build
```

### Install the jar
Create a directory in the project
```
mkdir maven_repository
```

Add local jars to this repository
```
mvn install:install-file -Dfile=minio-5.0.0-DEV-all.jar -DartifactId=minio -Dversion=5.0.0 -DgroupId=minio -Dpackaging=jar -DlocalRepositoryPath=maven_repository DcreateChecksum=true
```
If install is successful, you will see `BUILD SUCCESS`.

Add this repository to the project
```
:repositories {"local" ~(str (.toURI (java.io.File. "maven_repository")))}
```

Go to project directory and update installed dependencies for the project.
```
lein deps
```

Relaunch repl for Clojure and use minio-java.
Get it to use.

## Test
```

```
