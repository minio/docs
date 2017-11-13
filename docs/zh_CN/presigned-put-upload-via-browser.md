# 使用pre-signed URLs通过浏览器上传 [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

使用presigned URLs,你可以让浏览器直接上传一个文件到S3服务，而不需要暴露S3服务的认证信息给这个用户。下面就是使用[minio-js](https://github.com/minio/minio-js)实现的一个示例程序。

### 服务端代码

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

初始化Minio client对象，用于生成presigned upload URL。

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

这里是[`presignedPutObject`](https://docs.minio.io/docs/javascript-client-api-reference#presignedPutObject)的文档。

### 客户端代码

程序使用了[jQuery](http://jquery.com/).

用户通过浏览器选择了一个文件进行上传，然后在方法内部从Node.js服务端获得了一个URL。然后通过`XMLHttpRequest()`往这个URL发请求，直接把文件上传到`play.minio.io:9000`。

```html
<input type="file" id="selector" multiple>
<button onclick="upload()">Upload</button>

<div id="status">No uploads</div>

<script src="//code.jquery.com/jquery-3.1.0.min.js"></script>
<script type="text/javascript">

 function upload() {
   [$('#selector')[0].files].forEach(fileObj => {
     var file = fileObj[0]
     // 从服务器获取一个URL
     retrieveNewURL(file, url => {
       // 上传文件到服务器
       uploadFile(file, url)
     })
   })
 }

 // 发请求到Node.js server获取上传URL。
 function retrieveNewURL(file, cb) {
   $.get(`/presignedUrl?name=${file.name}`, (url) => {
     cb(url)
   })
 }

 // 使用XMLHttpRequest来上传文件到S3。
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

现在你就可以让别人访问网页，并直接上传文件到S3服务，而不需要暴露S3服务的认证信息。
