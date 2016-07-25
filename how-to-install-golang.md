# How to install Golang? [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Ubuntu (Kylin) 14.04

### Build Dependencies

This installation document assumes Ubuntu 14.04+ on x86-64 platform.

##### Install Git, GCC

```sh

$ sudo apt-get install git build-essential

```

##### Install Go 1.6+

Download Go 1.6+ from [https://golang.org/dl/](https://golang.org/dl/).

```sh

$ wget https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
$ mkdir -p ${HOME}/bin/
$ mkdir -p ${HOME}/go/
$ tar -C ${HOME}/bin/ -xzf go1.6.linux-amd64.tar.gz

```

##### Setup GOROOT and GOPATH

Add the following exports to your ``~/.bashrc``. Environment variable GOROOT specifies the location of your golang binaries
and GOPATH specifies the location of your project workspace.

```sh

export GOROOT=${HOME}/bin/go
export GOPATH=${HOME}/go
export PATH=${HOME}/bin/go/bin:${GOPATH}/bin:$PATH

```

##### Source the new enviornment

```sh

$ source ~/.bashrc

```

##### Testing it all

```sh

$ go env

```

## OS X (Yosemite) 10.10

### Build Dependencies

This installation document assumes OS X Yosemite 10.10+ on x86-64 platform.

##### Install brew

```sh

$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

```

##### Install Git, Python

```sh

$ brew install git python

```

##### Install Go 1.6+

Install golang binaries using `brew`

```sh

$ brew install go
$ mkdir -p $HOME/go

```

##### Setup GOROOT and GOPATH

Add the following exports to your ``~/.bash_profile``. Environment variable GOROOT specifies the location of your golang binaries
and GOPATH specifies the location of your project workspace.

```sh

export GOPATH=${HOME}/go
export GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
export GOROOT=$(brew --prefix)/Cellar/go/${GOVERSION}/libexec
export PATH=${GOPATH}/bin:$PATH

```

##### Source the new enviornment

```sh

$ source ~/.bash_profile

```

##### Testing it all

```sh

$ go env

```

