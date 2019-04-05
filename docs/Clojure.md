# How to use MinIO SDK for java with Clojure

In this receipe we will learn how to use `minio-java` with Clojure.

## Prerequisites
Install [`Clojure`](https://clojure.org/community/downloads) and [`Leiningen`](https://leiningen.org/).

Check by running -
```
lein --help
```

## Clojure Project
Following are the steps involved foe using minio-java with Clojure : 

### 1. Setup
Create a new Clojure project using Leiningen.
```
lein new <templateName> <projectName>
```

Example:
```
lein new app clojproject
```

Navigate to `project.clj` look at `:dependencies` section, consisting of dependencies that project requires in order to load, compile and run.
```
lein deps
```
Run this command to install list of dependencies to your project.

Use Leiningen to start Clojure now - 
```
lein repl
```

Test the project by running `(-main)`.
```
user=> (-main)
Hello, World!
nil
```

Or you can run the project using command - `lein run`.

### 2. Download minio-java from maven
Go to [`maven`](http://search.maven.org/) and search `minio`. 
Download the lastest version and add dependency in the `project.clj`.

```
::dependencies [
                [io.minio/minio "4.0.2"]
               ]
```
Run `lein deps`.

Check `lein classpath` to see if minio.jar is present.
```
/.m2/repository/io/minio/minio/4.0.2/minio-4.0.2.jar
```

Relaunch repl for Clojure and use minio-java.

### 3. Test
Use classes and methods from the imported class in your project.

```
(ns clojproject.core
 (import io.minio.MinioClient)
)

(defn -main
  [& args]
    ;; makeBucket
    (.makeBucket (new io.minio.MinioClient "https://play.min.io:9000" "Q3AM3UQ867SPQQA43P2F" "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG") "testbucketclojure")
    
    ;;putObject
    (.putObject (new io.minio.MinioClient "https://play.min.io:9000" "Q3AM3UQ867SPQQA43P2F" "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG") "testbucketclojure"  "objectname" "/Users/aarushiarya/Desktop/testFile")
    (println "Done.")
    )
    
```


