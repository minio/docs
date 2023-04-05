.. _developers-object-lambda:

=================================
Transform Data with Object Lambda
=================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The following documentation covers transforming the contents of an object with MinIO's Object Lambda.
Uses for Object Lambda include redacting personally identifable information (PII) and enriching data with information from other sources.

This documentation assumes the following:

- An existing :ref:`MinIO <minio-installation>` deployment
- Working Python (3.8+) and Golang (??) development environments
- :doc:`The MinIO Go SDK </developers/go/minio-go>`
  
-------
Example
-------

This example creates a Lambda handler in Python, invokes it from a Go function, and retrieves the transformed object with ``curl``.


Create a Lambda Handler
~~~~~~~~~~~~~~~~~~~~~~~~~

The sample handler retrieves the target object using a `presigned URL <https://min.io/docs/minio/linux/developers/go/API.html#presigned-operations>`__, transforms its contents, and then returns the new text to the caller.
It uses `the Flask web framework <https://flask.palletsprojects.com/en/2.2.x/>`__ and Python 3.8+. 

The following command installs Flask and other needed dependancies:

.. code-block:: shell
   :class: copyable

   pip install flask requests

The handler uses information from the MinIO event context to get the object and the tokens that validate the response when it is returned to the caller.
In the example below, ``object_context`` contains several values from the ``getObjectContext`` property of the JSON request payload:

* ``inputS3Url`` is a presigned URL for the original object. A presigned URL allows the function to access the object without the MinIO credentials usually required. 
* ``outputRoute`` and ``outputToken`` are tokens added to the response headers to validate the response.

For this example, the function calls string ``upper()`` to convert the text to all uppercase letters.
The original object is not changed.

.. code-block:: py
   :class: copyable

   from flask import Flask, request, abort, make_response
   import requests

   app = Flask(__name__)
   @app.route('/', methods=['POST'])
   def get_webhook():
      if request.method == 'POST':
         # obtain the request event from the 'POST' call
         event = request.json

         object_context = event["getObjectContext"]

         # Get the presigned URL to fetch the requested
         # original object from MinIO
         s3_url = object_context["inputS3Url"]

         # Extract the route and request token from the input context
         request_route = object_context["outputRoute"]
         request_token = object_context["outputToken"]

         # Get the original S3 object using the presigned URL
         r = requests.get(s3_url)
         original_object = r.content.decode('utf-8')

         # Transform all text in the original object to uppercase
         # You can replace it with your custom code based on your use case
         transformed_object = original_object.upper()

         # Write object back to S3 Object Lambda
         # response sends the transformed data
         # back to MinIO and then to the user
         resp = make_response(transformed_object, 200)
         resp.headers['x-amz-request-route'] = request_route
         resp.headers['x-amz-request-token'] = request_token
         return resp

      else:
         abort(400)

   if __name__ == '__main__':
      app.run()



Start the Handler
~~~~~~~~~~~~~~~~~

To test the handler in your local development environment, start it with the following command:

.. code-block:: shell
   :class: copyable

   python lambda_handler.py

The output resembles the following:

.. code-block:: shell

   * Serving Flask app 'webhook'
   * Debug mode: off
  WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
   * Running on http://127.0.0.1:5000
  Press CTRL+C to quit

Once the handler is running, start MinIO with the :envvar:`MINIO_LAMBDA_WEBHOOK_ENDPOINT` and :envvar:`MINIO_LAMBDA_WEBHOOK_ENDPOINT` environment variables to register the function with MinIO.
To identify the specific Object Lambda handler, append the name of the function to the name of the environment variable:

.. code-block:: shell
   :class: copyable

   MINIO_LAMBDA_WEBHOOK_ENABLE_myfunction=on MINIO_LAMBDA_WEBHOOK_ENDPOINT_myfunction=http://localhost:5000 minio server /data &

The output resembles the following:

.. code-block:: shell

   MinIO Object Storage Server
   Copyright: 2015-2023 MinIO, Inc.
   License: GNU AGPLv3 <https://www.gnu.org/licenses/agpl-3.0.html>
   Version: DEVELOPMENT.2023-02-05T05-17-27Z (go1.19.4 linux/amd64)

   Object Lambda ARNs: arn:minio:s3-object-lambda::myfunction:webhook


Create a Test Object
~~~~~~~~~~~~~~~~~~~~

Create a bucket and object for the handler to transform.

.. code-block:: shell
   :class: copyable

   mc alias set myminio/ http://localhost:9000 minioadmin minioadmin
   mc mb myminio/myfunctionbucket

.. code-block::	shell
   :class: copyable

   cat > testobject << EOF
   Test contents go here
   EOF

	   
Call the Handler
~~~~~~~~~~~~~~~~

The following Go code uses the :doc:`The MinIO Go SDK </developers/go/minio-go>` to generate a presigned URL, invoke the Object Lambda function, and print the transformed object to ``stdout``.

.. code-block:: go
   :class: copyable

   package main

   import (
      "context"
      "log"
      "net/url"
      "time"
      "fmt"

      "github.com/minio/minio-go/v7"
      "github.com/minio/minio-go/v7/pkg/credentials"
   )

   func main() {
      s3Client, err := minio.New("localhost:9000", &minio.Options{
         Creds:  credentials.NewStaticV4("minioadmin", "minioadmin", ""),
         Secure: false,
      })
      if err != nil {
         log.Fatalln(err)
      }

      // Set lambda function target via `lambdaArn`
      reqParams := make(url.Values)
      reqParams.Set("lambdaArn", "arn:minio:s3-object-lambda::myfunction:webhook")

      // Generate presigned GET url with lambda function
      presignedURL, err := s3Client.PresignedGetObject(context.Background(), "myfunctionbucket", "testobject", time.Duration(1000)*time.Second, reqParams)
      if err != nil {
         log.Fatalln(err)
      }
      fmt.Println(presignedURL)
   }

To retrieve the transformed object, run the Go code with ``curl``:

.. code-block:: shell
   :class: copyable

   curl -v $(go run presigned.go)

The test code generates the presigned URL, passing it to `curl` to access the object. 

The output resembles the following:

.. code-block:: shell

   ...
   ...
   > GET /myfunctionbucket/testobject?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20230205%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230205T173023Z&X-Amz-Expires=1000&X-Amz-SignedHeaders=host&lambdaArn=arn%3Aminio%3As3-object-lambda%3A%3Atoupper%3Awebhook&X-Amz-Signature=d7e343f0da9d4fa2bc822c12ad2f54300ff16796a1edaa6d31f1313c8e94d5b2 HTTP/1.1
   > Host: localhost:9000
   > User-Agent: curl/7.81.0
   > Accept: */*
   >
   TEST CONTENTS GO HERE


