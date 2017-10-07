# How to install Golang? [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

## Ubuntu (Xenial) 16.04

### Build Dependencies

This installation document assumes Ubuntu 16.04+ on x86-64 platform.

##### Install Git

```
$ sudo apt-get install git 
```

##### Install Go 1.9+

Download Go 1.9+ from [https://golang.org/dl/](https://golang.org/dl/).

```
$ wget https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz
$ tar -C ${HOME} -xzf go1.9.1.linux-amd64.tar.gz
```

##### Setup GOROOT and GOPATH

Add the following exports to your ``~/.bashrc``. Environment variable GOROOT specifies the location of your golang binaries
and GOPATH specifies the location of your project workspace.

```
export GOROOT=${HOME}/go
export GOPATH=${HOME}/work
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
```
##### Source the new environment

```
$ source ~/.bashrc
```

##### Testing it all

```
$ go env
$ go version
```

## OS X (El Capitan) 10.11

### Build Dependencies

This installation document assumes OS X El Capitan 10.11+ on x86-64 platform.

##### Install brew

Install brew from [brew.sh](http://brew.sh/)

##### Install Git

```
$ brew install git 
```

##### Install Go 1.9+

Install golang binaries using `brew`

```
$ brew install go
$ mkdir -p $HOME/go
```

##### Setup GOROOT and GOPATH

Add the following exports to your ``~/.bash_profile``. Environment variable GOROOT specifies the location of your golang binaries
and GOPATH specifies the location of your project workspace.

```
export GOPATH=${HOME}/work
export GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
export GOROOT=$(brew --prefix)/Cellar/go/${GOVERSION}/libexec
export PATH=${GOPATH}/bin:$PATH
```

##### Source the new environment

```
$ source ~/.bash_profile
```

##### Testing it all

```
$ go env
$ go version
```
