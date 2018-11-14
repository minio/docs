# Upload Files from a Browser Using Pre-signed URLs [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

Using pre-signed URLs, a browser can upload files directly to an S3-compatible cloud storage server (S3) without exposing the S3 credentials to the user. 

This guide describes how to use the [`presignedPutObject`](https://docs.minio.io/docs/javascript-client-api-reference#presignedPutObject) API from the [Minio JavaScript Library](https://github.com/minio/minio-js) to generate a pre-signed URL. This is demonstrated through a JavaScript example in which an Express Node.js server exposes an endpoint to generate a pre-signed URL and a client-side web application uploads a file to Minio Server using that URL.

These are the steps you will follow:

1. [Create the Server](#createserver) 
2. [Create the Client-side Web Application](#createclient)

## <a name="createserver"></a>1. Create the Server
The server consists of an [Express](https://expressjs.com) Node.js server that exposes an endpoint called `/presignedUrl`. This endpoint uses a `Minio.Client` object to generate a short-lived, pre-signed URL that can be used to upload a file to Mino Server.

### 1.1 Create a Minio Client Object
In order to use the Minio JavaScript API to generate the pre-signed URL, begin by instantiating a `Minio.Client` object and pass in the values for your server. The example below uses values for `play.minio.io:9000`:

```js
const Minio = require('minio')

var client = new Minio.Client({
    endPoint: 'play.minio.io',
    port: 9000,
    secure: true,
    accessKey: 'Q3AM3UQ867SPQQA43P2F',
    secretKey: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG'
})
```

### 1.2 Expose the Pre-signed URL Endpoint
Instantiate an `express` server and expose an endpoint called `/presignedUrl` as a `GET` request that accepts a filename through a query parameter called `name`. For the implementation of this endpoint, invoke [`presignedPutObject`](https://docs.minio.io/docs/javascript-client-api-reference#presignedPutObject) on the `Minio.Client` instance to generate a pre-signed URL, and return that URL in the response:

```js
// express is a small HTTP server wrapper, but this works with any HTTP server
const server = require('express')()

server.get('/presignedUrl', (req, res) => {
    client.presignedPutObject('uploads', req.query.name, (err, url) => {
        if (err) throw err
        res.end(url)
    })
})

server.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
})

server.listen(8080)
```

## <a name="createclient"></a>2. Create the Client-side Web Application
The client-side web application's user interface contains a selector field that allows the user to select files for upload, as well as a button that invokes an `onclick` handler called `upload`:

```html
<input type="file" id="selector" multiple>
<button onclick="upload()">Upload</button>

<div id="status">No uploads</div>

<script src="//code.jquery.com/jquery-3.1.0.min.js"></script>
<script type="text/javascript">

function upload() {
   [$('#selector')[0].files].forEach(fileObj => {
     var file = fileObj[0]
     // Retrieve a URL from our server.
     retrieveNewURL(file, url => {
       // Upload the file to the server.
       uploadFile(file, url)
     })
   })
}
...
```

`upload` iterates through all files selected and invokes a helper function called `retrieveNewURL`. `retrieveNewURL` takes in the name of the current file and invokes the `/presignedUrl` endpoint to generate a pre-signed URL for use in uploading that file: 

```html
...

// Request to our Node.js server for an upload URL.
function retrieveNewURL(file, cb) {
   $.get(`/presignedUrl?name=${file.name}`, (url) => {
     cb(url)
   })
}
</script>
```

`upload` then invokes another helper function called `uploadFile` that takes in the current filename and the pre-signed URL. It then invokes `XMLHttpRequest()` to upload this file to `play.minio.io:9000` using the URL:

```html
...

// Use XMLHttpRequest to upload the file to S3.
function uploadFile(file, url) {
     var xhr = new XMLHttpRequest ()
     xhr.open('PUT', url, true)
     xhr.send(file)
     xhr.onload = () => {
       if (xhr.status == 200) {
         $('#status').text(`Uploaded ${file.name}.`)
       }
     }
}
</script>
```

**Note:** This web application uses [jQuery](http://jquery.com/).
