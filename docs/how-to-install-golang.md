# How to install Golang? [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

## Ubuntu (Xenial) 16.04

### Build Dependencies

This installation document assumes Ubuntu 16.04+ on x86-64 platform.

##### Install Git

```
$ sudo apt-get install git 
```

##### Install Go 1.11+

Download Go 1.10+ from [https://golang.org/dl/](https://golang.org/dl/).

```
$ wget https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz
$ sudo tar -C /usr/local -xzf go1.11.1.linux-amd64.tar.gz
```

##### Setup PATH

Add the PATH to your ``~/.bashrc``.

```
export PATH=$PATH:/usr/local/go/bin:${HOME}/go/bin
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

##### Install Go 1.10+

Install golang binaries using `brew`

```
$ brew install go
```

##### Setup PATH

Add the PATH to your ``~/.bash_profile``. 

```
export PATH=${HOME}/go/bin:$PATH
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
