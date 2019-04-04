# 使用pre-signed URLs通过浏览器进行下载 [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

通过presigned URLs,你可以让浏览器直接下载一个私有的文件，而不需要暴露你的S3认证信息给该用户。以下是一个如何在一个Node.js程序中使用的示例，用的是[minio-js](https://github.com/minio/minio-js)。

这个程序开箱即用，只要把代码复制粘贴就可以用了，这个操作咱们应该不陌生，都懂得。

### 服务端代码

```js
const MinIO = require('minio')

var client = new MinIO.Client({
    endPoint: 'play.min.io',
    port: 9000,
    secure: true,
    accessKey: 'Q3AM3UQ867SPQQA43P2F',
    secretKey: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG'
})
```

为了发这个请求，我们需要创建一个MinIO client,并且输入咱们的认证信息。通过这个clinet,你可以上传下载文件，如果觉得这还不够，请看[API](https://github.com/minio/minio-js/blob/master/docs/API.md)。

示例中给出的是MinIO测试服务的真实认证信息，玩玩呗，来都来了!

```js
// express是一个小巧的Http server封装，不过这对任何HTTP server都管用。
const server = require('express')()

server.get('/presignedUrl', (req, res) => {

    client.presignedGetObject('pictures', 'house.png', (err, url) => {
        if (err) throw err

        res.redirect(url)
    })

})

server.listen(8080)
```

[`presignedGetObject`](https://docs.min.io/docs/javascript-client-api-reference#presignedGetObject)生成了一个可以用来下载`pictures/house.png`的URL。这个链接只有七天有效期，你可以通过`expiry`参数进行调整，最大也就七天。

在本示例中，HTPP server会生成一个从S3下载一张房子照片的链接,然后跳转到这个链接去。

### 客户端代码
你也可以通过客户端JS来请求这个文件，使用[jQuery](http://jquery.com/)，下面是示例代码，它会从S3服务下载文本并插入到一个`div`中。

```html
<div id="response"></div>

<script src="https://code.jquery.com/jquery-3.1.0.min.js"></script>
<script defer type="text/javascript">

$.get('http://YOUR_SERVER:8080/presignedUrl', (text) => {
	// Set the text.
	$('#response').text(text)
}, 'string')

</script>
```
