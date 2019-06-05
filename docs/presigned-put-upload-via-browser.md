# Upload Files Using Pre-signed URLs [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

Using pre-signed URLs, a client can upload files directly to an S3-compatible cloud storage server (S3) without exposing the S3 credentials to the user. 

This guide describes how to use the [`presignedPutObject`](https://docs.min.io/docs/javascript-client-api-reference#presignedPutObject) API from the [MinIO JavaScript Library](https://github.com/minio/minio-js) to generate a pre-signed URL. This is demonstrated through a JavaScript example in which an Express Node.js server exposes an endpoint to generate a pre-signed URL and a client-side web application uploads a file to MinIO Server using that URL.

1. [Create the Server](#createserver) 
2. [Create the Client-side Web Application](#createclient)

## <a name="createserver"></a>1. Create the Server
The server consists of an [Express](https://expressjs.com) Node.js server that exposes an endpoint called `/presignedUrl`. This endpoint uses a `Minio.Client` object to generate a short-lived, pre-signed URL that can be used to upload a file to Mino Server.

```js
// In order to use the MinIO JavaScript API to generate the pre-signed URL, begin by instantiating
// a `Minio.Client` object and pass in the values for your server.
// The example below uses values for play.min.io:9000

const Minio = require('minio')

var client = new Minio.Client({
    endPoint: 'play.min.io',
    port: 9000,
    useSSL: true,
    accessKey: 'Q3AM3UQ867SPQQA43P2F',
    secretKey: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG'
})

// Instantiate an `express` server and expose an endpoint called `/presignedUrl` as a `GET` request that
// accepts a filename through a query parameter called `name`. For the implementation of this endpoint,
// invoke [`presignedPutObject`](https://docs.min.io/docs/javascript-client-api-reference#presignedPutObject) 
// on the `Minio.Client` instance to generate a pre-signed URL, and return that URL in the response:

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
  // `upload` iterates through all files selected and invokes a helper function called `retrieveNewURL`.
  function upload() {
    // Reset status text on every upload.
    $('#status').text(`No uploads`)
    // Get selected files from the input element.
    var files = $("#selector")[0].files
    for (var i = 0; i < files.length; i++) {
      var file = files[i]
      // Retrieve a URL from our server.
      retrieveNewURL(file, (file, url) => {
        // Upload the file to the server.
        uploadFile(file, url)
      })
    }
  }

  //`retrieveNewURL` accepts the name of the current file and invokes the `/presignedUrl` endpoint to
  // generate a pre-signed URL for use in uploading that file: 
  function retrieveNewURL(file, cb) {
    $.get(`/presignedUrl?name=${file.name}`, (url) => {
      cb(file, url)
    })
  }

  // ``uploadFile` accepts the current filename and the pre-signed URL. It then invokes `XMLHttpRequest()`
  // to upload this file to S3 at `play.min.io:9000` using the URL:
  function uploadFile(file, url) {
    var xhr = new XMLHttpRequest()
    xhr.open('PUT', url, true)
    xhr.send(file)
    xhr.onload = () => {
      if (xhr.status == 200) {
        if ($('#status').text() === 'No uploads') {
          // For the first file being uploaded, change upload status text directly.
          $('#status').text(`Uploaded ${file.name}.`)
        } else {
          // If multiple files are uploaded, append upload status on the next line.
          $('#status').append(`<br>Uploaded ${file.name}.`)
        }
      }
    }
  }
</script>
```

**Note:** This web application uses [jQuery](http://jquery.com/).
