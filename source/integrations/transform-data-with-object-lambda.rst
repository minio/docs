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
- `The Flask web framework for Python <https://palletsprojects.com/p/flask/>`__
- :doc:`The MinIO Go SDK </developers/go/minio-go>`
  
      .. code-block:: nginx
         :class: copyable

         code stuff


--------------------
Example
--------------------

The following example creates a Lambda handler in Python, invokes it from a Go function, and retrieves the transformed object with `curl`.


Create a Lambda Handler
~~~~~~~~~~~~~~~~~~~~~~~~~

This handler retrieves the target object using a `presigned URL <https://min.io/docs/minio/linux/developers/go/API.html#presigned-operations>`__, transforms its contents, and then returns the new text to the caller. 


.. code-block:: shell
   :class: copyable

   pip install flask requests

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




Enable the Handler
~~~~~~~~~~~~~~~~~~

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

   
Create a Test Object
~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc alias set myminio/ http://localhost:9000 minioadmin minioadmin
   mc mb myminio/functionbucket


.. code-block::	shell
   :class: copyable

   cat > testobject << EOF
   Test contents go here
   EOF



	   
Invoke the Handler via PresignedGET
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


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
      reqParams.Set("lambdaArn", "arn:minio:s3-object-lambda::function:webhook")

      // Generate presigned GET url with lambda function
      presignedURL, err := s3Client.PresignedGetObject(context.Background(), "functionbucket", "testobject", time.Duration(1000)*time.Second, reqParams)
      if err != nil {
         log.Fatalln(err)
      }
      fmt.Println(presignedURL)
   }


Retrieve the Transformed Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   curl -v $(go run presigned.go)

.. code-block:: shell

   ...
   ...
   > GET /functionbucket/testobject?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20230205%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230205T173023Z&X-Amz-Expires=1000&X-Amz-SignedHeaders=host&lambdaArn=arn%3Aminio%3As3-object-lambda%3A%3Atoupper%3Awebhook&X-Amz-Signature=d7e343f0da9d4fa2bc822c12ad2f54300ff16796a1edaa6d31f1313c8e94d5b2 HTTP/1.1
   > Host: localhost:9000
   > User-Agent: curl/7.81.0
   > Accept: */*
   >
   TEST CONTENTS GO HERE


