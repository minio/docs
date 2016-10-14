# How to install Golang? [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Ubuntu (Xenial) 16.04

### Build Dependencies

This installation document assumes Ubuntu 16.04+ on x86-64 platform.

##### Install Git

```sh
$ sudo apt-get install git 
```

##### Install Go 1.7+

Download Go 1.7+ from [https://golang.org/dl/](https://golang.org/dl/).

```sh
$ wget https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz
$ tar -C ${HOME} -xzf go1.7.1.linux-amd64.tar.gz
```

##### Setup GOROOT and GOPATH

Add the following exports to your ``~/.bashrc``. Environment variable GOROOT specifies the location of your golang binaries
and GOPATH specifies the location of your project workspace.

```sh
export GOROOT=${HOME}/go
export GOPATH=${HOME}/work
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
```
##### Source the new environment

```sh
$ source ~/.bashrc
```

##### Testing it all

```sh
$ go env
$ go version
```

## OS X (El Capitan) 10.11

### Build Dependencies

This installation document assumes OS X El Capitan 10.11+ on x86-64 platform.

##### Install brew

Install brew from [brew.sh](http://brew.sh/)

##### Install Git

```sh
$ brew install git 
```

##### Install Go 1.7+

Install golang binaries using `brew`

```sh
$ brew install go
$ mkdir -p $HOME/go
```

##### Setup GOROOT and GOPATH

Add the following exports to your ``~/.bash_profile``. Environment variable GOROOT specifies the location of your golang binaries
and GOPATH specifies the location of your project workspace.

```sh
export GOPATH=${HOME}/work
export GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
export GOROOT=$(brew --prefix)/Cellar/go/${GOVERSION}/libexec
export PATH=${GOPATH}/bin:$PATH
```

##### Source the new environment

```sh
$ source ~/.bash_profile
```

##### Testing it all

```sh
$ go env
$ go version
```

