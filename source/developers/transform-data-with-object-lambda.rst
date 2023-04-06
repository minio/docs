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
- :doc:`The MinIO Go SDK </developers/go/minio-go>` installed
  
-------
Example
-------

This example creates a Lambda handler in Python, invokes it from a Go function, and retrieves the transformed object with ``curl``.


Create a Lambda Handler
~~~~~~~~~~~~~~~~~~~~~~~~~

The sample handler, written in Python, retrieves the target object using a `presigned URL <https://min.io/docs/minio/linux/developers/go/API.html#presigned-operations>`__. It then transforms the object's contents and returns the new text to the caller.
It uses `the Flask web framework <https://flask.palletsprojects.com/en/2.2.x/>`__ and Python 3.8+. 

The following command installs Flask and other needed dependancies:

.. code-block:: shell
   :class: copyable

   pip install flask requests

The handler uses information from the MinIO event context to get the original object, along with the tokens needed to validate the response when the transformed object is returned.
In the example below, ``object_context`` contains several values from the ``getObjectContext`` property of the JSON request payload:

* ``inputS3Url`` is a presigned URL for the original object. A `presigned URL <https://min.io/docs/minio/linux/developers/go/API.html#presigned-operations>`__ allows the function to access an object without the MinIO credentials usually required. 
* ``outputRoute`` and ``outputToken`` are tokens added to the response headers to validate the response and return it to the correct user.

The handler calls string ``upper()`` to convert the text to all uppercase letters.
It then sends the results back to MinIO, which returns it to the caller.
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

You may perform any actions needed for your use case, including saving the transformed object.
See the :doc:`The MinIO Python SDK </developers/python/minio-py>` for more about working with objects programmatically.


Start the Handler
+++++++++++++++++

To test the handler in your local development environment, start it with the following command:

.. code-block:: shell
   :class: copyable

   python lambda_handler.py

The output resembles the following:

.. code-block:: shell

    * Serving Flask app 'lambda_handler'
    * Debug mode: off
   WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
    * Running on http://127.0.0.1:5000
   Press CTRL+C to quit

Once the handler is running, start MinIO with the :envvar:`MINIO_LAMBDA_WEBHOOK_ENABLE` and :envvar:`MINIO_LAMBDA_WEBHOOK_ENDPOINT` environment variables to register the function with MinIO.
To identify the specific Object Lambda handler, append the name of the function to the name of the environment variable:

.. code-block:: shell
   :class: copyable

   MINIO_LAMBDA_WEBHOOK_ENABLE_myfunction=on MINIO_LAMBDA_WEBHOOK_ENDPOINT_myfunction=http://localhost:5000 minio server /data &

Replace ``myfunction`` with the name of the handler function and ``/data`` with the location of the MinIO directory for your local deployment. 
The output resembles the following:

.. code-block:: shell

   MinIO Object Storage Server
   Copyright: 2015-2023 MinIO, Inc.
   License: GNU AGPLv3 <https://www.gnu.org/licenses/agpl-3.0.html>
   Version: RELEASE.2023-03-24T21-41-23Z (go1.19.7 linux/arm64)
   
   Status:         1 Online, 0 Offline. 
   API: http://192.168.64.21:9000  http://127.0.0.1:9000       
   RootUser: minioadmin 
   RootPass: minioadmin 
   Object Lambda ARNs: arn:minio:s3-object-lambda::myfunction:webhook 


Test the Handler Function
~~~~~~~~~~~~~~~~~~~~~~~~~

To test the Lambda handler function, first create an object to transform.
Then invoke the handler, in this case from a test function written in Go.

#. Create a bucket and object for the handler to transform.

   .. code-block:: shell
      :class: copyable

      mc alias set myminio/ http://localhost:9000 minioadmin minioadmin
      mc mb myminio/myfunctionbucket
      cat > testobject << EOF
      Hello, World!
      EOF
      mc cp testobject myminio/myfunctionbucket/

#. Invoke the Handler

   The following Go code uses the :doc:`The MinIO Go SDK </developers/go/minio-go>` to generate a presigned URL and print the transformed object to ``stdout``.

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

   To retrieve the transformed object, execute the Go code with ``curl``:

   .. code-block:: shell
      :class: copyable

      curl -v $(go run presigned.go)

   The test function generates the presigned URL, passing it to ``curl`` to access the object. 
   The output resembles the following:

   .. code-block:: shell

      *   Trying 127.0.0.1:9000...
      * Connected to localhost (127.0.0.1) port 9000 (#0)
      > GET /myfunctionbucket/testobject?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20230406%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230406T184749Z&X-Amz-Expires=1000&X-Amz-SignedHeaders=host&lambdaArn=arn%3Aminio%3As3-object-lambda%3A%3Amyfunction%3Awebhook&X-Amz-Signature=68fe7e03929a7c0da38255121b2ae09c302840c06654d1b79d7907d942f69915 HTTP/1.1
      > Host: localhost:9000
      > User-Agent: curl/7.81.0
      > Accept: */*
      > 
      * Mark bundle as not supporting multiuse
      < HTTP/1.1 200 OK
      < Content-Security-Policy: block-all-mixed-content
      < Strict-Transport-Security: max-age=31536000; includeSubDomains
      < Vary: Origin
      < Vary: Accept-Encoding
      < X-Amz-Id-2: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
      < X-Amz-Request-Id: 17536CF16130630E
      < X-Content-Type-Options: nosniff
      < X-Xss-Protection: 1; mode=block
      < Date: Thu, 06 Apr 2023 18:47:49 GMT
      < Content-Length: 14
      < Content-Type: text/plain; charset=utf-8
      < 
      HELLO, WORLD!
      * Connection #0 to host localhost left intact



