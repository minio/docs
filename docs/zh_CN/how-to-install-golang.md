# 如何安装Golang? [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

## Ubuntu (Xenial) 16.04

### 构建依赖

本章节仅针对Ubuntu 16.04+ on x86-64平台。

##### 安装Git

```
$ sudo apt-get install git 
```

##### 安装Go 1.9+

从[https://golang.org/dl/](https://golang.org/dl/)下载Go 1.9+。

```
$ wget https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz
$ tar -C ${HOME} -xzf go1.9.1.linux-amd64.tar.gz
```

##### 设置GOROOT和GOPATH

将下列exports到你的``~/.bashrc``。GOROOT环境变量指定了你的golang二进制文件的路径，GOPATH指定了你工程的工作空间的路径。

```
export GOROOT=${HOME}/go
export GOPATH=${HOME}/work
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
```
##### 执行Source命令

```
$ source ~/.bashrc
```

##### 测试

```
$ go env
$ go version
```

## OS X (El Capitan) 10.11

### Build Dependencies

本章节仅针对OS X El Capitan 10.11+ on x86-64平台。

##### 安装brew

从[brew.sh](http://brew.sh/)安装brew。

##### 安装Git

```
$ brew install git 
```

##### 安装Go 1.9+

使用`brew`安装golang二进制。

```
$ brew install go
$ mkdir -p $HOME/go
```

##### 设置GOROOT和GOPATH

将下列exports到你的``~/.bashrc``。GOROOT环境变量指定了你的golang二进制文件的路径，GOPATH指定了你工程的工作空间的路径。

```
export GOPATH=${HOME}/work
export GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
export GOROOT=$(brew --prefix)/Cellar/go/${GOVERSION}/libexec
export PATH=${GOPATH}/bin:$PATH
```

##### 执行Source命令

```
$ source ~/.bash_profile
```

##### 测试

```
$ go env
$ go version
```
