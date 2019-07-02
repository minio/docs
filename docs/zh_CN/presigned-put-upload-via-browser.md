# 使用pre-signed URLs通过浏览器上传 [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

使用presigned URLs,你可以让浏览器直接上传一个文件到S3服务，而不需要暴露S3服务的认证信息给这个用户。下面就是使用[minio-js](https://github.com/minio/minio-js)实现的一个示例程序。

### 服务端代码

```js
const MinIO = require('minio')

var client = new MinIO.Client({
    endPoint: 'play.min.io',
    port: 9000,
    useSSL: true,
    accessKey: 'Q3AM3UQ867SPQQA43P2F',
    secretKey: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG'
})
```

初始化MinIO client对象，用于生成presigned upload URL。

```js
// express是一个小巧的Http server封装，不过这对任何HTTP server都管用。
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

这里是[`presignedPutObject`](https://docs.min.io/docs/javascript-client-api-reference#presignedPutObject)的文档。

### 客户端代码

用户通过浏览器选择了一个文件进行上传，然后在方法内部从Node.js服务端获得了一个URL。然后通过`Fetch API`往这个URL发请求，直接把文件上传到`play.min.io:9000`。

```html
<input type="file" id="selector" multiple>
<button onclick="upload()">Upload</button>

<div id="status">No uploads</div>

<script type="text/javascript">
    // `upload` iterates through all files selected and invokes a helper function called `retrieveNewURL`.
    function upload() {
        // Get selected files from the input element.
        var files = document.querySelector("#selector").files;
        for (var i = 0; i < files.length; i++) {
            var file = files[i];
            // 从服务器获取一个URL
            retrieveNewURL(file, (file, url) => {
                // 上传文件到服务器
                uploadFile(file, url);
            });
        }
    }

    // 发请求到Node.js server获取上传URL。
    // `retrieveNewURL` accepts the name of the current file and invokes the `/presignedUrl` endpoint to
    // generate a pre-signed URL for use in uploading that file: 
    function retrieveNewURL(file, cb) {
        fetch(`/presignedUrl?name=${file.name}`).then((response) => {
            response.text().then((url) => {
                cb(file, url);
            });
        }).catch((e) => {
            console.error(e);
        });
    }

    // 使用Fetch API来上传文件到S3。
    // ``uploadFile` accepts the current filename and the pre-signed URL. It then uses `Fetch API`
    // to upload this file to S3 at `play.min.io:9000` using the URL:
    function uploadFile(file, url) {
        if (document.querySelector('#status').innerText === 'No uploads') {
            document.querySelector('#status').innerHTML = '';
        }
        fetch(url, {
            method: 'PUT',
            body: file
        }).then(() => {
            // If multiple files are uploaded, append upload status on the next line.
            document.querySelector('#status').innerHTML += `<br>Uploaded ${file.name}.`;
        }).catch((e) => {
            console.error(e);
        });
    }
</script>
```

现在你就可以让别人访问网页，并直接上传文件到S3服务，而不需要暴露S3服务的认证信息。
