# Upload files from browser using pre-signed URLs [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Using presigned URLs, you can allow a browser to upload a file
directly to S3 without exposing your S3 credentials to the user. The following
is an annotated example of this using [minio-js](https://github.com/minio/minio-js).

### Server code

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

Initialize a Minio client object which is necessary in order to generate
a presign upload URL.

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

Here are the docs for [`presignedPutObject`](https://docs.minio.io/docs/javascript-client-api-reference#presignedPutObject).

### Client code

This application uses [jQuery](http://jquery.com/).

On the browser user selects a file to upload, internally this function
retrieves a URL from the Node.js server. Using `XMLHttpRequest()` this
using this URL we upload directly to `play.minio.io:9000`.

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

 // Request to our Node.js server for an upload URL.
 function retrieveNewURL(file, cb) {
   $.get(`/presignedUrl?name=${file.name}`, (url) => {
     cb(url)
   })
 }

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

Now a user can visit the website and upload a file straight to S3, without
exposing the S3 credentials.
