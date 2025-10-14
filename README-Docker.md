# MinIO Documentation Docker Setup

这个项目将MinIO文档构建过程容器化，让你可以通过简单的Docker命令来构建和查看MinIO文档。

## 🚀 快速开始

### 前提条件
- Docker
- Docker Compose

### 启动文档服务器

#### Windows用户
```bash
# 启动服务器
start-docs.bat

# 或者使用其他命令
start-docs.bat start    # 启动服务器
start-docs.bat stop     # 停止服务器
start-docs.bat logs     # 查看日志
start-docs.bat rebuild  # 重新构建
start-docs.bat restart  # 重启服务器
```

#### Linux/macOS用户
```bash
# 给脚本执行权限
chmod +x start-docs.sh

# 启动服务器
./start-docs.sh

# 或者使用其他命令
./start-docs.sh start    # 启动服务器
./start-docs.sh stop     # 停止服务器
./start-docs.sh logs     # 查看日志
./start-docs.sh rebuild  # 重新构建
./start-docs.sh restart  # 重启服务器
```

### 手动使用Docker Compose

```bash
# 构建并启动
docker-compose up -d

# 停止
docker-compose down

# 查看日志
docker-compose logs -f

# 重新构建
docker-compose build --no-cache
```

## 📖 访问文档

启动成功后，在浏览器中访问：
```
http://localhost:8000
```

## 🔧 技术细节

### Docker镜像包含：
- Node.js 18 (用于构建前端资源)
- Python 3 + pip (用于Sphinx文档生成)
- 所有必要的系统依赖 (make, git, curl, pandoc, asciidoc)
- MinIO文档的所有Python和Node.js依赖

### 构建过程：
1. 安装系统依赖
2. 创建Python虚拟环境
3. 安装Python和Node.js依赖
4. 构建前端资源 (`npm run build`)
5. 生成文档 (`make mindocs`)
6. 启动HTTP服务器提供文档访问

### 端口映射：
- 容器内部端口：8000
- 主机端口：8000

## 🐛 故障排除

### 构建失败
如果构建失败，尝试清理Docker缓存：
```bash
docker-compose build --no-cache
```

### 端口冲突
如果8000端口被占用，修改 `docker-compose.yml` 中的端口映射：
```yaml
ports:
  - "8080:8000"  # 改为8080或其他可用端口
```

### 查看详细日志
```bash
docker-compose logs -f minio-docs
```

## 📁 文件结构

- `Dockerfile` - Docker镜像构建文件
- `docker-compose.yml` - Docker Compose配置
- `start-docs.sh` - Linux/macOS启动脚本
- `start-docs.bat` - Windows启动脚本
- `README-Docker.md` - 本说明文件

## 🔄 更新文档

如果MinIO文档仓库有更新，重新构建容器：
```bash
git pull
docker-compose build --no-cache
docker-compose up -d
```

## 📝 原始MinIO文档

这个Docker化版本基于MinIO官方文档仓库：https://github.com/minio/docs

原始构建说明请参考仓库中的README.md文件。